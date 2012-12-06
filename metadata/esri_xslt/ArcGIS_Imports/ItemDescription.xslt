<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:res="http://www.esri.com/metadata/res/" xmlns:esri="http://www.esri.com/metadata/" >

  <!-- An XSLT template for displaying metadata in ArcGIS that is stored in the ArcGIS metadata format.

     Copyright (c) 2009-2010, Environmental Systems Research Institute, Inc. All rights reserved.
	
     Revision History: Created 11/19/2009 avienneau
-->

  <xsl:template name="iteminfo" >

    <div class="itemDescription" id="overview">

      <h1 class="idHeading">
        <xsl:choose>
          <xsl:when test="/metadata/dataIdInfo[1]/idCitation/resTitle/text()">
            <xsl:value-of select="/metadata/dataIdInfo[1]/idCitation/resTitle[1]" />
          </xsl:when>
          <xsl:when test="/metadata/idinfo/citation/citeinfo/title[text() and not(contains(text(), 'REQUIRED'))]">
            <xsl:value-of select="/metadata/idinfo/citation/citeinfo/title" />
          </xsl:when>
          <xsl:when test="/metadata/Esri/DataProperties/itemProps/itemName/text()">
            <xsl:value-of select="/metadata/Esri/DataProperties/itemProps/itemName" />
          </xsl:when>
          <xsl:otherwise>
            <span class="noContent"><res:idNoTitle/></span>
          </xsl:otherwise>
        </xsl:choose>
      </h1>

      <xsl:if test="/metadata/distInfo/distFormat/formatName or /metadata/distInfo/distributor/distorFormat/formatName or /metadata/idinfo/natvform">
        <p class="center">
          <span class="idHeading">
            <xsl:choose>
              <xsl:when test="/metadata/distInfo/distFormat/formatName/text()">
                <xsl:value-of select="/metadata/distInfo/distFormat/formatName[text()][1]"/>
              </xsl:when>
              <xsl:when test="/metadata/distInfo/distributor/distorFormat/formatName/text()">
                <xsl:value-of select="/metadata/distInfo/distributor/distorFormat/formatName[text()][1]"/>
              </xsl:when>
              <xsl:when test="/metadata/idinfo/natvform/text()">
                <xsl:value-of select="/metadata/idinfo/natvform[text()]"/>
              </xsl:when>
            </xsl:choose>
          </span>
        </p>
      </xsl:if>

      <xsl:choose>
        <xsl:when test="/metadata/Binary/Thumbnail/img/@src">
          <img name="thumbnail" id="thumbnail" alt="Thumbnail" title="Thumbnail" class="summary">
            <xsl:attribute name="src">
              <xsl:value-of select="/metadata/Binary/Thumbnail/img/@src"/>
            </xsl:attribute>
            <xsl:attribute name="class">center</xsl:attribute>
          </img>
        </xsl:when>
        <xsl:when test="/metadata/idinfo/browse/img/@src">
          <img name="thumbnail" id="thumbnail" alt="Thumbnail" title="Thumbnail" class="summary">
            <xsl:attribute name="src">
              <xsl:value-of select="/metadata/idinfo/browse/img/@src"/>
            </xsl:attribute>
            <xsl:attribute name="class">center</xsl:attribute>
          </img>
        </xsl:when>
        <xsl:otherwise>
          <div class="noThumbnail"><res:idThumbnailNotAvail/></div>
        </xsl:otherwise>
      </xsl:choose>

      <p class="center">
        <span class="idHeading"><res:idTags /></span>
        <br/>
        <xsl:choose>
          <xsl:when test="/metadata/dataIdInfo[1]/searchKeys/keyword/text()">
            <xsl:for-each select="/metadata/dataIdInfo[1]/searchKeys/keyword[text()]">
              <xsl:value-of select="."/>
              <xsl:if test="not(position()=last())">, </xsl:if>
            </xsl:for-each>
          </xsl:when>
          <!--
          <xsl:when test="/metadata/dataIdInfo[1]/themeKeys/keyword/text() or /metadata/dataIdInfo/placeKeys/keyword/text()">
            <xsl:for-each select="/metadata/dataIdInfo[1]/themeKeys/keyword[text()] | /metadata/dataIdInfo/placeKeys/keyword[text()]">
              <xsl:value-of select="."/>
              <xsl:if test="not(position()=last())">, </xsl:if>
            </xsl:for-each>
          </xsl:when>
          -->
          <xsl:when test="/metadata/dataIdInfo[1]/descKeys[not(thesaName/@uuidref = '723f6998-058e-11dc-8314-0800200c9a66')]/keyword/text()">
            <xsl:for-each select="/metadata/dataIdInfo[1]/descKeys[not(./thesaName/@uuidref = '723f6998-058e-11dc-8314-0800200c9a66')]/keyword[text()]">
              <xsl:value-of select="."/>
              <xsl:if test="not(position()=last())">, </xsl:if>
            </xsl:for-each>
          </xsl:when>
          <xsl:when test="/metadata/idinfo/keywords/theme/themekey[text() and not(contains(text(), 'REQUIRED'))] or /metadata/idinfo/keywords/place/placekey[text()]">
            <xsl:for-each select="/metadata/idinfo/keywords/theme/themekey[text()] | /metadata/idinfo/keywords/place/placekey[text()]">
              <xsl:value-of select="."/>
              <xsl:if test="not(position()=last())">, </xsl:if>
            </xsl:for-each>
          </xsl:when>
          <xsl:otherwise>
            <span class="noContent"><res:idNoTagsForItem/></span>
          </xsl:otherwise>
        </xsl:choose>
      </p>

      <p>
        <span class="idHeading"><res:idSummary_ItemDescription /></span>
        <br/>
        <xsl:choose>
          <xsl:when test="/metadata/dataIdInfo[1]/idPurp/*">
            <xsl:copy-of select="/metadata/dataIdInfo[1]/idPurp/node()" />
          </xsl:when>
          <xsl:when test="/metadata/dataIdInfo[1]/idPurp[(contains(.,'&lt;/')) or (contains(.,'/&gt;'))]">
            <xsl:copy-of select="esri:decodenodeset(/metadata/dataIdInfo[1]/idPurp)" />
          </xsl:when>
          <xsl:when test="/metadata/dataIdInfo[1]/idPurp/text()">
            <xsl:value-of select="/metadata/dataIdInfo[1]/idPurp[text()]"/>
          </xsl:when>
          <xsl:when test="/metadata/idinfo/descript/purpose[text() and not(contains(text(), 'REQUIRED'))]">
            <xsl:value-of select="/metadata/idinfo/descript/purpose[text()]"/>
          </xsl:when>
          <xsl:otherwise>
            <span class="noContent"><res:idNoSummaryForItem/></span>
          </xsl:otherwise>
        </xsl:choose>
      </p>
      <br/>

      <p>
        <span class="idHeading"><res:idDesc_ItemDescription /></span>
        <br/>
        <xsl:choose>
          <xsl:when test="/metadata/dataIdInfo[1]/idAbs/*">
            <xsl:copy-of select="/metadata/dataIdInfo[1]/idAbs/node()" />
          </xsl:when>
          <xsl:when test="/metadata/dataIdInfo[1]/idAbs[(contains(.,'&lt;/')) or (contains(.,'/&gt;'))]">
            <xsl:copy-of select="esri:decodenodeset(/metadata/dataIdInfo[1]/idAbs)" />
          </xsl:when>
          <xsl:when test="/metadata/dataIdInfo[1]/idAbs/text()">
            <pre class="wrap">
              <xsl:call-template name="handleURLs">
                <xsl:with-param name="text" select="/metadata/dataIdInfo[1]/idAbs[text()]" />
              </xsl:call-template>
            </pre>
          </xsl:when>
          <xsl:when test="/metadata/idinfo/descript/abstract[text() and not(contains(text(), 'REQUIRED'))]">
            <pre class="wrap">
              <xsl:call-template name="handleURLs">
                <xsl:with-param name="text" select="/metadata/idinfo/descript/abstract[text()]" />
              </xsl:call-template>
            </pre>
          </xsl:when>
          <xsl:otherwise>
            <span class="noContent"><res:idNoDescForItem/></span>
          </xsl:otherwise>
        </xsl:choose>
      </p>

      <p>
        <span class="idHeading"><res:idCredits_ItemDescription /></span>
        <br/>
        <xsl:choose>
          <xsl:when test="/metadata/dataIdInfo[1]/idCredit/*">
            <xsl:copy-of select="/metadata/dataIdInfo[1]/idCredit/node()" />
          </xsl:when>
          <xsl:when test="/metadata/dataIdInfo[1]/idCredit[(contains(.,'&lt;/')) or (contains(.,'/&gt;'))]">
            <xsl:copy-of select="esri:decodenodeset(/metadata/dataIdInfo[1]/idCredit)" />
          </xsl:when>
          <xsl:when test="/metadata/dataIdInfo[1]/idCredit/text()">
            <xsl:value-of select="/metadata/dataIdInfo[1]/idCredit[text()]" />
          </xsl:when>
          <xsl:when test="/metadata/idinfo/accconst[text() and not(contains(text(), 'REQUIRED'))]">
            <xsl:value-of select="/metadata/idinfo/accconst[text()]"/>
          </xsl:when>
          <xsl:otherwise>
            <span class="noContent"><res:idNoCreditsForItem/></span>
          </xsl:otherwise>
        </xsl:choose>
      </p>

		<p>
			<span class="idHeading"><res:idUseLimits_ItemDescription /></span>
			<br/>
			<xsl:choose>
				<xsl:when test="/metadata/dataIdInfo[1]/resConst/Consts/useLimit/text()">
					<xsl:value-of select="/metadata/dataIdInfo[1]/resConst/Consts/useLimit[text()]" />
				</xsl:when>
				<xsl:when test="/metadata/idinfo/useconst[text() and not(contains(text(), 'REQUIRED'))]">
					<xsl:value-of select="/metadata/idinfo/useconst[text()]"/>
				</xsl:when>
				<xsl:otherwise>
					<span class="noContent"><res:idNoUseLimitsForItem /></span>
				</xsl:otherwise>
			</xsl:choose>
		</p>

    </div>

  </xsl:template>
</xsl:stylesheet>