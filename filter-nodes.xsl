<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
        xmlns:xlink="http://www.w3.org/1999/xlink"
        xmlns:svg="http://www.w3.org/2000/svg" >
  
  <xsl:variable name="listings" select="document('listings.xml')" />
  
  <xsl:template match="node()|@*">
         <xsl:copy>
           <xsl:apply-templates select="node()|@*"/>
         </xsl:copy>
  </xsl:template>
  
  <xsl:template match="node()|@*" mode="name">
         <xsl:copy>
           <xsl:apply-templates select="node()|@*"/>
         </xsl:copy>
  </xsl:template>

  <xsl:template match="node()|@*" mode="listing">
         <xsl:copy>
           <xsl:apply-templates select="node()|@*"/>
         </xsl:copy>
  </xsl:template>
  
  <xsl:template match="node|way">
    <xsl:variable name="node" select="." />
    <xsl:variable name="nodeInListings">
      <xsl:for-each select="$listings//*">
        <!--xsl:message>
            <xsl:value-of select="$node/@id"/> test: <xsl:value-of select="$node/tag[@k='name']/@v"/> == <xsl:value-of select="./@name" />
        </xsl:message-->
        <xsl:if test="$node/tag[@k='name']/@v = ./@name"><xsl:value-of select="1" /></xsl:if>
      </xsl:for-each>
    </xsl:variable>
    <!--xsl:variable name="stripName" select="count($node/tag[@k='amenity' and @v='bank'])" /-->
    <xsl:variable name="stripName" select="count($node/tag[@k='highway' or @k='railway' or @k='barrier' or (@k='amenity' and (@v='bus_station' or @v='taxi'))])" />

    <xsl:choose>
      <xsl:when test="$nodeInListings != ''">
         <xsl:copy>
           <xsl:apply-templates select="node()|@*" mode="listing" />
         </xsl:copy>
      </xsl:when>
      <xsl:when test="$stripName = 0">
         <xsl:copy>
           <xsl:apply-templates select="node()|@*" mode="name"/>
         </xsl:copy>
      </xsl:when>
      <xsl:otherwise>
        <xsl:message>include(<xsl:value-of select="@id" />): <xsl:value-of select="$node/tag[@k='name']/@v"/></xsl:message>
        <xsl:copy-of select="$node" />
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <!-- :<xsl:value-of select="@k"/><xsl:value-of select="parent()/tag[@k='name']/@v"/> -->
  <xsl:template match="tag[@k='amenity' or @k='tourism' or @k='railway' or @k='building']" mode="listing"><xsl:message>omity</xsl:message></xsl:template>
  
  <xsl:template match="tag[@k='name']" mode="name"><xsl:message>omit <xsl:value-of select="@v" /></xsl:message></xsl:template>
</xsl:stylesheet>
