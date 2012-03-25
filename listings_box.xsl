<?xml version="1.0"?>
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
       xmlns:dc="http://purl.org/dc/elements/1.1/"
       xmlns:cc="http://creativecommons.org/ns#"
       xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
       xmlns:sodipodi="http://sodipodi.sourceforge.net/DTD/sodipodi-0.dtd"
       xmlns:inkscape="http://www.inkscape.org/namespaces/inkscape"
       xmlns:svg="http://www.w3.org/2000/svg" >
    <xsl:output omit-xml-declaration="no" indent="yes"/>
    <xsl:param name="rulesfile"/>
    <xsl:param name="orientation"/>
    <xsl:param name="size"/>
    <xsl:param name="listingsPlacement"/>
    <xsl:param name="boxWidth"/>
    <xsl:param name="box1X"/>
    <xsl:param name="box1Y"/>
    <xsl:param name="box1Height"/>
    <xsl:param name="box2X"/>
    <xsl:param name="box2Y"/>
    <xsl:param name="box2Height"/>
    <xsl:param name="box3X"/>
    <xsl:param name="box3Y"/>
    <xsl:param name="box3Height"/>
    <xsl:param name="box4X"/>
    <xsl:param name="box4Y"/>
    <xsl:param name="box4Height"/>

    <xsl:variable name="withmap">yes</xsl:variable>

    <xsl:variable name="leftOffset" select="document($rulesfile)/rules/@leftOffset"/>
    <xsl:variable name="bottomOffset" select="document($rulesfile)/rules/@bottomOffset"/>
    <xsl:variable name="projection" select="document($rulesfile)/rules/@projection"/>
    <xsl:variable name="dataWidth" select="document($rulesfile)/rules/@dataWidth"/>
    <xsl:variable name="dataHeight" select="document($rulesfile)/rules/@dataHeight"/>

    <xsl:variable name="pixelLineHeight">
        <xsl:choose>
            <xsl:when test="$dataWidth = 173">0.18</xsl:when>
            <xsl:otherwise>0.19</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="boxLocation">
        <xsl:choose>
            <xsl:when test="$listingsPlacement = 'manual'">specified</xsl:when>
            <xsl:when test="$leftOffset &gt;= $bottomOffset">left</xsl:when>
            <xsl:otherwise>bottom</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="map" select="document('map.svg')"/>
    <xsl:variable name="overlay" select="document('overlay.svg')"/>
    <xsl:variable name="unmatched" select="document('unmatched.svg')"/>

    <xsl:template match="/">
        <svg:svg>
            <xsl:copy-of select="$map/svg:svg/@*"/>
            <xsl:if test="$size = 'two-page'">
                <sodipodi:namedview showguides="true" showgrid="false">
                    <xsl:choose>
                        <xsl:when test="$orientation = 'landscape'">
                            <sodipodi:guide orientation="1,0" position="173"/>
                        </xsl:when>
                        <xsl:when test="$orientation = 'portrait'">
                            <sodipodi:guide orientation="0,1" position="173"/>
                        </xsl:when>
                    </xsl:choose>
                </sodipodi:namedview>
            </xsl:if>
            <xsl:if test="$withmap = 'yes'">
                <xsl:copy-of select="$map/svg:svg/*"/>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="$boxLocation = 'specified'">
                    <xsl:call-template name="specifiedListingsBoxes"/>
                </xsl:when>
                <xsl:when test="$boxLocation = 'left'">
                    <xsl:call-template name="verticalListingsBox"/>
                </xsl:when>
                <xsl:when test="$boxLocation = 'bottom'">
                    <xsl:call-template name="horizontalListingsBox"/>
                </xsl:when>
            </xsl:choose>
            <xsl:if test="$overlay">
                <xsl:copy-of select="$overlay/svg:svg/*"/>
            </xsl:if>
            <xsl:if test="$unmatched">
                <xsl:copy-of select="$unmatched/svg:svg/*"/>
            </xsl:if>
        </svg:svg>
    </xsl:template>

    <xsl:template name="specifiedListingsBoxes">

        <svg:g inkscape:groupmode="layer" inkscape:label="Listings Box">

            <svg:defs id="defs-rulefile">
                <xsl:call-template name="defs"/>
            </svg:defs>

            <xsl:variable name="box1Ypos" select="$dataHeight - $box1Y - $box1Height"/>
            <xsl:variable name="box1Lines" select="$box1Height * $pixelLineHeight"/>
            <xsl:variable name="box1LastListing">
                <xsl:call-template name="countListings">
                    <xsl:with-param name="lines" select="$box1Lines"/>
                    <xsl:with-param name="lineCount" select="0"/>
                    <xsl:with-param name="currentListing" select="1"/>
                </xsl:call-template>
            </xsl:variable>

            <!-- Box 1 -->
            <svg:rect class="listings-box">
                <xsl:attribute name="x">
                    <xsl:value-of select="$box1X"/>
                    <xsl:text>px</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="y">
                    <xsl:value-of select="$box1Ypos"/>
                    <xsl:text>px</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="height">
                    <xsl:value-of select="$box1Height"/>
                    <xsl:text>px</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="width">
                    <xsl:value-of select="$boxWidth"/>
                    <xsl:text>px</xsl:text>
                </xsl:attribute>
            </svg:rect>

            <xsl:call-template name="listingsFlowRoot">
                <xsl:with-param name="numBoxes" select="1"/>
                <xsl:with-param name="x" select="$box1X + 2"/>
                <xsl:with-param name="y" select="$box1Ypos + 2"/>
                <xsl:with-param name="height" select="$box1Height"/>
                <xsl:with-param name="width" select="$boxWidth - 4"/>
                <xsl:with-param name="lines" select="$box1Lines"/>
                <xsl:with-param name="firstListing" select="1"/>
            </xsl:call-template>

            <xsl:variable name="box2Ypos" select="$dataHeight - $box2Y - $box2Height"/>
            <xsl:variable name="box2Lines" select="$box2Height * $pixelLineHeight"/>
            <xsl:variable name="box2LastListing">
                <xsl:call-template name="countListings">
                    <xsl:with-param name="lines" select="$box2Lines"/>
                    <xsl:with-param name="lineCount" select="0"/>
                    <xsl:with-param name="currentListing" select="$box1LastListing + 1"/>
                </xsl:call-template>
            </xsl:variable>

            <!-- Box 2 -->
            <svg:rect class="listings-box">
                <xsl:attribute name="x">
                    <xsl:value-of select="$box2X"/>
                    <xsl:text>px</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="y">
                    <xsl:value-of select="$box2Ypos"/>
                    <xsl:text>px</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="height">
                    <xsl:value-of select="$box2Height"/>
                    <xsl:text>px</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="width">
                    <xsl:value-of select="$boxWidth"/>
                    <xsl:text>px</xsl:text>
                </xsl:attribute>
            </svg:rect>

            <xsl:call-template name="listingsFlowRoot">
                <xsl:with-param name="numBoxes" select="1"/>
                <xsl:with-param name="x" select="$box2X + 2"/>
                <xsl:with-param name="y" select="$box2Ypos + 2"/>
                <xsl:with-param name="height" select="$box2Height"/>
                <xsl:with-param name="width" select="$boxWidth - 4"/>
                <xsl:with-param name="lines" select="$box2Lines"/>
                <xsl:with-param name="firstListing" select="$box1LastListing + 1"/>
            </xsl:call-template>

            <xsl:variable name="box3Ypos" select="$dataHeight - $box3Y - $box3Height"/>
            <xsl:variable name="box3Lines" select="$box3Height * $pixelLineHeight"/>
            <xsl:variable name="box3LastListing">
                <xsl:call-template name="countListings">
                    <xsl:with-param name="lines" select="$box3Lines"/>
                    <xsl:with-param name="lineCount" select="0"/>
                    <xsl:with-param name="currentListing" select="$box2LastListing + 1"/>
                </xsl:call-template>
            </xsl:variable>

            <!-- Box 3 -->
            <svg:rect class="listings-box">
                <xsl:attribute name="x">
                    <xsl:value-of select="$box3X"/>
                    <xsl:text>px</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="y">
                    <xsl:value-of select="$box3Ypos"/>
                    <xsl:text>px</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="height">
                    <xsl:value-of select="$box3Height"/>
                    <xsl:text>px</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="width">
                    <xsl:value-of select="$boxWidth"/>
                    <xsl:text>px</xsl:text>
                </xsl:attribute>
            </svg:rect>

            <xsl:call-template name="listingsFlowRoot">
                <xsl:with-param name="numBoxes" select="1"/>
                <xsl:with-param name="x" select="$box3X + 2"/>
                <xsl:with-param name="y" select="$box3Ypos + 2"/>
                <xsl:with-param name="height" select="$box3Height"/>
                <xsl:with-param name="width" select="$boxWidth - 4"/>
                <xsl:with-param name="lines" select="$box3Lines"/>
                <xsl:with-param name="firstListing" select="$box2LastListing + 1"/>
            </xsl:call-template>

            <xsl:variable name="box4Ypos" select="$dataHeight - $box4Y - $box4Height"/>
            <xsl:variable name="box4Lines" select="$box4Height * $pixelLineHeight"/>

            <!-- Box 4 -->
            <svg:rect class="listings-box">
                <xsl:attribute name="x">
                    <xsl:value-of select="$box4X"/>
                    <xsl:text>px</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="y">
                    <xsl:value-of select="$box4Ypos"/>
                    <xsl:text>px</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="height">
                    <xsl:value-of select="$box4Height"/>
                    <xsl:text>px</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="width">
                    <xsl:value-of select="$boxWidth"/>
                    <xsl:text>px</xsl:text>
                </xsl:attribute>
            </svg:rect>

            <svg:g>
                <xsl:attribute name="transform">
                    <xsl:text>translate(</xsl:text>
                    <xsl:value-of select="$box4X + ( $boxWidth - 40 ) div 2"/>
                    <xsl:text>,</xsl:text>
                    <xsl:value-of select="$box4Ypos + $box4Height - 56"/>
                    <xsl:text>)</xsl:text>
                </xsl:attribute>
                <svg:use xlink:href="#wikitravel-logo" transform="scale(0.08)" />
            </svg:g>

            <svg:flowRoot>
                <svg:flowRegion>
                    <svg:rect>
                        <xsl:attribute name="y"> 
                            <xsl:value-of select="$box4Ypos + $box4Height - 10"/>
                            <xsl:text>px</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="x">
                            <xsl:value-of select="$box4X"/>
                            <xsl:text>px</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="height">
                            <xsl:value-of select="8"/>
                            <xsl:text>px</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="width">
                            <xsl:value-of select="$boxWidth"/>
                            <xsl:text>px</xsl:text>
                        </xsl:attribute>
                    </svg:rect>
                </svg:flowRegion>
                <svg:text class="osm-credit-text">
                    <xsl:text>Data: OpenStreetMap CC-by-sa 2.0</xsl:text>
                </svg:text>
            </svg:flowRoot>
        </svg:g>

    </xsl:template>

    <xsl:template name="horizontalListingsBox">

        <xsl:variable name="height" select="$bottomOffset * $projection - 2"/>
        <xsl:variable name="width" select="$dataWidth"/>
        <xsl:variable name="lines" select="$height * $pixelLineHeight"/>
        <xsl:variable name="y" select="$dataHeight - $height + 1"/>

        <!-- draw the listings box -->
        <svg:g inkscape:groupmode="layer" inkscape:label="Listings Box" class="listings-box" transform="translate(0,0)">

            <svg:defs id="defs-rulefile">
                <xsl:call-template name="defs"/>
            </svg:defs>

            <xsl:message>
               dataHeight: <xsl:value-of select="$dataHeight"/>
                    width: <xsl:value-of select="$width"/>
                width - 4: <xsl:value-of select="$width - 4"/>
                   height: <xsl:value-of select="$height"/>
                    lines: <xsl:value-of select="$lines"/>
            </xsl:message>

            <svg:rect class="listings-box" x="10px" >
                <xsl:attribute name="y">
                    <xsl:value-of select="$y"/>
                    <xsl:text>px</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="height">
                    <xsl:value-of select="$height - 10"/>
                    <xsl:text>px</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="width">
                    <xsl:value-of select="$width - 20"/>
                    <xsl:text>px</xsl:text>
                </xsl:attribute>
            </svg:rect>

            <xsl:variable name="numBoxes">
                <xsl:choose>
                    <xsl:when test="$dataWidth = 173">
                        <xsl:value-of select="3"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="4"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="textSpacing" select="2"/>

            <xsl:call-template name="listingsFlowRoot">
                <xsl:with-param name="numBoxes" select="$numBoxes"/>
                <xsl:with-param name="y" select="$y + 2"/>
                <xsl:with-param name="height" select="$height"/>
                <xsl:with-param name="width" select="$width"/>
                <xsl:with-param name="lines" select="$lines"/>
                <xsl:with-param name="firstListing" select="1"/>
            </xsl:call-template>

            <svg:g>
                <xsl:attribute name="transform">
                    <xsl:text>translate(</xsl:text>
                    <xsl:value-of select="( $numBoxes - 1 ) * ( ( $width ) div $numBoxes ) - 3"/>
                    <xsl:text>,</xsl:text>
                    <xsl:value-of select="$dataHeight - $dataHeight * 0.21"/>
                    <xsl:text>)</xsl:text>
                </xsl:attribute>
                <svg:use xlink:href="#wikitravel-logo" transform="scale(0.08)" />
            </svg:g>

            <svg:flowRoot>
                <svg:flowRegion>
                    <svg:rect>
                        <xsl:attribute name="y"> 
                            <xsl:value-of select="$dataHeight - 18"/>
                            <xsl:text>px</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="x">
                            <xsl:value-of select="( $numBoxes - 1 ) * ( ( $width - 4 ) div $numBoxes )"/>
                            <xsl:text>px</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="height">
                            <xsl:value-of select="8"/>
                            <xsl:text>px</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="width">
                            <xsl:value-of select="$width div $numBoxes - 4"/>
                            <xsl:text>px</xsl:text>
                        </xsl:attribute>
                    </svg:rect>
                </svg:flowRegion>
                <svg:text class="osm-credit-text">
                    <xsl:text>Data: OpenStreetMap CC-by-sa 2.0</xsl:text>
                </svg:text>
            </svg:flowRoot>

        </svg:g>

    </xsl:template>

    <xsl:template name="listingsFlowRoot">
        <xsl:param name="y"/>
        <xsl:param name="x" required="yes" select="12"/>
        <xsl:param name="height"/>
        <xsl:param name="width"/>
        <xsl:param name="lines"/>
        <xsl:param name="firstListing"/>
        <xsl:param name="numBoxes" required="yes" select="1"/>
        <xsl:param name="recursions" required="yes" select="0"/>
        <xsl:variable name="textWidth" select="( $width div $numBoxes ) - 2"/>
        <xsl:message>
                       x: <xsl:value-of select="$x"/>
                       y: <xsl:value-of select="$y"/>
                  height: <xsl:value-of select="$height"/>
                   width: <xsl:value-of select="$width"/>
                   lines: <xsl:value-of select="$lines"/>
            firstListing: <xsl:value-of select="$firstListing"/>
                numBoxes: <xsl:value-of select="$numBoxes"/>
              recursions: <xsl:value-of select="$recursions"/>
        </xsl:message>
        <xsl:variable name="lastListing">
            <xsl:call-template name="countListings">
                <xsl:with-param name="lines" select="$lines"/>
                <xsl:with-param name="lineCount" select="0"/>
                <xsl:with-param name="currentListing" select="$firstListing"/>
            </xsl:call-template>
        </xsl:variable>
        <svg:flowRoot>
            <svg:flowRegion>
                <svg:rect>
                    <xsl:attribute name="y"> 
                        <xsl:value-of select="$y"/>
                        <xsl:text>px</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="x">
                        <xsl:value-of select="$x"/>
                        <xsl:text>px</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="height">
                        <xsl:value-of select="$height - 8"/>
                        <xsl:text>px</xsl:text>
                    </xsl:attribute>
                    <xsl:attribute name="width">
                        <xsl:value-of select="$textWidth"/>
                        <xsl:text>px</xsl:text>
                    </xsl:attribute>
                </svg:rect>
            </svg:flowRegion>
            <xsl:call-template name="printListings">
                <xsl:with-param name="lines" select="$lines"/>
                <xsl:with-param name="firstListing" select="$firstListing"/>
                <xsl:with-param name="lastListing" select="$lastListing"/>
                <xsl:with-param name="x" select="$x"/>
                <xsl:with-param name="y" select="$y"/>
            </xsl:call-template>
        </svg:flowRoot>
        <xsl:call-template name="drawHeadingIcons">
            <xsl:with-param name="lines" select="$lines"/>
            <xsl:with-param name="firstListing" select="$firstListing"/>
            <xsl:with-param name="lastListing" select="$lastListing"/>
            <xsl:with-param name="x" select="$x"/>
            <xsl:with-param name="y" select="$y"/>
        </xsl:call-template>
        <xsl:if test="$recursions + 1 &lt; $numBoxes">
            <xsl:call-template name="listingsFlowRoot">
                <xsl:with-param name="y" select="$y"/>
                <xsl:with-param name="x" select="$x + $textWidth + 2"/>
                <xsl:with-param name="height" select="$height"/>
                <xsl:with-param name="width" select="$width"/>
                <xsl:with-param name="lines" select="$lines"/>
                <xsl:with-param name="firstListing" select="$lastListing + 1"/>
                <xsl:with-param name="numBoxes" select="$numBoxes"/>
                <xsl:with-param name="recursions" select="$recursions + 1"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template name="countListings">
        <xsl:param name="lines"/>
        <xsl:param name="firstLine"/>
        <xsl:param name="lineCount"/>
        <xsl:param name="currentListing"/>

        <xsl:variable name="allListings" select="//see | //listing | //do | //buy | //eat | //drink | //sleep"/>
        <!--xsl:message>
                  lineCount: <xsl:value-of select="$lineCount"/>
             currentListing: <xsl:value-of select="$currentListing"/>
        count($allListings): <xsl:value-of select="count($allListings)"/>
                listingName: <xsl:value-of select="$allListings[position() = $currentListing]/@name"/>
        </xsl:message-->
        <xsl:choose>
            <xsl:when test="$lineCount &gt; $lines - 3 and ( $currentListing = count(//see | //listing | //do) + 1
                                    or  $currentListing = count(//see | //listing | //do | //buy ) + 1
                                    or  $currentListing = count(//see | //listing | //do | //buy | //eat) + 1
                                    or  $currentListing = count(//see | //listing | //do | //buy | //eat | //drink ) + 1 )">
                <xsl:value-of select="$currentListing"/>
            </xsl:when>
            <xsl:when test="$lineCount &lt; $lines">
                <xsl:variable name="nextLineCount">
                    <xsl:choose>
                        <xsl:when test="$currentListing = 1
                                    or  $currentListing = count(//see | //listing | //do) + 1
                                    or  $currentListing = count(//see | //listing | //do | //buy ) + 1
                                    or  $currentListing = count(//see | //listing | //do | //buy | //eat) + 1
                                    or  $currentListing = count(//see | //listing | //do | //buy | //eat | //drink ) + 1 ">
                            <xsl:value-of select="$lineCount + 3"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$lineCount + 1"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="nextListing">
                    <xsl:choose>
                        <xsl:when test="$currentListing > count($allListings)">
                            <xsl:value-of select="$currentListing"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$currentListing + 1"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:call-template name="countListings">
                    <xsl:with-param name="lines" select="$lines"/>
                    <xsl:with-param name="lineCount" select="$nextLineCount"/>
                    <xsl:with-param name="currentListing" select="$nextListing"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$currentListing"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="printListings">
        <xsl:param name="lines"/>
        <xsl:param name="firstListing"/>
        <xsl:param name="lastListing"/>
        <xsl:param name="x" required="yes" select="4"/>
        <xsl:param name="y" required="yes" select="4"/>
        <xsl:message>
              firstListing: <xsl:value-of select="$firstListing"/>
               lastListing: <xsl:value-of select="$lastListing"/>
        </xsl:message>
        <xsl:variable name="headingClass">
            <xsl:choose>
                <xsl:when test="$dataWidth = 173">section-heading-small</xsl:when>
                <xsl:otherwise>section-heading</xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:variable name="buyPos" select="count( //see | //listing | //do )"/>
        <xsl:variable name="eatPos" select="count( //see | //listing | //do | //buy )"/>
        <xsl:variable name="drinkPos" select="count( //see | //listing | //do | //buy | //eat )"/>
        <xsl:variable name="sleepPos" select="count( //see | //listing | //do | //buy | //eat | //drink )"/>
        <xsl:variable name="endPos" select="count( //see | //listing | //do | //buy | //eat | //drink | //sleep )"/>
        <xsl:for-each select="//see | //listing | //do | //buy | //eat | //drink | //sleep">
            <xsl:if test="position() &gt;= $firstListing and position() &lt;= $lastListing">
                <xsl:choose>
                    <xsl:when test="position() = $sleepPos + 1">
                        <xsl:call-template name="heading">
                            <xsl:with-param name="title">Sleep</xsl:with-param>
                            <xsl:with-param name="class" select="$headingClass"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="position() = $drinkPos + 1">
                        <xsl:call-template name="heading">
                            <xsl:with-param name="title">Drink</xsl:with-param>
                            <xsl:with-param name="class" select="$headingClass"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="position() = $eatPos + 1">
                        <xsl:call-template name="heading">
                            <xsl:with-param name="title">Eat</xsl:with-param>
                            <xsl:with-param name="class" select="$headingClass"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="position() = $buyPos + 1">
                        <xsl:call-template name="heading">
                            <xsl:with-param name="title">Buy</xsl:with-param>
                            <xsl:with-param name="class" select="$headingClass"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="position() = 1">
                        <xsl:call-template name="heading">
                            <xsl:with-param name="title">See and Do</xsl:with-param>
                            <xsl:with-param name="class" select="$headingClass"/>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
                <xsl:variable name="lineNumber">
                    <xsl:choose>
                        <xsl:when test="position() &gt; $buyPos and position() &lt;= $eatPos">
                            <xsl:value-of select="position() - $buyPos"/>
                        </xsl:when>
                        <xsl:when test="position() &gt; $eatPos and position() &lt;= $drinkPos">
                            <xsl:value-of select="position() - $eatPos "/>
                        </xsl:when>
                        <xsl:when test="position() &gt; $drinkPos and position() &lt;= $sleepPos">
                            <xsl:value-of select="position() - $drinkPos"/>
                        </xsl:when>
                        <xsl:when test="position() &gt; $sleepPos">
                            <xsl:value-of select="position() - $sleepPos"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="position()"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="listingClass">
                    <xsl:choose>
                        <xsl:when test="$dataWidth = 173">listing-small</xsl:when>
                        <xsl:otherwise>listing</xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <svg:flowPara>
                    <xsl:attribute name="class">
                        <xsl:value-of select="$listingClass"/>
                    </xsl:attribute>
                    <xsl:value-of select="$lineNumber"/>
                    <svg:text>. </svg:text>
                    <xsl:value-of select="@name"/>
                </svg:flowPara>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="countHeaders">
        <xsl:param name="current"/>
        <xsl:param name="last"/>
        <xsl:param name="count" required="yes" select="0"/>
        <xsl:variable name="buyPos" select="count( //see | //listing | //do )"/>
        <xsl:variable name="eatPos" select="count( //see | //listing | //do | //buy )"/>
        <xsl:variable name="drinkPos" select="count( //see | //listing | //do | //buy | //eat )"/>
        <xsl:variable name="sleepPos" select="count( //see | //listing | //do | //buy | //eat | //drink )"/>
        <xsl:variable name="newCount">
            <xsl:choose>
                <xsl:when test="$current = 1 
                             or $current = $sleepPos + 1 
                             or $current = $drinkPos + 1 
                             or $current = $eatPos + 1 
                             or $current = $buyPos + 1 ">
                    <xsl:value-of select="$count + 1"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$count"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$current &lt; $last">
                <xsl:call-template name="countHeaders">
                    <xsl:with-param name="current" select="$current + 1"/>
                    <xsl:with-param name="last" select="$last"/>
                    <xsl:with-param name="count" select="$newCount"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$newCount"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="drawHeadingIcons">
        <xsl:param name="lines"/>
        <xsl:param name="firstListing"/>
        <xsl:param name="lastListing"/>
        <xsl:param name="x" required="yes" select="4"/>
        <xsl:param name="y" required="yes" select="4"/>
        <xsl:variable name="xStart" select="$x * 1.112 - 1.3"/>
        <xsl:variable name="yStart" select="$y * 1.112 - 9.2"/>
        <xsl:variable name="buyPos" select="count( //see | //listing | //do )"/>
        <xsl:variable name="eatPos" select="count( //see | //listing | //do | //buy )"/>
        <xsl:variable name="drinkPos" select="count( //see | //listing | //do | //buy | //eat )"/>
        <xsl:variable name="sleepPos" select="count( //see | //listing | //do | //buy | //eat | //drink )"/>
        <xsl:variable name="endPos" select="count( //see | //listing | //do | //buy | //eat | //drink | //sleep )"/>
        <xsl:for-each select="//see | //listing | //do | //buy | //eat | //drink | //sleep">
            <xsl:variable name="headerCount">
                <xsl:call-template name="countHeaders">
                    <xsl:with-param name="current" select="$firstListing"/>
                    <xsl:with-param name="last" select="position()"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:if test="position() &gt;= $firstListing and position() &lt;= $lastListing">
                <xsl:choose>
                    <xsl:when test="position() = $sleepPos + 1">
                        <xsl:call-template name="headingIcon">
                            <xsl:with-param name="section">sleep</xsl:with-param>
                            <xsl:with-param name="x" select="$xStart"/>
                            <xsl:with-param name="y" select="$yStart"/>
                            <xsl:with-param name="line" select="position() - $firstListing + 1"/>
                            <xsl:with-param name="numHeaders" select="$headerCount"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="position() = $drinkPos + 1">
                        <xsl:call-template name="headingIcon">
                            <xsl:with-param name="section">drink</xsl:with-param>
                            <xsl:with-param name="x" select="$xStart"/>
                            <xsl:with-param name="y" select="$yStart"/>
                            <xsl:with-param name="line" select="position() - $firstListing + 1"/>
                            <xsl:with-param name="numHeaders" select="$headerCount"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="position() = $eatPos + 1">
                        <xsl:call-template name="headingIcon">
                            <xsl:with-param name="section">eat</xsl:with-param>
                            <xsl:with-param name="x" select="$xStart - 0.4"/>
                            <xsl:with-param name="y" select="$yStart + 0.3"/>
                            <xsl:with-param name="line" select="position() - $firstListing + 1"/>
                            <xsl:with-param name="numHeaders" select="$headerCount"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="position() = $buyPos + 1">
                        <xsl:call-template name="headingIcon">
                            <xsl:with-param name="section">buy</xsl:with-param>
                            <xsl:with-param name="x" select="$xStart"/>
                            <xsl:with-param name="y" select="$yStart - 0.2"/>
                            <xsl:with-param name="line" select="position() - $firstListing + 1"/>
                            <xsl:with-param name="numHeaders" select="$headerCount"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="position() = 1">
                        <xsl:call-template name="headingIcon">
                            <xsl:with-param name="section">see</xsl:with-param>
                            <xsl:with-param name="x" select="$xStart"/>
                            <xsl:with-param name="y" select="$yStart"/>
                            <xsl:with-param name="line" select="position() - $firstListing + 1"/>
                            <xsl:with-param name="numHeaders" select="$headerCount"/>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="headingIcon">
        <xsl:param name="section"/>
        <xsl:param name="x"/>
        <xsl:param name="y"/>
        <xsl:param name="line"/>
        <xsl:param name="numHeaders" required="yes" select="0"/>
        <xsl:variable name="iconLineHeight" select="4.72"/>
        <xsl:variable name="headerLineHeight" select="6.8"/>
        <xsl:variable name="ypos" select="$y + $numHeaders * $headerLineHeight + $line * $iconLineHeight"/>
        <xsl:message>
            icon: <xsl:value-of select="$section"/>
            line: <xsl:value-of select="$line"/>
      numHeaders: <xsl:value-of select="$numHeaders"/>
               x: <xsl:value-of select="$x"/>
               y: <xsl:value-of select="$ypos"/>
        </xsl:message>
        <svg:g>
            <svg:use transform="scale(0.9)">
                <xsl:attribute name="x">
                    <xsl:value-of select="$x"/>
                    <xsl:text>px</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="y">
                    <xsl:value-of select="$ypos"/>
                    <xsl:text>px</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="xlink:href">
                    <xsl:text>#</xsl:text>
                    <xsl:value-of select="$section"/>
                </xsl:attribute>
            </svg:use>
        </svg:g>
    </xsl:template>

    <xsl:template name="verticalListingsBox">

        <xsl:variable name="height" select="$dataHeight"/>
        <xsl:variable name="width" select="$leftOffset"/>

        <!-- calculate placement of the logo -->
        <xsl:variable name="logo-placement-modifier">0.2</xsl:variable>
        <xsl:variable name="logo-height">5</xsl:variable>
        <xsl:variable name="logo-placement">
            <xsl:value-of select="$height * $logo-placement-modifier - $logo-height"/>
        </xsl:variable>

        <!-- draw the listings box -->
        <svg:g inkscape:groupmode="layer" inkscape:label="Listings Box" class="listings-box" transform="translate(0,0)">

            <svg:defs id="defs-rulefile">
                <xsl:call-template name="defs"/>
            </svg:defs>

            <svg:rect class="listings-box" x="10px" y="10px" >
                <xsl:attribute name="height">
                    <xsl:value-of select="$height - 20"/>
                    <xsl:text>px</xsl:text>
                </xsl:attribute>
                <xsl:attribute name="width">
                    <xsl:value-of select="$width"/>
                    <xsl:text>px</xsl:text>
                </xsl:attribute>
            </svg:rect>

            <svg:flowRoot id="flowRoot3148">

                <svg:flowRegion id="flowRegion3150">
                    <svg:rect id="rect3152" x="12px" y="10px">
                        <xsl:attribute name="height">
                            <xsl:value-of select="$height - 20"/>
                            <xsl:text>px</xsl:text>
                        </xsl:attribute>
                        <xsl:attribute name="width">
                            <xsl:value-of select="$width"/>
                            <xsl:text>px</xsl:text>
                        </xsl:attribute>
                    </svg:rect>
                </svg:flowRegion>

                <xsl:if test="count( /listings/see | /listings/do | /listings/listing ) &gt; 0">
                    <xsl:call-template name="heading">
                        <xsl:with-param name="title">See and Do</xsl:with-param>
                        <xsl:with-param name="class">section-heading</xsl:with-param>
                    </xsl:call-template>
                </xsl:if>

                <xsl:call-template name="listingsSet">
                    <xsl:with-param name="listings" select="/listings/see | /listings/do | /listings/listing"/>
                </xsl:call-template>

                <xsl:if test="count( /listing/buy ) &gt; 0">
                    <xsl:call-template name="heading">
                        <xsl:with-param name="title">Buy</xsl:with-param>
                        <xsl:with-param name="class">section-heading</xsl:with-param>
                    </xsl:call-template>
                </xsl:if>

    
                <xsl:call-template name="listingsSet">
                    <xsl:with-param name="listings" select="/listings/buy"/>
                </xsl:call-template>

                <xsl:if test="count( /listings/eat ) &gt; 0">
                    <xsl:call-template name="heading">
                        <xsl:with-param name="title">Eat</xsl:with-param>
                        <xsl:with-param name="class">section-heading</xsl:with-param>
                    </xsl:call-template>
                </xsl:if>

                <xsl:call-template name="listingsSet">
                    <xsl:with-param name="listings" select="/listings/eat"/>
                </xsl:call-template>

                <xsl:if test="count( /listings/drink ) &gt; 0">
                    <xsl:call-template name="heading">
                        <xsl:with-param name="title">Drink</xsl:with-param>
                        <xsl:with-param name="class">section-heading</xsl:with-param>
                    </xsl:call-template>
                </xsl:if>

                <xsl:call-template name="listingsSet">
                    <xsl:with-param name="listings" select="/listings/drink"/>
                </xsl:call-template>

                <xsl:if test="count( /listings/sleep ) &gt; 0">
                    <xsl:call-template name="heading">
                        <xsl:with-param name="title">Sleep</xsl:with-param>
                        <xsl:with-param name="class">section-heading</xsl:with-param>
                    </xsl:call-template>
                </xsl:if>

                <xsl:call-template name="listingsSet">
                    <xsl:with-param name="listings" select="/listings/sleep"/>
                </xsl:call-template>
                

            </svg:flowRoot> 

            <xsl:call-template name="drawHeadingIcons">
                <xsl:with-param name="lines" select="( $height - 4 ) * $pixelLineHeight"/>
                <xsl:with-param name="firstListing" select="1"/>
                <xsl:with-param name="lastListing" select="count( /listings/* )"/>
                <xsl:with-param name="x" select="12"/>
                <xsl:with-param name="y" select="10"/>
            </xsl:call-template>

            <svg:g>
                <xsl:attribute name="transform">
                    <xsl:text>translate(8,228)</xsl:text>
                </xsl:attribute>
                <svg:use xlink:href="#wikitravel-logo" transform="scale(0.12)" />
            </svg:g>

            <svg:flowRoot>

                <svg:flowRegion>
                    <svg:rect>
                        <xsl:attribute name="x">
                            <xsl:value-of select="0"/>
                        </xsl:attribute>
                        <xsl:attribute name="y">
                            <xsl:value-of select="$height - 8" />
                        </xsl:attribute>
                        <xsl:attribute name="height">
                            <xsl:value-of select="10" />
                        </xsl:attribute>
                        <xsl:attribute name="width">
                            <xsl:value-of select="$width" />
                        </xsl:attribute>
                    </svg:rect>
                </svg:flowRegion>

                <svg:text class="osm-credit-text">
                    <xsl:text>Data: OpenStreetMap CC-by-sa 2.0</xsl:text>
                </svg:text>

            </svg:flowRoot>

        </svg:g>
    </xsl:template>

    <xsl:template name="heading">
        <xsl:param name="class"/>
        <xsl:param name="title"/>
        <svg:flowPara>
            <xsl:attribute name="class">
                <xsl:value-of select="$class"/>
            </xsl:attribute>
            <xsl:text>.    </xsl:text>
            <xsl:value-of select="$title"/>
        </svg:flowPara>
    </xsl:template>

    <xsl:template name="listingsSet">
        <xsl:param name="listings"/>
        <xsl:for-each select="$listings">
            <svg:flowPara class="listing">
                <xsl:value-of select="position()"/>
                <xsl:text>. </xsl:text>
                <xsl:value-of select="@name"/>
            </svg:flowPara>
         </xsl:for-each>
    </xsl:template>

    <xsl:template name="defs">

        <svg:symbol class="icon-see" id="see">
            <svg:path
                      d="M 0,0 L 3.5,0 L 3.5,3.5 L 0,3.5 L 0,0 z "
                 />
        </svg:symbol>

        <svg:symbol class="icon-sleep" id="sleep">
             <svg:path
                    d="M 1.7529697,0.0036956 L 3.5015564,0.75402185 L 3.5015564,1.0237044 L 3.2318741,1.0237044 L 3.2318741,3.2228359 L 0.27406466,3.2228359 L 0.27406466,1.0237044 L 0.0040340858,1.0237044 L 0.0040340858,0.75402185 L 1.7529697,0.0036956 z "
                 />
        </svg:symbol>

        <svg:symbol class="icon-buy" id="buy"> 
                <svg:path
                     d="M 1.7500001,8.9012131e-14 C 1.2808815,8.9012131e-14 1.001917,0.2446048 0.875,0.46875 C 0.7798123,0.6368589 0.75541009,0.77323715 0.75,0.84375 L 0,0.84375 L 0.25,3.625 L 3.2500001,3.625 L 3.5000001,0.84375 L 2.7500001,0.84375 C 2.74459,0.77323715 2.7201878,0.6368589 2.6250001,0.46875 C 2.4980832,0.2446048 2.2191181,-1.6999991e-07 1.7500001,8.9012131e-14 z M 1.7500001,0.3125 C 2.1347584,0.31249986 2.2884479,0.44089211 2.3750001,0.59375 C 2.4327016,0.69565526 2.4382154,0.78512582 2.4375001,0.84375 L 1.03125,0.84375 C 1.0397941,0.78512581 1.0672986,0.69565521 1.125,0.59375 C 1.2115521,0.44089219 1.3652412,0.3125 1.7500001,0.3125 z "
                />
        </svg:symbol>

        <svg:symbol class="icon-eat" id="eat">
              <svg:path
                     d="M 0.10261638,0.022196479 C -0.030532341,0.018846784 -0.0045539651,0.48736081 0.01941521,0.69594775 C 0.029019771,0.77230832 0.09124526,0.85006928 0.37183396,0.85536039 C 0.25223882,2.406149 0.21321668,2.6587238 0.43948192,2.6623712 C 0.67991823,2.6661719 0.60781715,2.3849101 0.55182673,0.85673585 C 0.82437244,0.86185276 0.88099011,0.8019405 0.8997575,0.6976804 C 0.91722328,0.48617115 0.99707754,0.040383572 0.83131817,0.032459301 C 0.62574974,0.023017379 0.80306333,0.59299343 0.64177976,0.60225376 C 0.45371602,0.6123078 0.6557346,0.020743689 0.47547912,0.016522435 C 0.26838848,0.011582813 0.44564566,0.60810507 0.26306898,0.59857731 C 0.10722283,0.59073951 0.28525045,0.027117572 0.10261638,0.022196479 z "
                 />
              <svg:path
                     d="M 4.050853,0.0026634535 C 4.4912474,-0.0001575045 4.7523307,0.8325573 4.1399501,0.84912661 C 4.1711505,2.1636808 4.3179532,2.6626263 4.017253,2.6582302 C 3.705646,2.666577 3.8919774,2.1528362 3.9465928,0.85036939 C 3.3020431,0.86082744 3.6211887,0.0054288316 4.050853,0.0026634535 z "
                 />
              <svg:path
                     d="M 2.2429958,9.6739999e-17 C 4.0230911,9.6739999e-17 4.0230911,2.6434959 2.2429958,2.6434959 C 0.48421812,2.6434959 0.48421812,9.6739999e-17 2.2429958,9.6739999e-17 z "
                 />
        </svg:symbol>

        <svg:symbol class="icon-drink" id="drink"> 
                <svg:path
                     d="M 0.22409918,0.00070345805 L 3.287533,0.00077036 C 3.287533,-0.014921542 3.47678,0.54466044 3.4922326,1.658786 C 3.47678,2.9533684 1.947015,2.8935551 1.9470153,2.8931872 L 1.9470153,3.0108767 L 3.5,3.5 L 4.2413692e-10,3.5 L 1.5684371,3.0108763 L 1.5684371,2.8931872 C 1.5684371,2.8931872 0.023221137,2.9533684 0.023221137,1.6509402 C 0.023221137,0.54466044 0.21637321,-0.022834385 0.22409918,0.00070345805 z "
                />
        </svg:symbol>

        <svg:symbol
            id="wikitravel-logo">
          <svg:path
             id="path1473"
             d="M 117.90722,411.55837 L 131.69274,401.78297 L 139.84056,388.35964 L 117.90722,342.91316 L 117.90722,411.55837 z "
             style="color:#000000;fill:#3888b6;fill-opacity:1.0000000;fill-rule:evenodd;stroke:#1b4157;stroke-width:2.0000000;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:4.0000000;stroke-dashoffset:0.0000000;stroke-opacity:1.0000000;marker:none;marker-start:none;marker-mid:none;marker-end:none;visibility:visible;display:inline;overflow:visible;stroke-dasharray:none" />
          <svg:path
             id="path1475"
             d="M 193.42360,411.55837 L 139.84056,388.35964 C 139.84056,388.35964 117.84288,411.71597 117.90722,411.55837 L 193.42360,411.55837 z "
             style="color:#000000;fill:#759eb6;fill-opacity:1.0000000;fill-rule:evenodd;stroke:#1b4157;stroke-width:2.0000000;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:4.0000000;stroke-dashoffset:0.0000000;stroke-opacity:1.0000000;marker:none;marker-start:none;marker-mid:none;marker-end:none;visibility:visible;display:inline;overflow:visible;stroke-dasharray:none" />
          <svg:path
             id="path1477"
             d="M 116.77555,417.56266 L 93.878043,441.90937 L 116.77555,499.76442 L 116.77555,417.56266 z "
             style="color:#000000;fill:#71a6c1;fill-opacity:1.0000000;fill-rule:evenodd;stroke:#1b4157;stroke-width:2.0000000;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:4.0000000;stroke-dashoffset:0.0000000;stroke-opacity:1.0000000;marker:none;marker-start:none;marker-mid:none;marker-end:none;visibility:visible;display:inline;overflow:visible;stroke-dasharray:none" />
          <svg:path
             id="path1479"
             d="M 116.71120,417.72025 L 53.372800,417.72025 L 93.934273,441.82589 C 93.934273,441.82589 116.71120,417.72025 116.71120,417.72025 z "
             style="color:#000000;fill:#437c9b;fill-opacity:1.0000000;fill-rule:evenodd;stroke:#1b4157;stroke-width:2.0000000;stroke-linecap:round;stroke-linejoin:round;stroke-miterlimit:4.0000000;stroke-dashoffset:0.0000000;stroke-opacity:1.0000000;marker:none;marker-start:none;marker-mid:none;marker-end:none;visibility:visible;display:inline;overflow:visible;stroke-dasharray:none" />
          <svg:path
             id="text1481"
             d="M 182.85173,423.47234 L 170.49373,467.67831 L 161.57875,467.67831 L 154.75419,439.33484 L 154.63122,439.33484 L 147.74517,467.67831 L 139.13761,467.67831 L 126.65665,423.47234 L 136.49386,423.47234 L 143.68732,452.12322 L 149.83558,423.47234 L 159.54983,423.47234 L 166.25143,452.12322 L 173.44489,423.47234 L 182.85173,423.47234 M 194.45557,467.67831 L 185.78652,467.67831 L 185.78652,434.90810 L 194.45557,434.90810 L 194.45557,467.67831 M 194.45557,431.03470 L 185.78652,431.03470 L 185.78652,422.98048 L 194.45557,422.98048 L 194.45557,431.03470 M 229.04386,467.67831 L 219.32961,467.67831 L 212.13615,452.98398 L 207.89385,457.34924 L 207.89385,467.67831 L 199.22481,467.67831 L 199.22481,423.47234 L 207.89385,423.47234 L 207.89385,447.38906 L 218.71479,434.90810 L 229.28979,434.90810 L 218.34589,447.02017 L 229.04386,467.67831 M 241.49011,467.67831 L 232.82107,467.67831 L 232.82107,434.90810 L 241.49011,434.90810 L 241.49011,467.67831 M 241.49011,431.03470 L 232.82107,431.03470 L 232.82107,422.98048 L 241.49011,422.98048 L 241.49011,431.03470 M 272.81325,451.01653 C 272.81322,454.25463 272.64927,456.73443 272.32139,458.45593 C 271.82950,461.28413 270.86628,463.49750 269.43171,465.09605 C 267.09535,467.63733 263.81628,468.90796 259.59450,468.90797 C 256.97123,468.90796 254.59390,468.35462 252.46252,467.24794 C 250.12617,466.01829 248.46614,464.31727 247.48243,462.14488 C 246.62167,460.13646 246.19129,457.90259 246.19129,455.44328 L 246.19129,426.11609 L 254.79885,426.11609 L 254.79885,434.90810 L 272.81325,434.90810 L 272.81325,441.11784 L 254.79885,441.11784 L 254.79885,454.58252 C 254.79884,456.26306 254.92181,457.53370 255.16775,458.39444 C 255.74158,460.36189 257.25814,461.34561 259.71746,461.34561 C 261.15204,461.34561 262.25872,460.91524 263.03752,460.05447 C 264.18518,458.82483 264.75901,456.18108 264.75903,452.12322 L 264.75903,446.15941 L 272.81325,446.15941 L 272.81325,451.01653 M 297.09985,442.96232 C 296.28006,442.83938 295.48078,442.77789 294.70202,442.77787 C 289.41451,442.77789 286.77076,445.40115 286.77077,450.64764 L 286.77077,467.67831 L 278.10173,467.67831 L 278.10173,434.90810 L 286.27891,434.90810 L 286.27891,437.42888 C 286.27890,438.37165 286.29940,438.84301 286.34039,438.84298 C 286.38137,438.80202 286.44285,438.76104 286.52484,438.72002 C 288.16436,436.99854 289.43500,435.89185 290.33676,435.39996 C 291.77134,434.58022 293.63631,434.17034 295.93168,434.17031 C 296.30055,434.17034 296.68994,434.17034 297.09985,434.17031 L 297.09985,442.96232 M 319.22909,451.69284 C 318.36831,452.38966 316.85174,452.94300 314.67938,453.35287 C 312.22006,453.80376 310.62151,454.23414 309.88373,454.64401 C 308.36715,455.42280 307.60887,456.77541 307.60888,458.70186 C 307.60887,461.16117 308.90000,462.39082 311.48228,462.39081 C 312.67093,462.39082 313.90058,462.12439 315.17124,461.59154 C 316.44186,461.01771 317.40508,460.34140 318.06092,459.56261 C 318.92165,458.49692 319.35203,456.91887 319.35205,454.82845 C 319.35203,454.45957 319.33154,453.92672 319.29057,453.22991 C 319.24956,452.53312 319.22907,452.02077 319.22909,451.69284 M 328.38999,467.67831 L 320.33577,467.67831 C 320.08982,467.22744 319.82340,466.34619 319.53650,465.03456 C 317.52805,467.24794 314.33096,468.35462 309.94522,468.35462 C 306.91207,468.35462 304.41178,467.65782 302.44434,466.26421 C 300.14899,464.62468 299.00132,462.24736 299.00132,459.13224 C 299.00132,454.66451 300.74332,451.59039 304.22734,449.90985 C 305.82588,449.13109 309.08445,448.43429 314.00307,447.81944 C 317.48706,447.36859 319.22907,446.42586 319.22909,444.99124 C 319.22907,443.72063 318.69622,442.71641 317.63054,441.97859 C 316.60581,441.19984 315.39666,440.81045 314.00307,440.81043 C 312.56846,440.81045 311.33881,441.19984 310.31411,441.97859 C 309.16643,442.83938 308.51061,444.04853 308.34667,445.60607 L 300.10800,445.60607 C 300.31294,442.94185 300.92777,440.78996 301.95248,439.15040 C 303.01817,437.51089 304.71919,436.24025 307.05554,435.33848 C 309.22791,434.51874 311.68721,434.10886 314.43345,434.10882 C 323.73778,434.19083 328.38996,438.63807 328.38999,447.45054 L 328.38999,467.67831 M 361.76513,434.90810 L 350.02195,467.67831 L 340.98401,467.67831 L 329.24084,434.90810 L 338.83212,434.90810 L 345.65669,456.54997 L 352.66570,434.90810 L 361.76513,434.90810 M 384.26976,448.12685 C 384.06480,445.91350 383.30651,444.17150 381.99491,442.90083 C 380.72425,441.63022 379.24867,440.99490 377.56816,440.99487 C 375.92861,440.99490 374.51451,441.58923 373.32586,442.77787 C 372.01422,444.04853 371.19446,445.83153 370.86656,448.12685 L 384.26976,448.12685 M 393.12325,453.59880 L 370.55915,453.59880 C 370.76408,456.30405 371.62483,458.39445 373.14141,459.87003 C 374.45303,461.09968 376.05158,461.71451 377.93706,461.71450 C 379.33064,461.71451 380.58079,461.38660 381.68749,460.73078 C 382.79416,460.07498 383.51145,459.19373 383.83938,458.08703 L 392.69288,458.08703 C 391.70912,461.40710 389.94662,463.98936 387.40537,465.83384 C 384.86407,467.63733 381.85143,468.53907 378.36743,468.53907 C 367.42353,468.53907 361.95158,462.57526 361.95158,450.64764 C 361.95158,445.60609 363.32469,441.58923 366.07092,438.59705 C 368.85812,435.56394 372.75201,434.04738 377.75261,434.04734 C 387.99968,434.04738 393.12322,440.56452 393.12325,453.59880 M 405.67290,467.67831 L 397.00385,467.67831 L 397.00385,423.47234 L 405.67290,423.47234 L 405.67290,467.67831"
             style="font-size:61.482582px;font-style:normal;font-variant:normal;font-weight:normal;font-stretch:normal;letter-spacing:normal;writing-mode:lr-tb;text-anchor:start;color:#000000;fill:#516f7e;fill-opacity:1.0000000;fill-rule:nonzero;stroke:#0b324b;stroke-width:1.0000000pt;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4.0000000;stroke-dashoffset:0.0000000;stroke-opacity:1.0000000;marker:none;marker-start:none;marker-mid:none;marker-end:none;visibility:visible;display:inline;overflow:visible;font-family:Coolvetica" />
          <svg:path
             id="text1485"
             d="M 138.03397,479.40716 L 152.94280,479.40716 L 152.14837,482.82321 L 146.85216,482.82321 L 143.67443,497.94389 L 139.51691,497.94389 L 142.69463,482.82321 L 137.29250,482.82321 L 138.03397,479.40716 M 154.53031,479.30123 L 158.37006,479.30123 L 157.01953,485.76261 C 158.34358,484.65042 159.67645,484.09431 161.01817,484.09430 C 161.98913,484.09431 162.81004,484.36795 163.48091,484.91521 C 164.22236,485.51546 164.59310,486.28341 164.59311,487.21906 C 164.59310,487.73104 164.56662,488.11060 164.51367,488.35775 L 162.50111,497.97037 L 158.66136,497.97037 L 160.40911,489.68180 C 160.44440,489.52292 160.46206,489.27577 160.46207,488.94033 C 160.46206,487.89875 159.92361,487.37796 158.84672,487.37795 C 158.14055,487.37796 157.51384,487.72221 156.96657,488.41071 C 156.50756,488.99330 156.18979,489.67298 156.01325,490.44975 L 154.34495,497.91741 L 150.47871,497.91741 L 154.53031,479.30123 M 169.58063,492.30342 L 169.58063,492.67416 C 169.58062,493.48625 169.82778,494.14827 170.32210,494.66024 C 170.83406,495.17221 171.49609,495.42819 172.30818,495.42819 C 173.26149,495.42819 174.10005,494.91622 174.82388,493.89229 L 178.87548,493.89229 C 178.08103,495.53411 177.12772,496.69045 176.01552,497.36130 C 174.92096,498.01450 173.45568,498.34110 171.61967,498.34110 C 169.80130,498.34110 168.38898,497.82914 167.38270,496.80520 C 166.37642,495.78127 165.87328,494.35129 165.87328,492.51527 C 165.87328,490.06137 166.62358,488.04881 168.12417,486.47759 C 169.64241,484.90640 171.61966,484.12079 174.05593,484.12078 C 175.83897,484.12079 177.23364,484.63276 178.23993,485.65668 C 179.24620,486.68063 179.74934,488.08412 179.74935,489.86717 C 179.74934,489.84952 179.64341,490.66161 179.43158,492.30342 L 169.58063,492.30342 M 176.04200,489.60236 L 176.06848,489.28458 L 176.06848,488.99329 C 176.06847,488.35776 175.83897,487.86345 175.37998,487.51035 C 174.92096,487.15728 174.36486,486.98074 173.71167,486.98073 C 172.08749,486.98074 170.93116,487.85462 170.24266,489.60236 L 176.04200,489.60236 M 193.76072,479.38067 L 207.08068,479.38067 L 206.28625,482.77025 L 197.20325,482.77025 L 196.32938,486.84833 L 204.56498,486.84833 L 203.79703,490.29086 L 195.61439,490.29086 L 193.91960,497.97037 L 189.81504,497.97037 L 193.76072,479.38067 M 207.14317,484.49152 L 210.85051,484.49152 L 210.13553,486.92777 C 210.75341,485.85089 211.45074,485.14473 212.22753,484.80929 C 212.82776,484.54449 213.82521,484.41209 215.21989,484.41207 L 214.29305,488.62256 C 213.97527,488.58726 213.73694,488.56961 213.57806,488.56960 C 212.43054,488.56961 211.54784,488.78145 210.92996,489.20514 C 210.25910,489.66415 209.80892,490.44093 209.57942,491.53547 L 208.14945,497.97037 L 204.30970,497.97037 L 207.14317,484.49152 M 219.07575,492.30342 L 219.07575,492.67416 C 219.07574,493.48625 219.32290,494.14827 219.81722,494.66024 C 220.32918,495.17221 220.99120,495.42819 221.80330,495.42819 C 222.75661,495.42819 223.59517,494.91622 224.31899,493.89229 L 228.37059,493.89229 C 227.57615,495.53411 226.62283,496.69045 225.51064,497.36130 C 224.41608,498.01450 222.95080,498.34110 221.11479,498.34110 C 219.29642,498.34110 217.88410,497.82914 216.87782,496.80520 C 215.87154,495.78127 215.36840,494.35129 215.36840,492.51527 C 215.36840,490.06137 216.11870,488.04881 217.61929,486.47759 C 219.13753,484.90640 221.11478,484.12079 223.55104,484.12078 C 225.33409,484.12079 226.72876,484.63276 227.73505,485.65668 C 228.74132,486.68063 229.24446,488.08412 229.24447,489.86717 C 229.24446,489.84952 229.13853,490.66161 228.92670,492.30342 L 219.07575,492.30342 M 225.53712,489.60236 L 225.56360,489.28458 L 225.56360,488.99329 C 225.56359,488.35776 225.33409,487.86345 224.87510,487.51035 C 224.41608,487.15728 223.85998,486.98074 223.20679,486.98073 C 221.58261,486.98074 220.42628,487.85462 219.73777,489.60236 L 225.53712,489.60236 M 234.33339,492.30342 L 234.33339,492.67416 C 234.33338,493.48625 234.58054,494.14827 235.07485,494.66024 C 235.58682,495.17221 236.24884,495.42819 237.06093,495.42819 C 238.01424,495.42819 238.85281,494.91622 239.57663,493.89229 L 243.62823,493.89229 C 242.83379,495.53411 241.88047,496.69045 240.76828,497.36130 C 239.67372,498.01450 238.20844,498.34110 236.37243,498.34110 C 234.55406,498.34110 233.14174,497.82914 232.13546,496.80520 C 231.12918,495.78127 230.62604,494.35129 230.62604,492.51527 C 230.62604,490.06137 231.37633,488.04881 232.87693,486.47759 C 234.39517,484.90640 236.37242,484.12079 238.80868,484.12078 C 240.59173,484.12079 241.98640,484.63276 242.99269,485.65668 C 243.99895,486.68063 244.50209,488.08412 244.50211,489.86717 C 244.50209,489.84952 244.39617,490.66161 244.18433,492.30342 L 234.33339,492.30342 M 240.79476,489.60236 L 240.82124,489.28458 L 240.82124,488.99329 C 240.82123,488.35776 240.59173,487.86345 240.13273,487.51035 C 239.67372,487.15728 239.11762,486.98074 238.46443,486.98073 C 236.84025,486.98074 235.68391,487.85462 234.99541,489.60236 L 240.79476,489.60236 M 257.03054,479.40716 L 271.93937,479.40716 L 271.14493,482.82321 L 265.84873,482.82321 L 262.67100,497.94389 L 258.51348,497.94389 L 261.69120,482.82321 L 256.28907,482.82321 L 257.03054,479.40716 M 271.79941,484.49152 L 275.50676,484.49152 L 274.79177,486.92777 C 275.40965,485.85089 276.10699,485.14473 276.88377,484.80929 C 277.48400,484.54449 278.48145,484.41209 279.87613,484.41207 L 278.94929,488.62256 C 278.63151,488.58726 278.39318,488.56961 278.23430,488.56960 C 277.08678,488.56961 276.20408,488.78145 275.58620,489.20514 C 274.91534,489.66415 274.46516,490.44093 274.23567,491.53547 L 272.80569,497.97037 L 268.96594,497.97037 L 271.79941,484.49152 M 289.18215,488.14590 L 289.15567,488.14590 C 289.17331,487.26321 288.59955,486.82186 287.43440,486.82185 C 286.25157,486.82186 285.39535,487.37796 284.86574,488.49015 L 280.86710,488.46367 C 281.96165,485.58608 284.18605,484.14728 287.54032,484.14726 C 291.14173,484.14728 292.94244,485.38306 292.94245,487.85461 C 292.94244,488.94917 292.65115,490.62630 292.06858,492.88601 C 291.50364,495.07511 291.23883,496.75224 291.27415,497.91741 L 287.43440,497.91741 L 287.43440,496.56687 C 286.21626,497.73204 284.83042,498.31462 283.27687,498.31462 C 282.11170,498.31462 281.14956,497.96154 280.39044,497.25538 C 279.63132,496.53157 279.25175,495.59590 279.25175,494.44839 C 279.25175,493.67162 279.50774,492.88601 280.01971,492.09158 C 280.69056,491.04999 281.83807,490.34383 283.46224,489.97309 C 284.75098,489.81421 286.04855,489.64650 287.35495,489.46995 C 288.57307,489.27577 289.18214,488.83442 289.18215,488.14590 M 283.14447,494.07765 L 283.14447,494.05117 C 283.14446,494.47487 283.33866,494.81913 283.72705,495.08393 C 284.06247,495.31344 284.45969,495.42819 284.91870,495.42819 C 285.87201,495.42819 286.69292,495.03097 287.38144,494.23654 C 287.96401,493.53038 288.35240,492.67416 288.54660,491.66788 C 287.89339,491.73850 287.23137,491.80912 286.56052,491.87973 C 285.57189,492.02097 284.80394,492.23281 284.25667,492.51527 C 283.51520,492.88601 283.14446,493.40681 283.14447,494.07765 M 299.03596,484.57096 C 299.37139,487.16611 299.58323,490.03489 299.67151,493.17730 L 303.80255,484.57096 L 308.09248,484.57096 L 300.51890,497.91741 L 296.78508,497.91741 L 294.87844,484.57096 L 299.03596,484.57096 M 310.63642,492.30342 L 310.63642,492.67416 C 310.63642,493.48625 310.88358,494.14827 311.37789,494.66024 C 311.88986,495.17221 312.55188,495.42819 313.36397,495.42819 C 314.31728,495.42819 315.15585,494.91622 315.87967,493.89229 L 319.93127,493.89229 C 319.13683,495.53411 318.18351,496.69045 317.07132,497.36130 C 315.97676,498.01450 314.51148,498.34110 312.67547,498.34110 C 310.85710,498.34110 309.44477,497.82914 308.43850,496.80520 C 307.43222,495.78127 306.92908,494.35129 306.92908,492.51527 C 306.92908,490.06137 307.67937,488.04881 309.17997,486.47759 C 310.69821,484.90640 312.67546,484.12079 315.11172,484.12078 C 316.89477,484.12079 318.28943,484.63276 319.29573,485.65668 C 320.30199,486.68063 320.80513,488.08412 320.80515,489.86717 C 320.80513,489.84952 320.69921,490.66161 320.48737,492.30342 L 310.63642,492.30342 M 317.09780,489.60236 L 317.12428,489.28458 L 317.12428,488.99329 C 317.12427,488.35776 316.89477,487.86345 316.43577,487.51035 C 315.97676,487.15728 315.42066,486.98074 314.76747,486.98073 C 313.14329,486.98074 311.98695,487.85462 311.29845,489.60236 L 317.09780,489.60236 M 324.50226,479.35419 L 328.39497,479.35419 L 324.36985,497.94389 L 320.47714,497.94389 L 324.50226,479.35419 M 351.53154,485.33891 C 351.53153,484.31499 351.20493,483.52056 350.55175,482.95562 C 349.91619,482.39070 349.07762,482.10824 348.03605,482.10822 C 346.02348,482.10824 344.42579,483.05273 343.24298,484.94169 C 342.21904,486.56588 341.70707,488.44603 341.70708,490.58216 C 341.70707,491.90621 342.07781,493.00076 342.81928,493.86581 C 343.59605,494.78382 344.63764,495.24282 345.94404,495.24282 C 347.19747,495.24282 348.27436,494.81913 349.17473,493.97173 C 350.09273,493.10669 350.64000,492.03862 350.81656,490.76752 L 346.89736,490.76752 L 347.61235,487.40443 L 355.42426,487.40443 L 353.25281,497.86444 L 349.96916,497.86444 L 350.47230,495.66652 C 349.48366,496.69045 348.64510,497.37896 347.95660,497.73204 C 347.12685,498.13808 346.05879,498.34110 344.75240,498.34110 C 342.40440,498.34110 340.58604,497.65260 339.29730,496.27558 C 338.02621,494.89857 337.39067,493.02724 337.39067,490.66160 C 337.39067,487.48388 338.28219,484.77399 340.06525,482.53192 C 342.00719,480.09568 344.52289,478.87755 347.61235,478.87753 C 349.94267,478.87755 351.77869,479.37187 353.12041,480.36047 C 354.62098,481.45504 355.42424,483.11452 355.53018,485.33891 L 351.53154,485.33891 M 358.07078,484.51800 L 361.96349,484.51800 L 360.24222,492.72712 C 360.15395,493.15082 360.10981,493.39798 360.10982,493.46859 C 360.10981,494.54549 360.69240,495.08394 361.85757,495.08393 C 363.35815,495.08394 364.37326,493.84816 364.90289,491.37659 L 366.35935,484.51800 L 370.25206,484.51800 L 367.39211,497.97037 L 363.73772,497.97037 L 364.02901,496.27558 C 363.41111,497.03470 362.81088,497.56433 362.22830,497.86444 C 361.66337,498.14691 360.90425,498.28814 359.95093,498.28814 C 358.78576,498.28814 357.85893,497.97919 357.17042,497.36130 C 356.48191,496.72576 356.13766,495.83423 356.13766,494.68672 C 356.13766,494.19241 356.19945,493.64513 356.32303,493.04489 L 358.07078,484.51800 M 373.43061,484.49152 L 377.32333,484.49152 L 374.41041,497.94389 L 370.54418,497.94389 L 373.43061,484.49152 M 374.56930,479.30123 L 378.46201,479.30123 L 377.69406,482.63784 L 373.85431,482.63784 L 374.56930,479.30123 M 390.31312,479.38067 L 394.15287,479.38067 L 390.23368,497.97037 L 386.34096,497.97037 L 386.71170,496.59335 C 385.68776,497.74087 384.39019,498.31462 382.81898,498.31462 C 381.31839,498.31462 380.14440,497.78500 379.29700,496.72576 C 378.50257,495.75479 378.10536,494.50135 378.10536,492.96545 C 378.10536,490.70574 378.68794,488.71967 379.85311,487.00721 C 381.19481,485.06528 382.94256,484.09431 385.09635,484.09430 C 385.96139,484.09431 386.67638,484.23555 387.24132,484.51800 C 387.80624,484.78282 388.37117,485.25065 388.93610,485.92149 L 390.31312,479.38067 M 384.48729,495.11041 L 384.48729,495.13690 C 385.68776,495.13690 386.63224,494.47487 387.32076,493.15082 C 387.88568,492.07393 388.16814,490.87345 388.16815,489.54940 C 388.16814,488.94917 387.93864,488.42837 387.47965,487.98701 C 387.03829,487.54567 386.51749,487.32500 385.91727,487.32499 C 384.78740,487.32500 383.85174,487.88110 383.11027,488.99329 C 382.45707,489.98193 382.13047,491.07648 382.13048,492.27694 C 382.13047,494.16593 382.91608,495.11042 384.48729,495.11041 M 397.14811,492.30342 L 397.14811,492.67416 C 397.14811,493.48625 397.39527,494.14827 397.88958,494.66024 C 398.40154,495.17221 399.06357,495.42819 399.87566,495.42819 C 400.82897,495.42819 401.66754,494.91622 402.39136,493.89229 L 406.44296,493.89229 C 405.64852,495.53411 404.69520,496.69045 403.58301,497.36130 C 402.48845,498.01450 401.02316,498.34110 399.18715,498.34110 C 397.36878,498.34110 395.95646,497.82914 394.95019,496.80520 C 393.94391,495.78127 393.44077,494.35129 393.44077,492.51527 C 393.44077,490.06137 394.19106,488.04881 395.69166,486.47759 C 397.20990,484.90640 399.18715,484.12079 401.62341,484.12078 C 403.40646,484.12079 404.80112,484.63276 405.80741,485.65668 C 406.81368,486.68063 407.31682,488.08412 407.31683,489.86717 C 407.31682,489.84952 407.21090,490.66161 406.99906,492.30342 L 397.14811,492.30342 M 403.60949,489.60236 L 403.63597,489.28458 L 403.63597,488.99329 C 403.63596,488.35776 403.40646,487.86345 402.94746,487.51035 C 402.48845,487.15728 401.93235,486.98074 401.27916,486.98073 C 399.65498,486.98074 398.49864,487.85462 397.81014,489.60236 L 403.60949,489.60236"
             style="font-size:26.481045px;font-style:italic;font-variant:normal;font-weight:bold;font-stretch:normal;line-height:100.00000%;letter-spacing:normal;writing-mode:lr-tb;text-anchor:start;color:#000000;fill:#1b4157;fill-opacity:1.0000000;fill-rule:nonzero;stroke:none;stroke-width:1.0000000pt;stroke-linecap:butt;stroke-linejoin:miter;stroke-miterlimit:4.0000000;stroke-dashoffset:0.0000000;stroke-opacity:1.0000000;marker:none;marker-start:none;marker-mid:none;marker-end:none;visibility:visible;display:inline;overflow:visible;font-family:Helmet" />
        </svg:symbol>

        <svg:style type="text/css">

            .osm-credit-text {
                font-size: 2.8px;
                font-style: normal;
                font-variant: normal;
                font-weight: bold;
                font-stretch: normal;
                text-align: center;
                text-anchor: center;
                line-height: 100%;
                writing-mode: lr-tb;
                fill: #3f3f3f;
                fill-opacity: 1;
                stroke: none;
                stroke-width: 0.1px;
                stroke-linecap: butt;
                stroke-linejoin: miter;
                stroke-opacity: 1;
                font-family: Bitstream Vera Sans
            }

            .icon-see {
                 fill: #3077bd;
                 fill-opacity: 1;
                 fill-rule: evenodd;
                 font-size: 4px;
                 stroke: none;
            }

            .icon-sleep {
                 fill: #000088;
                 fill-opacity: 1;
                 fill-rule: evenodd;
                 font-size: 4px;
                 stroke: none;
            }

            .icon-buy {
                 fill: #00ae98;
                 fill-opacity: 1;
                 fill-rule: evenodd;
                 font-size: 4px;
                 stroke: none;
            }

            .icon-eat {
               font-size: 4px;
               fill: #ac2100;
               fill-opacity: 1;
               fill-rule: evenodd;
            }

            .icon-drink {
               font-size: 4px;
               fill: #810061;
               fill-opacity: 1;
               fill-rule: evenodd
            }

            .listing-small {
                font-family: Bitstream Vera Sans;
                font-weight: normal;
                font-style: normal;
                font-stretch: normal;
                font-variant: normal;
                font-size: 3.0px;
                text-anchor: start;
                text-align: start;
                writing-mode: lr;
            }

            .section-heading-small {
                font-family: Bitstream Vera Sans;
                font-weight: bold;
                font-style: normal;
                font-stretch: normal;
                font-variant: normal;
                font-size: 3.0px;
                text-anchor: start;
                text-align: start;
                writing-mode: lr;
                line-height: 6px;
            }

            .listing {
                font-family: Bitstream Vera Sans;
                font-weight: normal;
                font-style: normal;
                font-stretch: normal;
                font-variant: normal;
                font-size: 3.4px;
                text-anchor: start;
                text-align: start;
                writing-mode: lr;
            }

            .section-heading {
                font-family: Bitstream Vera Sans;
                font-weight: bold;
                font-style: normal;
                font-stretch: normal;
                font-variant: normal;
                font-size: 3.4px;
                text-anchor: start;
                text-align: start;
                writing-mode: lr;
                line-height: 6px;
            }

            .listings-box {
                opacity: 1;
                fill: #ffffff;
                fill-opacity: 1;
                fill-rule: nonzero;
                stroke: #000000;
                stroke-width: 0.2;
                stroke-linecap: round;
                stroke-linejoin: miter;
                stroke-miterlimit: 4;
                stroke-dasharray: none;
                stroke-dashoffset: 0;
                stroke-opacity: 1
            }
        </svg:style>
    </xsl:template>

</xsl:stylesheet>
