<?xml version="1.0" encoding="UTF-8"?>
<!-- Processes ArcGIS metadata to remove all elements containing information added automatically by ArcGIS. -->
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
	
	<!-- exclude elements containing content that was added automatically by an ArcGIS metadata synchronizer -->
	<!-- Synchronized elements have a Sync attribute with the value TRUE. -->
	<!-- A documentation template should not include properties. -->
	<!-- Remove automatically-generated content to produce a template. -->
	<xsl:template match="*[@Sync = 'TRUE']" priority="1" >
	</xsl:template>

</xsl:stylesheet>
