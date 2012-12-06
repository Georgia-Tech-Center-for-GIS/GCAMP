<?xml version="1.0"?>
<!-- Processes ArcGIS metadata to remove existing unique identifiers, if present, and add a new unique identifier. -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:esri="http://www.esri.com/metadata/">
	<xsl:output method="xml" indent="yes" version="1.0" encoding="UTF-8" omit-xml-declaration="no"/>

	<xsl:param name="gpparam" />
	<xsl:variable name="newID" select="esri:GuidGen()" />
	
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
	
	<!-- add Esri section including PublishedDocID if it doesn't already exist -->
	<xsl:template match="metadata" priority="1">
		<xsl:copy>
			<xsl:apply-templates select="node() | @*" />
			<xsl:if test="count (./Esri) = 0">
				<Esri>
					<PublishedDocID>{<xsl:value-of select="$newID"/>}</PublishedDocID>
				</Esri>
			</xsl:if>
		</xsl:copy>
	</xsl:template>
	
	<!-- copy existing Esri section, add a PublishedDocID if one doesn't exist -->
	<xsl:template match="Esri" priority="1">
		<xsl:copy>
			<xsl:apply-templates select="node() | @*" />
			<xsl:if test="count (PublishedDocID) = 0">
				<PublishedDocID>{<xsl:value-of select="$newID"/>}</PublishedDocID>
			</xsl:if>
		</xsl:copy>
	</xsl:template>

	<!-- replace existing PublishedDocID -->
	<xsl:template match="PublishedDocID" priority="1">
		<xsl:choose>
			<xsl:when test="(esri:strtoupper($gpparam) = 'OVERWRITE')">
				<PublishedDocID>{<xsl:value-of select="$newID"/>}</PublishedDocID>
			</xsl:when>
			<xsl:otherwise>
				<xsl:copy>      
					<xsl:apply-templates select="node() | @*" />
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<!-- remove existing PublishStatus -->
	<xsl:template match="PublishStatus" priority="1">
		<xsl:choose>
			<xsl:when test="(esri:strtoupper($gpparam) = 'OVERWRITE')"></xsl:when>
			<xsl:otherwise>
				<xsl:copy>      
					<xsl:apply-templates select="node() | @*" />
				</xsl:copy>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>
