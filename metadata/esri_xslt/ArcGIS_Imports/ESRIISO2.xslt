<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:res="http://www.esri.com/metadata/res/" xmlns:esri="http://www.esri.com/metadata/" xmlns:msxsl="urn:schemas-microsoft-com:xslt" >

<!-- An XSLT template for displaying metadata in ArcGIS that is stored in the ArcGIS metadata format.

     Copyright (c) 2009-2010, Environmental Systems Research Institute, Inc. All rights reserved.
	
     Revision History: Created 3/19/2009 avienneau
-->


<xsl:template name="arcgis" >

<div class="hide" id="arcgisMetadata">
<div class="box arcgis">

  <!-- BUILD THE TOC  -->

  <div><a name="TopArcGIS" id="TopArcGIS"/></div>

	<xsl:for-each select="/metadata/dataIdInfo">
		<xsl:call-template name="tocSectionArcGIS">
			<xsl:with-param name="count"><xsl:value-of select="count(../dataIdInfo)" /></xsl:with-param>
			<xsl:with-param name="sectionHeading"><xsl:value-of select="res:str('ResourceIdentification')"/></xsl:with-param>
		</xsl:call-template>
	</xsl:for-each>
	
	<xsl:for-each select="/metadata/svIdInfo">
		<xsl:call-template name="tocSectionArcGIS">
			<xsl:with-param name="count"><xsl:value-of select="count(../svIdInfo)" /></xsl:with-param>
			<xsl:with-param name="sectionHeading"><xsl:value-of select="res:str('ServiceIdentification')"/></xsl:with-param>
		</xsl:call-template>
	</xsl:for-each>
	
	<xsl:for-each select="/metadata/spatRepInfo">
		<xsl:call-template name="tocSectionArcGIS">
			<xsl:with-param name="count"><xsl:value-of select="count(../spatRepInfo)" /></xsl:with-param>
			<xsl:with-param name="sectionHeading"><xsl:value-of select="res:str('SpatialRepresentation')"/></xsl:with-param>
		</xsl:call-template>
	</xsl:for-each>
	
	<xsl:for-each select="/metadata/contInfo">
		<xsl:call-template name="tocSectionArcGIS">
			<xsl:with-param name="count"><xsl:value-of select="count(../contInfo)" /></xsl:with-param>
			<xsl:with-param name="sectionHeading"><xsl:value-of select="res:str('ContentInformation')"/></xsl:with-param>
		</xsl:call-template>
	</xsl:for-each>
	
	<xsl:for-each select="/metadata/refSysInfo">
		<xsl:call-template name="tocSectionArcGIS">
			<xsl:with-param name="count"><xsl:value-of select="count(../refSysInfo)" /></xsl:with-param>
			<xsl:with-param name="sectionHeading"><xsl:value-of select="res:str('ReferenceSystem')"/></xsl:with-param>
		</xsl:call-template>
	</xsl:for-each>
	
	<xsl:for-each select="/metadata/dqInfo">
		<xsl:call-template name="tocSectionArcGIS">
			<xsl:with-param name="count"><xsl:value-of select="count(../dqInfo)" /></xsl:with-param>
			<xsl:with-param name="sectionHeading"><xsl:value-of select="res:str('DataQuality')"/></xsl:with-param>
		</xsl:call-template>
	</xsl:for-each>
	
	<xsl:for-each select="/metadata/distInfo">
		<xsl:call-template name="tocSectionArcGIS">
			<xsl:with-param name="count"><xsl:value-of select="count(../distInfo)" /></xsl:with-param>
			<xsl:with-param name="sectionHeading"><xsl:value-of select="res:str('DistributionInformation')"/></xsl:with-param>
		</xsl:call-template>
	</xsl:for-each>
	
	<xsl:for-each select="/metadata/porCatInfo">
		<xsl:call-template name="tocSectionArcGIS">
			<xsl:with-param name="count"><xsl:value-of select="count(../porCatInfo)" /></xsl:with-param>
			<xsl:with-param name="sectionHeading"><xsl:value-of select="res:str('PortrayalCatalogue')"/></xsl:with-param>
		</xsl:call-template>
	</xsl:for-each>
	
	<xsl:for-each select="/metadata/appSchInfo">
		<xsl:call-template name="tocSectionArcGIS">
			<xsl:with-param name="count"><xsl:value-of select="count(../appSchInfo)" /></xsl:with-param>
			<xsl:with-param name="sectionHeading"><xsl:value-of select="res:str('ApplicationSchema')"/></xsl:with-param>
		</xsl:call-template>
	</xsl:for-each>
	
		<!-- Root node "metadata" will always exist. Only apply template if it contains elements that describe the metadata. -->
	<xsl:if test="metadata[mdFileID | mdLang | mdChar | mdParentID | mdHrLv | mdHrLvName | mdContact | mdDateSt | mdStanName | mdStanVer | mdMaint | mdConst | dataSetURI | dataSetFn]">
		<xsl:call-template name="tocSectionArcGIS">
			<xsl:with-param name="count"><xsl:value-of select="count(/metadata)" /></xsl:with-param>
			<xsl:with-param name="sectionHeading"><xsl:value-of select="res:str('MetadataDetails')"/></xsl:with-param>
		</xsl:call-template>
	</xsl:if>
	
	<xsl:for-each select="/metadata/mdExtInfo">
		<xsl:call-template name="tocSectionArcGIS">
			<xsl:with-param name="count"><xsl:value-of select="count(../mdExtInfo)" /></xsl:with-param>
			<xsl:with-param name="sectionHeading"><xsl:value-of select="res:str('MetadataExtensions')"/></xsl:with-param>
		</xsl:call-template>
	</xsl:for-each>
	
	<xsl:for-each select="/metadata/Esri">
		<xsl:call-template name="tocSectionArcGIS">
			<xsl:with-param name="count"><xsl:value-of select="count(../Esri)" /></xsl:with-param>
			<xsl:with-param name="sectionHeading"><xsl:value-of select="res:str('ESRIMetadataAndItemProperties')"/></xsl:with-param>
		</xsl:call-template>
	</xsl:for-each>
	
	<xsl:for-each select="/metadata/Esri/DataProperties[coordRef | itemProps/nativeExtBox]">
		<xsl:call-template name="tocSectionArcGIS">
			<xsl:with-param name="count"><xsl:value-of select="count(../DataProperties)" /></xsl:with-param>
			<xsl:with-param name="sectionHeading"><xsl:value-of select="res:str('ESRISpatial')"/></xsl:with-param>
		</xsl:call-template>
	</xsl:for-each>
	
	<xsl:for-each select="/metadata/Esri/DataProperties/RasterProperties">
		<xsl:call-template name="tocSectionArcGIS">
			<xsl:with-param name="count"><xsl:value-of select="count(../RasterProperties)" /></xsl:with-param>
			<xsl:with-param name="sectionHeading"><xsl:value-of select="res:str('ESRIRaster')"/></xsl:with-param>
		</xsl:call-template>
	</xsl:for-each>

	<xsl:for-each select="/metadata/Esri/DataProperties/topoinfo">
		<xsl:call-template name="tocSectionArcGIS">
			<xsl:with-param name="count"><xsl:value-of select="count(../topoinfo)" /></xsl:with-param>
			<xsl:with-param name="sectionHeading"><xsl:value-of select="res:str('ESRITopology')"/></xsl:with-param>
		</xsl:call-template>
	</xsl:for-each>
	
	<xsl:for-each select="/metadata/Esri/DataProperties/Terrain">
		<xsl:call-template name="tocSectionArcGIS">
			<xsl:with-param name="count"><xsl:value-of select="count(../Terrain)" /></xsl:with-param>
			<xsl:with-param name="sectionHeading"><xsl:value-of select="res:str('ESRITerrain')"/></xsl:with-param>
		</xsl:call-template>
	</xsl:for-each>
	
	<xsl:for-each select="/metadata/spdoinfo/netinfo">
		<xsl:call-template name="tocSectionArcGIS">
			<xsl:with-param name="count"><xsl:value-of select="count(../netinfo)" /></xsl:with-param>
			<xsl:with-param name="sectionHeading"><xsl:value-of select="res:str('ESRIGeometricNetwork')"/></xsl:with-param>
		</xsl:call-template>
	</xsl:for-each>
	
	<xsl:for-each select="/metadata/Esri/Locator">
		<xsl:call-template name="tocSectionArcGIS">
			<xsl:with-param name="count"><xsl:value-of select="count(../Locator)" /></xsl:with-param>
			<xsl:with-param name="sectionHeading"><xsl:value-of select="res:str('ESRILocator')"/></xsl:with-param>
		</xsl:call-template>
	</xsl:for-each>
	
	<xsl:if test="/metadata/spdoinfo/ptvctinf/esriterm">
		<xsl:variable name="eleID"><xsl:value-of select="generate-id(/metadata/spdoinfo/ptvctinf)" /></xsl:variable>
		<xsl:variable name="show"><xsl:value-of select="concat($eleID, 'Show')" /></xsl:variable>
		<xsl:variable name="hide"><xsl:value-of select="concat($eleID, 'Hide')" /></xsl:variable>
		<h2 class="iso">
			<a onclick="hideShow('{$eleID}')" href="#{$eleID}"><xsl:value-of select="res:str('ESRIFeatureClass')"/>&#160;
			<span id="{$show}" class="show">&#9660;</span><span id="{$hide}" class="hide">&#9658;</span></a>
		</h2>
		<div class="hide" id="{$eleID}">
			<xsl:apply-templates select="/metadata/spdoinfo/ptvctinf/esriterm" mode="arcgis"/>
			<div class="backToTop"><a onclick="hideShow('{$eleID}')" href="#{$eleID}"><xsl:value-of select="res:str('idHide')"/>&#160;&#9650;</a></div>
		</div>
	</xsl:if>
	
	<xsl:for-each select="/metadata/eainfo">
		<xsl:call-template name="tocSectionArcGIS">
			<xsl:with-param name="count"><xsl:value-of select="count(../eainfo)" /></xsl:with-param>
			<xsl:with-param name="sectionHeading"><xsl:value-of select="res:str('ESRIFieldsAndSubtypes')"/></xsl:with-param>
		</xsl:call-template>
	</xsl:for-each>
	
	<xsl:for-each select="/metadata/Binary">
		<xsl:call-template name="tocSectionArcGIS">
			<xsl:with-param name="count"><xsl:value-of select="count(../Binary)" /></xsl:with-param>
			<xsl:with-param name="sectionHeading"><xsl:value-of select="res:str('ESRIThumbnailsAndEnclosures')"/></xsl:with-param>
		</xsl:call-template>
	</xsl:for-each>
	
	<xsl:for-each select="/metadata/Esri/DataProperties/lineage">
		<xsl:call-template name="tocSectionArcGIS">
			<xsl:with-param name="count"><xsl:value-of select="count(../lineage)" /></xsl:with-param>
			<xsl:with-param name="sectionHeading"><xsl:value-of select="res:str('ESRIGeoprocessingHistory')"/></xsl:with-param>
		</xsl:call-template>
	</xsl:for-each>

	<xsl:for-each select="/metadata/Esri/locales">
		<xsl:call-template name="tocSectionArcGIS">
			<xsl:with-param name="count"><xsl:value-of select="count(../locales)" /></xsl:with-param>
			<xsl:with-param name="sectionHeading"><xsl:value-of select="res:str('ESRILocales')"/></xsl:with-param>
		</xsl:call-template>
	</xsl:for-each>

</div>
</div>
</xsl:template>


<!-- TEMPLATES FOR TABLE OF CONTENTS -->

<xsl:template name="tocSectionArcGIS">
	<xsl:param name="count" />
	<xsl:param name="sectionHeading" />
	<xsl:variable name="eleID"><xsl:value-of select="generate-id(.)" /></xsl:variable>
	<xsl:variable name="show"><xsl:value-of select="concat($eleID, 'Show')" /></xsl:variable>
	<xsl:variable name="hide"><xsl:value-of select="concat($eleID, 'Hide')" /></xsl:variable>
    <h2 class="iso">
		<a onclick="hideShow('{$eleID}')" href="#{$eleID}">
			<xsl:value-of select="$sectionHeading" />
			<xsl:if test="$count > 1">&#160;<xsl:value-of select="position()" /></xsl:if>&#160;
			<span id="{$show}" class="show">&#9660;</span><span id="{$hide}" class="hide">&#9658;</span>
		</a>
    </h2>
    <div class="hide" id="{$eleID}">
		<xsl:apply-templates select="." mode="arcgis"/>
		<div class="backToTop"><a onclick="hideShow('{$eleID}')" href="#{$eleID}"><res:idHide />&#160;&#9650;</a></div>
	</div>
</xsl:template>



<!-- TEMPLATES FOR METADATA UML CLASSES -->

<!-- Metadata Information (B.2.1 MD_Metadata - line1) -->
<!-- XML files created by ArcCatalog always have the root "metadata" rather than "Metadata" -->
<xsl:template match="metadata" mode="arcgis">
  <a name="Metadata_Information" id="Metadata_Information"></a>
  <dl>
  <dd>
    <xsl:for-each select="mdLang">
      <dt><xsl:if test="languageCode/@Sync = 'TRUE'">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:mdLang /></span>&#x2003;
        <xsl:apply-templates select="languageCode"  mode="arcgis"/>
      </dt>
    </xsl:for-each>
    <xsl:for-each select="mdChar">
      <dt><xsl:if test="CharSetCd/@Sync = 'TRUE'">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:mdChar /></span>&#x2003;
        <xsl:apply-templates select="CharSetCd" mode="arcgis"/>
      </dt>
    </xsl:for-each>
    <xsl:if test="(mdLang | mdChar)"><br /><br /></xsl:if>

	<xsl:for-each select="mdFileID">
      <dt><xsl:if test="@Sync = 'TRUE'">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:mdFileID /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="mdParentID">
      <dt><span class="isoElement"><res:mdParentID /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="dataSetURI">
      <dt><span class="isoElement"><res:dataSetURI /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="dataSetFn">
      <dt><span class="isoElement"><res:dataSetFn /></span>&#x2003;<xsl:for-each select="OnFunctCd">
          <xsl:call-template name="CI_OnLineFunctionCode">
				<xsl:with-param name="code" select="@value" />
			</xsl:call-template>
        </xsl:for-each>
       </dt>
    </xsl:for-each>
    <xsl:if test="(mdFileID | mdParentID | dataSetURI | dataSetFn)"><br /><br /></xsl:if>
    
    <xsl:for-each select="mdHrLv">
      <dt><xsl:if test="ScopeCd/@Sync = 'TRUE'">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:mdHrLv /></span>&#x2003;
        <xsl:apply-templates select="ScopeCd"  mode="arcgis"/>
      </dt>
    </xsl:for-each>
    <xsl:for-each select="mdHrLvName">
      <dt><xsl:if test="@Sync = 'TRUE'">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:mdHrLvName /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:if test="(mdHrLv | HrLvName)"><br /><br /></xsl:if>
 
    <xsl:apply-templates select="mdContact" mode="arcgis"/>
    
    <xsl:for-each select="mdDateSt">
      <dt><xsl:if test="@Sync = 'TRUE'">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:mdDateSt/></span>&#x2003;<xsl:call-template name="dateType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></dt>
    </xsl:for-each>
    <xsl:apply-templates select="mdMaint" mode="arcgis"/>
    <xsl:if test="(mdDateSt) and not (mdMaint)"><br /><br /></xsl:if>

    <xsl:for-each select="mdConst">
      <dt><span class="isoElement"><res:mdConst /></span></dt>
      <dl>
        <xsl:apply-templates select="Consts" mode="arcgis"/>
        <xsl:apply-templates select="LegConsts" mode="arcgis"/>
        <xsl:apply-templates select="SecConsts" mode="arcgis"/>
      </dl>
    </xsl:for-each>

    <xsl:for-each select="mdStanName">
      <dt><xsl:if test="@Sync = 'TRUE'">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:mdStanName /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="mdStanVer">
      <dt><xsl:if test="@Sync = 'TRUE'">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:mdStanVer /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:if test="(mdStanName | mdStanVer)"><br /><br /></xsl:if>

    <xsl:apply-templates select="loc" mode="arcgis" />
  </dd>
  </dl>
</xsl:template>

<!-- PT_Locale (from 19139, and added to 19115) -->
<xsl:template match="loc" mode="arcgis">
  <dd>
  <dt><span class="isoElement"><res:loc /></span></dt>
  <dd>
  <dl>
    <xsl:for-each select="locLang/languageCode">
	  <dt><xsl:if test="@Sync = 'TRUE'">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:locLang /></span>&#x2003;<xsl:call-template name="ISO639_LanguageCode">
				<xsl:with-param name="code" select="@value" />
			</xsl:call-template>
		</dt>
	</xsl:for-each>
    <xsl:for-each select="locCountry/countryCode">
	  <dt><xsl:if test="@Sync = 'TRUE'">
			<span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:locCountry /></span>&#x2003;<xsl:call-template name="ISO3166_CountryCode">
				<xsl:with-param name="code" select="@value" />
			</xsl:call-template>
		</dt>
	</xsl:for-each>
    <xsl:for-each select="locEncoding">
      <dt><xsl:if test="CharSetCd/@Sync = 'TRUE'">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:locEncoding /></span>&#x2003;
        <xsl:apply-templates select="CharSetCd" mode="arcgis"/>
      </dt>
    </xsl:for-each>
  </dl>
  </dd>
  </dd>
  <br />
</xsl:template>

<!-- language code list from ISO 639 -->
<xsl:template match="languageCode" mode="arcgis">
    <xsl:call-template name="ISO639_LanguageCode">
		<xsl:with-param name="code" select="@value" />
	</xsl:call-template>
	<xsl:if test="@country">&#160;(<xsl:call-template name="ISO3166_CountryCode">
			<xsl:with-param name="code" select="@country" />
		</xsl:call-template>)
	</xsl:if>
</xsl:template>

<!-- Character set code list (B.5.10 MD_CharacterSetCode) -->
<xsl:template match="CharSetCd" mode="arcgis">
    <xsl:call-template name="MD_CharSetCd">
		<xsl:with-param name="code" select="@value" />
	</xsl:call-template>
</xsl:template>

<!-- Scope code list (B.2.25 MD_ScopeCode) -->
<xsl:template match="ScopeCd" mode="arcgis">
	<xsl:call-template name="MD_ScopeCode">
		<xsl:with-param name="code" select="@value" />
	</xsl:call-template>
</xsl:template>

<!-- Maintenance Information (B.2.5 MD_MaintenanceInformation - line142) -->
<xsl:template match="mdMaint | resMaint" mode="arcgis">
    <dd>
    <xsl:choose>
      <xsl:when test="(local-name(.) = 'resMaint')">
        <dt><span class="isoElement"><res:resMaint /></span></dt>
      </xsl:when>
      <xsl:otherwise>
        <dt><span class="isoElement"><res:resOtherwise /></span></dt>
      </xsl:otherwise>
    </xsl:choose>

    <dd>
    <dl>
      <xsl:for-each select="dateNext">
        <dt><span class="isoElement"><res:dateNext /></span>&#x2003;<xsl:call-template name="dateType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></dt>
      </xsl:for-each>
      <xsl:for-each select="maintFreq">
        <dt><span class="isoElement"><res:maintFreq /></span>&#x2003;
        <xsl:for-each select="MaintFreqCd">
			<xsl:call-template name="MD_MaintenanceFrequencyCode">
				<xsl:with-param name="code" select="@value" />
			</xsl:call-template>
        </xsl:for-each>
        </dt>
      </xsl:for-each>
      <xsl:apply-templates select="usrDefFreq" mode="arcgis"/>
      <xsl:if test="(dateNext | maintFreq) and not (usrDefFreq)"><br /><br /></xsl:if>

      <xsl:for-each select="maintScp">
        <dt><span class="isoElement"><res:maintScp /></span>&#x2003;
            <xsl:apply-templates select="ScopeCd"  mode="arcgis"/>
        </dt>
      </xsl:for-each>
      <xsl:apply-templates select="upScpDesc" mode="arcgis"/>
      <xsl:if test="(maintScp) and not (upScpDesc)"><br /><br /></xsl:if>

      <xsl:for-each select="maintNote">
        <dt><span class="isoElement"><res:maintNote /></span>&#x2003;<xsl:value-of select="."/></dt>
        <br /><br />
      </xsl:for-each>
    </dl>
    </dd>
    </dd>
</xsl:template>

<!-- Time Period Information (from 19103 information in 19115 DTD) -->
<xsl:template match="usrDefFreq" mode="arcgis">
  <dd>
  <dt><span class="isoElement"><res:usrDefFreq /></span></dt>
  <dd>
  <dl>
    <xsl:for-each select="duration">
      <dt><span class="isoElement"><res:duration /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="designator">
      <dt><span class="element"><res:designator /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="years">
      <dt><span class="element"><res:years /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="months">
      <dt><span class="element"><res:months /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="days">
      <dt><span class="element"><res:days /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="timeIndicator">
      <dt><span class="element"><res:timeIndicator /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="hours">
      <dt><span class="element"><res:hours /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="minutes">
      <dt><span class="element"><res:minutes /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="seconds">
      <dt><span class="element"><res:seconds /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
  </dl>
  </dd>
  </dd>
  <br />
</xsl:template>

<!-- Scope Description Information (B.2.5.1 MD_ScopeDescription - line149) -->
<xsl:template match="scpLvlDesc | upScpDesc" mode="arcgis">
<dd>
  <xsl:if test="position() = 1">
    <dt><span class="isoElement"><res:scpLvlDesc /></span></dt>
  </xsl:if>
  <dd>
	  <dl>
		  <xsl:for-each select="attribSet">
			<dd><span class="isoElement"><res:attribSet /></span>&#x2003;<xsl:value-of select="."/></dd>
		  </xsl:for-each>
		  <xsl:for-each select="featSet">
			<dd><span class="isoElement"><res:featSet /></span>&#x2003;<xsl:value-of select="."/></dd>
		  </xsl:for-each>
		  <xsl:for-each select="featIntSet">
			<dd><span class="isoElement"><res:featIntSet /></span>&#x2003;<xsl:value-of select="."/></dd>
		  </xsl:for-each>
		  <xsl:for-each select="attribIntSet">
			<dd><span class="isoElement"><res:attribIntSet /></span>&#x2003;<xsl:value-of select="."/></dd>
		  </xsl:for-each>
		  <xsl:for-each select="datasetSet">
			<dd><span class="isoElement"><res:dataSet /></span>&#x2003;<xsl:value-of select="."/></dd>
		  </xsl:for-each>
		  <xsl:for-each select="other">
			<dd><span class="isoElement"><res:other /></span>&#x2003;<xsl:value-of select="."/></dd>
		  </xsl:for-each>
	  </dl>
  </dd>
</dd>
</xsl:template>

<!-- General Constraint Information (B.2.3 MD_Constraints - line67) -->
<xsl:template match="Consts" mode="arcgis">
  <dd>
    <dt><span class="isoElement"><res:Consts /></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="useLimit">
        <dt><span class="isoElement"><res:useLimit /></span>&#x2003;</dt>
		  <dl><dd><pre class="wrap">
			  <xsl:call-template name="handleURLs">
				  <xsl:with-param name="text" select="."/>
			  </xsl:call-template>
		  </pre></dd></dl>
      </xsl:for-each>
    </dl>
    </dd>
  </dd>
</xsl:template>

<!-- Legal Constraint Information (B.2.3 MD_LegalConstraints - line69) -->
<xsl:template match="LegConsts" mode="arcgis">
  <dd>
    <dt><span class="isoElement"><res:LegConsts /></span></dt>
    <dd>
    <dl>
      <xsl:if test="accessConsts">
        <dt><span class="isoElement"><res:accessConsts /></span>&#x2003;
        <xsl:for-each select="accessConsts">
              <xsl:apply-templates select="RestrictCd"  mode="arcgis"/> 
          <xsl:if test="not(position() = last())">, </xsl:if>
        </xsl:for-each>
        </dt>
        <br /><br />
      </xsl:if>

      <xsl:if test="useConsts">
        <dt><span class="isoElement"><res:useConsts /></span>&#x2003;
        <xsl:for-each select="useConsts">
            <xsl:apply-templates select="RestrictCd"  mode="arcgis"/> 
          <xsl:if test="not(position() = last())">, </xsl:if>
        </xsl:for-each>
        </dt>
        <br /><br />
      </xsl:if>

      <xsl:for-each select="othConsts">
        <dt><span class="isoElement"><res:othConsts /></span></dt>
		  <dl><dd><pre class="wrap">
			  <xsl:call-template name="handleURLs">
				  <xsl:with-param name="text" select="."/>
			  </xsl:call-template>
		  </pre></dd></dl>
      </xsl:for-each>

      <xsl:for-each select="useLimit">
        <dt><span class="isoElement"><res:useLimit /></span>&#x2003;</dt>
		  <dl><dd><pre class="wrap">
			  <xsl:call-template name="handleURLs">
				  <xsl:with-param name="text" select="."/>
			  </xsl:call-template>
		  </pre></dd></dl>
      </xsl:for-each>
    </dl>
    </dd>
  </dd>
</xsl:template>

<!-- Restrictions code list (B.5.24 MD_RestrictionCode) -->
<xsl:template match="RestrictCd" mode="arcgis">
	<xsl:call-template name="MD_RestrictionCode">
		<xsl:with-param name="code" select="@value" />
	</xsl:call-template>
</xsl:template>

<!-- Security Constraint Information (B.2.3 MD_SecurityConstraints - line73) -->
<xsl:template match="SecConsts" mode="arcgis">
  <dd>
    <dt><span class="isoElement"><res:SecConsts /></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="class">
        <dt><span class="isoElement"><res:classification /></span>&#x2003;
        <xsl:for-each select="ClasscationCd">
		    <xsl:call-template name="MD_ClassificationCode">
				<xsl:with-param name="code" select="@value" />
			</xsl:call-template>
        </xsl:for-each>
        </dt>
      </xsl:for-each>
      <xsl:for-each select="classSys">
        <dt><span class="isoElement"><res:classSys /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:if test="(class | classSys)"><br /><br /></xsl:if>

      <xsl:for-each select="userNote">
        <dt><span class="isoElement"><res:userNote /></span>&#x2003;<xsl:value-of select="."/></dt>
        <br /><br />
      </xsl:for-each>

      <xsl:for-each select="handDesc">
        <dt><span class="isoElement"><res:handDesc /></span>&#x2003;<xsl:value-of select="."/></dt>
        <br /><br />
      </xsl:for-each>

      <xsl:for-each select="useLimit">
        <dt><span class="isoElement"><res:useLimit /></span>&#x2003;<xsl:value-of select="."/></dt>
		  <dl><dd><pre class="wrap">
			  <xsl:call-template name="handleURLs">
				  <xsl:with-param name="text" select="."/>
			  </xsl:call-template>
		  </pre></dd></dl>
      </xsl:for-each>
    </dl>
    </dd>
  </dd>
</xsl:template>

<!-- RESOURCE IDENTIFICATION -->

<!-- Resource Identification Information (B.2.2 MD_Identification - line23, including MD_DataIdentification - line36) -->
<!-- DTD doesn't account for data and service subclasses of MD_Identification -->
<xsl:template match="metadata/dataIdInfo | svOperOn" mode="arcgis">
	<xsl:choose>
		<xsl:when test="(local-name(.) = 'dataIdInfo')">
		  <a>
			<xsl:attribute name="name"><xsl:value-of select = "generate-id(.)" /></xsl:attribute>
			<xsl:attribute name="id"><xsl:value-of select = "generate-id(.)" /></xsl:attribute>
		  </a>
		</xsl:when>
		<xsl:when test="(local-name(.) = 'svOperOn')">
			<dt><span class="isoElement"><res:svOperOn /></span></dt>
		</xsl:when>
	</xsl:choose>
  <dl>

  <dl>
  <dd>
    <xsl:apply-templates select="idCitation" mode="arcgis"/>

    <xsl:if test="tpCat">
      <dt><span class="isoElement"><res:tpCat /></span>&#x2003;
      <xsl:for-each select="tpCat">
        <xsl:for-each select="TopicCatCd">
			<xsl:call-template name="MD_TopicCategoryCode">
				<xsl:with-param name="code" select="@value" />
			</xsl:call-template>
        </xsl:for-each>
        <xsl:if test="not(position() = last())">, </xsl:if>
      </xsl:for-each>
      </dt>
      <xsl:if test="position() = last()"><br /><br /></xsl:if>
    </xsl:if>

    <xsl:if test="searchKeys/keyword/text()">
      <dt><span class="esriElement"><res:tagsForSearching /></span>&#x2003;
      <xsl:for-each select="searchKeys/keyword[text()]">
        <xsl:value-of select="." /><xsl:if test="not(position() = last())">, </xsl:if>
      </xsl:for-each>
      </dt><br /><br />
    </xsl:if>

    <xsl:apply-templates select="discKeys" mode="arcgis"/>
    <xsl:apply-templates select="stratKeys" mode="arcgis"/>
    <xsl:apply-templates select="placeKeys" mode="arcgis"/>
    <xsl:apply-templates select="tempKeys" mode="arcgis"/>
    <xsl:apply-templates select="themeKeys" mode="arcgis"/>
    <xsl:apply-templates select="otherKeys[not(./thesaName/@uuidref = '723f6998-058e-11dc-8314-0800200c9a66')]" mode="arcgis"/>
    
    <xsl:for-each select="idAbs">
      <dt><span class="isoElement"><res:idAbs /></span></dt>
      <xsl:choose>
		<xsl:when test="./*">
		  <xsl:variable name="htmlText">       
			  <xsl:for-each select=".//text()">
				  <xsl:value-of select="."></xsl:value-of>
				  <xsl:text> </xsl:text>
			  </xsl:for-each>
		  </xsl:variable>
		  <dl><dd><pre class="wrap">
			  <xsl:call-template name="handleURLs">
				  <xsl:with-param name="text" select="normalize-space($htmlText)" />
			  </xsl:call-template>
		  </pre></dd></dl>
		</xsl:when>
		<xsl:when test="(contains(.,'&lt;/')) or (contains(.,'/&gt;'))">
		  <xsl:variable name="escapedHtmlText">
		    <xsl:value-of select="esri:striphtml(.)" />
		  </xsl:variable>
		  <dl><dd><pre class="wrap">
			  <xsl:call-template name="handleURLs">
				  <xsl:with-param name="text" select="normalize-space($escapedHtmlText)" />
			  </xsl:call-template>
		  </pre></dd></dl>
		</xsl:when>
		<xsl:otherwise>
		  <dl><dd><pre class="wrap">
			  <xsl:call-template name="handleURLs">
				  <xsl:with-param name="text" select="." />
			  </xsl:call-template>
		  </pre></dd></dl>
		</xsl:otherwise>
	  </xsl:choose>
    </xsl:for-each>
	
    <xsl:for-each select="idPurp">
      <dt><span class="isoElement"><res:idPurp /></span></dt>
      <xsl:choose>
		<xsl:when test="./*">
		  <xsl:variable name="htmlText">
			  <xsl:for-each select=".//text()">
				  <xsl:value-of select="."></xsl:value-of>
				  <xsl:text> </xsl:text>
			  </xsl:for-each>
		  </xsl:variable>
		  <dl><dd><pre class="wrap">
			  <xsl:call-template name="handleURLs">
				  <xsl:with-param name="text" select="normalize-space($htmlText)" />
			  </xsl:call-template>
		  </pre></dd></dl>
		</xsl:when>
		<xsl:when test="(contains(.,'&lt;/')) or (contains(.,'/&gt;'))">
		  <xsl:variable name="escapedHtmlText">
		    <xsl:value-of select="esri:striphtml(.)" />
		  </xsl:variable>
		  <dl><dd><pre class="wrap">
			  <xsl:call-template name="handleURLs">
				  <xsl:with-param name="text" select="normalize-space($escapedHtmlText)" />
			  </xsl:call-template>
		  </pre></dd></dl>
		</xsl:when>
		<xsl:otherwise>
		  <dl><dd><pre class="wrap">
			  <xsl:call-template name="handleURLs">
				  <xsl:with-param name="text" select="." />
			  </xsl:call-template>
		  </pre></dd></dl>
		</xsl:otherwise>
	  </xsl:choose>
    </xsl:for-each>

    <xsl:apply-templates select="graphOver" mode="arcgis"/>
    
    <xsl:if test="dataLang">
		<dt><span class="isoElement"><res:dataLang /></span>&#x2003;<xsl:for-each select="dataLang">
				<xsl:if test="languageCode[@Sync = 'TRUE']"><span class="sync">*</span>&#x2009;</xsl:if>
				<xsl:apply-templates select="languageCode"  mode="arcgis"/>
				<xsl:if test="not(position() = last())">, </xsl:if>
			</xsl:for-each>
		</dt>
    </xsl:if>
    <xsl:for-each select="dataChar">
      <dt><span class="isoElement"><res:dataChar /></span>&#x2003;
        <xsl:apply-templates select="CharSetCd"  mode="arcgis"/>
      </dt>
    </xsl:for-each>
    <xsl:if test="(dataLang | dataChar)"><br /><br /></xsl:if>

	<!-- old service info - don't know if this was ever used -->
    <xsl:for-each select="serType">
      <dt><span class="element"><res:serType /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="typeProps">
      <dt><span class="element"><res:typeProps /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:if test="(serType | typeProps)"><br /><br /></xsl:if>

    <xsl:for-each select="idStatus">
      <dt><span class="isoElement"><res:idStatus /></span>&#x2003;
        <xsl:for-each select="ProgCd">
			<xsl:call-template name="MD_ProgressCode">
				<xsl:with-param name="code" select="@value" />
			</xsl:call-template>
        </xsl:for-each> 
        </dt>
    </xsl:for-each>
    <xsl:apply-templates select="resMaint" mode="arcgis"/>
    <xsl:if test="(idStatus) and not (resMaint)"><br /><br /></xsl:if>

    <xsl:for-each select="resConst">
      <dt><span class="isoElement"><res:resConst /></span></dt>
      <dl>
        <xsl:apply-templates select="Consts" mode="arcgis"/>
        <xsl:apply-templates select="LegConsts" mode="arcgis"/>
        <xsl:apply-templates select="SecConsts" mode="arcgis"/>
      </dl>
    </xsl:for-each>

    <xsl:apply-templates select="idSpecUse" mode="arcgis"/>

    <xsl:for-each select="spatRpType">
      <dt><xsl:if test="SpatRepTypCd[@Sync = 'TRUE']">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:spatRpType /></span>&#x2003;
        <xsl:for-each select="SpatRepTypCd">
			<xsl:call-template name="MD_SpatialRepresentationTypeCode">
				<xsl:with-param name="code" select="@value" />
			</xsl:call-template>
        </xsl:for-each>
        </dt>
    </xsl:for-each>
    <xsl:apply-templates select="dsFormat" mode="arcgis"/>
    <xsl:if test="(spatRpType) and not (dsFormat)"><br /><br /></xsl:if>

    <xsl:for-each select="envirDesc">
      <dt><xsl:if test="@Sync = 'TRUE'">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:envirDesc /></span>&#x2003;<xsl:value-of select="."/></dt>
      <br /><br />
    </xsl:for-each>
    
    <xsl:apply-templates select="dataScale" mode="arcgis"/>
    
   <xsl:apply-templates select="geoBox" mode="arcgis"/>

    <xsl:apply-templates select="geoDesc" mode="arcgis"/>

    <xsl:apply-templates select="dataExt" mode="arcgis"/>
    
    <xsl:for-each select="suppInfo">
      <dt><span class="isoElement"><res:suppInfo /></span></dt>
      <dl><dd><pre class="wrap">
		  <xsl:call-template name="handleURLs">
			  <xsl:with-param name="text" select="."/>
		  </xsl:call-template>
      </pre></dd></dl>
    </xsl:for-each>

    <xsl:for-each select="idCredit">
      <dt><span class="isoElement"><res:idCredit /></span></dt>
      <xsl:choose>
        <xsl:when test="./*">
          <xsl:variable name="htmlText">
            <xsl:for-each select=".//text()">
              <xsl:value-of select="."></xsl:value-of>
              <xsl:text> </xsl:text>
            </xsl:for-each>
          </xsl:variable>
          <dl><dd><pre class="wrap">
            <xsl:call-template name="handleURLs">
              <xsl:with-param name="text" select="normalize-space($htmlText)" />
            </xsl:call-template>
          </pre></dd></dl>
        </xsl:when>
        <xsl:when test="(contains(.,'&lt;/')) or (contains(.,'/&gt;'))">
          <xsl:variable name="escapedHtmlText">
            <xsl:value-of select="esri:striphtml(., '')" />
          </xsl:variable>
          <dl><dd><pre class="wrap">
            <xsl:call-template name="handleURLs">
              <xsl:with-param name="text" select="normalize-space($escapedHtmlText)" />
            </xsl:call-template>
          </pre></dd></dl>
        </xsl:when>
        <xsl:otherwise>
          <dl><dd><pre class="wrap">
            <xsl:call-template name="handleURLs">
              <xsl:with-param name="text" select="." />
            </xsl:call-template>
          </pre></dd></dl>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>

    <xsl:apply-templates select="idPoC" mode="arcgis"/>
    
    <xsl:apply-templates select="aggrInfo" mode="arcgis"/>
  </dd>
  </dl>
  </dl>
</xsl:template>

<!-- SERVICE IDENTIFICATION from ISO 19119 -->

<!-- Service Identification Information (B.2.2 MD_Identification - line23, including MD_DataIdentification - line36) -->
<xsl:template match="metadata/svIdInfo" mode="arcgis">
  <a>
    <xsl:attribute name="name"><xsl:value-of select = "generate-id(.)" /></xsl:attribute>
    <xsl:attribute name="id"><xsl:value-of select = "generate-id(.)" /></xsl:attribute>
  </a>
  <dl>

  <dl>
  <dd>
    <xsl:apply-templates select="idCitation" mode="arcgis"/>

    <xsl:if test="searchKeys/keyword/text()">
      <dt><span class="esriElement"><res:tagsForSearching /></span>&#x2003;
      <xsl:for-each select="searchKeys/keyword[text()]">
        <xsl:value-of select="." /><xsl:if test="not(position() = last())">, </xsl:if>
      </xsl:for-each>
      </dt><br /><br />
    </xsl:if>

    <xsl:apply-templates select="discKeys" mode="arcgis"/>
    <xsl:apply-templates select="stratKeys" mode="arcgis"/>
    <xsl:apply-templates select="placeKeys" mode="arcgis"/>
    <xsl:apply-templates select="tempKeys" mode="arcgis"/>
    <xsl:apply-templates select="themeKeys" mode="arcgis"/>
    <xsl:apply-templates select="otherKeys[not(./thesaName/@uuidref = '723f6998-058e-11dc-8314-0800200c9a66')]" mode="arcgis"/>
    
    <xsl:for-each select="idAbs">
      <dt><span class="isoElement"><res:idAbs /></span></dt>
      <xsl:choose>
		<xsl:when test="./DIV">
		  <xsl:variable name="htmlText">
			  <xsl:for-each select=".//SPAN[text()]">
				  <xsl:value-of select="."></xsl:value-of>
				  <xsl:text> </xsl:text>
			  </xsl:for-each>
		  </xsl:variable>
		  <dl><dd><pre class="wrap">
			  <xsl:call-template name="handleURLs">
				  <xsl:with-param name="text" select="normalize-space($htmlText)" />
			  </xsl:call-template>
		  </pre></dd></dl>
		</xsl:when>
		<xsl:when test="(substring(.,2,3) = 'DIV')">
		  <xsl:variable name="escapedHtmlText">
			  <xsl:call-template name="fixHTML">
					<xsl:with-param name="text" select="." />
				</xsl:call-template>
		  </xsl:variable>
		  <dl><dd><pre class="wrap">
			  <xsl:call-template name="handleURLs">
				  <xsl:with-param name="text" select="normalize-space($escapedHtmlText)" />
			  </xsl:call-template>
		  </pre></dd></dl>
		</xsl:when>
		<xsl:otherwise>
		  <dl><dd><pre class="wrap">
			  <xsl:call-template name="handleURLs">
				  <xsl:with-param name="text" select="." />
			  </xsl:call-template>
		  </pre></dd></dl>
		</xsl:otherwise>
	  </xsl:choose>
    </xsl:for-each>
	
    <xsl:for-each select="idPurp">
      <dt><span class="isoElement"><res:idPurp /></span></dt>
      <dl><dd><pre class="wrap">
		  <xsl:call-template name="handleURLs">
			  <xsl:with-param name="text" select="."/>
		  </xsl:call-template>
      </pre></dd></dl>

    </xsl:for-each>

    <xsl:apply-templates select="graphOver" mode="arcgis"/>
    
    <xsl:for-each select="svType">
      <dt><span class="isoElement"><res:svType /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="svType/@codeSpace">
      <dt><span class="isoElement"><res:svType_codespace /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="svTypeVer">
      <dt><span class="isoElement"><res:svTypeVer /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:if test="(svType | svTypeVer)"><br /><br /></xsl:if>

    <xsl:for-each select="idStatus">
      <dt><span class="isoElement"><res:idStatus /></span>&#x2003;
        <xsl:for-each select="ProgCd">
			<xsl:call-template name="MD_ProgressCode">
				<xsl:with-param name="code" select="@value" />
			</xsl:call-template>
        </xsl:for-each> 
        </dt>
    </xsl:for-each>
    <xsl:apply-templates select="resMaint" mode="arcgis"/>
    <xsl:if test="(idStatus) and not (resMaint)"><br /><br /></xsl:if>

    <xsl:for-each select="resConst">
      <dt><span class="isoElement"><res:resConst /></span></dt>
      <dl>
        <xsl:apply-templates select="Consts" mode="arcgis"/>
        <xsl:apply-templates select="LegConsts" mode="arcgis"/>
        <xsl:apply-templates select="SecConsts" mode="arcgis"/>
      </dl>
    </xsl:for-each>

    <xsl:apply-templates select="idSpecUse" mode="arcgis"/>

    <xsl:apply-templates select="dsFormat" mode="arcgis"/>

    <xsl:apply-templates select="svExt" mode="arcgis"/>
    
    <xsl:for-each select="idCredit">
      <dt><span class="isoElement"><res:idCredit /></span></dt>
      <dl><dd><pre class="wrap">
		  <xsl:call-template name="handleURLs">
			  <xsl:with-param name="text" select="."/>
		  </xsl:call-template>
      </pre></dd></dl>
    </xsl:for-each>

    <xsl:apply-templates select="idPoC" mode="arcgis"/>
    
    <xsl:apply-templates select="aggrInfo" mode="arcgis"/>

    <xsl:apply-templates select="svAccProps" mode="arcgis"/>

    <xsl:for-each select="svCouplRes">
      <dd>
		<dt><span class="isoElement"><res:svCouplRes /></span></dt>
		<dl><dd>
			<xsl:for-each select="svOpName">
			  <dt><span class="isoElement"><res:svOpName /></span>&#x2003;<xsl:value-of select="."/></dt>
			</xsl:for-each>
			<xsl:apply-templates select="svResCitId" mode="arcgis"/>
		</dd></dl>
      </dd>
	</xsl:for-each>
	<xsl:for-each select="svCouplType">
      <dt><span class="isoElement"><res:svCouplType /></span>&#x2003;
        <xsl:for-each select="CouplTypCd">
			<xsl:call-template name="SV_CouplTypCd">
				<xsl:with-param name="code" select="@value" />
			</xsl:call-template>
        </xsl:for-each> 
        </dt>
	</xsl:for-each>
    <xsl:if test="(svCouplRes | svCouplType)"><br /><br /></xsl:if>

    <xsl:apply-templates select="svOper" mode="arcgis"/>
    <xsl:apply-templates select="svOperOn" mode="arcgis"/>
    
  </dd>
  </dl>
  </dl>
</xsl:template>

<!-- Service Operation Metadata -->
<xsl:template match="svOper" mode="arcgis">
	<dd>
	<dt><span class="isoElement"><res:svOper /></span></dt>
	<dd>
    <dl>
		<xsl:for-each select="svOpName">
		  <dt><span class="isoElement"><res:svOpName_0 /></span>&#x2003;<xsl:value-of select="."/></dt>
		</xsl:for-each>
		<xsl:for-each select="svDesc">
		  <dt><span class="isoElement"><res:svDesc /></span>&#x2003;<xsl:value-of select="."/></dt>
		</xsl:for-each>
		<xsl:for-each select="svInvocName">
		  <dt><span class="isoElement"><res:svInvocName /></span>&#x2003;<xsl:value-of select="."/></dt>
		</xsl:for-each>
		<xsl:for-each select="svDCP">
		  <dt><span class="isoElement"><res:svDCP /></span>&#x2003;
			<xsl:for-each select="DCPListCd">
				<xsl:call-template name="SV_DCPList">
					<xsl:with-param name="code" select="@value" />
				</xsl:call-template>
			</xsl:for-each> 
			</dt>
		</xsl:for-each>

		<xsl:apply-templates select="svConPt" mode="arcgis"/>
		<xsl:apply-templates select="svParams" mode="arcgis"/>
		<xsl:apply-templates select="svOper" mode="arcgis"/>
    </dl>
    </dd>
  </dd>
</xsl:template>

<!-- Service Operation Parameters -->
<xsl:template match="svParams" mode="arcgis">
	<dd>
	<dt><span class="isoElement"><res:svParams /></span></dt>
	<dd>
    <dl>
		<xsl:if test="svParName">
			<dt><span class="isoElement"><res:svParName /></span>&#x2003;</dt>
			<xsl:apply-templates select="svParName"  mode="arcgis"/>
		</xsl:if>
		<xsl:for-each select="svDesc">
		  <dt><span class="isoElement"><res:svDesc /></span>&#x2003;<xsl:value-of select="."/></dt>
		</xsl:for-each>
		<xsl:for-each select="svParDir">
		  <dt><span class="isoElement"><res:svParDir /></span>&#x2003;
			<xsl:for-each select="ParamDirCd">
				<xsl:call-template name="SV_ParamDirCd">
					<xsl:with-param name="code" select="@value" />
				</xsl:call-template>
			</xsl:for-each> 
			</dt>
		</xsl:for-each>
		<xsl:for-each select="svParOpt">
		  <dt><span class="isoElement"><res:svParOpt /></span>&#x2003;<xsl:value-of select="."/></dt>
		</xsl:for-each>
		<xsl:for-each select="svRepeat">
		  <dt><span class="isoElement"><res:svRepeat /></span>&#x2003;<xsl:call-template name="booleanType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></dt>
		</xsl:for-each>
		<xsl:if test="svValType">
			<dt><span class="isoElement"><res:svValType /></span>&#x2003;</dt>
			<xsl:apply-templates select="svValType"  mode="arcgis"/>
		</xsl:if>
    </dl>
    </dd>
  </dd>
</xsl:template>

<!-- Keyword Information (B.2.2.2 MD_Keywords - line52)-->
<xsl:template match="discKeys | placeKeys | stratKeys | tempKeys | themeKeys | otherKeys[not(./thesaName/@uuidref='723f6998-058e-11dc-8314-0800200c9a66')]" mode="arcgis">
	<dd>
	<dt>
		<xsl:choose>
		 <xsl:when test="(local-name(.) = 'discKeys')">
			<span class="isoElement"><res:discKeys /></span>
		 </xsl:when>
		 <xsl:when test="(local-name(.) = 'placeKeys')">
			<span class="isoElement"><res:placeKeys /></span>
		 </xsl:when>
		 <xsl:when test="(local-name(.) = 'stratKeys')">
			<span class="isoElement"><res:stratKeys /></span>
		 </xsl:when>
		 <xsl:when test="(local-name(.) = 'tempKeys')">
			<span class="isoElement"><res:tempKeys /></span>
		 </xsl:when>
		 <xsl:when test="(local-name(.) = 'themeKeys')">
			<span class="isoElement"><res:themeKeys /></span>
		 </xsl:when>
		 <xsl:when test="(local-name(.) = 'otherKeys')">
			<span class="isoElement"><res:otherKeys /></span>
		 </xsl:when>
		</xsl:choose>&#x2003;<xsl:for-each select="keyword[text()]">
			<xsl:value-of select="."/><xsl:if test="not(position() = last())">, </xsl:if>
        </xsl:for-each>
	</dt>
	<dd>
    <dl>
		<xsl:apply-templates select="thesaName[*]" mode="arcgis"/>
		<xsl:for-each select="thesaLang">
			<dt><span class="isoElement"><res:thesaLang /></span>&#x2003;
				<xsl:apply-templates select="languageCode"  mode="arcgis"/><xsl:if test="countryCode">–<xsl:call-template name="ISO3166_CountryCode">
						<xsl:with-param name="code" select="countryCode/@value" />
					</xsl:call-template>
				</xsl:if>
			</dt><br /><br />
		</xsl:for-each>
		<xsl:if test="not(thesaName/* or thesaLang)"><br /></xsl:if>
    </dl>
    </dd>
  </dd>
</xsl:template>
<xsl:template match="descKeys" mode="arcgis">
	<dd>
	<dt>
		<xsl:choose>
		 <xsl:when test="(keyTyp/KeyTypCd/@value = '001') or (keyTyp/@KeyTypCd = '001')">
			<span class="element"><res:discKeys /></span>
		 </xsl:when>
		 <xsl:when test="(keyTyp/KeyTypCd/@value = '002') or (keyTyp/@KeyTypCd = '002')">
			<span class="element"><res:placeKeys /></span>
		 </xsl:when>
		 <xsl:when test="(keyTyp/KeyTypCd/@value = '003') or (keyTyp/@KeyTypCd = '001')">
			<span class="element"><res:stratKeys /></span>
		 </xsl:when>
		 <xsl:when test="(keyTyp/KeyTypCd/@value = '004') or (keyTyp/@KeyTypCd = '001')">
			<span class="element"><res:tempKeys /></span>
		 </xsl:when>
		 <xsl:when test="(keyTyp/KeyTypCd/@value = '005') or (keyTyp/@KeyTypCd = '001')">
			<span class="element"><res:themeKeys /></span>
		 </xsl:when>
		 <xsl:otherwise>
			<span class="element"><res:descKeys_other /></span>
		 </xsl:otherwise>
		</xsl:choose>&#x2003;<xsl:for-each select="keyword[text()]">
			<xsl:value-of select="."/><xsl:if test="not(position() = last())">, </xsl:if>
        </xsl:for-each>
	</dt>
	<dd>
    <dl>
		<xsl:if test="keyTyp/KeyTypCd/@value[(. != '001') and (. != '002') and (. != '003') and (. != '004') and (. != '005') and (. != '')]">
			<dt><span class="element"><res:keyTyp /></span>&#x2003;<xsl:value-of select="keyTyp/KeyTypCd/@value"/></dt>
		</xsl:if>
      
		<xsl:apply-templates select="thesaName" mode="arcgis"/>
		<xsl:if test="not(thesaName)"><br /></xsl:if>
    </dl>
    </dd>
  </dd>
</xsl:template>

<!-- Browse Graphic Information (B.2.2.1 MD_BrowGraph - line48) -->
<xsl:template match="graphOver" mode="arcgis">
  <dd>
    <dt><span class="isoElement"><res:graphOver /></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="bgFileName">
        <dt><span class="isoElement"><res:bgFileName /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="bgFileType">
        <dt><span class="isoElement"><res:bgFileType /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="bgFileDesc">
        <dt><span class="isoElement"><res:bgFileDesc /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
    </dl>
    </dd>
  </dd>
  <br />
</xsl:template>

<!-- Usage Information (B.2.2.5 MD_Usage - line62) -->
<xsl:template match="idSpecUse" mode="arcgis">
  <dd>
    <dt><span class="isoElement"><res:idSpecUse /></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="usageDate">
        <dt><span class="isoElement"><res:usageDate /></span>&#x2003;<xsl:call-template name="dateType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></dt>
      </xsl:for-each>
      <xsl:for-each select="specUsage">
        <dt><span class="isoElement"><res:specUsage /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:if test="(usageDate | specUsage)"><br /><br /></xsl:if>

      <xsl:for-each select="usrDetLim">
        <dt><span class="isoElement"><res:usrDetLim /></span>&#x2003;<xsl:value-of select="."/></dt>
        <br /><br />
      </xsl:for-each>

      <xsl:apply-templates select="usrCntInfo" mode="arcgis"/>
    </dl>
    </dd>
  </dd>
</xsl:template>

<!-- Aggregate Information (B.2.2.7 MD_AggregateInformation - line66.1) -->
<xsl:template match="aggrInfo" mode="arcgis">
  <dd>
    <dt><span class="isoElement"><res:aggrInfo /></span></dt>
    <dd>
    <dl>
		<xsl:for-each select="assocType">
		  <dt><span class="isoElement"><res:assocType /></span>&#x2003;
			<xsl:for-each select="AscTypeCd">
				<xsl:call-template name="DS_AssociationTypeCode">
					<xsl:with-param name="code" select="@value" />
				</xsl:call-template>
			</xsl:for-each> 
			</dt>
		</xsl:for-each>
		<xsl:for-each select="initType">
		  <dt><span class="isoElement"><res:initType /></span>&#x2003;
			<xsl:for-each select="InitTypCd">
				<xsl:call-template name="DS_InitiativeTypeCode">
					<xsl:with-param name="code" select="@value" />
				</xsl:call-template>
			</xsl:for-each> 
			</dt>
		</xsl:for-each>
		<xsl:if test="assocType | initType"><br /><br /></xsl:if>

		<xsl:apply-templates select="aggrDSName" mode="arcgis"/>

		<xsl:apply-templates select="aggrDSIdent" mode="arcgis"/>
    </dl>
    </dd>
  </dd>
  <br />
</xsl:template>

<!-- Resolution Information (B.2.2.4 MD_Resolution - line59) -->
<xsl:template match="dataScale" mode="arcgis">
  <dd>
  <dt><span class="isoElement"><res:dataScale /></span></dt>
    <dd>
    <dl>
      <xsl:apply-templates select="equScale" mode="arcgis"/>

      <xsl:for-each select="scaleDist">
        <dt><span class="isoElement"><res:scaleDist /></span></dt>
        <dd>
        <dl>
            <!-- value will be shown regardless of any subelement present: Integer, Real, or Decimal -->
            <xsl:for-each select="value">
              <dt><span class="isoElement"><res:value /></span>&#x2003;<xsl:value-of select="."/><xsl:for-each select="./@uom">&#160;<xsl:call-template name="ucum_units">
						<xsl:with-param name="unit" select="." />
					</xsl:call-template>
				</xsl:for-each>
			  </dt>
            </xsl:for-each>
            <xsl:apply-templates select="uom" mode="arcgis"/>
            <xsl:if test="(value) and not (uom)"><br /><br /></xsl:if>
        </dl>
        </dd>
      </xsl:for-each>
    </dl>
    </dd>
  </dd>
</xsl:template>

<!-- Representative Fraction Information (B.2.2.3 MD_RepresentativeFraction - line56) -->
<xsl:template match="equScale | srcScale" mode="arcgis">
  <xsl:choose>
    <xsl:when test="(local-name(.) = 'equScale')">
        <dt><span class="isoElement"><res:equScale /></span></dt>
    </xsl:when>
    <xsl:when test="(local-name(.) = 'srcScale')">
        <dt><span class="isoElement"><res:srcScale /></span></dt>
    </xsl:when>
    <xsl:otherwise>
        <dt><span class="isoElement"><res:scaleOtherwise /></span></dt>
    </xsl:otherwise>
  </xsl:choose>
  <dd>
  <dl>
    <xsl:for-each select="rfDenom">
      <dt><span class="isoElement"><res:rfDenom /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="Scale">
      <dt><span class="element"><res:Scale /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
  </dl>
  </dd>
  <br />
</xsl:template>

<!-- Units of Measurement Types (from ISO 19103 information in 19115 DTD) -->
<xsl:template match="uom" mode="arcgis">
    <xsl:choose>
      <xsl:when test="./UomArea">
          <dt><span class="element"><res:UomArea /></span></dt>
      </xsl:when>
      <xsl:when test="./UomLength">
          <dt><span class="element"><res:UomLength /></span></dt>
      </xsl:when>
      <xsl:when test="./UomVolume">
          <dt><span class="element"><res:UomVolume /></span></dt>
      </xsl:when>
      <xsl:when test="./UomScale">
          <dt><span class="element"><res:UomScale /></span></dt>
      </xsl:when>
      <xsl:when test="./UomTime">
          <dt><span class="element"><res:UomTime /></span></dt>
      </xsl:when>
      <xsl:when test="./UomVelocity">
          <dt><span class="element"><res:UomVelocity /></span></dt>
      </xsl:when>
      <xsl:when test="./UomAngle">
          <dt><span class="element"><res:UomAngle /></span></dt>
      </xsl:when>
      <xsl:otherwise>
          <dt><span class="element"><res:UomOtherwise /></span></dt>
      </xsl:otherwise>
    </xsl:choose>

    <xsl:apply-templates select="node()" mode="arcgis"/>
</xsl:template>

<!-- Units of Measurement (from ISO 19103 information in 19115 DTD) -->
<xsl:template match="UOM" mode="arcgis">
  <dd>
  <dl>
    <xsl:for-each select="unitSymbol">
       <dt><span class="isoElement"><res:unitSymbol /></span>&#x2003;<xsl:value-of select="."/></dt>
		<xsl:for-each select="@codeSpace">
			<dl>
			   <dt><span class="isoElement"><res:unitSymbol_codespace /></span>&#x2003;<xsl:value-of select="."/></dt>
			</dl>
		</xsl:for-each>
    </xsl:for-each>
    <xsl:for-each select="./@type">
       <dt><span class="isoElement"><res:unitSymbol_type /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="unitQuanType">
       <dt><span class="isoElement"><res:unitQuanType /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="unitQuanRef">
       <dt><span class="isoElement"><res:unitQuanRef /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:if test="(unitSymbol | unitQuanType | unitQuanRef)" ><br /><br /></xsl:if>
    
    <xsl:if test="@gmlID | gmlDesc | gmlDescRef | gmlIdent | gmlName | gmlRemarks">
       <xsl:call-template name="gmlAttributes" />
    </xsl:if>
  </dl>
  </dd>
  <br />
</xsl:template>
<xsl:template match="UomArea | UomTime | UomLength | UomVolume | UomVelocity | UomAngle | UomScale | vertUoM | axisUnits | falENUnits | valUnit" mode="arcgis">
  <dd>
  <dl>
    <xsl:for-each select="uomName">
       <dt><span class="element"><res:uomName /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="conversionToISOstandardUnit">
      <dt><span class="element"><res:conversionToISOstandardUnit /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
  </dl>
  </dd>
  <br />
</xsl:template>

<!-- GML object attributes -->
<xsl:template name="gmlAttributes">
   <dt><span class="isoElement"><res:gmlAttributes /></span></dt>
   <dd><dl>
		<xsl:for-each select="@gmlID">
		   <dt><span class="isoElement"><res:gmlID /></span>&#x2003;<xsl:value-of select="."/></dt>
		</xsl:for-each>
		<xsl:for-each select="gmlDesc">
		   <dt><span class="isoElement"><res:gmlDesc /></span>&#x2003;<xsl:value-of select="."/></dt>
		</xsl:for-each>
		<xsl:for-each select="gmlDescRef">
		   <dt><span class="isoElement"><res:gmlDescRef /></span>&#x2003;<xsl:value-of select="."/></dt>
		</xsl:for-each>
		<xsl:for-each select="gmlIdent">
		   <dt><span class="isoElement"><res:gmlIdent /></span>&#x2003;<xsl:value-of select="."/></dt>
			<xsl:for-each select="@codeSpace">
				<dl>
				   <dt><span class="isoElement"><res:gmlIdent_codespace /></span>&#x2003;<xsl:value-of select="."/></dt>
				</dl>
			</xsl:for-each>
		</xsl:for-each>
		<xsl:for-each select="gmlName">
		   <dt><span class="isoElement"><res:gmlName /></span>&#x2003;<xsl:value-of select="."/></dt>
			<xsl:for-each select="@codeSpace">
				<dl>
				   <dt><span class="isoElement"><res:gmlName_codespace /></span>&#x2003;<xsl:value-of select="."/></dt>
				</dl>
			</xsl:for-each>
		</xsl:for-each>
		<xsl:for-each select="gmlRemarks">
		   <dt><span class="isoElement"><res:gmlRemarks /></span>&#x2003;<xsl:value-of select="."/></dt>
		</xsl:for-each>
	</dl></dd>
</xsl:template>


<!-- SPATIAL REPRESENTATION -->

<!-- Spatial Representation Information (B.2.6  MD_SpatialRepresentation - line156) -->
<xsl:template match="metadata/spatRepInfo" mode="arcgis">
  <a>
    <xsl:attribute name="name"><xsl:value-of select = "generate-id()" /></xsl:attribute>
    <xsl:attribute name="id"><xsl:value-of select = "generate-id()" /></xsl:attribute>
  </a>
  <dl>
    <xsl:choose>
      <xsl:when test="./GridSpatRep">
        <dt><h2 class="iso"><res:GridSpatRep /></h2></dt>
      </xsl:when>
      <xsl:when test="./Georect">
        <dt><h2 class="iso"><res:Georect /></h2></dt>
      </xsl:when>
      <xsl:when test="./Georef">
        <dt><h2 class="iso"><res:Georef /></h2></dt>
      </xsl:when>
      <xsl:when test="./VectSpatRep">
        <dt><h2 class="iso"><res:VectSpatRep /></h2></dt>
      </xsl:when>
    </xsl:choose>
  
  <dl>
    <dd>
      <xsl:apply-templates  mode="arcgis"/>
    </dd>
  </dl>
  </dl>
</xsl:template>

<!-- Grid Information (B.2.6  MD_GridSpatialRepresentation - line157, 
		MD_Georectified - line162, and MD_Georeferenceable - line170) -->
<xsl:template match="GridSpatRep | Georect | Georef" mode="arcgis">
    <xsl:for-each select="numDims">
      <dt><span class="isoElement"><res:numDims /></span>&#x2003;<xsl:value-of select="."/></dt>
      <br /><br />
    </xsl:for-each>

    <xsl:apply-templates select="axisDimension" mode="arcgis"/>
    <xsl:apply-templates select="axDimProps" mode="arcgis"/>
    <xsl:if test="(numDims) and not (axDimProps)"><br /><br /></xsl:if>

    <xsl:for-each select="cellGeo">
      <dt><xsl:if test="./CellGeoCd/@Sync = 'TRUE'">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:cellGeo /></span>&#x2003;
        <xsl:for-each select="CellGeoCd">
          <xsl:call-template name="MD_CellGeometryCode">
				<xsl:with-param name="code" select="@value" />
			</xsl:call-template>
        </xsl:for-each>
        </dt>
    </xsl:for-each>
      <xsl:for-each select="ptInPixel">
        <dt><span class="isoElement"><res:ptInPixel /></span>&#x2003;
        <xsl:for-each select="PixOrientCd">
			<xsl:call-template name="MD_PixelOrientationCode">
				<xsl:with-param name="code" select="@value" />
			</xsl:call-template>
        </xsl:for-each>
        </dt>
      </xsl:for-each>
      <xsl:if test="cellGeo | ptInPixel"><br /><br /></xsl:if>

    <xsl:for-each select="tranParaAv">
      <dt><xsl:if test="./@Sync = 'TRUE'">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:tranParaAv /></span>&#x2003;<xsl:call-template name="booleanType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template>
      </dt>      
    </xsl:for-each>
      <xsl:for-each select="transDimDesc">
        <dt><span class="isoElement"><res:transDimDesc /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="transDimMap">
        <dt><span class="isoElement"><res:transDimMap /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:if test="tranParaAv | transDimDesc | transDimMap"><br /><br /></xsl:if>
    
      <xsl:for-each select="chkPtAv">
        <dt><span class="isoElement"><res:chkPtAv /></span>&#x2003;<xsl:call-template name="booleanType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template>
        </dt>      
      </xsl:for-each>
      <xsl:for-each select="chkPtDesc">
        <dt><span class="isoElement"><res:chkPtDesc /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="cornerPts">
        <dt><span class="isoElement"><res:cornerPts /></span></dt>
	    <dd>
	    <dl>
	      <xsl:for-each select="pos">
	        <dt><span class="isoElement"><res:pos /></span>&#x2003;<xsl:value-of select="."/></dt>
	        <br /><br />
	      </xsl:for-each>
			<xsl:if test="@gmlID | gmlDesc | gmlDescRef | gmlIdent | gmlName">
			   <xsl:call-template name="gmlAttributes" />
			   <br />
			</xsl:if>
			
	      <xsl:for-each select="coordinates">
	        <dt><span class="element"><res:coordinates /></span>&#x2003;<xsl:value-of select="."/></dt>
	        <br /><br />
	      </xsl:for-each>
	      
	       <xsl:if test="MdCoRefSys">
	        <dt><span class="element"><res:MdCoRefSys /></span></dt>
	        <dd>
	        <dl>
	          <xsl:apply-templates select="MdCoRefSys" mode="arcgis"/>
	        </dl>
	        </dd>
	      </xsl:if>     
	    </dl>
	    </dd>
      </xsl:for-each>
      <xsl:for-each select="centerPt">
        <dt><span class="isoElement"><res:centerPt /></span></dt>
	    <dd>
	    <dl>
	      <xsl:for-each select="pos">
	        <dt><span class="isoElement"><res:pos /></span>&#x2003;<xsl:value-of select="."/></dt>
	        <br /><br />
	      </xsl:for-each>
			<xsl:if test="@gmlID | gmlDesc | gmlDescRef | gmlIdent | gmlName">
			   <xsl:call-template name="gmlAttributes" />
			   <br />
			</xsl:if>

	      <xsl:for-each select="coordinates">
	        <dt><span class="element"><res:coordinates /></span>&#x2003;<xsl:value-of select="."/></dt>
	        <br /><br />
	      </xsl:for-each>
	      
	       <xsl:if test="MdCoRefSys">
	        <dt><span class="element"><res:MdCoRefSys1 /></span></dt>
	        <dd>
	        <dl>
	          <xsl:apply-templates select="MdCoRefSys" mode="arcgis"/>
	        </dl>
	        </dd>
	      </xsl:if>     
	    </dl>
	    </dd>
      </xsl:for-each>
      <xsl:if test="chkPtAv | chkPtDesc | cornerPts | centerPt"><br /><br /></xsl:if>

      <xsl:for-each select="ctrlPtAv">
        <dt><span class="isoElement"><res:ctrlPtAv /></span>&#x2003;<xsl:call-template name="booleanType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template>
        </dt>      
      </xsl:for-each>
      <xsl:for-each select="orieParaAv">
        <dt><span class="isoElement"><res:orieParaAv /></span>&#x2003;<xsl:call-template name="booleanType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template>
      </dt>      
      </xsl:for-each>
      <xsl:for-each select="orieParaDs">
        <dt><span class="isoElement"><res:orieParaDs /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:if test="ctrlPtAv | orieParaAv | orieParaDs"><br /><br /></xsl:if>

      <xsl:for-each select="georefPars">
        <dt><span class="isoElement"><res:georefPars /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:apply-templates select="paraCit" mode="arcgis"/>
      <xsl:if test="(georefPars) and not (paraCit)"><br /><br /></xsl:if>
</xsl:template>

<!-- Dimension Information (B.2.6.1 MD_Dimension - line179) -->
<xsl:template match="axisDimension" mode="arcgis">
  <dd>
    <dt><span class="isoElement"><res:axisDimension /></span></dt>
    <dd>
    <dl>
	  <xsl:for-each select="./@type">
		<dt><span class="isoElement"><res:axisDimension_type /></span>&#x2003;<xsl:call-template name="MD_DimensionNameTypeCode">
				<xsl:with-param name="code" select="." />
			</xsl:call-template>
		</dt>
	  </xsl:for-each>
	  <xsl:for-each select="dimSize">
		<dt><xsl:if test="./@Sync = 'TRUE'">
			<span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:dimSize /></span>&#x2003;<xsl:value-of select="."/></dt>
	  </xsl:for-each>
	  <xsl:for-each select="dimResol/value">
		<dt><xsl:if test="./@Sync = 'TRUE'">
				<span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:distance /></span>&#x2003;<xsl:value-of select="."/><xsl:for-each select="./@uom">&#160;<xsl:call-template name="ucum_units">
					<xsl:with-param name="unit" select="." />
				</xsl:call-template>
			</xsl:for-each>
		</dt>
	  </xsl:for-each>
    </dl>
    </dd>
    <br />
  </dd>
</xsl:template>
<xsl:template match="axDimProps" mode="arcgis">
  <dd>
    <dt><span class="element"><res:axDimProps /></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="Dimen">
	    <dt><span class="element"><res:Dimen /></span></dt>
	    <dd>
	    <dl>
	      <xsl:for-each select="dimName">
	        <dt><xsl:if test="./DimNameTypCd/@Sync = 'TRUE'">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="element"><res:dimName /></span>&#x2003;
	        <xsl:for-each select="DimNameTypCd">
				<xsl:call-template name="MD_DimensionNameTypeCode">
					<xsl:with-param name="code" select="@value" />
				</xsl:call-template>
	        </xsl:for-each> 
	        </dt>
	      </xsl:for-each>
	      <xsl:for-each select="dimSize">
	        <dt><xsl:if test="./@Sync = 'TRUE'">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="element"><res:dimSize /></span>&#x2003;<xsl:value-of select="."/></dt>
	      </xsl:for-each>
	      <xsl:for-each select="dimResol">
	        <dt><span class="element"><res:dimResol /></span></dt>
	        <dl>
	          <xsl:for-each select="value">
	            <dt><xsl:if test="./@Sync = 'TRUE'">
                    <span class="sync">*</span>&#x2009;</xsl:if><span class="element"><res:distance /></span>&#x2003;<xsl:value-of select="."/></dt>
	          </xsl:for-each>
                 <xsl:for-each select="uom/*/uomName">
	            <dt><xsl:if test="./@Sync = 'TRUE'">
                    <span class="sync">*</span>&#x2009;</xsl:if><span class="element"><res:UomOtherwise /></span>&#x2003;<xsl:value-of select="."/></dt>
	          </xsl:for-each>
	          <xsl:for-each select="uom/*/conversionToISOstandardUnit">
	            <dt><xsl:if test="./@Sync = 'TRUE'">
                    <span class="sync">*</span>&#x2009;</xsl:if><span class="element"><res:conversionToISOUnits /></span>&#x2003;<xsl:value-of select="."/></dt>
	          </xsl:for-each>
	        </dl>
	      </xsl:for-each>
	    </dl>
	    </dd>
      </xsl:for-each>
    </dl>
    </dd>
    <br />
  </dd>
</xsl:template>

<!-- Vector Information (B.2.6  MD_VectorSpatialRepresentation - line176) -->
<xsl:template match="VectSpatRep" mode="arcgis">
      <xsl:for-each select="topLvl">
        <dt><xsl:if test="./TopoLevCd/@Sync = 'TRUE'">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:topLvl /></span>&#x2003;
        <xsl:for-each select="TopoLevCd">
			<xsl:call-template name="MD_TopologyLevelCode">
				<xsl:with-param name="code" select="@value" />
			</xsl:call-template>
        </xsl:for-each>
        </dt><br /><br />
      </xsl:for-each>
      <xsl:apply-templates select="geometObjs" mode="arcgis"/>
      <xsl:if test="(topLvl) and not (geometObjs)"><br /><br /></xsl:if>
</xsl:template>

<!-- Geometric Object Information (B.2.6.2 MD_GeometricObjects - line183) -->
<xsl:template match="geometObjs" mode="arcgis">
  <dd>
    <dt><span class="isoElement"><res:geometObjs /></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="@Name">
        <dt><span class="sync">*</span>&#x2009;<span class="esriElement"><res:otfcname /></span>&#x2003;<xsl:value-of select="."/></dt>      
      </xsl:for-each>
      <xsl:for-each select="geoObjTyp">
        <dt><xsl:if test="./GeoObjTypCd/@Sync = 'TRUE'">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:geoObjTyp /></span>&#x2003;
        <xsl:for-each select="GeoObjTypCd">
			<xsl:call-template name="MD_GeometricObjectTypeCode">
				<xsl:with-param name="code" select="@value" />
			</xsl:call-template>
        </xsl:for-each>
        </dt>
      </xsl:for-each>
      <xsl:for-each select="geoObjCnt">
        <dt><xsl:if test="./@Sync = 'TRUE'">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:geoObjCnt /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
    </dl>
    </dd>
  </dd>
  <br />
</xsl:template>

<!-- Identifier Information (B.2.7.2 MD_Identifier - line205) -->
<xsl:template match="geoId | refSysID | refSysName | RS_Identifier | citId | svResCitId | imagQuCode | prcTypCde | measId | aggrDSIdent | projection | ellipsoid | datum | MdIdent | RS_Identifier | datumID" mode="arcgis">
  <dd>
	<xsl:choose>
		<xsl:when test="(local-name(.) = 'geoId')">
			<dt><span class="isoElement"><res:geoId /></span></dt>
		</xsl:when>
		<xsl:when test="(local-name() = 'citId') or (local-name() = 'svResCitId')">
			<dt><span class="isoElement"><res:citId /></span></dt>
		</xsl:when>
		<xsl:when test="(local-name(.) = 'imagQuCode')">
			<dt><span class="isoElement"><res:imagQuCode /></span></dt>
		</xsl:when>
		<xsl:when test="(local-name(.) = 'prcTypCde')">
			<dt><span class="isoElement"><res:prcTypCde /></span></dt>
		</xsl:when>
		<xsl:when test="(local-name(.) = 'measId')">
			<dt><span class="isoElement"><res:measId /></span></dt>
		</xsl:when>
		<xsl:when test="(local-name(.) = 'aggrDSIdent')">
			<dt><span class="isoElement"><res:aggrDSIdent /></span></dt>
		</xsl:when>
		<xsl:when test="(local-name() = 'refSysName')">
			<dt><span class="element"><res:refSysName /></span></dt>
		</xsl:when>
		<xsl:when test="(local-name() = 'datumID')">
			<dt><span class="element"><res:datumID /></span></dt>
		</xsl:when>
		<!-- can't use this method to add headings for refSysID, projection, ellipsoid, and datum
			  because all exist together inside MdCoRefSys - also affects RefSystem -->
	</xsl:choose>

    <dd>
    <dl>
      <xsl:for-each select="identCode">
		  <xsl:choose>
			<xsl:when test="@code">
				<dt><xsl:if test="@Sync = 'TRUE'">
						<span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:identCode /></span>&#x2003;<xsl:value-of select="@code"/></dt>
			</xsl:when>
			<xsl:when test="(. != '') and (local-name(../*) != 'refSysID')">
				<dt><xsl:if test="@Sync = 'TRUE'">
						<span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:identCode /></span>&#x2003;<xsl:value-of select="."/></dt>
			</xsl:when>
		  </xsl:choose>
      </xsl:for-each>
      <xsl:for-each select="idCodeSpace">
		  <dt><xsl:if test="./@Sync = 'TRUE'">
						<span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:idCodeSpace /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="idVersion">
		  <dt><xsl:if test="./@Sync = 'TRUE'">
						<span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:idVersion /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:if test="(identCode | idCodeSpace | idVersion)"><br /><br /></xsl:if>

      <xsl:apply-templates select="identAuth" mode="arcgis"/>
    </dl>
    </dd>
  </dd>
</xsl:template>

 
<!-- CONTENT INFORMATION -->

<!-- Content Information (B.2.8 MD_ContentInformation - line232) -->
<xsl:template match="contInfo" mode="arcgis">
  <a>
    <xsl:attribute name="name"><xsl:value-of select = "generate-id()" /></xsl:attribute>
    <xsl:attribute name="id"><xsl:value-of select = "generate-id()" /></xsl:attribute>
  </a>
  <dl>
    <xsl:choose>
      <xsl:when test="FetCatDesc">
        <dt><h2 class="iso"><res:FetCatDesc /></h2></dt>
      </xsl:when>
      <xsl:when test="CovDesc">
        <dt><h2 class="iso"><res:CovDesc /></h2></dt>
      </xsl:when>
      <xsl:when test="ImgDesc">
        <dt><h2 class="iso"><res:ImgDesc /></h2></dt>
      </xsl:when>
    </xsl:choose>
  
  <dl>
    <dd>
        <xsl:apply-templates  mode="arcgis"/>
    </dd>
    </dl>
  </dl>
</xsl:template>

<!-- Content Information (B.2.8 MD_ContentInformation ABSTRACT - line232) -->
<xsl:template match="ContInfo" mode="arcgis">
    <dt><span class="element"><res:ContInfo /></span>&#x2003;<xsl:value-of select="."/></dt>
</xsl:template>

<!-- Feature Catalogue Description (B.2.8 MD_FeatureCatalogueDescription - line233) -->
<xsl:template match="FetCatDesc" mode="arcgis">
      <xsl:for-each select="incWithDS">
        <dt><span class="isoElement"><res:incWithDS /></span>&#x2003;<xsl:call-template name="booleanType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template>
        </dt>      
      </xsl:for-each>
      <xsl:for-each select="compCode">
        <dt><span class="isoElement"><res:compCode /></span>&#x2003;<xsl:call-template name="booleanType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template>
        </dt>      
      </xsl:for-each>
      <xsl:for-each select="catLang">
        <dt><span class="isoElement"><res:catLang /></span>&#x2003;
            <xsl:apply-templates select="languageCode"  mode="arcgis"/><xsl:if test="countryCode">–<xsl:call-template name="ISO3166_CountryCode">
						<xsl:with-param name="code" select="countryCode/@value" />
					</xsl:call-template>
				</xsl:if>
			<xsl:for-each select="CharSetCd">
				<dl>
					<dt><span class="isoElement"><res:catLang_charset /></span>&#x2003;<xsl:apply-templates select="." mode="arcgis"/></dt>
				</dl>
			</xsl:for-each>
        </dt>
      </xsl:for-each>
      <xsl:if test="catLang | incWithDS | compCode"><br /><br /></xsl:if>

      <xsl:for-each select="catFetTyps/genericName">
        <dt><span class="isoElement"><res:catFetTyps /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="catFetTyps[TypeName | LocalName | ScopedName | MemberName]">
        <dt><span class="isoElement"><res:catFetTyps /></span></dt>
        <xsl:apply-templates select="TypeName | LocalName | ScopedName | MemberName"  mode="arcgis"/>
      </xsl:for-each>

     <xsl:apply-templates select="catCitation" mode="arcgis"/>
</xsl:template>

<!-- Coverage Description (B.2.8 MD_CoverageDescription - line239) -->
<xsl:template match="CovDesc" mode="arcgis">
      <xsl:for-each select="contentTyp">
        <dt><span class="isoElement"><res:contentTyp /></span>&#x2003;
        <xsl:for-each select="ContentTypCd">
		    <xsl:call-template name="MD_CoverageContentTypeCode">
				<xsl:with-param name="code" select="@value" />
			</xsl:call-template>
        </xsl:for-each>
        </dt>
      </xsl:for-each>
      <xsl:for-each select="attDesc">
        <dt><span class="isoElement"><res:attDesc /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:if test="attDesc | contentTyp"><br /><br /></xsl:if>

      <xsl:apply-templates select="covDim" mode="arcgis"/>
</xsl:template>

<!-- Range dimension Information (B.2.8.1 MD_RangeDimension - line256) -->
<xsl:template match="covDim" mode="arcgis">
    <dd>
    <xsl:choose>
      <xsl:when test="RangeDim">
        <dt><span class="isoElement"><res:RangeDim /></span></dt>
      </xsl:when>
      <xsl:when test="Band">
        <dt><span class="isoElement"><res:Band /></span></dt>
      </xsl:when>
      <xsl:otherwise>
        <dt><span class="isoElement"><res:RangeOtherwise /></span></dt>
      </xsl:otherwise>
    </xsl:choose>

    <dd>
    <dl>
      <xsl:for-each select="*/dimDescrp">
        <dt><span class="isoElement"><res:dimDescrp /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:if test="*/seqID">
        <dt><span class="isoElement"><res:seqID /></span></dt>
        <xsl:apply-templates select="*/seqID"  mode="arcgis"/>
      </xsl:if>
      <xsl:if test="(*/dimDescrp) and not (*/seqID)"><br /><br /></xsl:if>

    <xsl:for-each select="Band">
      <xsl:for-each select="maxVal">
        <dt><span class="isoElement"><res:maxVal /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="minVal">
        <dt><span class="isoElement"><res:minVal /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="pkResp">
        <dt><span class="isoElement"><res:pkResp /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:if test="valUnit">
        <dt><span class="isoElement"><res:valUnit /></span></dt>
        <xsl:apply-templates select="valUnit/UOM" mode="arcgis"/>
        <xsl:apply-templates select="valUnit" mode="arcgis"/>
      </xsl:if>
      <xsl:if test="(maxVal | minVal | pkResp) and not (valUnit)"><br /><br /></xsl:if>

      <xsl:for-each select="bitsPerVal">
        <dt><span class="isoElement"><res:bitsPerVal /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="toneGrad">
        <dt><span class="isoElement"><res:toneGrad /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="sclFac">
        <dt><span class="isoElement"><res:sclFac /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="offset">
        <dt><span class="isoElement"><res:offset /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:if test="bitsPerVal | toneGrad | sclFac | offset"><br /><br /></xsl:if>
    </xsl:for-each>
    </dl>
    </dd>
    </dd>
</xsl:template>

<!-- Member Names (from ISO 19103 information in 19115 DTD) -->
<!-- Local Name and Scoped Name -->
<xsl:template match="LocalName | ScopedName" mode="arcgis">
    <dd>
    <dl>
      <xsl:for-each select="scope">
        <dt><span class="element"><res:scope /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
    </dl>
    </dd>
    <br />
</xsl:template>

<!-- Type Name -->
<xsl:template match="TypeName | svValType" mode="arcgis">
    <dd>
    <dl>
      <xsl:for-each select="aName">
        <dt><span class="isoElement"><res:aName /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="scope">
        <dt><span class="element"><res:scope /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
    </dl>
    </dd>
    <br />
</xsl:template>

<!-- Member Name -->
<xsl:template match="MemberName | seqID | svParName" mode="arcgis">
    <dd>
    <dl>
      <xsl:for-each select="aName">
        <dt><span class="isoElement"><res:aName /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="scope">
        <dt><span class="element"><res:scope /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="attributeType">
        <dt><span class="isoElement"><res:attributeType /></span></dt>
        <dd>
        <dl>
          <xsl:for-each select="aName">
            <dt><span class="isoElement"><res:aName /></span>&#x2003;<xsl:value-of select="."/></dt>
          </xsl:for-each>
		  <xsl:for-each select="scope">
			<dt><span class="element"><res:scope /></span>&#x2003;<xsl:value-of select="."/></dt>
		  </xsl:for-each>
        </dl>
        </dd>
      </xsl:for-each>
    </dl>
    </dd>
    <br />
</xsl:template>

<!-- Image Description (B.2.8 MD_ImageDescription - line243) -->
<xsl:template match="ImgDesc" mode="arcgis">
      <xsl:for-each select="contentTyp">
        <dt><span class="isoElement"><res:contentTyp /></span>&#x2003;
        <xsl:for-each select="ContentTypCd">
          <xsl:choose>
            <xsl:when test="@value = '001'">image</xsl:when>
            <xsl:when test="@value = '002'">thematic classification</xsl:when>
            <xsl:when test="@value = '003'">physical measurement</xsl:when>
            <xsl:otherwise><xsl:value-of select="@value"/></xsl:otherwise>
	   </xsl:choose>
        </xsl:for-each>
        </dt>
      </xsl:for-each>
      <xsl:for-each select="attDesc">
        <dt><span class="isoElement"><res:attDescription /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:if test="attDesc | contentTyp"><br /><br /></xsl:if>

      <xsl:apply-templates select="covDim" mode="arcgis"/>

      <xsl:for-each select="illElevAng">
        <dt><span class="isoElement"><res:illElevAng /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="illAziAng">
        <dt><span class="isoElement"><res:illAziAng /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="imagCond">
        <dt><span class="isoElement"><res:imagCond /></span>&#x2003;
        <xsl:for-each select="ImgCondCd">
			<xsl:call-template name="MD_ImagingConditionCode">
				<xsl:with-param name="code" select="@value" />
			</xsl:call-template>
        </xsl:for-each>
        </dt>
      </xsl:for-each>
      <xsl:for-each select="cloudCovPer">
        <dt><span class="isoElement"><res:cloudCovPer /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:if test="illElevAng | illAziAng | imagCond | cloudCovPer"><br /><br /></xsl:if>

	  <xsl:apply-templates select="imagQuCode" mode="arcgis"/>
      <xsl:for-each select="imagQuCode/MdIdent">
        <dt><span class="element"><res:imagQuCode /></span></dt>
        <xsl:apply-templates select="."  mode="arcgis"/>
      </xsl:for-each>

	  <xsl:apply-templates select="prcTypCde" mode="arcgis"/>
      <xsl:for-each select="prcTypCde/MdIdent">
        <dt><span class="element"><res:prcTypCde /></span></dt>
        <xsl:apply-templates select="."  mode="arcgis"/>
      </xsl:for-each>

      <xsl:for-each select="cmpGenQuan">
        <dt><span class="isoElement"><res:cmpGenQuan /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="trianInd">
        <dt><span class="isoElement"><res:trianInd /></span>&#x2003;<xsl:call-template name="booleanType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template>
        </dt>      
      </xsl:for-each>
      <xsl:for-each select="radCalDatAv">
        <dt><span class="isoElement"><res:radCalDatAv /></span>&#x2003;<xsl:call-template name="booleanType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template>
        </dt>      
      </xsl:for-each>
      <xsl:for-each select="camCalInAv">
        <dt><span class="isoElement"><res:camCalInAv /></span>&#x2003;<xsl:call-template name="booleanType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template>
        </dt>      
      </xsl:for-each>
      <xsl:for-each select="filmDistInAv">
        <dt><span class="isoElement"><res:filmDistInAv /></span>&#x2003;<xsl:call-template name="booleanType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template>
        </dt>      
      </xsl:for-each>
      <xsl:for-each select="lensDistInAv">
        <dt><span class="isoElement"><res:lensDistInAv /></span>&#x2003;<xsl:call-template name="booleanType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template>
        </dt>      
      </xsl:for-each>
      <xsl:if test="cmpGenQuan | trainInd | radCalDatAv | camCalInAv | filmDistInAv | lensDistInAv"><br /><br /></xsl:if>
</xsl:template>


<!-- REFERENCE SYSTEM -->

<!-- Reference System Information (B.2.7 MD_ReferenceSystem - line186) -->
<xsl:template match="refSysInfo" mode="arcgis">
  <a>
    <xsl:attribute name="name"><xsl:value-of select = "generate-id()" /></xsl:attribute>
    <xsl:attribute name="id"><xsl:value-of select = "generate-id()" /></xsl:attribute>
  </a>
  <dl>
  
    <dl>
    <dd>
      <xsl:apply-templates select="RefSystem" mode="arcgis"/>

      <xsl:apply-templates select="MdCoRefSys" mode="arcgis"/>

	<!-- no support in the DIS DTD for RS_ReferenceSystem information and TMRefSys, SIRefSys, SCRefSys -->
    </dd>
    </dl>
    </dl>
</xsl:template>

<!-- Reference System Information (B.2.7 MD_ReferenceSystem - line186) -->
<xsl:template match="RefSystem" mode="arcgis">
      <xsl:if test="refSysID">
        <dt><span class="isoElement"><res:refSysID /></span></dt>
        <xsl:apply-templates select="refSysID" mode="arcgis"/>
      </xsl:if>

      <xsl:if test="not (*)"><br /></xsl:if>
</xsl:template>

<!-- Metadata for Coordinate Systems (B.2.7 MD_CRS - line189) -->
<xsl:template match="MdCoRefSys" mode="arcgis">
      <xsl:if test="refSysID">
        <dt><span class="element"><res:refSysID /></span></dt>
        <xsl:apply-templates select="refSysID" mode="arcgis"/>
      </xsl:if>

      <xsl:if test="projection">
        <dt><span class="element"><res:projection /></span></dt>
        <xsl:apply-templates select="projection" mode="arcgis"/>
      </xsl:if>
      
      <xsl:if test="ellipsoid">
        <dt><span class="element"><res:ellipsoid /></span></dt>
        <xsl:apply-templates select="ellipsoid" mode="arcgis"/>
      </xsl:if>
      
      <xsl:if test="datum">
        <dt><span class="element"><res:datum /></span></dt>
        <xsl:apply-templates select="datum" mode="arcgis"/>
      </xsl:if>

      <xsl:apply-templates select="projParas" mode="arcgis"/>

      <xsl:apply-templates select="ellParas" mode="arcgis"/>
      
      <xsl:if test="not(./*)"><br /></xsl:if>
</xsl:template>

<!-- Projection Parameter Information (B.2.7.5 MD_ProjectionParameters - line215) -->
<xsl:template match="projParas" mode="arcgis">
  <dd>
    <dt><span class="element"><res:projParas /></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="zone">
        <dt><span class="element"><res:zone /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="stanParal">
        <dt><span class="element"><res:stanParal /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="longCntMer">
        <dt><span class="element"><res:longCntMer /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="latProjOri">
        <dt><span class="element"><res:latProjOri /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="sclFacEqu">
        <dt><span class="element"><res:sclFacEqu /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="hgtProsPt">
        <dt><span class="element"><res:hgtProsPt /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="longProjCnt">
        <dt><span class="element"><res:longProjCnt /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="latProjCnt">
        <dt><span class="element"><res:latProjCnt /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="sclFacCnt">
        <dt><span class="element"><res:sclFacCnt /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="stVrLongPl">
        <dt><span class="element"><res:stVrLongPl /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="sclFacPrOr">
        <dt><span class="element"><res:sclFacPrOr /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:if test="zoneNum | stanParal | longCntMer | latProjOri | sclFacEqu | hgtProsPt | longProjCnt | latProjCnt | sclFacCnt | stVrLongPl | sclFacPrOr"><br /><br /></xsl:if>

      <xsl:apply-templates select="obLnAziPars" mode="arcgis"/>

      <xsl:apply-templates select="obLnPtPars" mode="arcgis"/>
      
      <xsl:for-each select="falEastng">
        <dt><span class="element"><res:falEastng /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="falNorthng">
        <dt><span class="element"><res:falNorthng /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:if test="falENUnits">
        <dt><span class="element"><res:falENUnits /></span></dt>
        <xsl:apply-templates select="falENUnits" mode="arcgis"/>
      </xsl:if>
      <xsl:if test="(falEastng | falNorthng) and not (falENUnits)"><br /><br /></xsl:if>
    </dl>
    </dd>
  </dd>
</xsl:template>

<!-- Oblique Line Azimuth Information (B.2.7.3 MD_ObliqueLineAzimuth - line210) -->
<xsl:template match="obLnAziPars" mode="arcgis">
  <dd>
    <dt><span class="element"><res:obLnAziPars /></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="aziAngle">
        <dt><span class="element"><res:aziAngle /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="aziPtLong">
        <dt><span class="element"><res:aziPtLong /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
    </dl>
    </dd>
  </dd>
  <br />
</xsl:template>

<!-- Oblique Line Point Information (B.2.7.4 MD_ObliqueLinePoint - line212) -->
<xsl:template match="obLnPtPars" mode="arcgis">
  <dd>
    <dt><span class="element"><res:obLnPtPars /></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="obLineLat">
        <dt><span class="element"><res:obLineLat /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="obLineLong">
        <dt><span class="element"><res:obLineLong /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
    </dl>
    </dd>
  </dd>
  <br />
</xsl:template>

<!-- Ellipsoid Parameter Information (B.2.7.1 MD_EllipsoidParameters - line201) -->
<xsl:template match="ellParas" mode="arcgis">
  <dd>
    <dt><span class="element"><res:ellParas /></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="semiMajAx">
        <dt><span class="element"><res:semiMajAx /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:if test="axisUnits">
        <dt><span class="element"><res:axisUnits /></span></dt>
        <xsl:apply-templates select="axisUnits" mode="arcgis"/>
      </xsl:if>
      <xsl:for-each select="denFlatRat">
        <dt><span class="element"><res:denFlatRat /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
    </dl>
    </dd>
  </dd>
  <br />
</xsl:template>


<!-- DATA QUALITY -->

<!-- Data Quality Information  (B.2.4 DQ_DataQuality - line78) -->
<xsl:template match="metadata/dqInfo" mode="arcgis">
  <a>
    <xsl:attribute name="name"><xsl:value-of select = "generate-id()" /></xsl:attribute>
    <xsl:attribute name="id"><xsl:value-of select = "generate-id()" /></xsl:attribute>
  </a>
  <dl>
  <dl>
  <dd>
    <xsl:apply-templates select="dqScope" mode="arcgis"/>

    <xsl:apply-templates select="dataLineage" mode="arcgis"/>

    <xsl:for-each select="dqReport">
      <xsl:apply-templates select="*" mode="arcgis"/>
    </xsl:for-each>
  </dd>
  </dl>
  </dl>
</xsl:template>

<!-- Scope Information (B.2.4.4 DQ_Scope - line138) -->
<xsl:template match="dqScope" mode="arcgis">
    <dd>
    <dt><span class="isoElement"><res:dqScope /></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="scpLvl">
        <dt><span class="isoElement"><res:scpLvl /></span>&#x2003;
            <xsl:apply-templates select="ScopeCd"  mode="arcgis"/>
        </dt>
      </xsl:for-each>
      <xsl:apply-templates select="scpLvlDesc" mode="arcgis"/>
      <xsl:if test="(scpLvl) and not (scpLvlDesc)"><br /><br /></xsl:if>

      <xsl:apply-templates select="scpExt" mode="arcgis"/>
    </dl>
    </dd>
    </dd>
</xsl:template>

<!-- Lineage Information (B.2.4.1 LI_Lineage - line82) -->
<xsl:template match="dataLineage" mode="arcgis">
  <dd>
  <dt><span class="isoElement"><res:dataLineage /></span></dt>
  <dd>
  <dl>
    <xsl:for-each select="statement">
      <dt><span class="isoElement"><res:statement /></span></dt>
      <dl><dd><pre class="wrap">
		  <xsl:call-template name="handleURLs">
			  <xsl:with-param name="text" select="."/>
		  </xsl:call-template>
      </pre></dd></dl>
    </xsl:for-each>

    <xsl:apply-templates select="prcStep" mode="arcgis"/>

    <xsl:apply-templates select="dataSource" mode="arcgis"/>
  </dl>
  </dd>
  </dd>
</xsl:template>

<!-- Process Step Information (B.2.4.1.1 LI_ProcessStep - line86) -->
<xsl:template match="prcStep | srcStep" mode="arcgis">
  <dd>
  <dt><span class="isoElement"><res:prcStep /></span></dt>
  <dd>
  <dl>
    <xsl:for-each select="stepDateTm">
      <dt><span class="isoElement"><res:stepDateTm /></span>&#x2003;<xsl:call-template name="dateType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></dt>
    </xsl:for-each>
    <xsl:for-each select="stepDesc">
      <dt><span class="isoElement"><res:stepDesc /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="stepRat">
      <dt><span class="isoElement"><res:stepRat /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:if test="stepDateTm | stepDesc | stepRat"><br /><br /></xsl:if>

    <xsl:apply-templates select="stepProc" mode="arcgis"/>

    <xsl:apply-templates select="stepSrc" mode="arcgis"/>
  </dl>
  </dd>
  </dd>
</xsl:template>

<!-- Source Information (B.2.4.1.2 LI_Source - line92) -->
<xsl:template match="dataSource | stepSrc" mode="arcgis">
  <dd>
  <dt><span class="isoElement"><res:dataSource /></span></dt>
  <dd>
  <dl>
      <xsl:for-each select="srcDesc">
        <dt><span class="isoElement"><res:srcDesc /></span>&#x2003;<xsl:value-of select="."/></dt>
        <br /><br />
      </xsl:for-each>
		<xsl:for-each select="srcMedName">
		  <dt><span class="isoElement"><res:srcMedName /></span>&#x2003;
			<xsl:for-each select="MedNameCd">
				<xsl:call-template name="MD_MediumNameCode">
					<xsl:with-param name="code" select="@value" />
				</xsl:call-template>
			</xsl:for-each>
			</dt>
		</xsl:for-each>
      
      <xsl:apply-templates select="srcScale" mode="arcgis"/>
      
      <xsl:apply-templates select="srcCitatn" mode="arcgis"/>
      
      <xsl:for-each select="srcRefSys">
        <dt><span class="isoElement"><res:srcRefSys /></span></dt>
	    <dd>
	    <dl>
	      <xsl:apply-templates select="RefSystem" mode="arcgis"/>
	
	      <xsl:apply-templates select="MdCoRefSys" mode="arcgis"/>
	    </dl>
	    </dd>
      </xsl:for-each>
      
      <xsl:apply-templates select="srcExt" mode="arcgis"/>

      <xsl:apply-templates select="srcStep" mode="arcgis"/>
  </dl>
  </dd>
  </dd>
</xsl:template>

<!-- Data Quality Element Information (B.2.4.2 DQ_Element - line99) -->
<xsl:template match="DQComplete | DQCompComm | DQCompOm | DQLogConsis | DQConcConsis | DQDomConsis | DQFormConsis | DQTopConsis | DQPosAcc | DQAbsExtPosAcc | DQGridDataPosAcc | DQRelIntPosAcc | DQTempAcc | DQAccTimeMeas | DQTempConsis | DQTempValid | DQThemAcc | DQThemClassCor | DQNonQuanAttAcc | DQQuanAttAcc" mode="arcgis">
  <dd>
  <xsl:choose>
    <xsl:when test="../DQComplete">
        <dt><span class="isoElement"><res:DQComplete /></span></dt>
    </xsl:when>
    <xsl:when test="../DQCompComm">
        <dt><span class="isoElement"><res:DQCompComm /></span></dt>
    </xsl:when>
    <xsl:when test="../DQCompOm">
        <dt><span class="isoElement"><res:DQCompOm /></span></dt>
    </xsl:when>
    <xsl:when test="../DQLogConsis">
        <dt><span class="isoElement"><res:DQLogConsis /></span></dt>
    </xsl:when>
    <xsl:when test="../DQConcConsis">
        <dt><span class="isoElement"><res:DQConcConsis /></span></dt>
    </xsl:when>
    <xsl:when test="../DQDomConsis">
        <dt><span class="isoElement"><res:DQDomConsis /></span></dt>
    </xsl:when>
    <xsl:when test="../DQFormConsis">
        <dt><span class="isoElement"><res:DQFormConsis /></span></dt>
    </xsl:when>
    <xsl:when test="../DQTopConsis">
        <dt><span class="isoElement"><res:DQTopConsis /></span></dt>
    </xsl:when>
    <xsl:when test="../DQPosAcc">
        <dt><span class="isoElement"><res:DQPosAcc /></span></dt>
    </xsl:when>
    <xsl:when test="../DQAbsExtPosAcc">
        <dt><span class="isoElement"><res:DQAbsExtPosAcc /></span></dt>
    </xsl:when>
    <xsl:when test="../DQGridDataPosAcc">
        <dt><span class="isoElement"><res:DQGridDataPosAcc /></span></dt>
    </xsl:when>
    <xsl:when test="../DQRelIntPosAcc">
        <dt><span class="isoElement"><res:DQRelIntPosAcc /></span></dt>
    </xsl:when>
    <xsl:when test="../DQTempAcc">
        <dt><span class="isoElement"><res:DQTempAcc /></span></dt>
    </xsl:when>
    <xsl:when test="../DQAccTimeMeas">
        <dt><span class="isoElement"><res:DQAccTimeMeas /></span></dt>
    </xsl:when>
    <xsl:when test="../DQTempConsis">
        <dt><span class="isoElement"><res:DQTempConsis /></span></dt>
    </xsl:when>
    <xsl:when test="../DQTempValid">
        <dt><span class="isoElement"><res:DQTempValid /></span></dt>
    </xsl:when>
    <xsl:when test="../DQThemAcc">
        <dt><span class="isoElement"><res:DQThemAcc /></span></dt>
    </xsl:when>
    <xsl:when test="../DQThemClassCor">
        <dt><span class="isoElement"><res:DQThemClassCor /></span></dt>
    </xsl:when>
    <xsl:when test="../DQNonQuanAttAcc">
        <dt><span class="isoElement"><res:DQNonQuanAttAcc /></span></dt>
    </xsl:when>
    <xsl:when test="../DQQuanAttAcc">
        <dt><span class="isoElement"><res:DQQuanAttAcc /></span></dt>
    </xsl:when>
    <xsl:otherwise>
        <dt><span class="isoElement"><res:DQOtherwise /></span></dt>
    </xsl:otherwise>
  </xsl:choose>

  <dd>
  <dl>
    <xsl:for-each select="measName">
      <dt><span class="isoElement"><res:measName /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="evalMethType">
      <dt><span class="isoElement"><res:evalMethType /></span>&#x2003;
        <xsl:for-each select="EvalMethTypeCd">
          <xsl:call-template name="DQ_EvaluationMethodTypeCode">
				<xsl:with-param name="code" select="@value" />
			</xsl:call-template>
        </xsl:for-each>
        </dt>
    </xsl:for-each>
    <xsl:for-each select="measDateTm">
      <dt><span class="isoElement"><res:measDateTm /></span>&#x2003;<xsl:call-template name="dateType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></dt>
    </xsl:for-each>
    <xsl:if test="measName | evalMethType | measDateTm"><br /><br /></xsl:if>

    <xsl:for-each select="measDesc">
      <dt><span class="isoElement"></span>&#x2003;<xsl:value-of select="."/></dt>
      <br /><br />
    </xsl:for-each>

    <xsl:for-each select="evalMethDesc">
      <dt><span class="isoElement"><res:evalMethDesc /></span>&#x2003;<xsl:value-of select="."/></dt>
      <br /><br />
    </xsl:for-each>

	<xsl:apply-templates select="measId" mode="arcgis"/>
	<xsl:for-each select="measId/MdIdent">
		<dt><span class="element"><res:measId /></span></dt>
		<xsl:apply-templates select="."  mode="arcgis"/>
	</xsl:for-each>

    <xsl:apply-templates select="evalProc" mode="arcgis"/>

    <xsl:for-each select="measResult">
        <xsl:for-each select="Result">
          <dt><span class="element"><res:Result /></span>&#x2003;<xsl:value-of select="."/></dt>
          <br /><br />
        </xsl:for-each>
        <xsl:apply-templates select="ConResult" mode="arcgis"/>
        <xsl:apply-templates select="QuanResult" mode="arcgis"/>
    </xsl:for-each>
  </dl>
  </dd>
  </dd>
</xsl:template>

<!-- Conformance Result Information (B.2.4.3 DQ_ConformanceResult - line129) -->
<xsl:template match="ConResult" mode="arcgis">
  <dd>
  <dt><span class="isoElement"><res:ConResult /></span></dt>
  <dd>
  <dl>
    <xsl:for-each select="conPass">
      <dt><span class="isoElement"><res:conPass /></span>&#x2003;<xsl:call-template name="booleanType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template>
      </dt>      
    </xsl:for-each>
    <xsl:for-each select="conExpl">
      <dt><span class="isoElement"><res:conExpl /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:if test="conPass | conExpl"><br /><br /></xsl:if>

    <xsl:apply-templates select="conSpec" mode="arcgis"/>
  </dl>
  </dd>
  </dd>
</xsl:template>

<!-- Quantitative Result Information (B.2.4.3 DQ_QuantitativeResult - line133) -->
<xsl:template match="QuanResult" mode="arcgis">
  <dd>
  <dt><span class="isoElement"><res:QuanResult /></span></dt>
  <dd>
  <dl>
    <xsl:if test="quanValue | quanVal">
      <xsl:for-each select="quanVal">
        <dt><span class="isoElement"><res:quanValue /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="quanValue">
        <dt><span class="element"><res:quanValue /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <br /><br />
    </xsl:if>
    <xsl:if test="(quanValType) and not (quanValUnit)"><br /><br /></xsl:if>

    <xsl:for-each select="quanValUnit">
      <dt><span class="isoElement"><res:quanValUnit /></span></dt>
      <xsl:apply-templates select="UOM" mode="arcgis"/>
      <xsl:if test="value | uom">
		  <dd>
		  <dl>
			  <!-- value will be shown regardless of the subelement Integer, Real, or Decimal -->
			  <xsl:for-each select="value">
				<dt><span class="element"><res:quanValPrecision /></span>&#x2003;<xsl:value-of select="."/></dt>
			  </xsl:for-each>
			  <xsl:apply-templates select="uom" mode="arcgis"/>
			  <xsl:if test="(value) and not (uom)"><br /><br /></xsl:if>
		  </dl>
		  </dd>
      </xsl:if>
    </xsl:for-each>

    <xsl:for-each select="quanValType">
      <dt><span class="isoElement"><res:quanValType /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>

    <xsl:for-each select="errStat">
      <dt><span class="isoElement"><res:errStat /></span>&#x2003;<xsl:value-of select="."/></dt>
      <br /><br />
    </xsl:for-each>
  </dl>
  </dd>
  </dd>
</xsl:template>


<!-- DISTRIBUTION INFORMATION -->

<!-- Distribution Information (B.2.10 MD_Distribution - line270) -->
<xsl:template match="metadata/distInfo" mode="arcgis">
  <a>
    <xsl:attribute name="name"><xsl:value-of select = "generate-id()" /></xsl:attribute>
    <xsl:attribute name="id"><xsl:value-of select = "generate-id()" /></xsl:attribute>
  </a>
  <dl>

  <dl>
  <dd>
      <xsl:apply-templates select="distributor" mode="arcgis"/>

      <xsl:apply-templates select="distFormat" mode="arcgis"/>

      <xsl:apply-templates select="distTranOps" mode="arcgis"/>
  </dd>
  </dl>
  </dl>
</xsl:template>


<!-- Distributor Information (B.2.10.2 MD_Distributor - line279) -->
<xsl:template match="distributor | formatDist" mode="arcgis">
  <dd>
  <dt><span class="isoElement"><res:distributor /></span></dt>

  <dd>
  <dl>
    <xsl:apply-templates select="distorCont" mode="arcgis"/>

    <xsl:apply-templates select="distorFormat" mode="arcgis"/>

    <xsl:apply-templates select="distorOrdPrc" mode="arcgis"/>

    <xsl:apply-templates select="distorTran" mode="arcgis"/>
  </dl>
  </dd>
  </dd>
</xsl:template>

<!-- Format Information (B.2.10.3 MD_Format - line284) -->
<xsl:template match="dsFormat | distorFormat | distFormat" mode="arcgis">
  <dd>
  <xsl:choose>
    <xsl:when test="(local-name(.) = 'dsFormat')">
        <dt><span class="isoElement"><res:dsFormat /></span></dt>
    </xsl:when>
    <xsl:when test="(local-name(.) = 'distorFormat')">
        <dt><span class="isoElement"><res:distorFormat /></span></dt>
    </xsl:when>
    <xsl:when test="(local-name(.) = 'distFormat')">
        <dt><span class="isoElement"><res:distFormat /></span></dt>
    </xsl:when>
    <xsl:otherwise>
        <dt><span class="isoElement"><res:dsOtherwise /></span></dt>
    </xsl:otherwise>
  </xsl:choose>

  <dd>
  <dl>
    <xsl:for-each select="formatName">
      <dt><xsl:if test="./@Sync = 'TRUE'">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:formatName /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="formatVer">
      <dt><span class="isoElement"><res:formatVer /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="formatAmdNum">
      <dt><span class="isoElement"><res:formatAmdNum /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="formatSpec">
      <dt><span class="isoElement"><res:formatSpec /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="fileDecmTech">
      <dt><span class="isoElement"><res:fileDecmTech /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:if test="formatName | formatVer | formatAmdNum | formatSpec | fileDecmTech"><br /><br /></xsl:if>

    <xsl:apply-templates select="formatDist" mode="arcgis"/>
  </dl>
  </dd>
  </dd>
</xsl:template>

<!-- Standard Order Process Information (B.2.10.5 MD_StandardOrderProcess - line298) -->
<xsl:template match="distorOrdPrc | svAccProps" mode="arcgis">
  <dd>
  <xsl:choose>
    <xsl:when test="(local-name(.) = 'distorOrdPrc')">
        <dt><span class="isoElement"><res:distorOrdPrc /></span></dt>
    </xsl:when>
    <xsl:when test="(local-name(.) = 'svAccProps')">
        <dt><span class="isoElement"><res:svAccProps /></span></dt>
    </xsl:when>
  </xsl:choose>
  <dd>
  <dl>
    <xsl:for-each select="resFees">
      <dt><span class="isoElement"><res:resFees /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="planAvDtTm">
      <dt><span class="isoElement"><res:planAvDtTm /></span>&#x2003;<xsl:call-template name="dateType">
				<xsl:with-param name="value" select="refDate" />
			</xsl:call-template></dt>
    </xsl:for-each>
    <xsl:for-each select="ordTurn">
      <dt><span class="isoElement"><res:ordTurn /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="ordInstr">
      <dt><span class="isoElement"><res:ordInstr /></span></dt>
      <dl><dd><pre class="wrap">
		  <xsl:call-template name="handleURLs">
			  <xsl:with-param name="text" select="."/>
		  </xsl:call-template>
      </pre></dd></dl>
    </xsl:for-each>
  </dl>
  </dd>
  </dd>
  <br />
</xsl:template>

<!-- Digital Transfer Options Information (B.2.10.1 MD_DigitalTransferOptions - line274) -->
<xsl:template match="distorTran | distTranOps" mode="arcgis">
  <dd>
  <dt><span class="isoElement"><res:distorTran /></span></dt>

  <dd>
  <dl>
    <xsl:for-each select="transSize">
      <dt><xsl:if test="./@Sync = 'TRUE'">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:transSize /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="unitsODist">
      <dt><span class="isoElement"><res:unitsODist /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:if test="transSize | unitsODist"><br /><br /></xsl:if>

    <xsl:apply-templates select="onLineSrc" mode="arcgis"/>

    <xsl:apply-templates select="offLineMed" mode="arcgis"/>
  </dl>
  </dd>
  </dd>
</xsl:template>

<!-- Medium Information (B.2.10.4 MD_Medium - line291) -->
<xsl:template match="offLineMed" mode="arcgis">
  <dd>
  <dt><span class="isoElement"><res:offLineMed /></span></dt>
  <dd>
  <dl>
    <xsl:for-each select="medName">
      <dt><span class="isoElement"><res:medName /></span>&#x2003;
        <xsl:for-each select="MedNameCd">
			<xsl:call-template name="MD_MediumNameCode">
				<xsl:with-param name="code" select="@value" />
			</xsl:call-template>
        </xsl:for-each>
        </dt>
    </xsl:for-each>
    <xsl:for-each select="medVol">
      <dt><span class="isoElement"><res:medVol /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:if test="medName | medVol"><br /><br /></xsl:if>

    <xsl:for-each select="medFormat">
      <dt><span class="isoElement"><res:medFormat /></span>&#x2003;
        <xsl:for-each select="MedFormCd">
			<xsl:call-template name="MD_MediumFormatCode">
				<xsl:with-param name="code" select="@value" />
			</xsl:call-template>
        </xsl:for-each>
      </dt>
    </xsl:for-each>
    <xsl:for-each select="medDensity">
      <dt><span class="isoElement"><res:medDensity /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="medDenUnits">
      <dt><span class="isoElement"><res:medDenUnits /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:if test="medDensity | medDenUnits | medFormat"><br /><br /></xsl:if>

    <xsl:for-each select="medNote">
      <dt><span class="isoElement"><res:medNote /></span>&#x2003;<xsl:value-of select="."/></dt>
      <xsl:if test="position() = last()"><br /><br /></xsl:if>
    </xsl:for-each>
  </dl>
  </dd>
  </dd>
</xsl:template>

<!-- Portrayal Catalogue Reference (B.2.9 MD_PortrayalCatalogueReference - line268) -->
<xsl:template match="porCatInfo" mode="arcgis">
  <a>
    <xsl:attribute name="name"><xsl:value-of select = "generate-id()" /></xsl:attribute>
    <xsl:attribute name="id"><xsl:value-of select = "generate-id()" /></xsl:attribute>
  </a>
  <dl>

  <dl>
  <dd>
    <xsl:apply-templates select="portCatCit" mode="arcgis"/>
  </dd>
  </dl>
  </dl>
</xsl:template>


<!-- APPLICATION SCHEMA -->

<!-- Application schema Information (B.2.12 MD_ApplicationSchemaInformation - line320) -->
<xsl:template match="appSchInfo" mode="arcgis">
  <a>
    <xsl:attribute name="name"><xsl:value-of select = "generate-id()" /></xsl:attribute>
    <xsl:attribute name="id"><xsl:value-of select = "generate-id()" /></xsl:attribute>
  </a>
  <dl>
    
    <dl>
    <dd>
      <xsl:apply-templates select="asName" mode="arcgis"/>

      <xsl:for-each select="asSchLang">
        <dt><span class="isoElement"><res:asSchLang /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="asCstLang">
        <dt><span class="isoElement"><res:asCstLang /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:if test="asSchLang | asCstLang"><br /><br /></xsl:if>

      <xsl:for-each select="asAscii">
        <dt><span class="isoElement"><res:asAscii /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="asGraFile">
        <dt><span class="isoElement"><res:asGraFile /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="asSwDevFile">
        <dt><span class="isoElement"><res:asSwDevFile /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="asSwDevFiFt">
        <dt><span class="isoElement"><res:asSwDevFiFt /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:if test="asAscii | asGraFile | asSwDevFile | asSwDevFiFt"><br /><br /></xsl:if>

      <xsl:apply-templates select="featCatSup" mode="arcgis"/>
    </dd>
    </dl>
  </dl>
</xsl:template>

<!-- Spatial Attribute Supplement Information (B.2.12.2 MD_SpatialAttributeSupplement - line332) -->
<xsl:template match="featCatSup" mode="arcgis">
  <dd>
    <dt><span class="element"><res:featCatSup /></span></dt>
    <dd>
    <dl>
      <xsl:apply-templates select="featTypeList" mode="arcgis"/>
    </dl>
    </dd>
  </dd>
</xsl:template>

<!-- Feature Type List Information (B.2.12.1 MD_FeatureTypeList - line329 -->
<xsl:template match="featTypeList" mode="arcgis">
  <dd>
    <dt><span class="element"><res:featTypeList /></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="spatObj">
        <dt><span class="element"><res:spatObj /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="spatSchName">
        <dt><span class="element"><res:spatSchName /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
    </dl>
    </dd>
  </dd>
  <br />
</xsl:template>


<!-- METADATA EXTENSIONS -->

<!-- Metadata Extension Information (B.2.11 MD_MetadataExtensionInformation - line303) -->
<xsl:template match="mdExtInfo" mode="arcgis">
  <a>
    <xsl:attribute name="name"><xsl:value-of select = "generate-id()" /></xsl:attribute>
    <xsl:attribute name="id"><xsl:value-of select = "generate-id()" /></xsl:attribute>
  </a>
  <dl>

    <dl>
    <dd>
      <xsl:apply-templates select="extOnRes" mode="arcgis"/>

      <xsl:apply-templates select="extEleInfo" mode="arcgis"/>
    </dd>
    </dl>
  </dl>
</xsl:template>

<!-- Extended Element Information (B.2.11.1 MD_ExtendedElementInformation - line306) -->
<xsl:template match="extEleInfo" mode="arcgis">
    <dd>
    <dt><span class="isoElement"><res:extEleInfo /></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="extEleName">
        <dt><span class="isoElement"><res:extEleName /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="extShortName">
        <dt><span class="isoElement"><res:extShortName /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="extDomCode">
        <dt><span class="isoElement"><res:extDomCode /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="extEleDef">
        <dt><span class="isoElement"><res:extEleDef /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:if test="extEleName | extShortName | extDomCode | extEleDef"><br /><br /></xsl:if>

      <xsl:for-each select="extEleOb">
        <dt><span class="isoElement"><res:extEleOb /></span>&#x2003;
        <xsl:for-each select="ObCd">
			<xsl:call-template name="MD_ObligationCode">
				<xsl:with-param name="code" select="@value" />
			</xsl:call-template>
        </xsl:for-each>
        </dt>
      </xsl:for-each>
      <xsl:for-each select="extEleCond">
        <dt><span class="isoElement"><res:extEleCond /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="extEleMxOc">
        <dt><span class="isoElement"><res:extEleMxOc /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="eleDataType">
        <dt><span class="isoElement"><res:eleDataType /></span>&#x2003;
        <xsl:for-each select="DatatypeCd">
		    <xsl:call-template name="MD_DatatypeCode">
				<xsl:with-param name="code" select="@value" />
			</xsl:call-template>
        </xsl:for-each>
        </dt>
      </xsl:for-each>
      <xsl:for-each select="extEleDomVal">
        <dt><span class="isoElement"><res:extEleDomVal /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:if test="extEleOb | extEleCond | extEleMxOc | eleDataType | extEleDomVal"><br /><br /></xsl:if>

      <xsl:for-each select="extEleParEnt">
        <dt><span class="isoElement"><res:extEleParEnt /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="extEleRule">
        <dt><span class="isoElement"><res:extEleRule /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="extEleRat">
        <dt><span class="isoElement"><res:extEleRat /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:if test="extEleParEnt | extEleRule | extEleRat"><br /><br /></xsl:if>

      <xsl:apply-templates select="extEleSrc" mode="arcgis"/>
    </dl>
    </dd>
    </dd>
</xsl:template>


<!-- TEMPLATES FOR DATA TYPE CLASSES -->

<!-- CITATION AND CONTACT INFORMATION -->

<!-- Citation Information (B.3.2 CI_Citation - line359) -->
<xsl:template match="idCitation | thesaName | identAuth | srcCitatn | evalProc | conSpec | paraCit | portCatCit | catCitation | asName | aggrDSName" mode="arcgis">
  <dd>
  <xsl:choose>
    <xsl:when test="(local-name(.) = 'idCitation')">
      <dt><span class="isoElement"><res:idCitation /></span></dt>
    </xsl:when>
    <xsl:when test="(local-name(.) = 'thesaName')">
      <dt><span class="isoElement"><res:thesaName /></span></dt>
    </xsl:when>
    <xsl:when test="(local-name(.) = 'identAuth')">
      <dt><span class="isoElement"><res:identAuth /></span></dt>
    </xsl:when>
    <xsl:when test="(local-name(.) = 'srcCitatn')">
      <dt><span class="isoElement"><res:srcCitatn /></span></dt>
    </xsl:when>
    <xsl:when test="(local-name(.) = 'evalProc')">
      <dt><span class="isoElement"><res:evalProc /></span></dt>
    </xsl:when>
    <xsl:when test="(local-name(.) = 'conSpec')">
      <dt><span class="isoElement"><res:conSpec /></span></dt>
    </xsl:when>
    <xsl:when test="(local-name(.) = 'paraCit')">
      <dt><span class="isoElement"><res:paraCit /></span></dt>
    </xsl:when>
    <xsl:when test="(local-name(.) = 'portCatCit')">
      <dt><span class="isoElement"><res:portCatCit /></span></dt>
    </xsl:when>
    <xsl:when test="(local-name(.) = 'catCitation')">
      <dt><span class="isoElement"><res:catCitation /></span></dt>
    </xsl:when>
    <xsl:when test="(local-name(.) = 'asName')">
      <dt><span class="isoElement"><res:asName /></span></dt>
    </xsl:when>
    <xsl:when test="(local-name(.) = 'aggrDSName')">
      <dt><span class="isoElement"><res:aggrDSName /></span></dt>
    </xsl:when>
    <xsl:otherwise>
      <dt><span class="isoElement"><res:idCitation /></span></dt>
    </xsl:otherwise>
  </xsl:choose>

  <dd>
  <dl>
	  <xsl:if test="../idCitation">
		<xsl:for-each select="resTitle">
		  <dt><span class="isoElement"><res:resTitle /></span>&#x2003;<xsl:value-of select="."/></dt>
		</xsl:for-each>
	  </xsl:if>
	  <xsl:if test="not(../idCitation)">
		<xsl:for-each select="resTitle">
		  <dt><xsl:if test="./@Sync = 'TRUE'">
					<span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:resTitle /></span>&#x2003;<xsl:value-of select="."/></dt>
		</xsl:for-each>
	  </xsl:if>

    <xsl:if test="resAltTitle">
	    <dt><span class="isoElement"><res:resAltTitle /></span>&#x2003; 
	      <xsl:for-each select="resAltTitle[text()]">
	        <xsl:value-of select="."/><xsl:if test="not(position() = last())">, </xsl:if>
	      </xsl:for-each>
	    </dt>
    </xsl:if>
    <xsl:if test="resTitle | resAltTitle"><br /><br /></xsl:if>

    <xsl:apply-templates select="date" mode="arcgis"/>
    <xsl:apply-templates select="resRefDate" mode="arcgis"/>

    <xsl:for-each select="resEd">
      <dt><span class="isoElement"><res:resEd /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="resEdDate">
      <dt><span class="isoElement"><res:resEdDate /></span>&#x2003;<xsl:call-template name="dateType">
				<xsl:with-param name="value" select="refDate" />
			</xsl:call-template></dt>
    </xsl:for-each>
    <xsl:for-each select="presForm">
      <dt><xsl:if test="./PresFormCd/@Sync = 'TRUE'">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:presForm /></span>&#x2003;
        <xsl:for-each select="PresFormCd">
          <xsl:call-template name="CI_PresentationFormCode">
				<xsl:with-param name="code" select="@value" />
			</xsl:call-template>
        </xsl:for-each>
        </dt>
    </xsl:for-each>
    <xsl:if test="resEd | resEdDate | presForm"><br /><br /></xsl:if>
    
    <xsl:for-each select="collTitle">
      <dt><span class="isoElement"><res:collTitle /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:apply-templates select="datasetSeries" mode="arcgis"/>
    <xsl:if test="(collTitle) and not (datasetSeries)"><br /><br /></xsl:if>

    <xsl:for-each select="isbn">
      <dt><span class="isoElement"><res:isbn /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="issn">
      <dt><span class="isoElement"><res:issn /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="citId">
		<xsl:if test="./*">
			<xsl:apply-templates select="." mode="arcgis"/>
		</xsl:if>
		<xsl:if test="./text()">
			<dt><span class="element"><res:citId /></span>&#x2003;<xsl:value-of select="./text()"/></dt>
		</xsl:if>
    </xsl:for-each>
    <xsl:for-each select="citIdType">
      <dt><span class="element"><res:citIdType /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:if test=" isbn | issn | citId | citIdType"><br /><br /></xsl:if>

    <xsl:for-each select="otherCitDet">
      <dt><span class="isoElement"><res:otherCitDet /></span>&#x2003;<xsl:value-of select="."/></dt>
      <br /><br />
    </xsl:for-each>
    
    <xsl:apply-templates select="citRespParty" mode="arcgis"/>

    <xsl:if test="not (text()) and not(*)"><br /></xsl:if>
  </dl>
  </dd>
  </dd>
</xsl:template>

<!-- Date Information (B.3.2.3 CI_Date) -->
<xsl:template match="date" mode="arcgis">
	<dd>
		<xsl:for-each select="*">
			<dt><span class="isoElement"><xsl:choose>
					<xsl:when test="(name() = 'createDate')"><res:Creation /></xsl:when>
					<xsl:when test="(name() = 'pubDate')"><res:Publication /></xsl:when>
					<xsl:when test="(name() = 'reviseDate')"><res:Revision /></xsl:when>
					<xsl:when test="(name() = 'notavailDate')"><res:NotAvailable /></xsl:when>
					<xsl:when test="(name() = 'inforceDate')"><res:InForce /></xsl:when>
					<xsl:when test="(name() = 'adoptDate')"><res:Adoption /></xsl:when>
					<xsl:when test="(name() = 'deprecDate')"><res:Deprecation /> </xsl:when>
					<xsl:when test="(name() = 'supersDate')"><res:Superseded /></xsl:when>
				</xsl:choose> <res:date /></span>&#x2003;<xsl:call-template name="dateType">
					<xsl:with-param name="value" select="." />
				</xsl:call-template>
			</dt>
        </xsl:for-each>
	</dd><xsl:if test="position() = last()"><br /><br /></xsl:if>
</xsl:template>
<xsl:template match="resRefDate" mode="arcgis">
  <dd>
    <dt><span class="element"><xsl:for-each select="refDateType/DateTypCd">
			<xsl:call-template name="CI_DateTypeCode">
				<xsl:with-param name="code" select="@value" />
			</xsl:call-template>
        </xsl:for-each> <res:resRefDate /></span>&#x2003;<xsl:call-template name="dateType">
				<xsl:with-param name="value" select="refDate" />
			</xsl:call-template></dt>
  </dd><xsl:if test="position() = last()"><br /><br /></xsl:if>
</xsl:template>

<!-- Responsible Party Information (B.3.2 CI_ResponsibleParty - line374) -->
<xsl:template match="mdContact | idPoC | usrCntInfo | stepProc | distorCont | citRespParty | extEleSrc" mode="arcgis">
  <dd>
  <xsl:choose>
    <xsl:when test="../mdContact">
      <dt><span class="isoElement"><res:mdContact /></span></dt>
    </xsl:when>
    <xsl:when test="../idPoC">
      <dt><span class="isoElement"><res:idPoC /></span></dt>
    </xsl:when>
    <xsl:when test="../usrCntInfo">
      <dt><span class="isoElement"><res:usrCntInfo /></span></dt>
    </xsl:when>
    <xsl:when test="../stepProc">
      <dt><span class="isoElement"><res:stepProc /></span></dt>
    </xsl:when>
    <xsl:when test="../distorCont">
      <dt><span class="isoElement"><res:distorCont /></span></dt>
    </xsl:when>
    <xsl:when test="../citRespParty">
      <dt><span class="isoElement"><res:citRespParty /></span></dt>
    </xsl:when>
    <xsl:when test="../extEleSrc">
      <dt><span class="isoElement"><res:extEleSrc /></span></dt>
    </xsl:when>
    <xsl:otherwise>
      <dt><span class="isoElement"><res:distorCont /></span></dt>
    </xsl:otherwise>
  </xsl:choose>

  <dd>
  <dl>
    <xsl:for-each select="rpIndName">
      <dt><span class="isoElement"><res:rpIndName /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="rpOrgName">
      <dt><span class="isoElement"><res:rpOrgName /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="rpPosName">
      <dt><span class="isoElement"><res:rpPosName /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="role">
      <dt><span class="isoElement"><res:role /></span>&#x2003;
        <xsl:for-each select="RoleCd">
          <xsl:call-template name="CI_RoleCode">
				<xsl:with-param name="code" select="@value" />
			</xsl:call-template>
        </xsl:for-each>
        </dt>
    </xsl:for-each>
    <xsl:if test="rpIndName | rpOrgName | rpPosName | role"><br /><br /></xsl:if>

    <xsl:apply-templates select="rpCntInfo" mode="arcgis"/>
  </dl>
  </dd>
  </dd>
</xsl:template>

<!-- Contact Information (B.3.2.2 CI_Contact - line387) -->
<xsl:template match="rpCntInfo" mode="arcgis">
  <dd>
    <dt><span class="isoElement"><res:rpCntInfo /></span></dt>
    <dd>
    <dl>
      <xsl:apply-templates select="cntPhone" mode="arcgis"/>

      <xsl:apply-templates select="cntAddress" mode="arcgis"/>

      <xsl:apply-templates select="cntOnlineRes" mode="arcgis"/>

      <xsl:for-each select="cntHours">
        <dt><span class="isoElement"><res:cntHours /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="cntInstr">
        <dt><span class="isoElement"><res:cntInstr /></span></dt>
		  <dl><dd><pre class="wrap">
			  <xsl:call-template name="handleURLs">
				  <xsl:with-param name="text" select="."/>
			  </xsl:call-template>
		  </pre></dd></dl>
      </xsl:for-each>
      <!-- <xsl:if test="cntHours | cntInstr"><br /><br /></xsl:if> -->
    </dl>
    </dd>
  </dd>
</xsl:template>

<!-- Telephone Information (B.3.2.6 CI_Telephone - line407) -->
<xsl:template match="cntPhone" mode="arcgis">
  <dd>
    <dt><span class="isoElement"><res:cntPhone /></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="voiceNum">
        <dt><span class="isoElement"><res:voiceNum /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="faxNum">
        <dt><span class="isoElement"><res:faxNum /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
    </dl>
    </dd>
  </dd>
  <br />
</xsl:template>

<!-- Address Information (B.3.2.1 CI_Address - line380) -->
<xsl:template match="cntAddress" mode="arcgis">
  <dd>
    <dt><span class="isoElement"><res:cntAddress /></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="delPoint">
        <dt><span class="isoElement"><res:delPoint /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="city">
        <dt><span class="isoElement"><res:city /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="adminArea">
        <dt><span class="isoElement"><res:adminArea /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="postCode">
        <dt><span class="isoElement"><res:postCode /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="country">
        <dt><span class="isoElement"><res:country /></span>&#x2003;<xsl:apply-templates select="."  mode="arcgis"/></dt>
      </xsl:for-each>
      <xsl:for-each select="eMailAdd">
        <dt><span class="isoElement"><res:eMailAdd /></span>&#x2003;<a>
			<xsl:attribute name="href">mailto:<xsl:value-of select="."/>?subject=<xsl:value-of select="/metadata/dataIdInfo/idCitation/resTitle"/></xsl:attribute><xsl:value-of select="."/></a></dt>
      </xsl:for-each>
    </dl>
    </dd>
  </dd>
  <br />
</xsl:template>

<!-- language code list from ISO 639 -->
<xsl:template match="country" mode="arcgis">
    <xsl:call-template name="ISO3166_CountryCode">
		<xsl:with-param name="code" select="." />
	</xsl:call-template>
</xsl:template>

<!-- Online Resource Information (B.3.2.4 CI_OnLineResource - line396) -->
<xsl:template match="cntOnlineRes | onLineSrc | extOnRes | svConPt" mode="arcgis">
  <dd>
  <xsl:choose>
    <xsl:when test="(local-name(.) = 'onLineSrc')">
      <dt><span class="isoElement"><res:onLineSrc /></span></dt>
    </xsl:when>
    <xsl:when test="(local-name(.) = 'extOnRes')">
      <dt><span class="isoElement"><res:extOnRes /></span></dt>
    </xsl:when>
    <xsl:when test="(local-name(.) = 'svConPt')">
      <dt><span class="isoElement"><res:svConPt /></span></dt>
    </xsl:when>
    <xsl:otherwise>
      <dt><span class="isoElement"><res:onLineRes /></span></dt>
    </xsl:otherwise>
  </xsl:choose>

  <dd>
  <dl>
    <xsl:for-each select="orName">
      <dt><span class="isoElement"><res:orName /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="linkage">
      <dt><xsl:if test="./@Sync = 'TRUE'">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:linkage /></span>&#x2003;<xsl:call-template name="urlType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></dt>
    </xsl:for-each>
    <xsl:for-each select="protocol">
      <dt><xsl:if test="./@Sync = 'TRUE'">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:protocol /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
    <xsl:for-each select="orFunct">
      <dt><span class="isoElement"><res:orFunct /></span>&#x2003;
        <xsl:for-each select="OnFunctCd">
          <xsl:call-template name="CI_OnLineFunctionCode">
				<xsl:with-param name="code" select="@value" />
			</xsl:call-template>
        </xsl:for-each>
        </dt>
    </xsl:for-each>
    <xsl:for-each select="orDesc">
      <dt><span class="isoElement"><res:orDesc /></span>&#x2003;
          <xsl:call-template name="ArcIMS_ContentTypeCode">
				<xsl:with-param name="code" select="@value" />
			</xsl:call-template>
        </dt>
    </xsl:for-each>
    <xsl:for-each select="appProfile">
      <dt><span class="isoElement"><res:appProfile /></span>&#x2003;<xsl:value-of select="."/></dt>
    </xsl:for-each>
  </dl>
  </dd>
  </dd>
  <br />
</xsl:template>

<!-- Series Information (B.3.2.5 CI_Series - line403) -->
<xsl:template match="datasetSeries" mode="arcgis">
  <dd>
    <dt><span class="isoElement"><res:datasetSeries /></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="seriesName">
        <dt><span class="isoElement"><res:seriesName /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="issId">
        <dt><span class="isoElement"><res:issId /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="artPage">
        <dt><span class="isoElement"><res:artPage /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
    </dl>
    </dd>
  </dd>
  <br />
</xsl:template>


<!-- EXTENT INFORMATION -->

<!-- Extent Information (B.3.1 EX_Extent - line334) -->
<xsl:template match="dataExt | scpExt | srcExt | svExt" mode="arcgis">
  <dd>
  <xsl:choose>
    <xsl:when test="(local-name(.) = 'dataExt')">
      <dt><span class="isoElement"><res:dataExt /></span></dt>
    </xsl:when>
    <xsl:when test="(local-name(.) = 'scpExt')">
      <dt><span class="isoElement"><res:scpExt /></span></dt>
    </xsl:when>
    <xsl:when test="(local-name(.) = 'srcExt')">
      <dt><span class="isoElement"><res:srcExt /></span></dt>
    </xsl:when>
    <xsl:when test="(local-name(.) = 'svExt')">
      <dt><span class="isoElement"><res:svExt /></span></dt>
    </xsl:when>
    <xsl:otherwise>
      <dt><span class="isoElement"><res:extent /></span></dt>
    </xsl:otherwise>
  </xsl:choose>

    <dd>
    <dl>
      <xsl:for-each select="exDesc">
        <dt><span class="isoElement"><res:exDesc /></span></dt>
		  <dl><dd><pre class="wrap">
			  <xsl:call-template name="handleURLs">
				  <xsl:with-param name="text" select="."/>
			  </xsl:call-template>
		  </pre></dd></dl>
        
        <br />
      </xsl:for-each>

      <xsl:for-each select="geoEle">
        <dt><span class="isoElement"><res:geoEle /></span></dt>
        <dd>
          <dd>
          <dl>
            <xsl:apply-templates select="BoundPoly" mode="arcgis"/>
            <xsl:apply-templates select="GeoBndBox" mode="arcgis"/>
            <xsl:apply-templates select="GeoDesc" mode="arcgis"/>
          </dl>
          </dd>
        </dd>
        <xsl:if test="not (*)"><br /></xsl:if>
      </xsl:for-each>

      <xsl:for-each select="tempEle">
        <xsl:apply-templates select="TempExtent" mode="arcgis"/>
        <xsl:apply-templates select="SpatTempEx" mode="arcgis"/>
      </xsl:for-each>

      <xsl:apply-templates select="vertEle" mode="arcgis"/>
    </dl>
    </dd>
  </dd>
</xsl:template>

<!-- Bounding Polygon Information (B.3.1.1 EX_BoundingPolygon - line341) -->
<xsl:template match="BoundPoly" mode="arcgis">
  <dd>
  <dt><span class="isoElement"><res:BoundPoly /></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="exTypeCode">
        <dt><span class="isoElement"><res:exTypeCode /></span>&#x2003;<xsl:call-template name="booleanType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></dt>      
      </xsl:for-each>
      <xsl:for-each select="polygon[exterior | interior]">
		<dt><span class="isoElement"><res:polygon /></span></dt>
		<dd>
		<dl>
		  <xsl:for-each select="exterior">
			<dt><span class="isoElement"><res:exterior /></span></dt>
			<dd>
			<dl>
			  <xsl:for-each select="pos">
				<dt><span class="isoElement"><res:pos /></span>&#x2003;<xsl:value-of select="."/></dt>
				<xsl:if test="position() = last()"><br /><br /></xsl:if>
			  </xsl:for-each>
			</dl>
			</dd>
		  </xsl:for-each>
		  <xsl:for-each select="interior">
			<dt><span class="isoElement"><res:interior /></span></dt>
			<dd>
			<dl>
			  <xsl:for-each select="pos">
				<dt><span class="isoElement"><res:pos /></span>&#x2003;<xsl:value-of select="."/></dt>
				<xsl:if test="position() = last()"><br /><br /></xsl:if>
			  </xsl:for-each>
			</dl>
			</dd>
		  </xsl:for-each>
			<xsl:if test="@gmlID | gmlDesc | gmlDescRef | gmlIdent | gmlName">
			   <xsl:call-template name="gmlAttributes" />
			   <br />
			</xsl:if>
		</dl>
		</dd>
      </xsl:for-each>
      <xsl:for-each select="polygon[GM_Polygon/coordinates]">
		<dt><span class="element"><res:polygon /></span></dt>
		<dd>
		<dl>
		  <xsl:for-each select="GM_Polygon">
			  <xsl:for-each select="coordinates">
				<dt><span class="element"><res:polygonCoordinates /></span>&#x2003;<xsl:value-of select="."/></dt>
			  </xsl:for-each>
			  <xsl:if test="coordinates"><br /><br /></xsl:if>
			  <xsl:for-each select="MdCoRefSys">
				<dt><span class="isoElement"><res:polygonMdCoRefSys /></span></dt>
				<dd>
				<dl>
				  <xsl:apply-templates select="polygon/GM_Polygon/MdCoRefSys" mode="arcgis"/>
				</dl>
				</dd>
			  </xsl:for-each>
		  </xsl:for-each>
		</dl>
		</dd>
      </xsl:for-each>
    </dl>
    </dd>
  </dd>
</xsl:template>

<!-- Bounding Box Information (B.3.1.1 EX_GeographicBoundingBox - line343) -->
<xsl:template match="geoBox | GeoBndBox | nativeExtBox" mode="arcgis">
  <dd>
  <xsl:choose>
	<xsl:when test="(local-name(.) = 'geoBox')">
	  <dt><span class="element"><res:GeoBndBox /></span></dt>
	</xsl:when>
	<xsl:otherwise>
	  <dt><span class="isoElement"><res:GeoBndBox /></span></dt>
	</xsl:otherwise>
  </xsl:choose>

    <dd>
    <dl>
      <xsl:for-each select="@esriExtentType">
        <dt><span class="sync">*</span>&#x2009;<span class="esriElement"><res:attExtentType /></span>&#x2003;
          <xsl:choose>
            <xsl:when test=". = 'native'"><res:attExtentNative /></xsl:when>
            <xsl:when test=". = 'decdegrees'"><res:attExtentDecDegrees /></xsl:when>
            <xsl:when test=". = 'search'"><res:attExtentSearch /></xsl:when>
            <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
		   </xsl:choose>
        </dt>
      </xsl:for-each>
      <xsl:for-each select="westBL">
        <dt><xsl:if test="./@Sync = 'TRUE'">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:westBL /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="eastBL">
        <dt><xsl:if test="./@Sync = 'TRUE'">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:eastBL /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="northBL">
        <dt><xsl:if test="./@Sync = 'TRUE'">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:northBL /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="southBL">
        <dt><xsl:if test="./@Sync = 'TRUE'">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:southBL /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="exTypeCode">
        <dt><xsl:if test="./@Sync = 'TRUE'">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:exTypeCode1 /></span>&#x2003;<xsl:call-template name="booleanType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template>
        </dt>      
      </xsl:for-each>
    </dl>
    </dd>
  </dd>
  <br />
</xsl:template>

<!-- Geographic Description Information (B.3.1.1 EX_GeographicDescription - line348) -->
<xsl:template match="geoDesc | GeoDesc" mode="arcgis">
  <dd>
  <xsl:choose>
    <xsl:when test="(local-name(.) = 'geoDesc')">
      <dt><span class="element"><res:geoDesc_0 /></span></dt>
    </xsl:when>
    <xsl:otherwise>
      <dt><span class="isoElement"><res:GeoDesc /></span></dt>
    </xsl:otherwise>
  </xsl:choose>

    <dd>
    <dl>
      <xsl:apply-templates select="geoId" mode="arcgis"/>
      <xsl:for-each select="exTypeCode">
        <dt><span class="isoElement"><res:exTypeCode2 /></span>&#x2003;<xsl:call-template name="booleanType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template>
        </dt><br /><br />
      </xsl:for-each>
      <xsl:if test="(exTypeCode) and not (geoId)"><br /><br /></xsl:if>
    </dl>
    </dd>
  </dd>
</xsl:template>

<!-- Temporal Extent Information (B.3.1.2 EX_TemporalExtent - line350) -->
<xsl:template match="TempExtent" mode="arcgis">
  <dd>
  <dt><span class="isoElement"><res:TempExtent /></span></dt>
  <xsl:apply-templates select="exTemp/TM_Instant" mode="arcgis"/>
  <xsl:apply-templates select="exTemp/TM_Period" mode="arcgis"/>
  <xsl:apply-templates select="exTemp/TM_GeometricPrimitive" mode="arcgis"/>
  </dd>
</xsl:template>

<!-- temporal extent Information from ISO 19103 as defined is DTD -->
<xsl:template match="exTemp/TM_Instant" mode="arcgis">
  <dd>
  <dl>
      <xsl:for-each select="tmPosition">
        <dt><span class="isoElement"><res:tmPosition /></span>&#x2003;<xsl:call-template name="dateType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></dt>
      </xsl:for-each>
  </dl>
  </dd>
  <br />
</xsl:template>
<xsl:template match="exTemp/TM_Period" mode="arcgis">
  <dd>
  <dl>
      <xsl:for-each select="tmBegin">
        <dt><span class="isoElement"><res:begin /></span>&#x2003;<xsl:call-template name="dateType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></dt>
      </xsl:for-each>
      <xsl:for-each select="tmEnd">
        <dt><span class="isoElement"><res:end /></span>&#x2003;<xsl:call-template name="dateType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></dt>
      </xsl:for-each>
  </dl>
  </dd>
  <br />
</xsl:template>
<xsl:template match="TM_GeometricPrimitive" mode="arcgis">
  <dd>
  <dl>
  <xsl:for-each select="TM_Period">
      <xsl:for-each select="begin">
        <dt><span class="element"><res:begin /></span>&#x2003;<xsl:call-template name="dateType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></dt>
      </xsl:for-each>
      <xsl:for-each select="end">
        <dt><span class="element"><res:end /></span>&#x2003;<xsl:call-template name="dateType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></dt>
      </xsl:for-each>
  </xsl:for-each>
  <xsl:for-each select="TM_Instant">
      <xsl:for-each select=".//calDate">
        <dt><span class="element"><res:calDate /></span>&#x2003;<xsl:call-template name="dateType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></dt>
      </xsl:for-each>
      <xsl:for-each select=".//clkTime">
        <dt><span class="element"><res:clkTime /></span>&#x2003;<xsl:call-template name="timeType">
				<xsl:with-param name="value" select="." />
			</xsl:call-template></dt>
      </xsl:for-each>
  </xsl:for-each>
  </dl>
  </dd>
  <br />
</xsl:template>

<!-- Spatial Temporal Extent Information (B.3.1.2 EX_SpatialTemporalExtent - line352) -->
<xsl:template match="SpatTempEx" mode="arcgis">
  <dd>
  <dt><span class="isoElement"><res:SpatTempEx /></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="exTemp">
        <dt><span class="isoElement"><res:exTemp /></span></dt>
		  <xsl:apply-templates select="TM_Instant" mode="arcgis"/>
		  <xsl:apply-templates select="TM_Period" mode="arcgis"/>
        <xsl:apply-templates select="TM_GeometricPrimitive" mode="arcgis"/>
      </xsl:for-each>

      <xsl:for-each select="exSpat">
        <dt><span class="isoElement"><res:exSpat /></span></dt>
        <dd>
          <dd>
          <dl>
            <xsl:apply-templates select="BoundPoly" mode="arcgis"/>
            <xsl:apply-templates select="GeoBndBox" mode="arcgis"/>
            <xsl:apply-templates select="GeoDesc" mode="arcgis"/>
          </dl>
          </dd>
        </dd>
      </xsl:for-each>
    </dl>
    </dd>
  </dd>
</xsl:template>

<!-- Vertical Extent Information (B.3.1.3 EX_VerticalExtent - line354) -->
<xsl:template match="vertEle" mode="arcgis">
  <dd>
  <dt><span class="isoElement"><res:vertEle /></span></dt>
    <dd>
    <dl>
      <xsl:for-each select="vertMinVal">
        <dt><xsl:if test="./@Sync = 'TRUE'">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:vertMinVal /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:for-each select="vertMaxVal">
        <dt><xsl:if test="./@Sync = 'TRUE'">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="isoElement"><res:vertMaxVal /></span>&#x2003;<xsl:value-of select="."/></dt>
      </xsl:for-each>
      <xsl:if test="vertUoM">
        <dt><span class="element"><res:vertUoM /></span></dt>
        <xsl:apply-templates select="vertUoM" mode="arcgis"/>
      </xsl:if>
      <xsl:if test="(vertMinVal | vertMaxVal) and not (vertUoM)"><br /><br /></xsl:if>

      <xsl:for-each select="vertDatum">
        <xsl:apply-templates select="datumID" mode="arcgis"/>
      </xsl:for-each>
    </dl>
    </dd>
  </dd>
  <xsl:if test="not (*)"><br /></xsl:if>
</xsl:template>


<!-- ESRI EXTENDED ELEMENTS -->

<!-- 	GEOPROCESSING HISTORY -->

<xsl:template match="/metadata/Esri/DataProperties/lineage" mode="arcgis">
  <a name="Geoprocessing" id="Geoprocessing"></a>
  <dl>
    <dd>
    <dl>
      <xsl:for-each select="Process">
        <dt><span class="esriElement"><res:Process /></span></dt>
        <dd>
        <dl>
          <xsl:if test="@Name">
            <dt><span class="esriElement"><res:ProcessName /></span>&#x2003;<xsl:value-of select="@Name"/></dt>
          </xsl:if>
          <xsl:if test="@Date">
            <dt><span class="esriElement"><res:ProcessDate /></span>&#x2003;<xsl:call-template name="dateType">
				<xsl:with-param name="value" select="@Date" />
			</xsl:call-template></dt>
          </xsl:if>
          <xsl:if test="@Time">
            <dt><span class="esriElement"><res:ProcessTime /></span>&#x2003;<xsl:call-template name="timeType">
				<xsl:with-param name="value" select="@Time" />
			</xsl:call-template></dt>
          </xsl:if>
          <xsl:if test="@ToolSource">
            <dt><span class="esriElement"><res:ProcessToolLocation /></span>&#x2003;<xsl:value-of select="@ToolSource"/></dt>
          </xsl:if>
          <dt><span class="esriElement"><res:ProcessCommandIssued /></span>&#x2003;<span class="code"><xsl:value-of select="."/></span></dt>
          <br /><br />
        </dl>
        </dd>
      </xsl:for-each>
    </dl>
    </dd>
  </dl>
</xsl:template>

<!-- 	ESRI METADATA AND ITEM PROPERTIES -->

<xsl:template match="/metadata/Esri" mode="arcgis">
  <a name="Properties" id="Properties"></a>
  <dl>
    <dd>
    <dl>
      <xsl:if test="ArcGISFormat | ArcGISstyle | ArcGISProfile | CreaDate | CreaTime | ModDate | ModTime | SyncDate | SyncTime | SyncOnce | MapLyrSync | Sync | Identifier | PublishedDocID | PublishStatus">
        <dt><span class="esriElement"><res:Properties /></span></dt>
        <dl>
		  <dt><span class="esriElement"><res:ArcGISFormat /></span>&#x2003;<xsl:choose>
					<xsl:when test="ArcGISFormat"><res:ArcGISFormat /> <xsl:value-of select="ArcGISFormat" /></xsl:when>
					<xsl:otherwise><res:ESRIISOFormat /></xsl:otherwise>
				</xsl:choose>
		  </dt>
		  <xsl:if test="ArcGISstyle">
			  <dt><span class="esriElement"><res:ArcGISstyle /></span>&#x2003;<xsl:value-of select="ArcGISstyle" /></dt>
		  </xsl:if>
		  <xsl:if test="ArcGISProfile">
			  <dt><span class="esriElement"><res:ArcGISProfile /></span>&#x2003;<xsl:value-of select="ArcGISProfile" /></dt>
		  </xsl:if>
		  <br /><br />
	
		  <xsl:if test="CreaDate | CreaTime">
			  <dt><span class="esriElement"><res:CreaDate /></span>&#x2003;<xsl:call-template name="dateType">
				<xsl:with-param name="value" select="CreaDate" />
			</xsl:call-template>T<xsl:call-template name="timeType">
				<xsl:with-param name="value" select="CreaTime" />
			</xsl:call-template></dt>
		  </xsl:if>
	
		  <xsl:if test="ModDate | ModTime">
			  <dt><span class="esriElement"><res:ModDate /></span>&#x2003;<xsl:call-template name="dateType">
				<xsl:with-param name="value" select="ModDate" />
			</xsl:call-template>T<xsl:call-template name="timeType">
				<xsl:with-param name="value" select="ModTime" />
			</xsl:call-template></dt>
		  </xsl:if>
	
		  <xsl:if test="(CreaDate | CreaTime | ModDate | ModTime) and (SyncDate | SyncTime | SyncOnce | Sync | MapLyrSync)"><br /><br /></xsl:if>
		  
		  <xsl:if test="SyncDate | SyncTime | SyncOnce | Sync | MapLyrSync">
			<dt><span class="esriElement"><res:Sync /></span></dt>
			<dl>	
			  <xsl:if test="SyncDate | SyncTime">
				  <dt><span class="esriElement"><res:SyncDate /></span>&#x2003;<xsl:call-template name="dateType">
				<xsl:with-param name="value" select="SyncDate" />
			</xsl:call-template>T<xsl:call-template name="timeType">
				<xsl:with-param name="value" select="SyncTime" />
			</xsl:call-template></dt>
			  </xsl:if>
			  
			  <xsl:for-each select="SyncOnce[. = 'FALSE']">
				<dt><span class="esriElement"><res:SyncOnce /></span>&#x2003;<res:boolTrue /></dt>
			  </xsl:for-each>
			  <xsl:for-each select="SyncOnce[. = 'TRUE']">
				<dt><span class="esriElement"><res:SyncOnce /></span>&#x2003;<res:boolFalse /></dt>
			  </xsl:for-each>
			  <xsl:for-each select="Sync">
				<dt><span class="element"><res:SyncWhenViewing /></span>&#x2003;<xsl:value-of select="." /></dt>
			  </xsl:for-each>
		  
			  <xsl:for-each select="MapLyrSync">
				<br /><br />
				<dt><span class="esriElement"><res:MapLyrSync /></span>&#x2003;<xsl:value-of select="." /></dt>
			  </xsl:for-each>
			</dl>
		  </xsl:if>

		  <xsl:if test="(CreaDate | CreaTime | ModDate | ModTime | SyncDate | SyncTime | SyncOnce | Sync | MapLyrSync) and (Identifier | PublishedDocID | PublishStatus)"><br /></xsl:if>
		  
		  <xsl:for-each select="Identifier">
		    <dt><span class="esriElement"><res:Identifier /></span>&#x2003;<xsl:value-of select="." /></dt>
		  </xsl:for-each>
		  <xsl:for-each select="PublishedDocID">
		    <dt><span class="esriElement"><res:PublishedDocID /></span>&#x2003;<xsl:value-of select="." /></dt>
		  </xsl:for-each>
		  <xsl:for-each select="PublishStatus">
		    <dt><span class="esriElement"><res:PublishStatus /></span>&#x2003;<xsl:value-of select="." /></dt>
		  </xsl:for-each>
		  
		  <xsl:for-each select="MetaID">
		    <br /><br />
		    <dt><span class="element"><res:MetaID /></span>&#x2003;<xsl:value-of select="." /></dt>
		  </xsl:for-each>
	    </dl><br />  
	  </xsl:if>
    </dl>

	  <xsl:for-each select="DataProperties/itemProps">
	    <dl>
	      <dt><span class="esriElement"><res:itemProps /></span></dt>
	      <dd>
	      <dl>			
			  <xsl:for-each select="itemName">
				<dt><span class="esriElement"><res:itemName /></span>&#x2003;<xsl:value-of select="." /></dt>
			  </xsl:for-each>
			  <xsl:for-each select="itemSize">
				<dt><span class="esriElement"><res:itemSize /></span>&#x2003;<xsl:value-of select="." /></dt>
			  </xsl:for-each>
			  <!-- native type -->
			  <xsl:for-each select="imsContentType">
				<dt><span class="esriElement"><res:imsContentType /></span>&#x2003;<xsl:call-template name="ArcIMS_ContentTypeCode">
						<xsl:with-param name="code" select="@value" />
					</xsl:call-template>
				</dt>
			  </xsl:for-each>
		  </dl>
		  </dd><br />
		</dl>
	  </xsl:for-each>

	  <xsl:if test="(Server | Service | ServiceType | ServiceFCType | ServiceFCName)">
		<dl>
	      <dt><span class="esriElement"><res:ServiceInfo /></span></dt>
	      <dd>
	      <dl>			
			  <xsl:for-each select="Server">
				<dt><span class="esriElement"><res:Server /></span>&#x2003;<xsl:value-of select="." /></dt>
			  </xsl:for-each>
			  <xsl:for-each select="Service">
				<dt><span class="esriElement"><res:Service /></span>&#x2003;<xsl:value-of select="." /></dt>
			  </xsl:for-each>
			  <xsl:for-each select="ServiceType">
				<dt><span class="esriElement"><res:ServiceType /></span>&#x2003;<xsl:value-of select="." /></dt>
			  </xsl:for-each>
			  <xsl:for-each select="ServiceFCType">
				<dt><span class="esriElement"><res:ServiceFCType /></span>&#x2003;<xsl:value-of select="." /></dt>
			  </xsl:for-each>
			  <xsl:for-each select="ServiceFCName">
				<dt><span class="esriElement"><res:ServiceFCName /></span>&#x2003;<xsl:value-of select="." /></dt>
			  </xsl:for-each>
		  </dl>
		  </dd><br />
		</dl>
	  </xsl:if>


	  <!-- removing data frame count and name; cross reference association description; lineage process step software and version; sde connection info in distinfo -->

	  <xsl:for-each select="DataProperties/copyHistory">
		<dl>
	      <dt><span class="esriElement"><res:copyHistory /></span></dt>
	      <dd>
	      <dl>			
			  <xsl:for-each select="copy">
				<dt><span class="esriElement"><res:copy /></span>&#x2003;<xsl:call-template name="dateType">
				<xsl:with-param name="value" select="@date" />
			</xsl:call-template>T<xsl:call-template name="timeType">
				<xsl:with-param name="value" select="@time" />
			</xsl:call-template></dt>
				<dd>
				<dl>
					<xsl:for-each select="@source">
						<dt><span class="esriElement"><res:source /></span>&#x2003;<xsl:value-of select="." /></dt>
					</xsl:for-each>
					<xsl:for-each select="@dest">
						<dt><span class="esriElement"><res:dest /></span>&#x2003;<xsl:value-of select="." /></dt>
					</xsl:for-each>
				</dl>
				</dd>
			  </xsl:for-each>
		  </dl>
		  </dd><br />
		</dl>
	  </xsl:for-each>

    </dd>
  </dl>
</xsl:template>

<!-- 	ESRI SPATIAL PROPERTIES -->

<xsl:template match="/metadata/Esri/DataProperties" mode="arcgis">
  <a name="ESRISpatial" id="ESRISpatial"></a>
  <dl>
    <dd>
    <dl>
		  <xsl:for-each select="itemProps/nativeExtBox">
			<dt><span class="esriElement"><res:nativeExtBox /></span></dt>
			<xsl:apply-templates select="." mode="arcgis"/>
		  </xsl:for-each>
		  <xsl:for-each select="coordRef">
			  <dt><span class="esriElement"><res:coordRef /></span></dt>
			  <dd>
			  <dl>			
				  <xsl:for-each select="type">
					<dt><span class="esriElement"><res:type /></span>&#x2003;<xsl:value-of select="." /></dt>
				  </xsl:for-each>
				  <xsl:for-each select="projcsn">
					<dt><span class="esriElement"><res:projcsn /></span>&#x2003;<xsl:value-of select="." /></dt>
				  </xsl:for-each>
				  <xsl:for-each select="geogcsn">
					<dt><span class="esriElement"><res:geogcsn /></span>&#x2003;<xsl:value-of select="." /></dt>
				  </xsl:for-each>
				  <xsl:for-each select="peXml">
					<dt><span class="esriElement"><res:peXml /></span>&#x2003;</dt>
					<xsl:variable name="pestring" select="esri:decodenodeset(.)" />
					<dd><dl>
						<xsl:apply-templates select="msxsl:node-set($pestring)" mode="pexml" />
					</dl></dd>
				  </xsl:for-each>
			  </dl>
			  </dd><br />
		  </xsl:for-each>
		</dl>
    </dd>
  </dl>
</xsl:template>

<xsl:template match="ProjectedCoordinateSystem | GeographicCoordinateSystem" mode="pexml">
	<xsl:choose>
		<xsl:when test="(local-name(.) = 'ProjectedCoordinateSystem')">
			<dt><span class="esriElement"><res:ProjectedCoordinateSystem /></span></dt>
		</xsl:when>
		<xsl:when test="(local-name(.) = 'GeographicCoordinateSystem')">
			<dt><span class="esriElement"><res:GeographicCoordinateSystem /></span></dt>
		</xsl:when>
	</xsl:choose>
	<dd><dl>
		<xsl:for-each select="WKID">
			<dt><span class="esriElement"><res:WKID /></span>&#x2003;<xsl:value-of select="." /></dt>
		</xsl:for-each>
		<xsl:for-each select="*[not((local-name(.) = 'WKT') or (local-name(.) = 'WKID'))]">
			<xsl:call-template name="arcgisElement">
				<xsl:with-param name="ele" select="."></xsl:with-param>
			</xsl:call-template>
		</xsl:for-each>
		<xsl:for-each select="WKT">
			<dt><span class="esriElement"><res:WKT /></span>&#x2003;<xsl:value-of select="." /></dt>
		</xsl:for-each>
	</dl></dd>
</xsl:template>

<!-- 	ESRI RASTER PROPERTIES -->

<xsl:template match="/metadata/Esri/DataProperties/RasterProperties" mode="arcgis">
  <a>
    <xsl:attribute name="name"><xsl:value-of select = "generate-id()" /></xsl:attribute>
    <xsl:attribute name="id"><xsl:value-of select = "generate-id()" /></xsl:attribute>
  </a>
  <dl>
    <dd>
    <dl>
	  <xsl:for-each select="General">
		<dt><span class="esriElement"><res:General /></span></dt>
		<dd>
		<dl>
			<xsl:for-each select="*[(local-name(.) != 'HasColormap') and (local-name(.) != 'HasPyramids')]">
				<xsl:call-template name="arcgisElement">
					<xsl:with-param name="ele" select="."></xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
			<xsl:for-each select="HasColormap">
			  <dt><xsl:if test="@Sync = 'TRUE'">
					<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:idHasColmap /></span>&#x2003;<xsl:call-template name="booleanType">
					<xsl:with-param name="value" select="." />
				</xsl:call-template></dt>
			</xsl:for-each>
			<xsl:for-each select="HasPyramids">
			  <dt><xsl:if test="@Sync = 'TRUE'">
					<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:idHasPyramids /></span>&#x2003;<xsl:call-template name="booleanType">
					<xsl:with-param name="value" select="." />
				</xsl:call-template></dt>
			</xsl:for-each>
			<br /><br />
		</dl>
		</dd>
	  </xsl:for-each>
	  <xsl:for-each select="Properties">
		<dt><span class="esriElement"><res:MosaicProperties /></span></dt>
		<dd>
		<dl>
			<xsl:for-each select="*">
				<xsl:call-template name="arcgisElement">
					<xsl:with-param name="ele" select="."></xsl:with-param>
				</xsl:call-template>
			</xsl:for-each>
			<br /><br />
		</dl>
		</dd>
	  </xsl:for-each>
	  <xsl:for-each select="Functions">
		<dt><span class="esriElement"><res:MosaicFunctions /></span></dt>
		<dd>
		<dl>
			<xsl:for-each select="Function">
				<dt><span class="esriElement"><res:MosaicFunction /></span>&#x2003;<xsl:value-of select="@Name" /></dt>
				<dd>
				<dl>
					<dt><span class="esriElement"><res:MosaicDescription /></span>&#x2003;<xsl:value-of select="@Description" /></dt>
					<xsl:for-each select="Arguments">
						<dt><span class="esriElement"><res:MosaicArguments /></span></dt>
						<dd>
						<dl>
							<xsl:for-each select=".//*">
								<xsl:call-template name="arcgisElement">
									<xsl:with-param name="ele" select="."></xsl:with-param>
								</xsl:call-template>
							</xsl:for-each>
							<br /><br />
						</dl>
						</dd>
					</xsl:for-each>
				</dl>
				</dd>
			</xsl:for-each>
		</dl>
		</dd>
	  </xsl:for-each>
	</dl>
	</dd>
  </dl>
</xsl:template>

  <!-- 	MULTI-LINGUAL CONTENT FROM LOCALES PAGE -->

  <xsl:template match="/metadata/Esri/locales" mode="arcgis">
    <a name="ESRILocales" id="ESRILocales"></a>
    <dl>
    <dd>
    <dl>
      <xsl:for-each select="locale">
        <dt><span class="esriElement"><res:idLocale /></span>&#x2003;<xsl:call-template name="ISO639_LanguageCode">
          <xsl:with-param name="code" select="@language" />
        </xsl:call-template>–<xsl:call-template name="ISO3166_CountryCode">
          <xsl:with-param name="code" select="@country" />
        </xsl:call-template>
      </dt>
        <dd>
        <dl>
          <xsl:for-each select="resTitle">
            <dt><span class="esriElement"><res:resTitle /></span>&#x2003;<xsl:value-of select="."/>
          </dt>
          </xsl:for-each>
          <xsl:for-each select="idAbs">
            <dt><span class="esriElement"><res:idAbs /></span></dt>
		        <dl><dd><pre class="wrap">
			        <xsl:call-template name="handleURLs">
				        <xsl:with-param name="text" select="." />
			        </xsl:call-template>
		        </pre></dd></dl>
          </xsl:for-each>
          <br /><br />
        </dl>
        </dd>
      </xsl:for-each>
    </dl>
    </dd>
  </dl>
</xsl:template>

<!-- 	ESRI TOPOLOGY PROPERTIES -->

<xsl:template match="/metadata/Esri/DataProperties/topoinfo" mode="arcgis">
  <a>
    <xsl:attribute name="name"><xsl:value-of select = "generate-id()" /></xsl:attribute>
    <xsl:attribute name="id"><xsl:value-of select = "generate-id()" /></xsl:attribute>
  </a>
  <dl>
    <dd>
    <dl>
		  <xsl:for-each select="topoProps">
			  <xsl:for-each select="topoName">
				<dt><xsl:if test="@Sync = 'TRUE'">
					<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:topoName /></span>&#x2003;<xsl:value-of select="."/></dt>
			  </xsl:for-each>
			  <xsl:for-each select="clusterTol">
				<dt><xsl:if test="@Sync = 'TRUE'">
					<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:clusterTol /></span>&#x2003;<xsl:value-of select="."/></dt>
			  </xsl:for-each>
			  <xsl:for-each select="trustedArea/trustedPolygon">
				<dt><xsl:if test="@Sync = 'TRUE'">
					<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:trustedPolygon /></span>&#x2003;<xsl:value-of select="."/></dt>
			  </xsl:for-each>
			  <xsl:for-each select="notTrusted">
				<dt><xsl:if test="@Sync = 'TRUE'">
					<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:notTrusted /></span>&#x2003;<xsl:value-of select="."/></dt>
			  </xsl:for-each>
			  <xsl:for-each select="maxErrors">
				<dt><xsl:if test="@Sync = 'TRUE'">
					<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:maxErrors /></span>&#x2003;<xsl:value-of select="."/></dt>
			  </xsl:for-each>
			<br /><br />
		  </xsl:for-each>
		  
		  <xsl:for-each select="topoRule">
			<dt><span class="esriElement"><res:topoRule /> <xsl:value-of select="position()" /></span></dt>
			<dd>
			<dl>
			  <xsl:for-each select="topoRuleName">
				<dt><xsl:if test="@Sync = 'TRUE'">
					<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:topoRuleName /></span>&#x2003;<xsl:value-of select="."/></dt>
			  </xsl:for-each>
			  <xsl:for-each select="topoRuleID">
				<dt><xsl:if test="@Sync = 'TRUE'">
					<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:topoRuleID /></span>&#x2003;<xsl:value-of select="."/></dt>
			  </xsl:for-each>
			  <xsl:for-each select="topoRuleType">
				<dt><xsl:if test="@Sync = 'TRUE'">
					<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:topoRuleType /></span>&#x2003;<xsl:value-of select="."/></dt>
			  </xsl:for-each>
			  <xsl:if test="(topoRuleName | topoRuleID | topoRuleType | rulehelp)"><br /><br /></xsl:if>

			  <xsl:for-each select="topoRuleOrigin">
				<dt><span class="esriElement"><res:topoRuleOrigin /></span></dt>
				<dd>
				<dl>
				  <xsl:for-each select="fcname">
					<dt><xsl:if test="@Sync = 'TRUE'">
						<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:fcname /></span>&#x2003;<xsl:value-of select="."/></dt>
				  </xsl:for-each>
				  <xsl:for-each select="stcode">
					<dt><xsl:if test="@Sync = 'TRUE'">
						<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:stcode /></span>&#x2003;<xsl:value-of select="."/></dt>
				  </xsl:for-each>
				  <xsl:for-each select="stname">
					<dt><xsl:if test="@Sync = 'TRUE'">
						<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:stname /></span>&#x2003;<xsl:value-of select="."/></dt>
				  </xsl:for-each>
				  <xsl:for-each select="allOriginSubtypes">
					<dt><xsl:if test="@Sync = 'TRUE'">
						<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:allOriginSubtypes /></span>&#x2003;<xsl:value-of select="."/></dt>
				  </xsl:for-each>
				</dl>
				</dd>
				<br />
			  </xsl:for-each>
			  
			  <xsl:for-each select="topoRuleDest">
				<dt><span class="esriElement"><res:topoRuleDest /></span></dt>
				<dd>
				<dl>
				  <xsl:for-each select="fcname">
					<dt><xsl:if test="@Sync = 'TRUE'">
						<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:fcname /></span>&#x2003;<xsl:value-of select="."/></dt>
				  </xsl:for-each>
				  <xsl:for-each select="stcode">
					<dt><xsl:if test="@Sync = 'TRUE'">
						<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:stcode /></span>&#x2003;<xsl:value-of select="."/></dt>
				  </xsl:for-each>
				  <xsl:for-each select="stname">
					<dt><xsl:if test="@Sync = 'TRUE'">
						<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:stname /></span>&#x2003;<xsl:value-of select="."/></dt>
				  </xsl:for-each>
				  <xsl:for-each select="allDestSubtypes">
					<dt><xsl:if test="@Sync = 'TRUE'">
						<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:allDestSubtypes /></span>&#x2003;<xsl:value-of select="."/></dt>
				  </xsl:for-each>
				</dl>
				</dd>
			  </xsl:for-each>

		   </dl>
		   </dd>
		   <br />
		 </xsl:for-each>
		 
	</dl>
	</dd>
  </dl>
</xsl:template>

<xsl:template match="/metadata/Esri/DataProperties/Terrain" mode="arcgis">
  <a name="Terrain" id="Terrain"></a>
  <dl>
    <dd>
    <dl>
	  <xsl:for-each select="totalPts">
		<dt><span class="esriElement"><res:totalPts /></span>&#x2003;<xsl:value-of select="."/></dt>
	  </xsl:for-each>
	</dl>
	</dd><br />
  </dl>
</xsl:template>

<xsl:template match="/metadata/spdoinfo/netinfo" mode="arcgis">
  <a name="GeometricNetwork" id="GeometricNetwork"></a>
  <dl>
    <dd>
    <dl>
          <xsl:for-each select="nettype">
            <dt><xsl:if test="@Sync = 'TRUE'">
                <span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:nettype /></span>&#x2003;<xsl:value-of select="."/></dt>
            <br /><br />
          </xsl:for-each>
          <xsl:for-each select="connrule">
            <dt><span class="esriElement"><res:connrule /></span></dt>
            <dd>
            <dl>
              <xsl:for-each select="ruletype">
                <dt><xsl:if test="@Sync = 'TRUE'">
                    <span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:ruletype /></span>&#x2003;<xsl:value-of select="."/></dt>
              </xsl:for-each>
              <xsl:for-each select="rulecat">
                <dt><xsl:if test="@Sync = 'TRUE'">
                    <span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:rulecat /></span>&#x2003;<xsl:value-of select="."/></dt>
              </xsl:for-each>
              <xsl:for-each select="rulehelp">
                <dt><xsl:if test="@Sync = 'TRUE'">
                    <span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:rulehelp /></span>&#x2003;<xsl:value-of select="."/></dt>
              </xsl:for-each>
              <xsl:if test="(ruletype | rulecat | rulehelp)"><br /><br /></xsl:if>

              <xsl:for-each select="rulefeid">
                <dt><xsl:if test="@Sync = 'TRUE'">
                    <span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:rulefeid /></span>&#x2003;<xsl:value-of select="."/></dt>
              </xsl:for-each>
              <xsl:for-each select="rulefest">
                <dt><xsl:if test="@Sync = 'TRUE'">
                    <span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:rulefest /></span>&#x2003;<xsl:value-of select="."/></dt>
              </xsl:for-each>
              <xsl:for-each select="ruleteid">
                <dt><xsl:if test="@Sync = 'TRUE'">
                    <span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:ruleteid /></span>&#x2003;<xsl:value-of select="."/></dt>
              </xsl:for-each>
              <xsl:for-each select="ruletest">
                <dt><xsl:if test="@Sync = 'TRUE'">
                    <span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:ruletest /></span>&#x2003;<xsl:value-of select="."/></dt>
              </xsl:for-each>
              <xsl:if test="(rulefeid | rulefest | ruleteid | ruletest)"><br /><br /></xsl:if>
              
              <xsl:for-each select="ruledjid">
                <dt><xsl:if test="@Sync = 'TRUE'">
                    <span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:ruledjid /></span>&#x2003;<xsl:value-of select="."/></dt>
              </xsl:for-each>
              <xsl:for-each select="ruledjst">
                <dt><xsl:if test="@Sync = 'TRUE'">
                    <span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:ruledjst /></span>&#x2003;<xsl:value-of select="."/></dt>
              </xsl:for-each>
              <xsl:for-each select="rulejunc">
                <dt><span class="esriElement"><res:rulejunc /></span></dt>
                <dd>
                <dl>
                  <xsl:for-each select="junctid">
                    <dt><xsl:if test="@Sync = 'TRUE'">
                        <span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:junctid /></span>&#x2003;<xsl:value-of select="."/></dt>
                  </xsl:for-each>
                  <xsl:for-each select="junctst">
                    <dt><xsl:if test="@Sync = 'TRUE'">
                        <span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:junctst /></span>&#x2003;<xsl:value-of select="."/></dt>
                  </xsl:for-each>
                </dl>
                </dd>
                <br />
              </xsl:for-each>
              <xsl:if test="(rulefeid | rulefest) and not (rulejunc)"><br /><br /></xsl:if>

              <xsl:for-each select="ruleeid">
                <dt><xsl:if test="@Sync = 'TRUE'">
                    <span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:ruleeid /></span>&#x2003;<xsl:value-of select="."/></dt>
              </xsl:for-each>
              <xsl:for-each select="ruleest">
                <dt><xsl:if test="@Sync = 'TRUE'">
                    <span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:ruleest /></span>&#x2003;<xsl:value-of select="."/></dt>
              </xsl:for-each>
              <xsl:for-each select="ruleemnc">
                <dt><xsl:if test="@Sync = 'TRUE'">
                    <span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:ruleemnc /></span>&#x2003;<xsl:value-of select="."/></dt>
              </xsl:for-each>
              <xsl:for-each select="ruleemxc">
                <dt><xsl:if test="@Sync = 'TRUE'">
                    <span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:ruleemxc /></span>&#x2003;<xsl:value-of select="."/></dt>
              </xsl:for-each>
              <xsl:if test="(ruleeid | ruleest | ruleemnc | ruleemxc)"><br /><br /></xsl:if>

              <xsl:for-each select="rulejid">
                <dt><xsl:if test="@Sync = 'TRUE'">
                    <span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:rulejid /></span>&#x2003;<xsl:value-of select="."/></dt>
              </xsl:for-each>
              <xsl:for-each select="rulejst">
                <dt><xsl:if test="@Sync = 'TRUE'">
                    <span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:rulejst /></span>&#x2003;<xsl:value-of select="."/></dt>
              </xsl:for-each>
              <xsl:for-each select="rulejmnc">
                <dt><xsl:if test="@Sync = 'TRUE'">
                    <span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:rulejmnc /></span>&#x2003;<xsl:value-of select="."/></dt>
              </xsl:for-each>
              <xsl:for-each select="rulejmxc">
                <dt><xsl:if test="@Sync = 'TRUE'">
                    <span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:rulejmxc /></span>&#x2003;<xsl:value-of select="."/></dt>
              </xsl:for-each>
              <xsl:if test="(rulejid | rulejst | rulejmnc | rulejmxc)"><br /><br /></xsl:if>
            </dl>
            </dd>
          </xsl:for-each>
          
	</dl>
	</dd><br />
  </dl>
</xsl:template>

	  <!-- Locators -->
<xsl:template match="/metadata/Esri/Locator" mode="arcgis">
  <a name="Locator" id="Locator"></a>
  <dl>
    <dd>
    <dl>
	  <xsl:for-each select="Style">
		<dt><span class="esriElement"><res:Style /></span>&#x2003;<xsl:value-of select="."/></dt>
		<br /><br />
	  </xsl:for-each>
	  <xsl:for-each select="Properties">
		<xsl:if test="FieldAliases[text()]">
		  <dt><span class="esriElement"><res:InputFields /></span></dt>
		  <dd>
		  <dl>
			<xsl:for-each select="FieldAliases">
			  <dt><span class="esriElement">-</span>&#x2003;<xsl:value-of select="."/></dt>
			</xsl:for-each>
		  </dl>
		  </dd>
		</xsl:if>
		<xsl:if test="(FileMAT | FileSTN | IntFileMAT | IntFileSTN)">
		  <br />
		  <dt><span class="esriElement"><res:RuleBases /></span></dt>
		  <dd>
		  <dl>
			<xsl:for-each select="FileMAT">
			  <dt><span class="esriElement"><res:FileMAT /></span>&#x2003;<xsl:value-of select="."/></dt>
			</xsl:for-each>
			<xsl:for-each select="FileSTN">
			  <dt><span class="esriElement"><res:FileSTN /></span>&#x2003;<xsl:value-of select="."/></dt>
			</xsl:for-each>
			<xsl:for-each select="IntFileMAT">
			  <dt><span class="esriElement"><res:IntFileMAT /></span>&#x2003;<xsl:value-of select="."/></dt>
			</xsl:for-each>
			<xsl:for-each select="IntFileSTN">
			  <dt><span class="esriElement"><res:IntFileSTN /></span>&#x2003;<xsl:value-of select="."/></dt>
			</xsl:for-each>
		  </dl>
		  </dd>
		</xsl:if>
		<xsl:for-each select="Fallback">
		  <br />
		  <dt><span class="esriElement"><res:Fallback /></span>&#x2003;<xsl:value-of select="."/></dt>
		</xsl:for-each>
	  </xsl:for-each>
	  
	</dl>
	</dd><br />
  </dl>
</xsl:template>

	  <!-- raster properties? -->
	  
<xsl:template match="/metadata/spdoinfo/ptvctinf/esriterm" mode="arcgis">
  <xsl:if test="position() = 1"><a name="FeatureClass" id="FeatureClass"></a></xsl:if>
  <dl>
    <dd>
    <dl>
		<dt><span class="esriElement"><res:FeatureClass /></span>&#x2003;<xsl:value-of select="@Name"/></dt>
		<dd>
		<dl>
		  <xsl:for-each select="efeatyp">
			<dt><xsl:if test="@Sync = 'TRUE'">
				<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:efeatyp /></span>&#x2003;<xsl:value-of select="."/></dt>
		  </xsl:for-each>
		  <xsl:for-each select="efeageom">
			  <xsl:choose>
				  <xsl:when test="@code">
					<dt><xsl:if test="@Sync = 'TRUE'">
						<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:efeageom /></span>&#x2003;<xsl:call-template name="GeometryTypeCode">
							<xsl:with-param name="code" select="." />
						</xsl:call-template>
					</dt>
				  </xsl:when>
				  <xsl:when test="(. != '') and number(.)">
					<dt><xsl:if test="@Sync = 'TRUE'">
						<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:efeageom /></span>&#x2003;<xsl:call-template name="GeometryTypeCode">
							<xsl:with-param name="code" select="." />
						</xsl:call-template>
					</dt>
				  </xsl:when>
				  <xsl:when test="(. != '') and not(number(.))">
					<dt><xsl:if test="@Sync = 'TRUE'">
						<span class="sync">*</span>&#x2009;</xsl:if><span class="element"><res:efeageom /></span>&#x2003;<xsl:value-of select="."/>
					</dt>
				  </xsl:when>
			  </xsl:choose>
		  </xsl:for-each>
		  <xsl:for-each select="esritopo">
			<dt><xsl:if test="@Sync = 'TRUE'">
				<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:esritopo /></span>&#x2003;<xsl:value-of select="."/></dt>
		  </xsl:for-each>
		  <xsl:for-each select="efeacnt">
			<dt><xsl:if test="@Sync = 'TRUE'">
				<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:efeacnt /></span>&#x2003;<xsl:value-of select="."/></dt>
		  </xsl:for-each>
		  <xsl:for-each select="spindex">
			<dt><xsl:if test="@Sync = 'TRUE'">
				<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:spindex /></span>&#x2003;<xsl:value-of select="."/></dt>
		  </xsl:for-each>
		  <xsl:for-each select="linrefer">
			<dt><xsl:if test="@Sync = 'TRUE'">
				<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:linrefer /></span>&#x2003;<xsl:value-of select="."/></dt>
		  </xsl:for-each>
		  <xsl:for-each select="netwrole">
			<dt><xsl:if test="@Sync = 'TRUE'">
				<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:netwrole /></span>&#x2003;<xsl:value-of select="."/></dt>
		  </xsl:for-each>
		  <xsl:for-each select="featdesc">
			<dt><xsl:if test="@Sync = 'TRUE'">
				<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:featdesc /></span>&#x2003;<xsl:value-of select="."/></dt>
		  </xsl:for-each>
		  <xsl:if test="(@Name | efeatyp | efeageom | esritopo | efeacnt | spindex | linrefer | linrefer | netwrole | featdesc) and (XYRank | ZRank | topoWeight | validateEvents | partTopoRules)"><br /><br /></xsl:if>

		  <xsl:for-each select="XYRank">
			<dt><xsl:if test="@Sync = 'TRUE'">
				<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:XYRank /></span>&#x2003;<xsl:value-of select="."/></dt>
		  </xsl:for-each>
		  <xsl:for-each select="ZRank">
			<dt><xsl:if test="@Sync = 'TRUE'">
				<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:ZRank /></span>&#x2003;<xsl:value-of select="."/></dt>
		  </xsl:for-each>
		  <xsl:for-each select="topoWeight">
			<dt><xsl:if test="@Sync = 'TRUE'">
				<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:topoWeight /></span>&#x2003;<xsl:value-of select="."/></dt>
		  </xsl:for-each>
		  <xsl:for-each select="validateEvents">
			<dt><xsl:if test="@Sync = 'TRUE'">
				<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:validateEvents /></span>&#x2003;<xsl:value-of select="."/></dt>
		  </xsl:for-each>
		  <xsl:if test="partTopoRules">
			<dt><span class="sync">*</span>&#x2009;<span class="esriElement"><res:partTopoRules /></span>&#x2003;
			<xsl:for-each select="partTopoRules/topoRuleID">
			  <xsl:value-of select="."/><xsl:if test="not(position() = last())">, </xsl:if>
			</xsl:for-each>
			</dt>
		  </xsl:if>
		</dl>
		</dd>
	</dl>
	</dd><br />
  </dl>
  <xsl:if test="position() = last()">
  </xsl:if>
</xsl:template>
	  
<!-- Entity and Attribute -->
<xsl:template match="/metadata/eainfo" mode="arcgis">
  <a name="Field" id="Field"></a>
  <dl>
    <dd>
    <dl>

      <xsl:for-each select="detailed">
        <xsl:choose>
			<xsl:when test="(enttyp/enttypt[. = 'Relationship']) and @Name">
				<dt><span class="esriElement"><res:ParticipatesIn /></span>&#x2003;<xsl:value-of select="@Name"/>&#x20;<xsl:value-of select="enttyp/enttypt"/></dt>
			</xsl:when>
			<xsl:when test="(enttyp/enttypt[. != '']) and @Name">
				<dt><xsl:value-of select="@Name"/>&#160;<xsl:value-of select="enttyp/enttypt"/></dt>
			</xsl:when>
			<xsl:when test="(enttyp/enttypt[. != '']) and (enttyp/enttypl[. != ''])">
				<dt><xsl:value-of select="enttyp/enttypl"/>&#160;<xsl:value-of select="enttyp/enttypt"/></dt>
			</xsl:when>
			<xsl:when test="@Name">
				<dt><xsl:value-of select="@Name"/></dt>
			</xsl:when>
			<xsl:when test="(enttyp/enttypl[. != ''])">
				<dt><xsl:value-of select="enttyp/enttypl"/></dt>
			</xsl:when>
			<xsl:otherwise>
				<dt><span class="esriElement"><res:Fields /></span></dt>
			</xsl:otherwise>
          </xsl:choose>

          <dd>
          <dl>
              <xsl:for-each select="enttyp/enttypc">
                <dt><xsl:if test="@Sync = 'TRUE'">
                    <span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:RowCount /></span>&#x2003;<xsl:value-of select="."/></dt>
              </xsl:for-each>
              <xsl:for-each select="enttyp/enttypd">
                <dt><span class="esriElement"><res:enttypd /></span></dt>
                <dd><xsl:value-of select="." /></dd>
              </xsl:for-each>
              <xsl:for-each select="enttyp/enttypds">
                <dt><span class="esriElement"><res:enttypds /></span></dt>
                <dd><xsl:value-of select="." /></dd>
              </xsl:for-each>

			  <xsl:if test="./attr or ./subtype"><br /><br /></xsl:if>
			  <xsl:for-each select="attr">
			    <xsl:variable name="fieldName">
					<xsl:choose>
						<xsl:when test="attrlabl"><xsl:value-of select="attrlabl"/></xsl:when>
						<xsl:when test="not(attrlabl) and ./@Name"><xsl:value-of select="./@Name"/></xsl:when>
					</xsl:choose>
			    </xsl:variable>
			  
				<dt><span class="esriElement"><res:Field /></span>&#x2003;<xsl:value-of select="$fieldName"/></dt>
				<dd>
				<dl>
				  <xsl:for-each select="attalias">
					<dt><xsl:if test="@Sync = 'TRUE'">
						<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:attalias /></span>&#x2003;<xsl:value-of select="."/></dt>
				  </xsl:for-each>
	
				  <xsl:for-each select="attrtype">
					<dt><xsl:if test="@Sync = 'TRUE'">
						<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:attrtype /></span>&#x2003;<xsl:value-of select="."/></dt>
				  </xsl:for-each>
				  <xsl:for-each select="attwidth[. != 0]">
					<dt><xsl:if test="@Sync = 'TRUE'">
						<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:attwidth /></span>&#x2003;<xsl:value-of select="."/></dt>
				  </xsl:for-each>
				  <xsl:for-each select="atprecis[. != 0]">
					<dt><xsl:if test="@Sync = 'TRUE'">
						<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:atprecis /></span>&#x2003;<xsl:value-of select="."/></dt>
				  </xsl:for-each>
				  <xsl:for-each select="attscale[. != 0]">
					<dt><xsl:if test="@Sync = 'TRUE'">
						<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:attscale /></span>&#x2003;<xsl:value-of select="."/></dt>
				  </xsl:for-each>
				  <xsl:for-each select="atoutwid[. != 0]">
					<dt><xsl:if test="@Sync = 'TRUE'">
						<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:atoutwid /></span>&#x2003;<xsl:value-of select="."/></dt>
				  </xsl:for-each>
				  <xsl:for-each select="atnumdec[. != 0]">
					<dt><xsl:if test="@Sync = 'TRUE'">
						<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:atnumdec /></span>&#x2003;<xsl:value-of select="."/></dt>
				  </xsl:for-each>
				  <xsl:for-each select="atindex">
					<dt><xsl:if test="@Sync = 'TRUE'">
						<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:atindex /></span>&#x2003;<xsl:value-of select="."/></dt>
				  </xsl:for-each>
	
				  <xsl:for-each select="attrdef">
					  <dt><xsl:if test="@Sync = 'TRUE'">
						  <span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:attrdef /></span></dt>
			          <dl><dd><pre class="wrap">
						  <xsl:call-template name="handleURLs">
							  <xsl:with-param name="text" select="."/>
						  </xsl:call-template>
					  </pre></dd></dl>
				  </xsl:for-each>
				  <xsl:for-each select="attrdefs">
					  <dt><xsl:if test="@Sync = 'TRUE'">
						  <span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:attrdefs /></span></dt>
				      <dl><dd><pre class="wrap">
						  <xsl:call-template name="handleURLs">
							  <xsl:with-param name="text" select="."/>
						  </xsl:call-template>
					  </pre></dd></dl>
				  </xsl:for-each>
	
				  <xsl:choose>
					<xsl:when test="attrdef"></xsl:when>
					<xsl:when test="not(attrdef or attrdefs) and (../subtype[stfield/stfldnm = $fieldName]) and attrdomv"><br /><br /></xsl:when>
					<xsl:when test="not(attrdef or attrdefs) and not(../subtype[stfield/stfldnm = $fieldName]) and attrdomv"><br /><br /></xsl:when>
					<xsl:when test="not(attrdef or attrdefs) and (../subtype[stfield/stfldnm = $fieldName])and not(attrdomv)"><br /><br /></xsl:when>
					<xsl:when test="not(attrdef) and not(../subtype[stfield/stfldnm = $fieldName]) and not(attrdomv)"><br /><br /></xsl:when>
				  </xsl:choose>
	
				  <xsl:for-each select="../subtype[stfield/stfldnm = $fieldName]">
					  <xsl:if test="position() = 1"><dt><span class="esriElement"><res:subtype /></span></dt></xsl:if>
					  <dd>
					  <dl>
						  <dd>
						  <dl class="subtype">
							<xsl:if test="position() = 1">
								<dt class="header"><span class="sync">*</span>&#x2009;<span class="esriElement"><res:subtypeName /></span></dt>
								<dd class="header"><span class="sync">*</span>&#x2009;<span class="esriElement"><res:subtypeDefaultValue /></span></dd>
							</xsl:if>
							<dt><xsl:value-of select="stname"/> (<xsl:value-of select="stcode"/>)</dt>
							<xsl:choose>
								<xsl:when test="stfield[stfldnm = $fieldName]/stflddv">
									<xsl:for-each select="stfield[stfldnm = $fieldName]/stflddv">
										<dd><xsl:value-of select="."/></dd>
									</xsl:for-each>
								</xsl:when>
								<xsl:otherwise>
									<dd>no default value</dd>
								</xsl:otherwise>
							</xsl:choose>
						  </dl>
						  </dd>
					  </dl>

					  <xsl:if test="(position() = last())"><br /></xsl:if>
					  <xsl:if test="(position() = last()) and (stfield[stfldnm = $fieldName]/stflddd)">
						<dl>
						<dd>
						  <xsl:for-each select="stfield[stfldnm = $fieldName]/stflddd">
							<dt><xsl:if test="@Sync = 'TRUE'">
									<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:stDomain /></span>&#x2003;<xsl:value-of select="domname"/></dt>
							<dd>
							<dl>
							  <xsl:for-each select="domtype">
								<dt><xsl:if test="@Sync = 'TRUE'">
									<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:domtype /></span>&#x2003;<xsl:value-of select="."/></dt>
							  </xsl:for-each>
							  <xsl:for-each select="domdesc">
								<dt><xsl:if test="@Sync = 'TRUE'">
									<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:domdesc /></span>&#x2003;<xsl:value-of select="."/></dt>
							  </xsl:for-each>
							  <xsl:for-each select="mrgtype">
								<dt><xsl:if test="@Sync = 'TRUE'">
									<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:mrgtype /></span>&#x2003;<xsl:value-of select="."/></dt>
							  </xsl:for-each>
							  <xsl:for-each select="splttype">
								<dt><xsl:if test="@Sync = 'TRUE'">
									<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:splttype /></span>&#x2003;<xsl:value-of select="."/></dt>
							  </xsl:for-each>
							</dl>
							</dd>
						  </xsl:for-each>
						</dd>
						</dl><br />
					  </xsl:if>

					  </dd>
				  </xsl:for-each>
	
				  <xsl:for-each select="attrdomv">
				    <xsl:choose>
						<xsl:when test="./edom">
							<dt><span class="esriElement"><res:edom /></span></dt>
						</xsl:when>
						<xsl:when test="./codesetd">
							<dt><span class="esriElement"><res:codesetd /></span></dt>
						</xsl:when>
						<xsl:when test="./rdom">
							<dt><span class="esriElement"><res:rdom /></span></dt>
						</xsl:when>
						<xsl:when test="./udom">
						</xsl:when>
						<xsl:otherwise>
							<dt><span class="esriElement"><res:udom /></span></dt><br /><br />
						</xsl:otherwise>
					</xsl:choose>
					<xsl:for-each select="edom">
						<dd>
						<dl>
						  <xsl:for-each select="edomv">
							<dt><span class="esriElement"><res:edomv /></span>&#x2003;<xsl:value-of select="."/></dt>
						  </xsl:for-each>
						  <xsl:for-each select="edomvd">
							  <dt><span class="esriElement"><res:edomvd /></span>&#x2003;<xsl:value-of select="."/></dt>
						  </xsl:for-each>
						  <xsl:for-each select="edomvds">
							  <dt><span class="esriElement"><res:edomvds /></span>&#x2003;<xsl:value-of select="."/></dt>
						  </xsl:for-each>
						  <xsl:for-each select="attr">
							<dt><span class="esriElement"><res:edom_attr /></span>&#x2003;<xsl:value-of select="."/></dt>
						  </xsl:for-each>
						</dl>
						</dd>
						<br />
					  </xsl:for-each>
	
					  <xsl:for-each select="rdom">
						<dd>
						<dl>
						  <xsl:for-each select="rdommin">
							<dt><span class="esriElement"><res:rdommin /></span>&#x2003;<xsl:value-of select="."/></dt>
						  </xsl:for-each>
						  <xsl:for-each select="rdommax">
							<dt><span class="esriElement"><res:rdommax /></span>&#x2003;<xsl:value-of select="."/></dt>
						  </xsl:for-each>
						  <!-- ESRI Profile element  -->
						  <xsl:for-each select="rdommean">
							<dt><span class="esriElement"><res:rdommean /></span>&#x2003;<xsl:value-of select="."/></dt>
						  </xsl:for-each>
						  <!-- ESRI Profile element  -->
						  <xsl:for-each select="rdomstdv">
							<dt><span class="esriElement"><res:rdomstdv /></span>&#x2003;<xsl:value-of select="."/></dt>
						  </xsl:for-each>
						  <xsl:for-each select="attrunit">
							<dt><span class="esriElement"><res:attrunit /></span>&#x2003;<xsl:value-of select="."/></dt>
						  </xsl:for-each>
						  <xsl:for-each select="attrmres">
							<dt><span class="esriElement"><res:attrmres /></span>&#x2003;<xsl:value-of select="."/></dt>
						  </xsl:for-each>
						  <xsl:for-each select="attr">
							<dt><span class="esriElement"><res:rdom_attr /></span>&#x2003;<xsl:value-of select="."/></dt>
						  </xsl:for-each>
						</dl>
						</dd>
						<br />
					  </xsl:for-each>
	
					  <xsl:for-each select="codesetd">
						<dd>
						<dl>
						  <xsl:for-each select="codesetn">
							<dt><span class="esriElement"><res:codesetn /></span>&#x2003;<xsl:value-of select="."/></dt>
						  </xsl:for-each>
						  <xsl:for-each select="codesets">
							<dt><span class="esriElement"><res:codesets /></span>&#x2003;<xsl:value-of select="."/></dt>
						  </xsl:for-each>
						</dl>
						</dd>
						<br />
					  </xsl:for-each>
	
					  <xsl:for-each select="udom">
						<dt><xsl:if test="@Sync = 'TRUE'">
							<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:udomDesc /></span>&#x2003;<xsl:value-of select="."/></dt>
						<br /><br />
					  </xsl:for-each>
				  </xsl:for-each>

				  <xsl:for-each select="begdatea">
					<dt><span class="esriElement"><res:begdatea /></span>&#x2003;<xsl:value-of select="."/></dt>
				  </xsl:for-each>
				  <xsl:for-each select="enddatea">
					<dt><span class="esriElement"><res:enddatea /></span>&#x2003;<xsl:value-of select="."/></dt>
				  </xsl:for-each>
				  <xsl:if test="(begdatea | enddatea)"><br /><br /></xsl:if>
	
				  <xsl:for-each select="attrvai">
					<dt><span class="esriElement"><res:attrvai /></span></dt>
					<dd>
					<dl>
					  <xsl:for-each select="attrva">
						<dt><span class="esriElement"><res:attrva /></span>&#x2003;<xsl:value-of select="."/></dt>
					  </xsl:for-each>
					  <xsl:for-each select="attrvae">
						<dt><span class="esriElement"><res:attrvae /></span></dt>
						<dl><dd><pre class="wrap"><xsl:value-of select="." /></pre></dd></dl>
					  </xsl:for-each>
					</dl>
					</dd>
				  </xsl:for-each>
				  <xsl:for-each select="attrmfrq">
					<dt><span class="esriElement"><res:attrmfrq /></span>&#x2003;<xsl:value-of select="."/></dt><br /><br />
				  </xsl:for-each>
				</dl>
				</dd>
			  </xsl:for-each>

          </dl>
          </dd>
		  <xsl:if test="not(position() = last())"><br /></xsl:if>
	  </xsl:for-each>
    </dl>
    </dd>
  </dl><br />
</xsl:template>

<!-- Entity and Attribute -->
<xsl:template match="/metadata/eainfo/relinfo" mode="arcgis">
  <a name="Relationship" id="Relationship"></a>
  <dl>
    <dd>
    <dl>
	  <xsl:for-each select="reldesc">
		<dt><xsl:if test="@Sync = 'TRUE'">
			<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:reldesc /></span>&#x2003;<xsl:value-of select="."/></dt>
	  </xsl:for-each>
	  <xsl:for-each select="relcard">
		<dt><xsl:if test="@Sync = 'TRUE'">
			<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:relcard /></span>&#x2003;<xsl:value-of select="."/></dt>
	  </xsl:for-each>
	  <xsl:for-each select="relattr">
		<dt><xsl:if test="@Sync = 'TRUE'">
			<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:relattr /></span>&#x2003;<xsl:value-of select="."/></dt>
	  </xsl:for-each>
	  <xsl:for-each select="relcomp">
		<dt><xsl:if test="@Sync = 'TRUE'">
			<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:relcomp /></span>&#x2003;<xsl:value-of select="."/></dt>
	  </xsl:for-each>
	  <xsl:for-each select="relnodir">
		<dt><xsl:if test="@Sync = 'TRUE'">
			<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:relnodir /></span>&#x2003;<xsl:value-of select="."/></dt>
	  </xsl:for-each>
	  <xsl:if test="(reldesc | relcard | relattr | relcomp | relnodir)"><br /><br /></xsl:if>

	  <dt><span class="esriElement"><res:otfc /></span></dt>
	  <dd>
		<dl>	
		  <xsl:for-each select="otfcname">
			<dt><xsl:if test="@Sync = 'TRUE'">
				<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:otfcname /></span>&#x2003;<xsl:value-of select="."/></dt>
		  </xsl:for-each>
		  <xsl:for-each select="otfcpkey">
			<dt><xsl:if test="@Sync = 'TRUE'">
				<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:otfcpkey /></span>&#x2003;<xsl:value-of select="."/></dt>
		  </xsl:for-each>
		  <xsl:for-each select="otfcfkey">
			<dt><xsl:if test="@Sync = 'TRUE'">
				<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:otfcfkey /></span>&#x2003;<xsl:value-of select="."/></dt>
		  </xsl:for-each>
		</dl>
	  </dd>
	  
	  <dt><span class="esriElement"><res:dtfc /></span></dt>
	  <dd>
		<dl>	
		  <xsl:for-each select="dtfcname">
			<dt><xsl:if test="@Sync = 'TRUE'">
				<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:otfcname /></span>&#x2003;<xsl:value-of select="."/></dt>
		  </xsl:for-each>
		  <xsl:for-each select="dtfcpkey">
			<dt><xsl:if test="@Sync = 'TRUE'">
				<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:otfcpkey /></span>&#x2003;<xsl:value-of select="."/></dt>
		  </xsl:for-each>
		  <xsl:for-each select="dtfcfkey">
			<dt><xsl:if test="@Sync = 'TRUE'">
				<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:otfcfkey /></span>&#x2003;<xsl:value-of select="."/></dt>
		  </xsl:for-each>
		</dl>
	  </dd>
	  <xsl:if test="(otfcname | otfcpkey | otfcfkey | dtfcname | dtfcpkey | dtfcfkey)"><br /><br /></xsl:if>

	  <xsl:for-each select="relflab">
		<dt><xsl:if test="@Sync = 'TRUE'">
			<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:relflab /></span>&#x2003;<xsl:value-of select="."/></dt>
	  </xsl:for-each>
	  <xsl:for-each select="relblab">
		<dt><xsl:if test="@Sync = 'TRUE'">
			<span class="sync">*</span>&#x2009;</xsl:if><span class="esriElement"><res:relblab /></span>&#x2003;<xsl:value-of select="."/></dt>
	  </xsl:for-each>
	  <xsl:if test="(relflab | relblab)"><br /><br /></xsl:if>
	  
    </dl>
    </dd>
  </dl><br />
</xsl:template>

<!-- BINARY INFORMATION -->

<!-- Thumbnail -->
<xsl:template match="/metadata/Binary/Thumbnail/img[@src]" mode="arcgis">
    <img name="thumbnail" id="thumbnail" alt="Thumbnail" title="Thumbnail">
        <xsl:attribute name="src"><xsl:value-of select="@src"/></xsl:attribute>
    </img>
</xsl:template>

<!-- Enclosures -->
<xsl:template match="Binary" mode="arcgis">
  <a name="Binary_Enclosures" id="Binary_Enclosures"></a>
  <dl>
    <dd>
    <dl>
      <xsl:for-each select="Thumbnail">
        <dt><span class="esriElement"><res:Thumbnail /></span></dt>
        <dd>
        <dl>
          <xsl:for-each select="img">
            <dt><span class="esriElement"><res:EnclosureType /></span>&#x2003;<res:Picture /></dt>
            <br /><br />
            <img name="thumbnail" id="thumbnail" alt="Thumbnail" title="Thumbnail">
              <xsl:attribute name="src"><xsl:value-of select="@src"/></xsl:attribute>
            </img>
          </xsl:for-each>
        </dl>
        </dd>
        <br />
      </xsl:for-each>

      <xsl:for-each select="Enclosure">
        <dt><span class="esriElement"><res:Enclosure /></span></dt>
        <dd>
        <dl>
          <xsl:for-each select="*/@EsriPropertyType">
            <dt><span class="esriElement"><res:EnclosureType /></span>&#x2003;<xsl:value-of select="."/></dt>
          </xsl:for-each>
          <xsl:for-each select="img">
            <dt><span class="esriElement"><res:EnclosureType /></span>&#x2003;<res:Image /></dt>
           </xsl:for-each>
          <xsl:for-each select="*/@OriginalFileName">
            <dt><span class="esriElement"><res:OriginalFileName /></span>&#x2003;<xsl:value-of select="."/></dt>
          </xsl:for-each>
          <xsl:for-each select="Descript">
            <dt><span class="esriElement"><res:Descript /></span>&#x2003;<xsl:value-of select="."/></dt>
          </xsl:for-each>
          <xsl:for-each select="*/@SourceMetadata">
            <dt><span class="esriElement"><res:SourceMetadata /></span>&#x2003;<xsl:value-of select="."/></dt>
          </xsl:for-each>
          <xsl:for-each select="img">
            <dd>
              <br />
				<img class="enclosed">
				  <xsl:attribute name="src"><xsl:value-of select="@src"/></xsl:attribute>
					<xsl:attribute name="title"><xsl:value-of select="img/@OriginalFileName"/></xsl:attribute>
					<xsl:attribute name="alt"><xsl:value-of select="img/@OriginalFileName"/></xsl:attribute>
				</img>
            </dd>
           </xsl:for-each>
        </dl>
        </dd>
        <br />
      </xsl:for-each>
    </dl>
    </dd>
  </dl>
</xsl:template>

</xsl:stylesheet>