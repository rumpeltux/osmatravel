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
# settings have been moved out to Config.mk so that 
# the various build targets won't have to be dependant 
# on this file
include Config.mk
include Listings.mk

####################################################

# targets
RULES_FILE = wikitravel-print-rules.xml

# Programs
XML = xmlstarlet

empty:=
space:= $(empty) $(empty)
BORDER_VALUE = $(subst $(space),+,${BORDER})

DING = $(shell if [ "${BELL}" = "yes" ] ; then echo 'ding' ; else echo '' ; fi )

PNG = $(subst /,_,${ARTICLE})_map_with_listings.png

ifeq (${SIZE}, two-page)
	LDIM = 3460
	SDIM = 3008
else
	LDIM = 3008
	SDIM = 1730
endif

ifeq (${ORIENTATION}, portrait)
	WIDTH  = ${SDIM}
	HEIGHT = ${LDIM}
else
	WIDTH  = ${LDIM}
	HEIGHT = ${SDIM}
endif

all : map.svg listings.svg unmatched.txt ${PNG} ${DING}

map.svg : data.osm osmarender.xsl ${RULES_FILE}
	${XML} tr --net osmarender.xsl ${RULES_FILE} > $@ 2> transform.log

rels.xml : Config.mk
	wget -q -O rels.xml "http://openstreetmap.org/api/0.5/relations/search?type=name&value=${BORDER_VALUE}"

relid : Config.mk rels.xml
	${XML} sel -t -m "/osm" -v "relation[tag/@k = 'is_in' and tag/@v = '${IS_IN}']/@id" rels.xml > relid

relation.xml : relid
	wget -q -O relation.xml "http://openstreetmap.org/api/0.5/relation/`cat relid`/full"

data.osm : wikitravel-print-rules.xml
	wget -q -O data.osm `xmlstarlet sel -t -m '/rules' -v '@dataurl' wikitravel-print-rules.xml`

article.xml : Config.mk
	wget -q -O article.xml http://wikitravel.org/en/Special:Export?pages=${ARTICLE}

article.wiki : article.xml
	${XML} sel -N mw=http://www.mediawiki.org/xml/export-0.3/ -t -v "/mw:mediawiki/mw:page/mw:revision/mw:text" article.xml | ${XML} unesc > article.wiki

listings.xml : article.wiki
	echo '<listings>' > listings.xml
	sed 's/&/\&amp;/g' < article.wiki >> listings.xml
	echo '</listings>' >> listings.xml

${RULES_FILE} : icon_rules.xsl listings.xml relation.xml
	${XML} tr icon_rules.xsl \
		-s border="${BORDER}" \
		-s listingsPlacement="${LISTINGS_PLACEMENT}" \
		-s expandForListings="${EXPAND_FOR_LISTINGS}" \
		-s minOffset="${MIN_LISTINGS_BOX_SIZE}" \
		-s orientation="${ORIENTATION}" \
		-s size="${SIZE}" \
		listings.xml > $@

overlay.svg :
	touch $@

listings.svg : listings_box.xsl listings.xml ${RULES_FILE} map.svg overlay.svg Listings.mk
	${XML} tr listings_box.xsl \
		-s orientation="${ORIENTATION}" \
		-s size="${SIZE}" \
		-s rulesfile="${RULES_FILE}" \
		-s listingsPlacement="${LISTINGS_PLACEMENT}" \
		-s boxWidth="${BOX_WIDTH}" \
		-s box1X="${BOX1_X}" \
		-s box1Y="${BOX1_Y}" \
		-s box1Height="${BOX1_H}" \
		-s box2X="${BOX2_X}" \
		-s box2Y="${BOX2_Y}" \
		-s box2Height="${BOX2_H}" \
		-s box3X="${BOX3_X}" \
		-s box3Y="${BOX3_Y}" \
		-s box3Height="${BOX3_H}" \
		-s box4X="${BOX4_X}" \
		-s box4Y="${BOX4_Y}" \
		-s box4Height="${BOX4_H}" \
		listings.xml > $@

listings.png : listings.svg
	inkscape -z --export-png=listings.png -w ${WIDTH} -h ${HEIGHT} listings.svg >/dev/null 2>&1

index.scm : Config.mk
	echo -n > $@
	echo '(define filename "listings.png" )' >> $@
	echo '(define outfile "${PNG}" )' >> $@
	echo '(define img (car (file-png-load 1 filename filename ) ) )' >> $@
	echo '(gimp-image-convert-indexed img 0 0 64 0 1 "none" )' >> $@
	echo '(file-png-save-defaults 1 img 2 outfile outfile )' >> $@
	echo '(gimp-quit 1 )' >> $@

${PNG} : listings.png index.scm
	gimp-console -icd -b - < index.scm >/dev/null 2>&1


listings.txt : listings.xml
	${XML} sel -T -t -m '/listings' -m 'see|do|buy|eat|drink|sleep' -v @name -n $< > $@

namednodes.txt : data.osm
	${XML} sel -T -t -m "//node/tag[@k='name']"  -v @v -n $< > $@
	${XML} sel -T -t -m "//node/tag[@k='name:en']"  -v @v -n $< >> $@

unmatched.txt : namednodes.txt listings.txt
	grep -v -f $^ > $@ || /bin/true

.PHONY : wt-clean
wt-clean :
	${RM} article.xml article.wiki wikitravel-print-rules.xml listings.xml listings.txt ${PNG}

.PHONY : osm-clean
osm-clean : 
	${RM} data.osm relation.xml rels.xml relid

.PHONY : clean
clean : wt-clean osm-clean
	${RM} index.scm map.svg listings.svg listings.png namednodes.txt unmatched.txt transform.log ${RULES_FILE}

.PHONY : diff
diff : article.wiki
	gvimdiff -f article.wiki /home/mark/share/Wiki/travel/${ARTICLE}.wiki

.PHONY : ding
ding : map.svg listings.svg unmatched.txt
	play -q bell.ogg

.DELETE_ON_ERROR : 

