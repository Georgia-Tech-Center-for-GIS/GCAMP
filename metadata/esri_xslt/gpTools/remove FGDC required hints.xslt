<?xml version="1.0" encoding="UTF-8"?>
<!-- Processes ArcGIS metadata to remove REQUIRED text added by ArcGIS to FGDC metadata elements by previous releases. -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >
	<xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="no" />

	<!-- start processing all nodes and attributes in the XML document -->
	<!-- any CDATA blocks in the original XML will be lost because they can't be handled by XSLT -->
	<xsl:template match="/">
		<xsl:apply-templates select="node() | @*" />
	</xsl:template>
	
	<!-- copy all nodes and attributes in the XML document -->
	<xsl:template match="node() | @*" priority="0" >
		<xsl:copy>
			<xsl:apply-templates select="node() | @*" />
		</xsl:copy>
	</xsl:template>

	<!-- templates below override the default template above that copies all noes and attributes -->
	
	<!-- only copy elements that do not contain default REQUIRED text added by ArcGIS to some FGDC metadata element by previous releases -->
	<xsl:template match="*" priority="1" >
		<xsl:if test="not(contains (text(), 'REQUIRED.') or contains (text(), 'REQUIRED:'))">
			<xsl:copy>
				<xsl:apply-templates select="node() | @*" />
			</xsl:copy>
		</xsl:if>
	</xsl:template>
	
</xsl:stylesheet>
