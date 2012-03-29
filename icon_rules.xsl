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

    <xsl:include href="vars.xsl"/>
    <xsl:param name="border"/>
    <xsl:param name="orientation"/>
    <xsl:param name="size"/>
    <xsl:param name="expandForListings" required="yes" select="no"/>
    <xsl:param name="minOffset" required="yes" select="78"/>
    <xsl:param name="cropMarginFactor" required="yes" select="0.04"/>
    <xsl:param name="zoomFactor" required="no" select="1.2 div $osmrules/rules/@symbolScale div $scale * $mapScale"/>
    <xsl:param name="attenuationFactor" required="no" select="7"/>

    <xsl:variable name="reldata" select="document('relation.xml')"/>
    <xsl:variable name="osmrules" select="document('style.xml')"/>

    <xsl:template name="adjustZoom">
        <xsl:param name="value"/>
        <xsl:value-of select="$value * $zoomFactor"/>
    </xsl:template>

    <xsl:template name="adjustZoomText">
        <xsl:param name="value"/>
        <xsl:value-of select="$value * ( 0.6 + ( 0.4 * $zoomFactor ) )"/>
    </xsl:template>
    
     <xsl:template match="node()|@*">
         <xsl:copy>
           <xsl:apply-templates select="node()|@*"/>
         </xsl:copy>
     </xsl:template>


    <xsl:template match="/">

        <rules
            xmlns:xlink="http://www.w3.org/1999/xlink"
            xmlns:svg="http://www.w3.org/2000/svg"
            svgBaseProfile="full"
            data="filtered.osm"
            minimumMapWidth="0.5"
            minimumMapHeight="0.5"
            withOSMLayers="yes"
            withUntaggedSegments="no"
            showScale="no"
            showGrid="no"
            showBorder="no"
            showLicense="no"
            showRelationBoundary="yes"
            symbolsDir="stylesheets/symbols"
            interactive="no">
            <xsl:attribute name="scale">
                <xsl:value-of select="$mapScale"/>
            </xsl:attribute>
            <xsl:attribute name="textAttenuation">
                <xsl:value-of select="$osmrules/rules/@textAttenuation"/>
            </xsl:attribute>
            <xsl:attribute name="dataurl">
                <xsl:value-of select="$dataurl"/>
            </xsl:attribute>
            <xsl:attribute name="symbolScale">
                <xsl:value-of select="$osmrules/rules/@symbolScale"/>
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

            <xsl:apply-templates select="$osmrules/rules/*" />
            
            <xsl:call-template name="icon-rules"  />

            <defs>
                <xsl:call-template name="see-do-symbol" />
                <xsl:call-template name="buy-symbol" />
                <xsl:call-template name="sleep-symbol" />
                <xsl:call-template name="eat-symbol" />
                <xsl:call-template name="drink-symbol" />
                <xsl:call-template name="misc-symbol" />
            </defs>

        </rules>
    </xsl:template>
    
    <!-- relocate the road descriptions since we scaled the font -->
    <!--xsl:template match="pathText[@dy='0.35px']/@dy">
        <xsl:attribute name="dy"><xsl:text>0.7px</xsl:text></xsl:attribute>
    </xsl:template-->
    
    <xsl:template match="svg:style/text()[last()]">
        <xsl:value-of select="." />
        <xsl:text>
                 .icon-see {
                      fill: #3077bd;
                      fill-opacity: 1;
                      fill-rule: evenodd;
                      font-size: 12;
                      stroke: none;
                 }

                 .icon-sleep {
                      fill: #000088;
                      fill-opacity: 1;
                      fill-rule: evenodd;
                      font-size: 12;
                      stroke: none;
                 }
                 
                 .icon-misc {
                      fill: #20941e;
                 }

                 .icon-buy {
                      fill: #00ae98;
                      fill-opacity: 1;
                      fill-rule: evenodd;
                      font-size: 12;
                      stroke: none;
                 }

                 .icon-eat {
                    font-size: 12px;
                    fill: #ac2100;
                    fill-opacity: 1;
                    fill-rule: evenodd;
                 }

                 .icon-drink {
                    font-size: 12px;
                    fill: #810061;
                    fill-opacity: 1;
                    fill-rule: evenodd
                 }

                 .icon-label {
                    font-style: normal;
                    font-variant: normal;
                    font-weight: bold;
                    font-stretch: normal;
                    text-align: center;
                    line-height: 100%;
                    writing-mode: lr-tb;
                    text-anchor: middle;
                    fill: #ffffff;
                    fill-opacity: 1;
                    stroke: none;
                    stroke-width: 1pt;
                    stroke-linecap: butt;
                    stroke-linejoin: miter;
                    stroke-opacity: 1;
                    font-family: Bitstream Vera Sans Mono
                 }

                 .icon-see-label {
                    font-size: 2.8px;
                 }
                 
                 .icon-see-label-big {
                    font-size: 3.2px;
                 }

                 .icon-buy-label {
                    font-size: 2.4px;
                 }
                 .icon-buy-label-big {
                    font-size: 3.0px;
                 }

                 .icon-sleep-label {
                    font-size: 2.6px;
                 }
                 .icon-sleep-label-big {
                    font-size: 3.0px;
                 }

                 .icon-eat-label {
                    font-size: 2.2px;
                 }
                 .icon-eat-label-big {
                    font-size: 2.6px;
                 }

                 .icon-drink-label {
                    font-size: 2.6px;
                 }
                 .icon-drink-label-big {
                    font-size: 3.0px;
                 }
          </xsl:text>
    </xsl:template>

    <xsl:template name="icon-rules">

        <xsl:for-each select="/listings/see|/listings/do">
            <rule e="node" k="name:en|name" layer="5">
                <xsl:attribute name="v">
                    <xsl:value-of select="@name"/>
                </xsl:attribute>
                <symbol width='2px' 
                        height='2px'
                        transform='scale({$zoomFactor}) translate(-1.75,-1.75)'
                        xlink:href="#see-{position()}" />
            </rule>
            <rule e="way" k="name:en|name" layer="5">
                <xsl:attribute name="v">
                    <xsl:value-of select="@name"/>
                </xsl:attribute>
                <areaSymbol width='2px' 
                        height='2px'
                        transform='scale({$zoomFactor}) translate(-1.75,-1.75)'
                        xlink:href="#see-{position()}" />
            </rule>
        </xsl:for-each>
        
        <xsl:for-each select="/listings/listing">
            <rule e="node" k="name:en|name" layer="5">
                <xsl:attribute name="v">
                    <xsl:value-of select="@name"/>
                </xsl:attribute>
                <symbol width='2px' 
                        height='2px'
                        transform='scale({$zoomFactor}) translate(-1.75,-1.75)'
                        xlink:href="#misc-{position()}" />
            </rule>
            <rule e="way" k="name:en|name" layer="5">
                <xsl:attribute name="v">
                    <xsl:value-of select="@name"/>
                </xsl:attribute>
                <areaSymbol width='2px' 
                        height='2px'
                        transform='scale({$zoomFactor}) translate(-1.75,-1.75)'
                        xlink:href="#misc-{position()}" />
            </rule>
        </xsl:for-each>

        <xsl:for-each select="/listings/sleep">
            <rule e="node" k="name:en|name" layer="5">
                <xsl:attribute name="v">
                    <xsl:value-of select="@name"/>
                </xsl:attribute>
                <symbol width='2px' 
                        height='2px'
                        transform='scale({$zoomFactor}) translate(-1.75,-1.75)'
                        xlink:href="#sleep-{position()}" />
            </rule>
        </xsl:for-each>

        <xsl:for-each select="/listings/buy">
            <rule e="node" k="name:en|name" layer="5">
                <xsl:attribute name="v">
                    <xsl:value-of select="@name"/>
                </xsl:attribute>
                <symbol width='2px' 
                        height='2px'
                        transform='scale({$zoomFactor}) translate(-1.75,-1.75)'
                        xlink:href="#buy-{position()}" />
            </rule>
        </xsl:for-each>

        <xsl:for-each select="/listings/eat">
            <rule e="node" k="name:en|name" layer="5">
                <xsl:attribute name="v">
                    <xsl:value-of select="@name"/>
                </xsl:attribute>
                <symbol width='2px' 
                        height='2px'
                        transform='scale({$zoomFactor}) translate(-2.25,-2.25)'
                        xlink:href="#eat-{position()}" />
            </rule>
        </xsl:for-each>

        <xsl:for-each select="/listings/drink">
            <rule e="node" k="name:en|name" layer="5">
                <xsl:attribute name="v">
                    <xsl:value-of select="@name"/>
                </xsl:attribute>
                <symbol width='2px' 
                        height='2px'
                        transform='scale({$zoomFactor}) translate(-1.75,-1.75)'
                        xlink:href="#drink-{position()}" />
            </rule>
        </xsl:for-each>

    </xsl:template>

    <xsl:template name="see-do-symbol">
        <xsl:for-each select="/listings/see|/listings/do">
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
    
    <xsl:template name="misc-symbol">
        <xsl:for-each select="/listings/listing">
            <svg:symbol
                class="icon-misc">
                <xsl:attribute name="id">
                    <xsl:text>misc-</xsl:text>
                    <xsl:value-of select="position()"/>
                </xsl:attribute>
                <svg:use xlink:href="#misc" />
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
                 <svg:use xlink:href="#sleep" />
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
                  <svg:use xlink:href="#buy" />
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
                 <svg:use xlink:href="#eat" />
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
                 <svg:use xlink:href="#drink" />
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

