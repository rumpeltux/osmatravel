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
    <xsl:variable name="unmatched" select="document('unmatched.xml')"/>

    <xsl:template match="/">
        <svg:svg>
            <xsl:copy-of select="/svg:svg/@*"/>
            <svg:g inkscape:groupmode="layer" inkscape:label="Unmatched Listings Box">
                <svg:defs id="defs-rulefile">
                    <xsl:call-template name="defs"/>
                </svg:defs>
                <xsl:if test="$unmatched/listings/listing">
                    <svg:rect class="unmatched-listings-box" x="10" y="10" height="200" width="100"/>
                    <svg:flowRoot>
                        <svg:flowRegion>
                            <svg:rect x="14" y="14" height="190" width="100">
                            </svg:rect>
                        </svg:flowRegion>
                        <svg:flowPara class="unmatched-heading">WARNING! This article has unmatched listings:</svg:flowPara>
                        <svg:flowPara class="unmatched-listing"/>
                        <xsl:for-each select="$unmatched/listings/listing">
                            <svg:flowPara class="unmatched-listing">
                                <xsl:value-of select="."/>
                            </svg:flowPara>
                        </xsl:for-each>
                    </svg:flowRoot>
                </xsl:if>
            </svg:g>
        </svg:svg>
    </xsl:template>

    <xsl:template name="defs">

        <svg:style type="text/css">

            .unmatched-listing {
                font-family: Bitstream Vera Sans;
                font-weight: normal;
                font-style: normal;
                font-stretch: normal;
                font-variant: normal;
                font-size: 5px;
                text-anchor: start;
                text-align: start;
                writing-mode: lr;
            }

            .unmatched-heading {
                font-family: Bitstream Vera Sans;
                font-weight: bold;
                font-style: normal;
                font-stretch: normal;
                font-variant: normal;
                font-size: 5px;
                text-anchor: start;
                text-align: start;
                writing-mode: lr;
                line-height: 6px;
                color: red;
            }

            .unmatched-listings-box {
                opacity: 1;
                fill: #ffffff;
                fill-opacity: 1;
                fill-rule: nonzero;
                stroke: #FF0000;
                stroke-width: 2;
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
