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
    <xsl:param name="zoomFactor" required="no" select="1.2 div 0.107"/>
    <xsl:param name="attenuationFactor" required="no" select="7"/>

    <xsl:include href="vars.xsl"/>
    <xsl:variable name="reldata" select="document('relation.xml')"/>
    <xsl:variable name="osmrules" select="document('styles-z17.xml')"/>

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
                <xsl:value-of select="$scale"/>
            </xsl:attribute>
            <xsl:attribute name="textAttenuation">
                <xsl:value-of select="$attenuationFactor * $scale"/>
            </xsl:attribute>
            <xsl:attribute name="dataurl">
                <xsl:value-of select="$dataurl"/>
            </xsl:attribute>
            <xsl:attribute name="symbolScale">
                <xsl:value-of select="0.107"/>
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
            </defs>

        </rules>
    </xsl:template>
    
    <!-- relocate the road descriptions since we scaled the font -->
    <xsl:template match="pathText[@dy='0.35px']/@dy">
        <xsl:attribute name="dy"><xsl:text>0.7px</xsl:text></xsl:attribute>
    </xsl:template>
    
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

        <xsl:for-each select="/listings/see|/listings/do|/listings/listing">
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

