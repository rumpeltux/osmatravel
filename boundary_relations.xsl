<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet>
  <!-- Draw areas for a boundary relation -->
  <xsl:template match="relation" mode="area">
    <xsl:param name="instruction"/>
    <xsl:param name="layer"/>

    <xsl:variable name="relation" select="@id"/>

    <xsl:message>
        Processing boundary relation: <xsl:value-of select="tag[@k='name']/@v"/>
    </xsl:message>

    <xsl:if test="(tag[@k='type']/@v='boundary') and ($showRelationBoundary!='~|no')">
      <!-- Generate an area for a relation Boundary -->
      <xsl:variable name="boundaryWays" select="$data/osm/relation[@id=$relation]/member[@type='way'][key('wayById', @ref)]"/>
      <xsl:variable name="firstWay" select="key('wayById',$boundaryWays[1]/@ref)"/>
      <xsl:message>
        count(boundaryWays): <xsl:value-of select="count($boundaryWays)"/>
      </xsl:message>
      <xsl:variable name="pathArea">
        <xsl:call-template name="generateRelationBorderPath">
            <xsl:with-param name="way"          select="$firstWay"/>
            <xsl:with-param name="firstWay"     select="$firstWay"/>
            <xsl:with-param name="reverse"      select="0 != 0"/><!-- false -->
            <xsl:with-param name="recursions"   select="1"/>
            <xsl:with-param name="boundaryWays" select="$boundaryWays"/>
        </xsl:call-template>
      </xsl:variable>
      <xsl:if test ="$pathArea!=''">
        <path id="area_{@id}" d="{$pathArea}"/>
        <xsl:call-template name="renderArea">
          <xsl:with-param name="instruction" select="$instruction"/>
          <xsl:with-param name="pathId" select="concat('area_',@id)"/>
        </xsl:call-template>
      </xsl:if>
    </xsl:if>
  </xsl:template>

  <!-- a recursive template which actually does the 
       drawing for boundary relations -->
  <xsl:template name="generateRelationBorderPath">
      <xsl:param name="way"/>
      <xsl:param name="firstWay"/>
      <xsl:param name="boundaryWays"/>
      <xsl:param name="reverse"/>
      <xsl:param name="recursions"/>

      <xsl:variable name="first" select="$way/nd[1]/@ref"/>
      <xsl:variable name="last" select="$way/nd[last()]/@ref"/>
      <xsl:variable name="firstNodeWays" select="key('wayByNode',$first)"/>
      <xsl:variable name="lastNodeWays" select="key('wayByNode',$last)"/>

      <xsl:message>
              WayID: <xsl:value-of select="$way/@id"/>
         firstWayID: <xsl:value-of select="$firstWay/@id"/>
           position: <xsl:value-of select="position()"/>
          firstNode: <xsl:value-of select="$first"/>
           lastNode: <xsl:value-of select="$last"/>
           reversed: <xsl:choose><xsl:when test="$reverse">true</xsl:when><xsl:otherwise>false</xsl:otherwise></xsl:choose>
      </xsl:message>

      <xsl:for-each select="$way/tag">
          <xsl:message>
               tagName: <xsl:value-of select="@k"/>
              tagValue: <xsl:value-of select="@v"/>
          </xsl:message>
      </xsl:for-each>

      <xsl:choose>
        <xsl:when test="$reverse">
          <xsl:for-each select="$way/nd">
            <xsl:sort select="position()" data-type="number" order="descending"/>
            <xsl:choose>
              <xsl:when test="($firstWay/@id = $way/@id) and (position() = 1)">
                <xsl:call-template name="moveToNode">
                  <xsl:with-param name="node" select="key('nodeById',@ref)"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="lineToNode">
                  <xsl:with-param name="node" select="key('nodeById',@ref)"/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <xsl:for-each select="$way/nd">
            <xsl:choose>
              <xsl:when test="($firstWay/@id = $way/@id) and (position() = 1)">
                <xsl:call-template name="moveToNode">
                  <xsl:with-param name="node" select="key('nodeById',@ref)"/>
                </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                <xsl:call-template name="lineToNode">
                  <xsl:with-param name="node" select="key('nodeById',@ref)"/>
                </xsl:call-template>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:for-each>
        </xsl:otherwise>
      </xsl:choose>

      <xsl:variable name="nextWayID">
          <xsl:choose>
              <xsl:when test="$reverse">
                  <xsl:call-template name="getNextWayID">
                      <xsl:with-param name="nodeWays" select="$firstNodeWays"/>
                      <xsl:with-param name="boundaryWays" select="$boundaryWays"/>
                      <xsl:with-param name="currentWay" select="$way"/>
                  </xsl:call-template>
              </xsl:when>
              <xsl:otherwise>
                  <xsl:call-template name="getNextWayID">
                      <xsl:with-param name="nodeWays" select="$lastNodeWays"/>
                      <xsl:with-param name="boundaryWays" select="$boundaryWays"/>
                      <xsl:with-param name="currentWay" select="$way"/>
                  </xsl:call-template>
              </xsl:otherwise>
          </xsl:choose>
      </xsl:variable>

      <xsl:variable 
            name="nextReverse" 
            select="($last = key('wayById',$nextWayID)/nd[last()]/@ref) or
                    ($first = key('wayById',$nextWayID)/nd[last()]/@ref)"/>

      <xsl:choose>
          <xsl:when test="$recursions >= count($boundaryWays)">
              <xsl:text>Z</xsl:text>
          </xsl:when>
          <xsl:otherwise>
              <xsl:call-template name="generateRelationBorderPath">
                  <xsl:with-param name="way" select="key('wayById',$nextWayID)"/>
                  <xsl:with-param name="firstWay" select="$firstWay"/>
                  <xsl:with-param name="reverse" select="$nextReverse"/>
                  <xsl:with-param name="boundaryWays" select="$boundaryWays"/>
                  <xsl:with-param name="recursions" select="$recursions + 1"/>
              </xsl:call-template>
          </xsl:otherwise>
      </xsl:choose>
  </xsl:template>

  <xsl:template name="getNextWayID">
      <xsl:param name="nodeWays"/>
      <xsl:param name="boundaryWays"/>
      <xsl:param name="currentWay"/>
      <xsl:for-each select="$nodeWays">
          <xsl:variable name="wayID" select="@id"/>
          <xsl:variable name="nextWayID" select="$boundaryWays[@ref=$wayID]/@ref"/>
          <xsl:if test="$nextWayID != $currentWay/@id">
              <xsl:value-of select="$nextWayID"/>
          </xsl:if>
      </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>

