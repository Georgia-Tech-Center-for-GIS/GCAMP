<?xml version="1.0" encoding="UTF-8"?>
<!-- Processes ArcGIS metadata to remove empty XML elements to avoid exporting and validation errors. -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="no" />

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
	
	<!-- copy all elements that have text; don't copy elements with no content -->
	<!-- don't exclude empty elements with text in a value attribute -->
	<xsl:template match="*" priority="1">
		<xsl:if test="(. != '')">
			<xsl:copy>
				<xsl:apply-templates select="node() | @*" />
			</xsl:copy>
		</xsl:if>
		<xsl:if test="(. = '') and (.//@*[not(name() = 'Sync')] != '')">
			<xsl:copy>
				<xsl:apply-templates select="node() | @*" />
			</xsl:copy>
		</xsl:if>
	</xsl:template>

</xsl:stylesheet>
