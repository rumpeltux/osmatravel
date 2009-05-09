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

    <xsl:variable name="dataWidth">
        <xsl:choose>
            <xsl:when test="$size = 'two-page' and $orientation = 'landscape'">346</xsl:when>
            <xsl:when test="$size = 'two-page' and $orientation = 'portrait'">300.8</xsl:when>
            <xsl:when test="$size = 'one-page' and $orientation = 'landscape'">300.8</xsl:when>
            <xsl:when test="$size = 'one-page' and $orientation = 'portrait'">173</xsl:when>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="dataHeight">
        <xsl:choose>
            <xsl:when test="$size = 'two-page' and $orientation = 'landscape'">300.8</xsl:when>
            <xsl:when test="$size = 'two-page' and $orientation = 'portrait'">346</xsl:when>
            <xsl:when test="$size = 'one-page' and $orientation = 'landscape'">173</xsl:when>
            <xsl:when test="$size = 'one-page' and $orientation = 'portrait'">300.8</xsl:when>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="ratio" select="$dataWidth div $dataHeight"/>

    <xsl:variable name="reldata" select="document('relation.xml')"/>

    <xsl:variable name="bottomLeftLatitude">
        <xsl:for-each select="$reldata/osm/node">
            <xsl:sort select="@lat" data-type="number"/>
            <xsl:if test="position() = 1">
                <xsl:value-of select="@lat"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="topRightLatitude">
        <xsl:for-each select="$reldata/osm/node">
            <xsl:sort select="@lat" data-type="number"/>
            <xsl:if test="position() = last()">
                <xsl:value-of select="@lat"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="bottomLeftLongitude">
        <xsl:for-each select="$reldata/osm/node">
            <xsl:sort select="@lon" data-type="number"/>
            <xsl:if test="position() = 1">
                <xsl:value-of select="@lon"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>

    <xsl:variable name="topRightLongitude">
        <xsl:for-each select="$reldata/osm/node">
            <xsl:sort select="@lon" data-type="number"/>
            <xsl:if test="position() = last()">
                <xsl:value-of select="@lon"/>
            </xsl:if>
        </xsl:for-each>
    </xsl:variable>

    <!-- Derive the latitude of the middle of the map -->
    <xsl:variable name="middleLatitude" select="($topRightLatitude + $bottomLeftLatitude) div 2.0"/>
    <!--woohoo lets do trigonometry in xslt -->
    <!--convert latitude to radians -->
    <xsl:variable name="latr" select="$middleLatitude * 3.1415926 div 180.0"/>
    <!--taylor series: two terms is 1% error at lat<68 and 10% error lat<83. we probably need polar projection by then -->
    <xsl:variable name="coslat" select="1 - ($latr * $latr) div 2 + ($latr * $latr * $latr * $latr) div 24"/>
    <xsl:variable name="projection" select="1 div $coslat"/>

    <xsl:variable name="horizontalCropOffset" select="($topRightLongitude - $bottomLeftLongitude) * $cropMarginFactor"/>
    <xsl:variable name="verticalCropOffset"   select="($topRightLatitude - $bottomLeftLatitude) * $cropMarginFactor"/>

    <xsl:variable name="bboxWidth" select="( ($topRightLongitude - $bottomLeftLongitude + ( 2 * $horizontalCropOffset ) ) * 10000 )"/>
    <xsl:variable name="bboxHeight" select="( ($topRightLatitude - $bottomLeftLatitude + ( 2 * $verticalCropOffset ) ) * $projection * 10000 )"/>

    <xsl:variable name="relation-ratio" select="$bboxWidth div $bboxHeight"/>

    <xsl:variable name="scale">
        <xsl:choose>
            <xsl:when test="$relation-ratio &lt; $ratio">
                <xsl:variable name="rawScale" select="$dataHeight div $bboxHeight"/>
                <xsl:variable name="testOffset" select="$dataWidth - $bboxWidth * $rawScale"/>
                <xsl:choose>
                    <xsl:when test="$expandForListings = 'yes' and $testOffset &lt; $minOffset">
                        <xsl:value-of select="( $dataWidth - $minOffset ) div $bboxWidth"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$rawScale"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:when test="$relation-ratio &gt; $ratio">
                <xsl:variable name="rawScale" select="$dataWidth div $bboxWidth"/>
                <xsl:variable name="testOffset" select="( $dataHeight - $bboxHeight * $rawScale ) div $projection"/>
                <xsl:choose>
                    <xsl:when test="$expandForListings = 'yes' and $testOffset &lt; $minOffset">
                        <xsl:value-of select="( $dataHeight - $minOffset ) div $bboxHeight"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$rawScale"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>1</xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="leftOffset" select="$dataWidth - $bboxWidth * $scale"/>
    <xsl:variable name="bottomOffset" select="( $dataHeight - $bboxHeight * $scale ) div $projection"/>

    <xsl:variable name="dataurl">
        <xsl:text>http://www.openstreetmap.org/api/0.6/map?bbox=</xsl:text>
        <xsl:value-of select="$bottomLeftLongitude - $leftOffset div ( 10000 * $scale ) - $horizontalCropOffset"/>
        <xsl:text>,</xsl:text>
        <xsl:value-of select="$bottomLeftLatitude - $bottomOffset div ( 10000 * $scale ) - $verticalCropOffset"/>
        <xsl:text>,</xsl:text>
        <xsl:value-of select="$topRightLongitude + $horizontalCropOffset"/>
        <xsl:text>,</xsl:text>
        <xsl:value-of select="$topRightLatitude + $verticalCropOffset"/>
    </xsl:variable>

    <xsl:variable name="iconLatitudeScaleFactor">85</xsl:variable>

    <!-- if latitude data is not available, just scale symbols to size 1 -->
    <xsl:variable name="symbolScale">
      <xsl:choose>
        <xsl:when test="$size = 'one-page'">
          <xsl:value-of select="1.2"/>
        </xsl:when>
        <xsl:when test="$size = 'two-page'">
          <xsl:value-of select="1.2"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="1"/>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:variable>

</xsl:stylesheet>
