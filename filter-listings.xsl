<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
        xmlns:xlink="http://www.w3.org/1999/xlink"
        xmlns:svg="http://www.w3.org/2000/svg" >
  
  <xsl:param name="map" />
  
  <xsl:template match="node()|@*">
         <xsl:copy>
           <xsl:apply-templates select="node()|@*"/>
         </xsl:copy>
  </xsl:template>

  <xsl:template match="see|do|eat|drink|buy|sleep|listing">
      <xsl:if test="not(@map) or contains(@map, $map)">
          <xsl:message>include: <xsl:value-of select="@name"/></xsl:message>
          <xsl:copy-of select="." />
      </xsl:if>
      <xsl:if test="not(not(@map) or contains(@map, $map))">
          <xsl:message>omit: <xsl:value-of select="@name"/></xsl:message>
      </xsl:if>
  </xsl:template>
</xsl:stylesheet>
