<?xml version="1.0" encoding="UTF-8"?>
<!-- Processes ArcGIS metadata to remove existing unique identifiers, if present. -->
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
	
	<!-- exclude all elements containing unique identifiers for the document and previous ArcIMS publishing information from the output -->
	<!-- For content that will be reused or associated with many documents, as with templates, do not copy unique identifiers. -->
	<xsl:template match="MetaID | PublishedDocID | PublishStatus | Identifier | mdFileID" priority="1" >
	</xsl:template>

</xsl:stylesheet>
