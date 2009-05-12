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
$(error You must set the variable ARTICLE, eg. make adjustments ARTICLE=Paris/6th_arrondissement)
endif

PAGE_WIDTH = 1730
PAGE_HEIGHT = 3008
PAGE_DOUBLE_WIDTH = 3460

# Functions
################################################################################

getval = $(shell if egrep -q '\[\[Image:.*$(1)=' article.wiki ; then egrep '\[\[Image:.*$(1)=' article.wiki | sed 's/.*$(1)=\([^|]*\)|.*/\1/' ; else echo $(2) ; fi )

SIZE  = $(call getval,size,two-page)
ORIENTATION = $(call getval,orientation,landscape)

LONG  = $(if $(findstring two-page,$(SIZE)),$(PAGE_DOUBLE_WIDTH),${PAGE_HEIGHT})
SHORT =  $(if $(findstring two-page,$(SIZE)),${PAGE_HEIGHT},${PAGE_WIDTH})

WIDTH = $(if $(findstring landscape,$(ORIENTATION)),$(LONG),$(SHORT))
HEIGHT = $(if $(findstring portrait,$(ORIENTATION)),$(SHORT),$(LONG))

################################################################################

# Programs
XML = xmlstarlet
LISTFILTER = listfilter.sh

empty:=
space:= $(empty) $(empty)
BORDER_VALUE = $(subst $(space),+,$(call getval,border))

DING := $(shell if [ "${BELL}" != "no" ] ; then echo 'ding' ; else echo '' ; fi )

PNG := $(subst /,_,${ARTICLE})_map_with_listings.png

SVG := $(subst /,_,${ARTICLE})_map_with_listings.svg

OVERLAY := $(subst /,_,${ARTICLE})_overlay.svg

all : map.svg ${SVG} unmatched.txt ${PNG} ${DING}

map.svg : data.osm osmarender.xsl wikitravel-print-rules.xml
	${XML} tr --net osmarender.xsl wikitravel-print-rules.xml > $@ 2> osmarender.log

Config.mk :
	echo ARTICLE = $(ARTICLE) > $@
	echo BELL = $(BELL) >> $@

rels.xml : Config.mk
	wget -q -O - "http://www.informationfreeway.org/api/0.6/relation[name=${BORDER_VALUE}]" > $@

relid : Config.mk rels.xml
	${XML} sel -t -m "/osm" -v "relation[tag/@k = 'Is_In' and tag/@v = '$(call getval,is_in)']/@id" rels.xml > relid

relation.xml : relid
	wget -q -O - "http://openstreetmap.org/api/0.6/relation/`cat relid`/full" > $@

data.osm : dataurl.txt
	wget -q -O - `cat dataurl.txt` > $@

article.xml : Config.mk
	wget -q -O - http://wikitravel.org/en/Special:Export?pages=${ARTICLE} > $@

png_page.html : Config.mk
	wget -q -O - http://wikitravel.org/shared/Image:${PNG} > $@

overlay_page.html : Config.mk
	wget -q -O - http://wikitravel.org/shared/Image:${OVERLAY} > $@

svg_page.html : Config.mk
	wget -q -O - http://wikitravel.org/shared/Image:${SVG} > $@

article.wiki : article.xml
	${XML} sel -N mw=http://www.mediawiki.org/xml/export-0.3/ -t -v "/mw:mediawiki/mw:page/mw:revision/mw:text" article.xml | ${XML} unesc > article.wiki

listings-all.xml : article.wiki
	echo '<listings>' > listings-all.xml
	sed 's/&/\&amp;/g' < article.wiki >> listings-all.xml
	echo '</listings>' >> listings-all.xml

listings.xml : listings-all.xml unmatched.txt
	${XML} ed -d "`sh ${LISTFILTER} | sed -e 's/_/ /g' -e 's/\"/\\\"/g'`" listings-all.xml > $@

wikitravel-print-rules.xml : icon_rules.xsl variables.xsl listings-all.xml relation.xml
	${XML} tr icon_rules.xsl \
		-s border="$(call getval,border)" \
		-s listingsPlacement="$(call getval,listings_placement,auto)" \
		-s expandForListings="$(call getval,expand_for_listings,yes)" \
		-s minOffset="$(call getval,min_listings_box_size,65)" \
		-s orientation="$(call getval,orientation,landscape)" \
		-s size="$(call getval,size,two-page)" \
		listings-all.xml > $@ 2> icon_rules.log

dataurl.txt : dataurl.xsl variables.xsl listings-all.xml relation.xml
	${XML} tr dataurl.xsl \
		-s border="$(call getval,border)" \
		-s listingsPlacement="$(call getval,listings_placement,auto)" \
		-s expandForListings="$(call getval,expand_for_listings,yes)" \
		-s minOffset="$(call getval,min_listings_box_size,65)" \
		-s orientation="$(call getval,orientation,landscape)" \
		-s size="$(call getval,size,two-page)" \
		listings-all.xml > $@

overlay.svg : overlay_page.html
	if egrep -q '(current)' overlay_page.html ;\
	then \
		wget -q -O $@ http://wikitravel.org$(shell egrep '(current)' overlay_page.html | sed 's/.*href="\(\/upload\/[^"]*\).*/\1/') ;\
	else \
		cp overlay_base.svg $@ ;\
	fi

listings.svg : listings_box.xsl listings.xml wikitravel-print-rules.xml map.svg overlay.svg 
	${XML} tr listings_box.xsl \
		-s orientation="$(call getval,orientation,landscape)" \
		-s size="$(call getval,size,two-page)" \
		-s rulesfile="wikitravel-print-rules.xml" \
		-s listingsPlacement="$(call getval,listings_placement,auto)" \
		-s boxWidth="$(call getval,box_width)" \
		-s box1X="$(call getval,box1_x)" \
		-s box1Y="$(call getval,box1_y)" \
		-s box1Height="$(call getval,box1_h)" \
		-s box2X="$(call getval,box2_x)" \
		-s box2Y="$(call getval,box2_y)" \
		-s box2Height="$(call getval,box2_h)" \
		-s box3X="$(call getval,box3_x)" \
		-s box3Y="$(call getval,box3_y)" \
		-s box3Height="$(call getval,box3_h)" \
		-s box4X="$(call getval,box4_x)" \
		-s box4Y="$(call getval,box4_y)" \
		-s box4Height="$(call getval,box4_h)" \
		listings.xml > $@ 2> listings_box.log

listings.png : listings.svg
	inkscape -z --export-png=listings.png -w $(WIDTH) -h $(HEIGHT) listings.svg >/dev/null 2>&1

index.scm : Config.mk
	echo -n > $@
	echo '(define filename "listings.png" )' >> $@
	echo '(define outfile "${PNG}" )' >> $@
	echo '(define img (car (file-png-load 1 filename filename ) ) )' >> $@
	echo '(gimp-image-convert-indexed img 0 0 64 0 1 "none" )' >> $@
	echo '(file-png-save-defaults 1 img 2 outfile outfile )' >> $@
	echo '(gimp-quit 1 )' >> $@

${PNG} : listings.png index.scm
	gimp -i -c -d -b - < index.scm >/dev/null 2>&1

listings.txt : listings-all.xml
	${XML} sel -T -t -m '/listings' -m 'see|do|buy|eat|drink|sleep' -v @name -n $< > $@

namednodes.txt : data.osm
	${XML} sel -T -t -m "//node/tag[@k='name']"  -v @v -n $< > $@
	${XML} sel -T -t -m "//node/tag[@k='name:en']"  -v @v -n $< >> $@

unmatched.txt : namednodes.txt listings.txt
	grep -v -f $^ > $@ || /bin/true

${SVG} :
	cp listings.svg ${SVG}

.PHONY : wt-clean
wt-clean :
	${RM} article.xml article.wiki wikitravel-print-rules.xml listings-all.xml listings.xml listings.txt overlay.svg *.html

.PHONY : osm-clean
osm-clean : 
	${RM} data.osm relation.xml rels.xml relid

.PHONY : clean
clean : wt-clean osm-clean
	${RM} index.scm map.svg listings.svg listings.png namednodes.txt unmatched.txt transform.log wikitravel-print-rules.xml Config.mk

.PHONY : dist-clean
	${RM} *listings.png *listings.svg *.log Config.mk

.PHONY : diff
diff : article.wiki
	gvimdiff -f article.wiki /home/mark/share/Wiki/travel/${ARTICLE}.wiki

.PHONY : ding
ding : map.svg ${SVG} unmatched.txt
	play -q bell.ogg

.PHONY : adjustments
adjustments : listings.svg
	inkscape listings.svg

.DELETE_ON_ERROR : 

