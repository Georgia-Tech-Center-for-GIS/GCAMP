<?xml version="1.0" encoding="UTF-8"?>
<!-- Processes ArcGIS metadata to merge original FGDC metadata and transformed ArcGIS metadata. -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="no" />

	<xsl:param name="gpparam" />

	<!-- start processing all nodes and attributes in the XML document -->
	<!-- any CDATA blocks in the original XML will be lost because they can't be handled by XSLT -->
	<xsl:template match="/">
		<xsl:apply-templates select="node() | @*" />
	</xsl:template>

	<!-- copy all nodes and attributes in the XML document -->
	<xsl:template match="node() | @*" priority="0">
		<xsl:copy>
			<xsl:apply-templates select="node() | @*" />
		</xsl:copy>
	</xsl:template>
	
	<!-- templates below override the default template above that copies all noes and attributes -->

	<!-- exclude original ESRI-ISO elements from the output -->
	<xsl:template match="mdFileID | mdLang | mdChar | mdParentID | mdHrLv | mdHrLvName | mdContact | mdDateSt | mdStanName | mdStanVer | distInfo | dataIdInfo | appSchInfo | porCatInfo | mdMaint | mdConst | dqInfo | spatRepInfo | refSysInfo | contInfo | mdExtInfo | dataSetURI | dataSetFn | loc | svIdInfo | series | describes | propType | featType | featAttr | taxSys | miAcquInfo" priority="1" >
	</xsl:template>

	<!-- copy existing Esri section, add ArcGISFormat if one doesn't exist -->
	<xsl:template match="Esri" priority="1" >
		<xsl:copy>
			<xsl:apply-templates select="node() | @*" />
			<xsl:if test="count (ArcGISFormat) = 0">
				<ArcGISFormat>1.0</ArcGISFormat>
			</xsl:if>
		</xsl:copy>
	</xsl:template>

	<!-- copy existing Binary section, add original document as an enclosure if document was not previously upgraded from FGDC -->
	<xsl:template match="Binary" priority="1" >
		<xsl:copy>
			<xsl:apply-templates select="node() | @*" />
			<xsl:if test="(count (Enclosure) = 0)">
				<xsl:copy-of select="document($gpparam)/metadata/Binary/Enclosure"/>
			</xsl:if>
			<xsl:if test="(count (Enclosure/Data) > 0) and (count (Enclosure/Data/@SourceMetadataSchema) = 0)">
				<xsl:copy-of select="document($gpparam)/metadata/Binary/Enclosure"/>
			</xsl:if>
		</xsl:copy>
	</xsl:template>	

	<!-- add Esri section with ArcGISFormat and Binary section with original document if these sections don't already exist -->
	<xsl:template match="metadata" priority="1" >
		<xsl:copy>
			<xsl:apply-templates select="node() | @*" />
			<xsl:copy-of select="document($gpparam)/metadata/mdFileID"/>
			<xsl:copy-of select="document($gpparam)/metadata/mdLang"/>
			<xsl:copy-of select="document($gpparam)/metadata/mdChar"/>
			<xsl:copy-of select="document($gpparam)/metadata/mdParentID"/>
			<xsl:copy-of select="document($gpparam)/metadata/mdHrLv"/>
			<xsl:copy-of select="document($gpparam)/metadata/mdHrLvName"/>
			<xsl:copy-of select="document($gpparam)/metadata/mdContact"/>
			<xsl:copy-of select="document($gpparam)/metadata/mdDateSt"/>
			<xsl:copy-of select="document($gpparam)/metadata/mdStanName"/>
			<xsl:copy-of select="document($gpparam)/metadata/mdStanVer"/>
			<xsl:copy-of select="document($gpparam)/metadata/distInfo"/>
			<xsl:copy-of select="document($gpparam)/metadata/dataIdInfo"/>
			<xsl:copy-of select="document($gpparam)/metadata/appSchInfo"/>
			<xsl:copy-of select="document($gpparam)/metadata/porCatInfo"/>
			<xsl:copy-of select="document($gpparam)/metadata/mdMaint"/>
			<xsl:copy-of select="document($gpparam)/metadata/mdConst"/>
			<xsl:copy-of select="document($gpparam)/metadata/dqInfo"/>
			<xsl:copy-of select="document($gpparam)/metadata/spatRepInfo"/>
			<xsl:copy-of select="document($gpparam)/metadata/refSysInfo"/>
			<xsl:copy-of select="document($gpparam)/metadata/contInfo"/>
			<xsl:copy-of select="document($gpparam)/metadata/mdExtInfo"/>
			<xsl:copy-of select="document($gpparam)/metadata/dataSetURI"/>
			<xsl:copy-of select="document($gpparam)/metadata/dataSetFn"/>
			<xsl:copy-of select="document($gpparam)/metadata/loc"/>
			<xsl:copy-of select="document($gpparam)/metadata/svIdInfo"/>
			<xsl:copy-of select="document($gpparam)/metadata/series"/>
			<xsl:copy-of select="document($gpparam)/metadata/describes"/>
			<xsl:copy-of select="document($gpparam)/metadata/propType"/>
			<xsl:copy-of select="document($gpparam)/metadata/featType"/>
			<xsl:copy-of select="document($gpparam)/metadata/featAttr"/>
			<xsl:copy-of select="document($gpparam)/metadata/taxSys"/>
			<xsl:copy-of select="document($gpparam)/metadata/miAcquInfo"/>
			<xsl:if test="count (./Esri) = 0">
				<Esri>
					<ArcGISFormat>1.0</ArcGISFormat>
				</Esri>
			</xsl:if>
			<xsl:if test="count (./Binary) = 0">
				<Binary>
					<xsl:copy-of select="document($gpparam)/metadata/Binary/Enclosure"/>
				</Binary>
			</xsl:if>
		</xsl:copy>
	</xsl:template>

</xsl:stylesheet>
