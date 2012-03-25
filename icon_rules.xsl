<?xml version="1.0" encoding="UTF-8"?>
<!--
Copyright (C) 2008 Mark Jaroski

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307, USA

==============================================================================
-->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
        xmlns:xlink="http://www.w3.org/1999/xlink"
        xmlns:svg="http://www.w3.org/2000/svg" >

    <xsl:output omit-xml-declaration="no" indent="yes" encoding="UTF-8"/>

    <xsl:param name="border"/>
    <xsl:param name="orientation"/>
    <xsl:param name="size"/>
    <xsl:param name="expandForListings" required="yes" select="no"/>
    <xsl:param name="minOffset" required="yes" select="78"/>
    <xsl:param name="cropMarginFactor" required="yes" select="0.04"/>
    <xsl:param name="zoomFactor" required="no" select="0.75"/>
    <xsl:param name="attenuationFactor" required="no" select="7"/>

    <xsl:include href="variables.xsl"/>

    <xsl:template name="adjustZoom">
        <xsl:param name="value"/>
        <xsl:value-of select="$value * $zoomFactor"/>
    </xsl:template>

    <xsl:template name="adjustZoomText">
        <xsl:param name="value"/>
        <xsl:value-of select="$value * ( 0.6 + ( 0.4 * $zoomFactor ) )"/>
    </xsl:template>

    <xsl:template match="/">

        <xsl:message>

              firstRelNode: <xsl:value-of select="$reldata/osm/node[1]/@id"/>

       bottomLeftLongitude: <xsl:value-of select="$bottomLeftLongitude"/>
         topRightLongitude: <xsl:value-of select="$topRightLongitude"/>

      horizontalCropOffset: <xsl:value-of select="$horizontalCropOffset"/>
        verticalCropOffset: <xsl:value-of select="$verticalCropOffset"/>

                 dataWidth: <xsl:value-of select="$dataWidth"/>
                dataHeight: <xsl:value-of select="$dataHeight"/>

                 bboxWidth: <xsl:value-of select="$bboxWidth"/>
                bboxHeight: <xsl:value-of select="$bboxHeight"/>

                     scale: <xsl:value-of select="$scale"/>

                     projection: <xsl:value-of select="$projection"/>

                     ratio: <xsl:value-of select="$ratio"/>
            relation-ratio: <xsl:value-of select="$relation-ratio"/>

                leftOffset: <xsl:value-of select="$leftOffset"/>
              bottomOffset: <xsl:value-of select="$bottomOffset"/>

                   dataurl: <xsl:value-of select="$dataurl"/>

        </xsl:message>

        <rules
            xmlns:xlink="http://www.w3.org/1999/xlink"
            xmlns:svg="http://www.w3.org/2000/svg"
            svgBaseProfile="full"
            data="data.osm"
            minimumMapWidth="1"
            minimumMapHeight="1"
            withOSMLayers="yes"
            withUntaggedSegments="no"
            showScale="no"
            showGrid="no"
            showBorder="no"
            showLicense="no"
            showRelationBoundary="yes"
            interactive="no">
            <xsl:attribute name="scale">
                <xsl:value-of select="$scale"/>
            </xsl:attribute>
            <xsl:attribute name="textAttenuation">
                <xsl:value-of select="$attenuationFactor * $scale"/>
            </xsl:attribute>
            <xsl:attribute name="dataurl">
                <xsl:value-of select="$dataurl"/>
            </xsl:attribute>
            <xsl:attribute name="symbolScale">
                <xsl:value-of select="$symbolScale"/>
            </xsl:attribute>
            <xsl:attribute name="leftOffset">
                <xsl:value-of select="$leftOffset"/>
            </xsl:attribute>
            <xsl:attribute name="projection">
                <xsl:value-of select="$projection"/>
            </xsl:attribute>
            <xsl:attribute name="bottomOffset">
                <xsl:value-of select="$bottomOffset"/>
            </xsl:attribute>
            <xsl:attribute name="dataWidth">
                <xsl:value-of select="$dataWidth"/>
            </xsl:attribute>
            <xsl:attribute name="dataHeight">
                <xsl:value-of select="$dataHeight"/>
            </xsl:attribute>

            <xsl:call-template name="background-rule" />

            <rule e="node|way" k="osmarender:render" v="~|yes">
                <xsl:call-template name="landuse-rules" />
                <xsl:call-template name="static-rules" />
                <!-- xsl:call-template name="transport-rules"  / -->
            </rule>

            <rule e="node|way" k="osmarender:render" v="~|yes" layer="4">
                <xsl:call-template name="non-physical-boundaries" />
                <xsl:call-template name="streetname-rules" />
            </rule>

            <rule e="node|way" k="osmarender:renderName" v="~|yes" layer="5">
                <rule e="node" k="railway" v="station" layer="5">
                    <rule e="node" s="way" k="railway" v="rail" layer="5">
                        <text k="name" class='caption-casing railway-station-caption-casing' dy='-1.5px' />
                        <text k="name" class='caption-core railway-station-caption-core' dy='-1.5px' />
                    </rule>
                    <else>
                        <text k="name" class='caption-casing railway-halt-caption-casing' dy='-1px' />
                        <text k="name" class='caption-core railway-halt-caption-core' dy='-1px' />
                    </else>
                </rule>
            </rule>

            <xsl:call-template name="icon-rules"  />

            <defs>
                <xsl:call-template name="defs" />
                <xsl:call-template name="see-do-symbol" />
                <xsl:call-template name="buy-symbol" />
                <xsl:call-template name="sleep-symbol" />
                <xsl:call-template name="eat-symbol" />
                <xsl:call-template name="drink-symbol" />
            </defs>

        </rules>
    </xsl:template>

    <xsl:template name="background-rule">
        <rule e="relation" k="type" v="boundary" layer="-5">
            <rule e="relation" k="name" layer="-5">
                <xsl:attribute name="v">
                    <xsl:value-of select="$border"/>
                </xsl:attribute>
                <area class='boundary-selected-area' />
            </rule>
        </rule>
    </xsl:template>

    <xsl:template name="transport-rules">
        <rule e="node" k="amenity" v="bus_station">
            <symbol xlink:href="#symbol-bus" width='6px' height='2px' transform='translate(-1,-1)' />
        </rule>
    </xsl:template>

    <xsl:template name="icon-rules">

        <xsl:for-each select="/listings/see|/listings/do|/listings/listing">
            <rule e="node" k="name:en|name" layer="5">
                <xsl:attribute name="v">
                    <xsl:value-of select="@name"/>
                </xsl:attribute>
                <symbol width='2px' 
                        height='2px'>
                    <xsl:attribute name="transform">
                        <xsl:text>translate(-1,-1) scale(</xsl:text>
                        <xsl:value-of select="$zoomFactor * 1.1"/>
                        <xsl:text>)</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="xlink:href">
                        <xsl:text>#see-</xsl:text>
                        <xsl:value-of select="position()"/>
                    </xsl:attribute>
                </symbol>
            </rule>
            <rule e="way" k="name:en|name" layer="5">
                <xsl:attribute name="v">
                    <xsl:value-of select="@name"/>
                </xsl:attribute>
                <areaSymbol width='2px' 
                        height='2px'>
                    <xsl:attribute name="transform">
                        <xsl:text>translate(-1,-1) scale(</xsl:text>
                        <xsl:value-of select="$zoomFactor * 1.1"/>
                        <xsl:text>)</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="xlink:href">
                        <xsl:text>#see-</xsl:text>
                        <xsl:value-of select="position()"/>
                    </xsl:attribute>
                </areaSymbol>
            </rule>
        </xsl:for-each>

        <xsl:for-each select="/listings/sleep">
            <rule e="node" k="name:en|name" layer="5">
                <xsl:attribute name="v">
                    <xsl:value-of select="@name"/>
                </xsl:attribute>
                <symbol width='2px' 
                        height='2px'>
                    <xsl:attribute name="transform">
                        <xsl:text>translate(-1,-1) scale(</xsl:text>
                        <xsl:value-of select="$zoomFactor * 1.1"/>
                        <xsl:text>)</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="xlink:href">
                        <xsl:text>#sleep-</xsl:text>
                        <xsl:value-of select="position()"/>
                    </xsl:attribute>
                </symbol>
            </rule>
        </xsl:for-each>

        <xsl:for-each select="/listings/buy">
            <rule e="node" k="name:en|name" layer="5">
                <xsl:attribute name="v">
                    <xsl:value-of select="@name"/>
                </xsl:attribute>
                <symbol width='2px' 
                        height='2px'>
                    <xsl:attribute name="transform">
                        <xsl:text>translate(-1,-1) scale(</xsl:text>
                        <xsl:value-of select="$zoomFactor * 1.1"/>
                        <xsl:text>)</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="xlink:href">
                        <xsl:text>#buy-</xsl:text>
                        <xsl:value-of select="position()"/>
                    </xsl:attribute>
                </symbol>
            </rule>
        </xsl:for-each>

        <xsl:for-each select="/listings/eat">
            <rule e="node" k="name:en|name" layer="5">
                <xsl:attribute name="v">
                    <xsl:value-of select="@name"/>
                </xsl:attribute>
                <symbol width='2px' 
                        height='2px'>
                    <xsl:attribute name="transform">
                        <xsl:text>translate(-1,-1) scale(</xsl:text>
                        <xsl:value-of select="$zoomFactor * 1.4"/>
                        <xsl:text>)</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="xlink:href">
                        <xsl:text>#eat-</xsl:text>
                        <xsl:value-of select="position()"/>
                    </xsl:attribute>
                </symbol>
            </rule>
        </xsl:for-each>

        <xsl:for-each select="/listings/drink">
            <rule e="node" k="name:en|name" layer="5">
                <xsl:attribute name="v">
                    <xsl:value-of select="@name"/>
                </xsl:attribute>
                <symbol width='2px' 
                        height='2px'>
                    <xsl:attribute name="transform">
                        <xsl:text>translate(-1,-1) scale(</xsl:text>
                        <xsl:value-of select="$zoomFactor * 1.1"/>
                        <xsl:text>)</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="xlink:href">
                        <xsl:text>#drink-</xsl:text>
                        <xsl:value-of select="position()"/>
                    </xsl:attribute>
                </symbol>
            </rule>
        </xsl:for-each>

    </xsl:template>

    <xsl:template name="landuse-rules">
        <!-- Landuse -->
        <rule e="way" k="landuse" v="cemetery">
            <rule e="way" k="religion" v="christian">
                <area class='landuse-cemetery-christian' />
            </rule>
			<else>
				<area class='landuse-cemetery' />
			</else>
        </rule>
    </xsl:template>

    <xsl:template name="non-physical-boundaries">
		<!-- Non-physical boundaries -->
		<rule e="way" k="boundary" v="administrative" layer="4">
			<rule e="way" k="border_type" v="state" layer="4">
				<line class="boundary boundary-administrative-state-casing" />
				<line class="boundary boundary-administrative-state-core" />
			</rule>	
			<else>
			        <rule e="way" k="admin_level" v="10" layer="4">
   					<line class="boundary boundary-administrative-parish-core" />
  				</rule>
			        <else>
  	 		        	<rule e="way" k="admin_level" v="8" layer="4">
   						<line class="boundary boundary-administrative-district-core" />
  					</rule>
                                	<else>
  						<line class="boundary boundary-administrative-state-core" />
  					</else>
				</else>
			</else>	
		</rule>
    </xsl:template>

    <xsl:template name="streetname-rules">
        <!-- Waterway and Street names -->
        <rule e="way" k="osmarender:renderName" v="~|yes" layer="4">
            <rule e="way" k="tunnel" v="~|no|false" layer="4">    <!-- no names in tunnels -->
				<rule e="way" k="junction" v="~" layer="4"> <!-- no names on or along junctions -->
    
					<rule e="way" k="waterway" v="drain" layer="4">
					    <text k="name" startOffset='50%' class="waterway-name-casing waterway-drain-name-casing" dy='0.5px' />
					    <text k="name" startOffset='50%' class="waterway-name-core waterway-drain-name-core" dy='0.5px' />
					</rule>
					<rule e="way" k="waterway" v="canal" layer="4">
					    <text k="name" startOffset='50%' class="waterway-name-casing waterway-canal-name-casing" dy='0.5px' />
					    <text k="name" startOffset='50%' class="waterway-name-core waterway-canal-name-core" dy='0.5px' />
					</rule>
					<rule e="way" k="waterway" v="stream" layer="4">
					    <text k="name" startOffset='50%' class="waterway-name-casing waterway-stream-name-casing" dy='0.5px' />
					    <text k="name" startOffset='50%' class="waterway-name-core waterway-stream-name-core" dy='0.5px' />
					</rule>
					<rule e="way" k="waterway" v="river" layer="4">
					    <text k="name" startOffset='50%' class="waterway-name-casing waterway-river-name-casing" dy='0.5px' />
					    <text k="name" startOffset='50%' class="waterway-name-core waterway-river-name-core" dy='0.5px' />
					</rule>
					
					<rule e="way" k="highway" v="pedestrian" layer="4">
					    <text k="name" startOffset='50%' class="highway-name highway-pedestrian-name" dy='0.7px' />
					</rule>
                    <!--xsl:if test="$scale > 0.1" -->
                        <rule e="way" k="scramble" v="*" layer="4">
                            <text k="name" startOffset='50%' class="caption-casing highway-scramble-name" dy='0.7px' />
                            <text k="name" startOffset='50%' class="caption-core highway-scramble-name" dy='0.7px' />
                        </rule>
                        <rule e="way" k="highway" v="cycleway" layer="4">
                            <text k="name" startOffset='50%' class="highway-name highway-cycleway-name" dy='0.7px' />
                        </rule>
                        <rule e="way" k="highway" v="steps" layer="4">
                            <text k="name" startOffset='50%' class="highway-name highway-steps-name" dy='0.7px' />
                        </rule>
                        <rule e="way" k="highway" v="footway|footpath" layer="4">
                            <text k="name" startOffset='50%' class="highway-name highway-footway-name" dy='0.7px' />
                        </rule>
                        <rule e="way" k="highway" v="bridleway" layer="4">
                            <text k="name" startOffset='50%' class="highway-name highway-bridleway-name" dy='0.7px' />
                        </rule>
                        <rule e="way" k="highway" v="byway" layer="4">
                            <text k="name" startOffset='50%' class="highway-name highway-byway-name" dy='0.7px' />
                        </rule>
                        <rule e="way" k="highway" v="track" layer="4">
                            <text k="name" startOffset='50%' class="highway-name highway-track-name" dy='0.7px' />
                        </rule>
                        <rule e="way" k="highway" v="unsurfaced" layer="4">
                            <text k="name" startOffset='50%' class="highway-name highway-unsurfaced-name" dy='0.7px' />
                        </rule>
                    <!-- /xsl:if-->
                    <!-- xsl:if test="$scale > 0.2" -->
                        <rule e="way" k="highway" v="service" layer="4">
                            <text k="name" startOffset='50%' class="highway-name highway-service-name" dy='0.7px' />
                        </rule>
                    <!-- /xsl:if -->
                    <!-- xsl:if test="$scale > 0.2" -->
                        <rule e="way" k="highway" v="unclassified|residential|minor" layer="4">
                            <text k="name" startOffset='50%' class="highway-name highway-unclassified-name" dy='0.7px' />
                        </rule>
                    <!-- /xsl:if -->
                    <!-- xsl:if test="$scale > 0.1" -->
                        <rule e="way" k="highway" v="tertiary" layer="4">
                            <text k="name" startOffset='50%' class="highway-name highway-tertiary-name" dy='1px' />
                        </rule>
                    <!-- /xsl:if -->
                    <!-- xsl:if test="$scale > 0.1" -->
                        <rule e="way" k="highway" v="secondary" layer="4">
                            <text k="name" startOffset='50%' class="highway-name highway-secondary-name" dy='1px' />
                        </rule>
                    <!-- /xsl:if -->
					<rule e="way" k="highway" v="primary_link" layer="4">
					    <text k="name" startOffset='50%' class="highway-name highway-primary-link-name" dy='1px' />
					</rule>
					<rule e="way" k="highway" v="trunk_link" layer="4">
					    <text k="name" startOffset='50%' class="highway-name highway-trunk-link-name" dy='0.7px' />
					</rule>
					<rule e="way" k="highway" v="motorway_link" layer="4">
					    <text k="name" startOffset='50%' class="highway-name highway-motorway-link-name" dy='0.7px' />
					</rule>
					<rule e="way" k="highway" v="primary" layer="4">
					    <text k="name" startOffset='50%' class="highway-name highway-primary-name" dy='1px'/>
					</rule>
					<rule e="way" k="highway" v="trunk" layer="4">
					    <text k="name" startOffset='50%' class="highway-name highway-trunk-name" dy='0.7px' />
					</rule>
					<rule e="way" k="highway" v="motorway" layer="4">
					    <text k="name" startOffset='50%' class="highway-name highway-motorway-name" dy='0.7px' />
					</rule>
				</rule>
				<rule e="way" k="junction" v="*" layer="4"> <!-- Roundabouts, motorway exits etc -->
                    <rule e="way" k="highway" v="secondary" layer="4">
                        <areaText k="name" startOffset='50%' class="highway-name highway-secondary-name" dy='2px' />
                    </rule>
                    <rule e="way" k="highway" v="primary|primary_link" layer="4">
                        <areaText k="name" startOffset='50%' class="highway-name highway-primary-name" dy='2px' />
                    </rule>
                    <rule e="way" k="highway" v="trunk|trunk_link" layer="4">
                        <areaText k="name" startOffset='50%' class="highway-name highway-trunk-name" dy='2.2px' />
                    </rule>
                    <rule e="way" k="highway" v="motorway|motorway_link" layer="4">
                        <areaText k="name" startOffset='50%' class="highway-name highway-motorway-name" dy='2.2px' />
                    </rule>
				</rule>
            </rule>
        </rule>
    </xsl:template>

    <xsl:template name="static-rules">

        <!-- Natural features -->
        <rule e="way" k="natural" v="coastline">
            <area class='natural-coastline'/>
        </rule>
        <rule e="way" k="natural" v="land">
            <area class='natural-land' />
        </rule>
        <rule e="way" k="natural" v="beach">
            <area class='natural-beach' />
        </rule>
        <rule e="way" k="natural" v="forest|wood|heath|scrub">
            <area class='landuse-wood'/>
        </rule>

		<!-- Artificial landuse -->
        <rule e="way" k="amenity" v="school|college|university">
            <area class='amenity-school'/>
        </rule>
        <rule e="way" k="leisure" v="park|playground|playing_fields|garden|pitch|golf_course|common|green">
            <area class='leisure-park'/>
        </rule>
        <rule e="way" k="leisure" v="stadium|sports_centre">
            <area class='leisure-stadium'/>
        </rule>
        <rule e="way" k="leisure" v="track">
            <area class='leisure-track'/>
        </rule>

		<!-- Airports and runways -->
		<rule e="way" k="aeroway" v="apron">
			<area class='aeroway-apron'/>			
		</rule>
		<rule e="way" k="landuse" v="runway">
			<rule e="way" k="use_status" v="~">
				<area class='landuse-runway' />
			</rule>
			<rule e="way" k="use_status" v="disused">
				<area class='landuse-runway-disused' />
			</rule>
			<rule e="way" k="use_status" v="dismantled">
				<area class='landuse-runway-dismantled' />
			</rule>
		</rule>

		<!-- Raceways and racetracks (cars and horses etc) -->
		<rule e="way" k="landuse" v="raceway">
			<rule e="way" k="use_status" v="~">
				<area class='landuse-raceway' />
			</rule>
			<rule e="way" k="use_status" v="disused">
				<area class='landuse-raceway-disused' />
			</rule>
			<rule e="way" k="use_status" v="dismantled">
				<area class='landuse-raceway-dismantled' />
			</rule>
		</rule>

        <!-- Man-made areas -->
        <rule e="way" k="sport" v="*">
            <area class='sport'/>
        </rule>
        <rule e="way" k="amenity" v="parking">
            <area class='amenity-parking'/>
        </rule>
        <rule e="way" k="tourism" v="attraction">
            <area class='tourism-attraction'/>
        </rule>
        <rule e="way" k="aeroway" v="terminal">
            <area class='building-block'/>
        </rule>
        <rule e="way" k="building" v="*">
            <area class='building-block'/>
        </rule>


        <!-- Airfields and airports -->
        <rule e="segment|way" k="aeroway" v="runway">
            <line class='aeroway-runway-casing'/>
        </rule>
        <rule e="segment|way" k="aeroway" v="taxiway">
            <line class='aeroway-taxiway-casing'/>
        </rule>


        <!-- Waterways -->
        <rule e="way" k="waterway" v="riverbank">
            <area class='waterway-riverbank'/>
        </rule>
        <rule e="segment|way" k="waterway" v="river">
            <line class='waterway-casing waterway-river-casing'/>
        </rule>
        <rule e="segment|way" k="waterway" v="stream">
            <line class='waterway-casing waterway-stream-casing'/>
        </rule>
        <rule e="segment|way" k="waterway" v="canal">
            <line class='waterway-casing waterway-canal-casing'/>
        </rule>
        <rule e="segment|way" k="waterway" v="drain">
            <line class='waterway-casing waterway-drain-casing'/>
        </rule>
        <rule e="segment|way" k="waterway" v="river">
            <line class='waterway-core waterway-river-core'/>
        </rule>
        <rule e="segment|way" k="waterway" v="stream">
            <line class='waterway-core waterway-stream-core'/>
        </rule>
        <rule e="segment|way" k="waterway" v="canal">
            <line class='waterway-core waterway-canal-core'/>
        </rule>
        <rule e="segment|way" k="waterway" v="drain">
            <line class='waterway-core waterway-drain-core'/>
        </rule>
        <rule e="way" k="waterway" v="dock">
            <area class='natural-water' />
        </rule>
        <rule e="way" k="natural" v="water|pond|lake">
            <area class='natural-water' />
        </rule>
        <rule e="way" k="landuse" v="reservoir">
            <area class='natural-water' />
        </rule>
        <rule e="way" k="landuse" v="basin">
            <area class='natural-water' />
        </rule>

        <!-- Bridge casings -->
        <rule e="way" k="bridge" v="yes|true">
            <rule e="way" k="railway" v="rail">
                <line class='bridge-casing railway-rail-bridge-casing' smart-linecap='no'/>
            </rule>
            <rule e="way" k="railway" v="light_rail">
                <line class='bridge-casing railway-light-rail-bridge-casing' smart-linecap='no'/>
            </rule>
            <rule e="way" k="railway" v="subway">
                <line class='bridge-casing railway-subway-bridge-casing' smart-linecap='no'/>
            </rule>
            <rule e="way" k="railway" v="tram">
                <line class='bridge-casing railway-tram-bridge-casing' smart-linecap='no'/>
            </rule>
            <rule e="way" k="railway" v="narrow_gauge">
                <line class='bridge-casing railway-narrow-gauge-bridge-casing' smart-linecap='no'/>
            </rule>
            <rule e="way" k="railway" v="preserved">
                <line class='bridge-casing railway-preserved-bridge-casing' smart-linecap='no'/>
            </rule>
            <rule e="way" k="railway" v="monorail">
                <line class='bridge-casing railway-monorail-bridge-casing' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="motorway">
                <line class='bridge-casing highway-motorway-bridge-casing' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="trunk">
                <line class='bridge-casing highway-trunk-bridge-casing' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="primary">
                <line class='bridge-casing highway-primary-bridge-casing' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="motorway_link">
                <line class='bridge-casing highway-motorway-link-bridge-casing' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="trunk-link">
                <line class='bridge-casing highway-trunk-link-bridge-casing' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="primary-link">
                <line class='bridge-casing highway-primary-link-bridge-casing' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="secondary">
                <line class='bridge-casing highway-secondary-bridge-casing' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="tertiary">
                <line class='bridge-casing highway-tertiary-bridge-casing' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="unclassified|residential|minor">
                <line class='bridge-casing highway-unclassified-bridge-casing' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="service">
                <line class='bridge-casing highway-service-bridge-casing' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="unsurfaced">
                <line class='bridge-casing highway-unsurfaced-bridge-casing' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="track">
                <line class='bridge-casing highway-track-bridge-casing' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="byway">
                <line class='bridge-casing highway-byway-bridge-casing' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="bridleway">
                <line class='bridge-casing highway-bridleway-bridge-casing' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="cycleway">
                <line class='bridge-casing highway-cycleway-bridge-casing' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="pedestrian">
                <line class='bridge-casing highway-pedestrian-bridge-casing' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="footway|footpath">
                <line class='bridge-casing highway-footway-bridge-casing' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="steps">
                <line class='bridge-casing highway-steps-bridge-casing' smart-linecap='no'/>
            </rule>
        </rule>


        <!-- Bridge cores -->
        <rule e="way" k="bridge" v="yes|true">
            <rule e="way" k="railway" v="rail">
                <line class='bridge-core railway-rail-bridge-core' smart-linecap='no'/>
            </rule>
            <rule e="way" k="railway" v="light_rail">
                <line class='bridge-core railway-light-rail-bridge-core' smart-linecap='no'/>
            </rule>
            <rule e="way" k="railway" v="subway">
                <line class='bridge-core railway-subway-bridge-core' smart-linecap='no'/>
            </rule>
            <rule e="way" k="railway" v="tram">
                <line class='bridge-core railway-tram-bridge-core' smart-linecap='no'/>
            </rule>
            <rule e="way" k="railway" v="narrow_gauge">
                <line class='bridge-core railway-narrow-gauge-bridge-core' smart-linecap='no'/>
            </rule>
            <rule e="way" k="railway" v="preserved">
                <line class='bridge-core railway-preserved-bridge-core' smart-linecap='no'/>
            </rule>
            <rule e="way" k="railway" v="monorail">
                <line class='bridge-core railway-monorail-bridge-core' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="motorway">
                <line class='bridge-core highway-motorway-bridge-core' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="trunk">
                <line class='bridge-core highway-trunk-bridge-core' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="primary">
                <line class='bridge-core highway-primary-bridge-core' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="motorway_link">
                <line class='bridge-core highway-motorway-link-bridge-core' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="trunk-link">
                <line class='bridge-core highway-trunk-link-bridge-core' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="primary-link">
                <line class='bridge-core highway-primary-link-bridge-core' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="secondary">
                <line class='bridge-core highway-secondary-bridge-core' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="tertiary">
                <line class='bridge-core highway-tertiary-bridge-core' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="unclassified|residential|minor">
                <line class='bridge-core highway-unclassified-bridge-core' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="service">
                <line class='bridge-core highway-service-bridge-core' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="unsurfaced">
                <line class='bridge-core highway-unsurfaced-bridge-core' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="track">
                <line class='bridge-core highway-track-bridge-core' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="byway">
                <line class='bridge-core highway-byway-bridge-core' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="bridleway">
                <line class='bridge-core highway-bridleway-bridge-core' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="cycleway">
                <line class='bridge-core highway-cycleway-bridge-core' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="pedestrian">
                <line class='bridge-core highway-pedestrian-bridge-core' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="footway|footpath">
                <line class='bridge-core highway-footway-bridge-core' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="steps">
                <line class='bridge-core highway-steps-bridge-core' smart-linecap='no'/>
            </rule>
        </rule>

        <!-- Linear casings -->
        <rule e="way" k="tunnel" v="~|no">
			<rule e="way" k="highway" v="raceway">
				<rule e="way" k="use_status" v="~">
					<line class='highway-raceway-casing' />
				</rule>
				<rule e="way" k="use_status" v="disused">
					<line class='highway-raceway-casing-disused' />
				</rule>
				<rule e="way" k="use_status" v="dismantled">
					<line class='highway-raceway-casing-dismantled' />
				</rule>
			</rule>
            <rule e="way" k="highway" v="steps">
                <line class='highway-casing highway-steps-casing' />
            </rule>
            <rule e="way" k="highway" v="footway|footpath">
                <line class='highway-casing highway-footway-casing' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="pedestrian">
                <line class='highway-casing highway-pedestrian-casing' />
            </rule>
            <rule e="way" k="highway" v="cycleway">
                <line class='highway-casing highway-cycleway-casing' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="bridleway">
                <line class='highway-casing highway-bridleway-casing' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="byway">
                <line class='highway-casing highway-byway-1-casing' smart-linecap='no'/>
                <line class='highway-casing highway-byway-2-casing' smart-linecap='no'/>
                <line class='highway-casing highway-byway-3-casing' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="track">
                <line class='highway-casing highway-track-casing'/>
            </rule>
            <rule e="way" k="highway" v="unsurfaced">
                <line class='highway-casing highway-unsurfaced-casing' smart-linecap='no'/>
            </rule>
            <rule e="way" k="highway" v="service">
                <line class='highway-casing highway-service-casing' />
            </rule>
            <rule e="way" k="highway" v="unclassified|residential|minor">
                <line class='highway-casing highway-unclassified-casing' />
            </rule>
            <rule e="way" k="highway" v="tertiary">
                <line class='highway-casing highway-tertiary-casing' />
            </rule>
            <rule e="way" k="highway" v="secondary">
                <line class='highway-casing highway-secondary-casing' />
            </rule>
            <rule e="way" k="highway" v="primary_link">
                <line class='highway-casing highway-primary-link-casing' />
            </rule>
            <rule e="way" k="highway" v="trunk_link">
                <line class='highway-casing highway-trunk-link-casing' />
            </rule>
            <rule e="way" k="highway" v="motorway_link">
                <line class='highway-casing highway-motorway-link-casing' />
            </rule>
            <rule e="way" k="highway" v="primary">
                <line class='highway-casing highway-primary-casing' />
            </rule>
            <rule e="way" k="highway" v="trunk">
                <line class='highway-casing highway-trunk-casing' />
            </rule>
            <rule e="way" k="highway" v="motorway">
                <line class='highway-casing highway-motorway-casing' />
            </rule>
            <rule e="way" k="railway" v="monorail">
                <line class='railway-casing railway-monorail-casing' />
            </rule>
            <rule e="way" k="railway" v="preserved">
                <line class='railway-casing railway-preserved-casing' />
            </rule>
            <rule e="way" k="railway" v="narrow_gauge">
                <line class='railway-casing railway-narrow-gauge-casing' />
            </rule>
            <rule e="way" k="railway" v="tram">
                <line class='railway-casing railway-tram-casing' />
            </rule>
            <rule e="way" k="railway" v="subway">
                <line class='railway-casing railway-subway-casing' />
            </rule>
            <rule e="way" k="railway" v="light_rail">
                <line class='railway-casing railway-light-rail-casing' />
            </rule>
            <rule e="way" k="railway" v="rail">
                <line class='railway-casing railway-rail-casing' />
            </rule>
        </rule>

        <!-- Linear cores -->
        <rule e="way" k="tunnel" v="~|false|no">
			<rule e="way" k="highway" v="raceway">
				<rule e="way" k="use_status" v="~">
					<line class='highway-raceway-core' />
				</rule>
				<rule e="way" k="use_status" v="disused">
					<line class='highway-raceway-core-disused' />
				</rule>
				<rule e="way" k="use_status" v="dismantled">
					<line class='highway-raceway-core-dismantled' />
				</rule>
			</rule>
            <rule e="way" k="scramble" v="*">
                <line class='highway-core highway-scramble-core' />
            </rule>
			<rule e="way" k="highway" v="steps">
				<line class='highway-core highway-steps-core' smart-linecap='no'/>
			</rule>
			<rule e="way" k="highway" v="footway|footpath">
				<line class='highway-core highway-footway-core' />
			</rule>
			<rule e="way" k="highway" v="pedestrian">
				<line class='highway-core highway-pedestrian-core' />
			</rule>
			<rule e="way" k="highway" v="cycleway">
				<line class='highway-core highway-cycleway-core' />
			</rule>
			<rule e="way" k="highway" v="bridleway">
				<line class='highway-core highway-bridleway-core' />
			</rule>
			<rule e="way" k="highway" v="byway">
				<line class='highway-core highway-byway-2-casing' smart-linecap='no'/>
				<line class='highway-core highway-byway-3-casing' smart-linecap='no'/>
				<line class='highway-core highway-byway-1-core' />
			</rule>
			<rule e="way" k="highway" v="track">
				<line class='highway-core highway-track-core' />
			</rule>
            <rule e="way" k="highway" v="unsurfaced">
                <line class='highway-core highway-unsurfaced-core' />
            </rule>
            <rule e="way" k="highway" v="service">
                <line class='highway-core highway-service-core' />
            </rule>
            <rule e="way" k="highway" v="unclassified|residential|minor">
                <line class='highway-core highway-unclassified-core' />
            </rule>
            <rule e="way" k="highway" v="tertiary">
                <line class='highway-core highway-tertiary-core' />
            </rule>
            <rule e="way" k="highway" v="secondary">
                <line class='highway-core highway-secondary-core' />
            </rule>
            <rule e="way" k="highway" v="primary_link">
                <line class='highway-core highway-primary-link-core' />
            </rule>
			<rule e="way" k="highway" v="trunk_link">
				<line class='highway-core highway-trunk-link-core' />
			</rule>
			<rule e="way" k="highway" v="motorway_link">
				<line class='highway-core highway-motorway-link-core' />
			</rule>
			<rule e="way" k="highway" v="primary">
				<line class='highway-core highway-primary-core' />
			</rule>
			<rule e="way" k="highway" v="trunk">
				<line class='highway-core highway-trunk-core' />
			</rule>
			<rule e="way" k="highway" v="motorway">
				<line class='highway-core highway-motorway-core' />
			</rule>
            <rule e="way" k="railway" v="monorail">
                <line class='railway-core railway-monorail-core' />
            </rule>
            <rule e="way" k="railway" v="preserved">
                <line class='railway-core railway-preserved-core' />
            </rule>
            <rule e="way" k="railway" v="narrow_gauge">
                <line class='railway-core railway-narrow-gauge-core' />
            </rule>
            <rule e="way" k="railway" v="tram">
                <line class='railway-core railway-tram-core' />
            </rule>
            <rule e="way" k="railway" v="subway">
                <line class='railway-core railway-subway-core' />
            </rule>
            <rule e="way" k="railway" v="light_rail">
                <line class='railway-core railway-light-rail-core' />
            </rule>
            <rule e="way" k="railway" v="rail">
                <line class='railway-core railway-rail-1-core' />
                <line class='railway-core railway-rail-2-core' smart-linecap='no'/>
            </rule>
			<rule e="way" k="aeroway" v="runway">
			    <line class='aeroway-runway-core'/>
			</rule>
			<rule e="way" k="aeroway" v="taxiway">
			    <line class='aeroway-taxiway-core'/>
			</rule>
        </rule>

        <!-- Tunnels -->
        <rule e="way" k="tunnel" v="true|yes">
            <rule e="way" k="highway" v="steps">
				<line class='tunnel-casing highway-steps-casing tunnel' mask-class='tunnel-core highway-steps-core'/>
				<line class='highway-steps-casing highway-tunnel-ends'/>
            </rule>
            <rule e="way" k="highway" v="footway|footpath">
				<line class='tunnel-casing highway-footway-casing tunnel' mask-class='tunnel-core highway-footway-core'/>
				<line class='highway-footway-casing highway-tunnel-ends'/>
            </rule>
            <rule e="way" k="highway" v="pedestrian">
				<line class='tunnel-casing highway-pedestrian-casing tunnel' mask-class='tunnel-core highway-pedestrian-core'/>
				<line class='highway-pedestrian-casing highway-tunnel-ends'/>
            </rule>
            <rule e="way" k="highway" v="cycleway">
				<line class='tunnel-casing highway-cycleway-casing tunnel' mask-class='tunnel-core highway-cycleway-core'/>
				<line class='highway-cycleway-casing highway-tunnel-ends'/>
            </rule>
            <rule e="way" k="highway" v="bridleway">
				<line class='tunnel-casing highway-bridleway-casing tunnel' mask-class='tunnel-core highway-bridleway-core'/>
				<line class='highway-bridleway-casing highway-tunnel-ends'/>
            </rule>
            <rule e="way" k="highway" v="byway">
				<line class='tunnel-casing highway-byway-1-casing tunnel' mask-class='tunnel-core highway-byway-1-core'/>
				<line class='highway-byway-1-casing highway-tunnel-ends'/>
            </rule>
            <rule e="way" k="highway" v="track">
				<line class='tunnel-casing highway-track-casing tunnel' mask-class='tunnel-core highway-track-core'/>
				<line class='highway-track-casing highway-tunnel-ends'/>
            </rule>
            <rule e="way" k="highway" v="unsurfaced">
				<line class='tunnel-casing highway-unsurfaced-casing tunnel' mask-class='tunnel-core highway-unsurfaced-core'/>
				<line class='highway-unsurfaced-casing highway-tunnel-ends'/>
            </rule>
            <rule e="way" k="highway" v="service">
				<line class='tunnel-casing highway-service-casing tunnel' mask-class='tunnel-core highway-service-core'/>
				<line class='highway-service-casing highway-tunnel-ends'/>
            </rule>
            <rule e="way" k="highway" v="unclassified|residential|minor|tertiary">
				<line class='tunnel-casing highway-unclassified-casing tunnel' mask-class='tunnel-core highway-unclassified-core'/>
				<line class='highway-unclassified-casing highway-tunnel-ends'/>
            </rule>
            <rule e="way" k="highway" v="tertiary">
				<line class='tunnel-casing highway-tertiary-casing tunnel' mask-class='tunnel-core highway-tertiary-core'/>
				<line class='highway-tertiary-casing highway-tunnel-ends'/>
            </rule>
            <rule e="way" k="highway" v="secondary">
				<line class='tunnel-casing highway-secondary-casing tunnel' mask-class='tunnel-core highway-secondary-core'/>
				<line class='highway-secondary-casing highway-tunnel-ends'/>
            </rule>
            <rule e="way" k="highway" v="primary_link">
				<line class='tunnel-casing highway-primary-link-casing tunnel' mask-class='tunnel-core highway-primary-link-core'/>
				<line class='highway-primary-link-casing highway-tunnel-ends'/>
            </rule>
            <rule e="way" k="highway" v="trunk_link">
				<line class='tunnel-casing highway-trunk-link-casing tunnel' mask-class='tunnel-core highway-trunk-link-core'/>
				<line class='highway-trunk-link-casing highway-tunnel-ends'/>
            </rule>
            <rule e="way" k="highway" v="motorway_link">
				<line class='tunnel-casing highway-motorway-link-casing tunnel' mask-class='tunnel-core highway-motorway-link-core'/>
				<line class='highway-motorway-link-casing highway-tunnel-ends'/>
            </rule>
            <rule e="way" k="highway" v="primary">
				<line class='tunnel-casing highway-primary-casing tunnel' mask-class='tunnel-core highway-primary-core'/>
				<line class='highway-primary-casing highway-tunnel-ends'/>
            </rule>
            <rule e="way" k="highway" v="trunk">
				<line class='tunnel-casing highway-trunk-casing tunnel' mask-class='tunnel-core highway-trunk-core'/>
				<line class='highway-trunk-casing highway-tunnel-ends'/>
            </rule>
            <rule e="way" k="highway" v="motorway">
				<line class='tunnel-casing highway-motorway-casing tunnel' mask-class='tunnel-core highway-motorway-core'/>
				<line class='highway-motorway-casing highway-tunnel-ends'/>
            </rule>
            <rule e="way" k="railway" v="monorail">
				<line class='tunnel-casing railway-monorail-casing tunnel' mask-class='tunnel-core railway-monorail-core'/>
				<line class='railway-monorail-casing highway-tunnel-ends'/>
            </rule>
            <rule e="way" k="railway" v="preserved">
				<line class='tunnel-casing railway-preserved-casing tunnel' mask-class='tunnel-core railway-preserved-core'/>
				<line class='railway-preserved-casing highway-tunnel-ends'/>
            </rule>
            <rule e="way" k="railway" v="narrow_gauge">
				<line class='tunnel-casing railway-narrow-gauge-casing tunnel' mask-class='tunnel-core railway-narrow-gauge-core'/>
				<line class='railway-narrow-gauge-casing highway-tunnel-ends'/>
            </rule>
            <rule e="way" k="railway" v="tram">
				<line class='tunnel-casing railway-tram-casing tunnel' mask-class='tunnel-core railway-tram-core'/>
				<line class='railway-tram-casing highway-tunnel-ends'/>
            </rule>
            <rule e="way" k="railway" v="subway">
				<line class='tunnel-casing railway-subway-casing tunnel' mask-class='tunnel-core railway-subway-core'/>
				<line class='railway-subway-casing highway-tunnel-ends'/>
            </rule>
            <rule e="way" k="railway" v="light_rail">
				<line class='tunnel-casing railway-light-rail-casing tunnel' mask-class='tunnel-core railway-light-rail-core'/>
				<line class='railway-light-rail-casing highway-tunnel-ends'/>
            </rule>
			<rule e="way" k="railway" v="rail">
				<line class='tunnel-casing railway-rail-casing tunnel' mask-class='tunnel-core railway-rail-1-core'/>
				<line class='railway-rail-casing highway-tunnel-ends'/>
			</rule>
        </rule>

        <!-- highway motorway-junctions -->
        <rule e="node" k="highway" v="motorway_junction">
          <circle r="2.25" class="highway-motorway-junction" />
          <text k="name" class='highway-motorway-junction-caption' dy='-2px' />
          <text k="ref" class='highway-motorway-junction-caption' dy='+6px' />
        </rule>
        
        <!-- Linear cores (under construction) -->
        <rule e="way" k="highway" v="construction">
			<rule e="way" k="construction" v="steps">
				<line class='highway-core highway-steps-core under-construction' />
			</rule>
			<rule e="way" k="construction" v="footway|footpath">
				<line class='highway-core highway-footway-core under-construction' />
			</rule>
			<rule e="way" k="construction" v="pedestrian">
				<line class='highway-core highway-pedestrian-core under-construction' />
			</rule>
			<rule e="way" k="construction" v="cycleway">
				<line class='highway-core highway-cycleway-core under-construction' />
			</rule>
			<rule e="way" k="construction" v="bridleway">
				<line class='highway-core highway-bridleway-core under-construction' />
			</rule>
			<rule e="way" k="construction" v="byway">
				<line class='highway-core highway-byway-1-core under-construction' />
			</rule>
			<rule e="way" k="construction" v="track">
				<line class='highway-core highway-track-core under-construction' />
			</rule>
            <rule e="way" k="construction" v="unsurfaced">
                <line class='highway-core highway-unsurfaced-core under-construction' />
            </rule>
            <rule e="way" k="construction" v="service">
                <line class='highway-core highway-service-core under-construction' />
            </rule>
            <rule e="way" k="construction" v="unclassified|residential|minor">
                <line class='highway-core highway-unclassified-core under-construction' />
            </rule>
            <rule e="way" k="construction" v="tertiary">
                <line class='highway-core highway-tertiary-core under-construction' />
            </rule>
            <rule e="way" k="construction" v="secondary">
                <line class='highway-core highway-secondary-core under-construction' />
            </rule>
            <rule e="way" k="construction" v="primary_link">
                <line class='highway-core highway-primary-link-core under-construction' />
            </rule>
			<rule e="way" k="construction" v="trunk_link">
				<line class='highway-core highway-trunk-link-core under-construction' />
			</rule>
			<rule e="way" k="construction" v="motorway_link">
				<line class='highway-core highway-motorway-link-core under-construction' />
			</rule>
			<rule e="way" k="construction" v="primary">
				<line class='highway-core highway-primary-core under-construction' />
			</rule>
			<rule e="way" k="construction" v="trunk">
				<line class='highway-core highway-trunk-core under-construction' />
			</rule>
			<rule e="way" k="construction" v="motorway">
				<line class='highway-core highway-motorway-core under-construction' />
			</rule>
		</rule>
		<rule e="way" k="highway" v="construction">
            <rule e="way" k="construction" v="monorail">
                <line class='railway-core railway-monorail-core under-construction' />
            </rule>
            <rule e="way" k="construction" v="preserved">
                <line class='railway-core railway-preserved-core under-construction' />
            </rule>
            <rule e="way" k="construction" v="narrow_gauge">
                <line class='railway-core railway-narrow-gauge-core under-construction' />
            </rule>
            <rule e="way" k="construction" v="tram">
                <line class='railway-core railway-tram-core under-construction' />
            </rule>
            <rule e="way" k="construction" v="subway">
                <line class='railway-core railway-subway-core under-construction' />
            </rule>
            <rule e="way" k="construction" v="light_rail">
                <line class='railway-core railway-light-rail-core under-construction' />
            </rule>
            <rule e="way" k="construction" v="rail">
                <line class='railway-core railway-rail-1-core under-construction' />
            </rule>
        </rule>

		<!-- Mini-roundabouts -->
        <rule e="node" k="highway" v="mini_roundabout">
	        <rule e="node" k="direction" v="clockwise">
				<!--symbol xlink:href="#symbol-roundabout_left" width='4px' height='4px' transform='translate(0,0)'/-->
			</rule>
			<else> <!-- Default is anti-clockwise -->
				<!--symbol xlink:href="#symbol-roundabout_right" width='4px' height='4px' transform='translate(0,0)'/-->
            </else>
        </rule>


		<!-- Oneway markers -->
        <rule e="way" k="tunnel" v="~|false|no">
			<rule e="way" k="highway" v="*">
	            <rule e="way" k="oneway" v="1|yes|true">
					<line class="oneway-casing oneway-casing-1" smart-linecap='no' />
					<line class="oneway-casing oneway-casing-2" smart-linecap='no' />
					<line class="oneway-casing oneway-casing-3" smart-linecap='no' />
					<line class="oneway-casing oneway-casing-4" smart-linecap='no' />
					<line class="oneway-casing oneway-casing-5" smart-linecap='no' />
					<line class="oneway-casing oneway-casing-6" smart-linecap='no' />
					<line class="oneway-casing oneway-casing-7" smart-linecap='no' />
					<line class="oneway-casing oneway-casing-8" smart-linecap='no' />
					<line class="oneway-core oneway-core-1" smart-linecap='no' />
					<line class="oneway-core oneway-core-2" smart-linecap='no' />
					<line class="oneway-core oneway-core-3" smart-linecap='no' />
					<line class="oneway-core oneway-core-4" smart-linecap='no' />
					<line class="oneway-core oneway-core-5" smart-linecap='no' />
					<line class="oneway-core oneway-core-6" smart-linecap='no' />
					<line class="oneway-core oneway-core-7" smart-linecap='no' />
				</rule>
	            <rule e="way" k="oneway" v="-1">
					<line class="otherway" />
				</rule>
			</rule>
			<!-- Motorway implies oneway-ness -->
			<rule e="way" k="highway" v="motorway|motorway_link">
					<line class="oneway-casing oneway-casing-1" smart-linecap='no'/>
					<line class="oneway-casing oneway-casing-2" smart-linecap='no'/>
					<line class="oneway-casing oneway-casing-3" smart-linecap='no'/>
					<line class="oneway-casing oneway-casing-4" smart-linecap='no'/>
					<line class="oneway-casing oneway-casing-5" smart-linecap='no'/>
					<line class="oneway-casing oneway-casing-6" smart-linecap='no'/>
					<line class="oneway-casing oneway-casing-7" smart-linecap='no'/>
					<line class="oneway-casing oneway-casing-8" smart-linecap='no'/>
					<line class="oneway-core oneway-core-1" smart-linecap='no'/>
					<line class="oneway-core oneway-core-2" smart-linecap='no'/>
					<line class="oneway-core oneway-core-3" smart-linecap='no'/>
					<line class="oneway-core oneway-core-4" smart-linecap='no'/>
					<line class="oneway-core oneway-core-5" smart-linecap='no'/>
					<line class="oneway-core oneway-core-6" smart-linecap='no'/>
					<line class="oneway-core oneway-core-7" smart-linecap='no'/>
			</rule>
			<!-- Roundabouts are oneway in the direction of the segments -->
			<rule e="way" k="junction" v="roundabout">
					<line class="oneway-casing oneway-casing-1" smart-linecap='no'/>
					<line class="oneway-casing oneway-casing-2" smart-linecap='no'/>
					<line class="oneway-casing oneway-casing-3" smart-linecap='no'/>
					<line class="oneway-casing oneway-casing-4" smart-linecap='no'/>
					<line class="oneway-casing oneway-casing-5" smart-linecap='no'/>
					<line class="oneway-casing oneway-casing-6" smart-linecap='no'/>
					<line class="oneway-casing oneway-casing-7" smart-linecap='no'/>
					<line class="oneway-casing oneway-casing-8" smart-linecap='no'/>
					<line class="oneway-core oneway-core-1" smart-linecap='no'/>
					<line class="oneway-core oneway-core-2" smart-linecap='no'/>
					<line class="oneway-core oneway-core-3" smart-linecap='no'/>
					<line class="oneway-core oneway-core-4" smart-linecap='no'/>
					<line class="oneway-core oneway-core-5" smart-linecap='no'/>
					<line class="oneway-core oneway-core-6" smart-linecap='no'/>
					<line class="oneway-core oneway-core-7" smart-linecap='no'/>
			</rule>
 		</rule>


        <!-- Aerialways -->
        <rule e="node|way" k="aerialway" v="*">
            <line class='aerialway-line'/>
            <line class='aerialway-struts'/>
        </rule>


		<!-- Natural features -->
		<rule e="node" k="natural" v="peak">
			<symbol xlink:href="#symbol-peak" width='4px' height='4px' transform='translate(-2,-2)' />
		</rule>


		<!-- Draw marine features -->
		<rule e="way" k="man_made" v="pier">
			<line class="artificial-pier-casing"/>
		</rule>

		<rule e="way" k="man_made" v="pier">
			<line class="artificial-pier-core"/>
		</rule>


        <!-- Power lines and pylons -->
        <rule e="node" k="power" v="tower">
            <symbol xlink:href="#power-tower" width='2px' height='2px' transform='translate(-1,-1)'/>
        </rule>
        <rule e="way" k="power" v="line">
            <line class='power-line'/>
        </rule>


        <!-- Non-pysical routes -->
        <rule e="segment|way" k="route" v="ferry">
            <line class='route-ferry' />
        </rule>


        <!-- Railway stations -->
        <rule e="node" k="railway" v="station">
			<rule e="node" s="way" k="railway" v="rail">
	            <circle r="1.5" class="railway-station" />
			</rule>
			<else>
	            <circle r="1" class="railway-halt" />
			</else>
        </rule>
        <rule e="node" k="railway" v="halt">
            <circle r="1" class="railway-halt" />
        </rule>

        <!-- Level crossings -->
        <!-- For everything, except trams, if it shares a node with a road then render a railroad crossing symbol.  -->
        <!-- rule e="node" s="way" k="railway" v="rail|light_rail|subway|narrow_gauge|preserved|monorail">
			<rule e="node" s="way" k="railway" v="rail">
				<rule e="node" s="way" k="highway" v="motorway|trunk|primary|secondary|tertiary|minor|unclassified|residential|service|unsurfaced|track">
					<symbol xlink:href="#symbol-railway-crossing" width='7px' height='7px' transform='translate(-3.5,-3.5)' />
				</rule>
			</rule>
			<else>
			    <rule e="node" s="way" k="highway" v="motorway|trunk|primary|secondary|tertiary|minor|unclassified|residential|service|unsurfaced|track">
					<symbol xlink:href="#symbol-railway-crossing" width='6px' height='6px' transform='translate(-3,-3)' />
			    </rule>
			</else>
        </rule -->


        <!-- Gates -->
        <rule e="node" k="highway" v="gate">
			<rule e="node" k="status" v="open">
				<wayMarker class='gate-open' />
			</rule>
			<else>
				<rule e="node" k="status" v="locked">
					<wayMarker class='gate-locked' />
				</rule>
				<else>
					<wayMarker class='gate-closed' />
				</else>
			</else>
        </rule>

    </xsl:template>

    <xsl:include href="style-z16.xsl"/>

    <xsl:template name="see-do-symbol">
        <xsl:for-each select="/listings/see|/listings/do|/listings/listing">
            <svg:symbol
                class="icon-see">
                <xsl:attribute name="id">
                    <xsl:text>see-</xsl:text>
                    <xsl:value-of select="position()"/>
                </xsl:attribute>
                <svg:path
                          d="M 0,0 L 3.5,0 L 3.5,3.5 L 0,3.5 L 0,0 z "
                     />
                <svg:text x="1.8" y="3" xml:space="default">
                    <xsl:attribute name="class">
                        <xsl:text>icon-label icon-see-label</xsl:text>
                        <xsl:if test="position() &lt; 10">
                            <xsl:text>-big</xsl:text>
                        </xsl:if>
                    </xsl:attribute>
                    <svg:tspan x="1.8" y="3" ><xsl:value-of select="position()"/></svg:tspan>
                </svg:text>
            </svg:symbol>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="sleep-symbol">
        <xsl:for-each select="/listings/sleep">
            <svg:symbol class="icon-sleep" >
                 <xsl:attribute name="id">
                     <xsl:text>sleep-</xsl:text>
                     <xsl:value-of select="position()"/>
                 </xsl:attribute>
                 <svg:path
                        d="M 1.7529697,0.0036956 L 3.5015564,0.75402185 L 3.5015564,1.0237044 L 3.2318741,1.0237044 L 3.2318741,3.2228359 L 0.27406466,3.2228359 L 0.27406466,1.0237044 L 0.0040340858,1.0237044 L 0.0040340858,0.75402185 L 1.7529697,0.0036956 z "
                     />
                  <svg:text x="1.8" y="2.8" xml:space="default">
                    <xsl:attribute name="class">
                        <xsl:text>icon-label icon-sleep-label</xsl:text>
                        <xsl:if test="position() &lt; 10">
                            <xsl:text>-big</xsl:text>
                        </xsl:if>
                    </xsl:attribute>
                    <svg:tspan x="1.8" y="2.8" ><xsl:value-of select="position()"/></svg:tspan>
                  </svg:text>
            </svg:symbol>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="buy-symbol">
        <xsl:for-each select="/listings/buy">
            <svg:symbol class="icon-buy"> 
                 <xsl:attribute name="id">
                     <xsl:text>buy-</xsl:text>
                     <xsl:value-of select="position()"/>
                 </xsl:attribute>
                    <svg:path
                         d="M 1.7500001,8.9012131e-14 C 1.2808815,8.9012131e-14 1.001917,0.2446048 0.875,0.46875 C 0.7798123,0.6368589 0.75541009,0.77323715 0.75,0.84375 L 0,0.84375 L 0.25,3.625 L 3.2500001,3.625 L 3.5000001,0.84375 L 2.7500001,0.84375 C 2.74459,0.77323715 2.7201878,0.6368589 2.6250001,0.46875 C 2.4980832,0.2446048 2.2191181,-1.6999991e-07 1.7500001,8.9012131e-14 z M 1.7500001,0.3125 C 2.1347584,0.31249986 2.2884479,0.44089211 2.3750001,0.59375 C 2.4327016,0.69565526 2.4382154,0.78512582 2.4375001,0.84375 L 1.03125,0.84375 C 1.0397941,0.78512581 1.0672986,0.69565521 1.125,0.59375 C 1.2115521,0.44089219 1.3652412,0.3125 1.7500001,0.3125 z "
                    />
                  <svg:text x="1.8" y="3" xml:space="default">
                      <xsl:attribute name="class">
                          <xsl:text>icon-label icon-buy-label</xsl:text>
                          <xsl:if test="position() &lt; 10">
                              <xsl:text>-big</xsl:text>
                          </xsl:if>
                      </xsl:attribute>
                      <svg:tspan x="1.8" y="3" ><xsl:value-of select="position()"/></svg:tspan>
                  </svg:text>
            </svg:symbol>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="eat-symbol">
        <xsl:for-each select="/listings/eat">
            <svg:symbol class="icon-eat" >
                 <xsl:attribute name="id">
                     <xsl:text>eat-</xsl:text>
                     <xsl:value-of select="position()"/>
                 </xsl:attribute>
                  <svg:path
                         d="M 0.10261638,0.022196479 C -0.030532341,0.018846784 -0.0045539651,0.48736081 0.01941521,0.69594775 C 0.029019771,0.77230832 0.09124526,0.85006928 0.37183396,0.85536039 C 0.25223882,2.406149 0.21321668,2.6587238 0.43948192,2.6623712 C 0.67991823,2.6661719 0.60781715,2.3849101 0.55182673,0.85673585 C 0.82437244,0.86185276 0.88099011,0.8019405 0.8997575,0.6976804 C 0.91722328,0.48617115 0.99707754,0.040383572 0.83131817,0.032459301 C 0.62574974,0.023017379 0.80306333,0.59299343 0.64177976,0.60225376 C 0.45371602,0.6123078 0.6557346,0.020743689 0.47547912,0.016522435 C 0.26838848,0.011582813 0.44564566,0.60810507 0.26306898,0.59857731 C 0.10722283,0.59073951 0.28525045,0.027117572 0.10261638,0.022196479 z "
                     />
                  <svg:path
                         d="M 4.050853,0.0026634535 C 4.4912474,-0.0001575045 4.7523307,0.8325573 4.1399501,0.84912661 C 4.1711505,2.1636808 4.3179532,2.6626263 4.017253,2.6582302 C 3.705646,2.666577 3.8919774,2.1528362 3.9465928,0.85036939 C 3.3020431,0.86082744 3.6211887,0.0054288316 4.050853,0.0026634535 z "
                     />
                  <svg:path
                         d="M 2.2429958,9.6739999e-17 C 4.0230911,9.6739999e-17 4.0230911,2.6434959 2.2429958,2.6434959 C 0.48421812,2.6434959 0.48421812,9.6739999e-17 2.2429958,9.6739999e-17 z "
                     />
                  <svg:text x="2.2376723" y="2.0941877" >
                      <xsl:attribute name="class">
                          <xsl:text>icon-label icon-eat-label</xsl:text>
                          <xsl:if test="position() &lt; 10">
                              <xsl:text>-big</xsl:text>
                          </xsl:if>
                      </xsl:attribute>
                      <svg:tspan x="2.2376723" y="2.0941877"><xsl:value-of select="position()"/></svg:tspan>
                  </svg:text>
            </svg:symbol>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="drink-symbol">
        <xsl:for-each select="/listings/drink">
            <svg:symbol class="icon-drink"> 
                 <xsl:attribute name="id">
                     <xsl:text>drink-</xsl:text>
                     <xsl:value-of select="position()"/>
                 </xsl:attribute>
                    <svg:path
                         d="M 0.22409918,0.00070345805 L 3.287533,0.00077036 C 3.287533,-0.014921542 3.47678,0.54466044 3.4922326,1.658786 C 3.47678,2.9533684 1.947015,2.8935551 1.9470153,2.8931872 L 1.9470153,3.0108767 L 3.5,3.5 L 4.2413692e-10,3.5 L 1.5684371,3.0108763 L 1.5684371,2.8931872 C 1.5684371,2.8931872 0.023221137,2.9533684 0.023221137,1.6509402 C 0.023221137,0.54466044 0.21637321,-0.022834385 0.22409918,0.00070345805 z "
                    />
                  <svg:text x="1.8" y="2.4" xml:space="default">
                      <xsl:attribute name="class">
                          <xsl:text>icon-label icon-drink-label</xsl:text>
                          <xsl:if test="position() &lt; 10">
                              <xsl:text>-big</xsl:text>
                          </xsl:if>
                      </xsl:attribute>
                      <svg:tspan x="1.8" y="2.4" ><xsl:value-of select="position()"/></svg:tspan>
                  </svg:text>
            </svg:symbol>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>

