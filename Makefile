# ==============================================================================
# 
# Copyright (C) 2008 Mark Jaroski
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA
# 
# ==============================================================================

################### SETTINGS ######################
-include Config.mk

ifndef ARTICLE
$(error You must set the variable ARTICLE, eg. make Config.mk ARTICLE=Paris/6th_arrondissement)
endif

BELL = no

# Programs
SHELL=/bin/bash
XML = xmlstarlet
LISTFILTER = listfilter.sh
INKSCAPE = /usr/bin/inkscape
PYTHON = /usr/bin/python
UPLOAD = pywikipedia/upload.py

# Functions
################################################################################

SIZE  = $(call getval,size,a4-landscape)

WIDTH = $(call getvar,dataWidth)
HEIGHT = $(call getvar,dataHeight)
# export at 300dpi
PAGE_WIDTH  = $(shell echo ${WIDTH}*300/25.4 | bc)
PAGE_HEIGHT = $(shell echo ${HEIGHT}*300/25.4 | bc)

PLACEMENT = $(call getval,placement,left-bottom)
ZOOMLEVEL = $(call getval,zoom,17)

PROVIDED_URL = $(call getval,osm_url,none)

DING := $(shell if [ "${BELL}" != "no" ] ; then echo 'ding' ; else echo '' ; fi )
PNG := $(subst /,_,${ARTICLE})_map_with_listings.png
SVG := $(subst /,_,${ARTICLE})_map_with_listings.svg
SVGZ := $(subst /,_,${ARTICLE})_map_with_listings.svgz
OVERLAY := $(subst /,_,${ARTICLE})_overlay.svg

getval = $(shell if egrep -q '\[\[Image:.*\|$(1)=' article.wiki ;\
				 then \
				   	 egrep '\[\[Image:.*\|$(1)=' article.wiki | sed 's/.*|$(1)=\([^|]*\)|.*/\1/' ;\
				 else \
				   	 echo $(2) ;\
				 fi )
				 
getvar = $(shell ${XML} sel -t -v "//xsl:variable[@name='$1']/text()" dataurl.xsl)

################################################################################
# RULES
################################################################################

# make the ultimate output files and optionally a noise
all : map.svg ${SVGZ} unmatched.txt ${PNG} ${DING}

# remove amenity|tourism tags from nodes in that are in the listing
# so that they won't be rendered by osmarender
filtered.osm: filter-nodes.xsl listings.xml data.osm
	${XML} tr filter-nodes.xsl data.osm > $@ 2> filtered.log

stylesheets:
	@echo Downloading osmarender stylesheets ...
	wget -nv -r -np -R index.html -nH --cut-dirs 3 http://svn.openstreetmap.org/applications/rendering/osmarender/stylesheets/

style.xml: stylesheets/osm-map-features-z*.xml article.wiki 
	cp stylesheets/osm-map-features-z${ZOOMLEVEL}.xml $@

# transform OSM data into an SVG
map.svg : filtered.osm osmarender.xsl wikitravel-print-rules.xml 
	${XML} tr --net osmarender.xsl wikitravel-print-rules.xml > $@ 2> osmarender.log


# store configuration from the command line
Config.mk :
	echo ARTICLE = $(ARTICLE) > $@


# fetch the specified article
article.xml : Config.mk
	wget -q -O - http://wikitravel.org/en/Special:Export?pages=${ARTICLE} > $@



# extract wikitext from the XML exported from MediaWiki
article.wiki : article.xml
	${XML} sel -N mw=http://www.mediawiki.org/xml/export-0.3/ -t -v "/mw:mediawiki/mw:page/mw:revision/mw:text" article.xml | ${XML} unesc > article.wiki



# get the list of relations matchine the border name 
# *** (unless the article provides a URL) ***
empty:=
space:= $(empty) $(empty)
BORDER_VALUE = $(subst $(space),+,$(call getval,border))
RELS = $(if $(and $(findstring none,$(call getval,relid,none)), $(findstring none,$(PROVIDED_URL))),wget -q -O - "http://www.informationfreeway.org/api/0.6/relation[name=${BORDER_VALUE}]",echo)
rels.xml : article.wiki
	$(if $(and $(findstring none,$(call getval,osm_url,none)),$(findstring none,$(call getval,border,none))),$(error You must configure either 'relid', 'border' or 'osm_url' in the map image in your Wikitravel article.))
	${RELS} > $@
# TODO we need to fix extracting the URL


# get the specific border relation for the covered area
# *** (unless the article provides a URL) ***
RELID = $(if $(call getval,relid),$(call getval,relid),$(shell ${XML} sel -t -m "/osm" -v "relation[tag/@k = 'Is_In' and tag/@v = '$(call getval,is_in)']/@id" rels.xml))
RELATION = $(if $(findstring none,$(PROVIDED_URL)),wget -q -O - "http://openstreetmap.org/api/0.6/relation/${RELID}/full",echo)
relation.xml : rels.xml
	${RELATION} > $@



# convert the wiki page into our own listings XML format
# the listings should already be good XML, so all we should have to do is
# wrap the page with a top-level tag
listings-all.xml : article.wiki
	echo '<listings>' > listings-all.xml
	sed 's/&/\&amp;/g' < article.wiki >> listings-all.xml
	echo '</listings>' >> listings-all.xml



# strip out any unmatched listings
listings.xml : listings-all.xml unmatched.txt
	$(if $(shell cat unmatched.txt),${XML} ed -d "`sh ${LISTFILTER} | sed -e 's/_/ /g' -e 's/\"/\\\"/g'`" listings-all.xml > $@,cp listings-all.xml $@)



# calculate or fetch the correct data URL, then get the data
CALCULATED_URL = "$(shell ${XML} tr --omit-decl relation_bbox.xsl relation.xml)"
DATAURL = $(if $(findstring none,$(PROVIDED_URL)),$(CALCULATED_URL),$(PROVIDED_URL))
DATAFILE = $(call getvar,datafile)

data.osm : dataurl.xsl listings-all.xml relation.xml article.wiki
	make ${DATAFILE}
	cp ${DATAFILE} $@

%.osm:
	wget -O $@ $(call getvar,dataurl)

# This collection of rules fetch the description pages of the various
# images which will download or (someday) upload from/to shared
png_page.html : Config.mk
	wget -q -O - http://wikitravel.org/shared/Image:${PNG} > $@

overlay_page.html : Config.mk
	wget -q -O - http://wikitravel.org/shared/Image:${OVERLAY} > $@

svg_page.html : Config.mk
	wget -q -O - http://wikitravel.org/shared/Image:${SVGZ} > $@


# Build the rules file
wikitravel-print-rules.xml : icon_rules.xsl vars.xsl listings.xml style.xml
	${XML} tr icon_rules.xsl \
		listings.xml > $@ 2> icon_rules.log

# if the description page from the static overlay contains a current image
# then fetch it, otherwise make a dummy overlay
overlay.svg : overlay_page.html
	$(if $(shell grep '(current)' overlay_page.html),wget -q -O - http://wikitravel.org$(shell egrep '(current)' overlay_page.html | sed 's/.*href="\(\/upload\/[^"]*\).*/\1/') > $@,cp overlay_base.svg $@)



# create a listings box layer, sandwiching it between the previously
# generated map.svg and the downloaded or generated overlay.svg
listings.svg : listbox.xsl listings.xml wikitravel-print-rules.xml map.svg overlay.svg unmatched.svg
	${XML} tr listbox.xsl listings.xml > $@ 2> listbox.log 

# use inkscape to convert the layered SVG file into a PNG
TRANSFORM = "${INKSCAPE} -z --export-png=$@ -w $(PAGE_WIDTH) -h $(PAGE_HEIGHT) listings.svg"
listings.png : listings.svg
	# For some reason Make clobbers inkscape's memory footprint so background this
	killall inkscape || /bin/true # sorry, one inkscape at a time
	echo "cd ${PWD} && ${TRANSFORM}" | at now
	sleep 1
	while pidof inkscape ; do sleep 1 ; done



# Generate scheme instructions for Gimp to rename the raw PNG image and
# reduce its colour set
index.scm : Config.mk
	echo -n > $@
	echo '(define filename "listings.png" )' >> $@
	echo '(define outfile "${PNG}" )' >> $@
	echo '(define img (car (file-png-load 1 filename filename ) ) )' >> $@
	echo '(gimp-image-convert-indexed img 0 0 64 0 1 "none" )' >> $@
	echo '(file-png-save-defaults 1 img 2 outfile outfile )' >> $@
	echo '(gimp-quit 1 )' >> $@


# execute the above scheme file in Gimp to 
${PNG} : listings.png index.scm
	gimp -i -c -d -b - < index.scm >/dev/null 2>&1


# convert our listings into a simple text file
listings.txt : listings-all.xml
	${XML} sel -T -t -m '/listings' -m 'see|do|buy|eat|drink|sleep|listing' -v @name -n $< > $@ || true


# get a list of the named nodes in our OSM data
namednodes.txt : data.osm
	${XML} sel -T -t -m "//node/tag[@k='name']"  -v @v -n $< > $@ || true
	${XML} sel -T -t -m "//way/tag[@k='name']"  -v @v -n $< >> $@ || true
	${XML} sel -T -t -m "//node/tag[@k='name:en']"  -v @v -n $< >> $@ || true
	${XML} sel -T -t -m "//way/tag[@k='name:en']"  -v @v -n $< >> $@ || true

vars.xsl: listings.xml calculation.py relation.xml dataurl.xsl
	python calculation.py ${SIZE} ${DATAURL} ${PLACEMENT} `for i in //see\|//do //buy //eat //drink //sleep //listing; do ${XML} sel -t -v "count($$i)" listings.xml; done` > $@

# use the calculation script to determine the dataurl, listings are not yet known
# as they depend on the data.osm file
dataurl.xsl: calculation.py relation.xml
	python calculation.py ${SIZE} ${DATAURL} ${PLACEMENT} 0 0 0 0 0 > $@

# find any listings which are not in the nodes list, and warn about them
unmatched.txt : namednodes.txt listings.txt
	grep -vx -f $^ > $@ || /bin/true


# convert the list of unmatched listings to XML so we can read it with XSL 1.1
unmatched.xml : unmatched.txt
	echo '<listings>' > $@
	sed 's/.*/<listing>&<\/listing>/' $< >> $@
	echo '</listings>' >> $@



# create an xsl layer with the unmatched listings
unmatched.svg : unmatched.xsl unmatched.xml map.svg
	${XML} tr unmatched.xsl map.svg > $@



# rename the generated layered SVG to keep (and eventually upload)
${SVGZ} : listings.svg
	cat listings.svg | gzip > ${SVGZ}


# warn if anything is amis
.PHONY : warnings
warnings : unmatched.txt
	@$(if $(shell cat unmatched.txt),echo !!! WARNING !!! There are unmatched listings in this article! >&2)
	@cat $<

# cleanup files from Wikitravel
.PHONY : wt-clean
wt-clean :
	${RM} article.xml article.wiki wikitravel-print-rules.xml listings-all.xml listings.xml listings.txt overlay.svg overlay_page.html dataurl.xsl

#cleanup files from openstreetmap
.PHONY : osm-clean
osm-clean : 
	${RM} *.osm relation.xml rels.xml relid vars.xml

# cleanup everything
.PHONY : clean
clean : wt-clean osm-clean
	${RM} index.scm map.svg listings.svg listings.png namednodes.txt unmatched.txt transform.log wikitravel-print-rules.xml Config.mk

# scour
.PHONY : dist-clean
	${RM} *listings.png *listings.svg *.log Config.mk
	${RM} -r stylesheets

.PHONY : ding
ding : map.svg ${SVGZ} unmatched.txt warnings
	play -q bell.ogg || true

.PHONY : adjustments 
adjustments : listings.svg warnings
	killall inkscape || /bin/true # sorry, one inkscape at a time
	echo "DISPLAY=:0.0 ${INKSCAPE} ${PWD}/listings.svg" | at now
	@sleep 3
	while ps u -C inkscape ; do sleep 15 ; done

.PHONY : svg
svg : ${SVGZ}

.PHONY : svg
png : ${PNG}

UPLOAD_MESSAGE = "Created using [http://wikitravel.org/en/Wikitravel:How_to_create_a_map osmatravel]\
{{Imagecredit|credit=Selfmade|captureDate=|location=|source=OSM|caption=${ARTICLE}|description=Map of ${ARTICLE}}}\
{{Map|$(call getval,is_in)}}"

.PHONY : upload-svg
upload-svg : ${SVGZ}
	${PYTHON} ${UPLOAD} -keep -noverify ${SVGZ} ${UPLOAD_MESSAGE} 2>&1

.PHONY : upload-png
upload-png : ${PNG}
	${PYTHON} ${UPLOAD} -keep -noverify ${PNG} ${UPLOAD_MESSAGE} 2>&1

.DELETE_ON_ERROR : 

