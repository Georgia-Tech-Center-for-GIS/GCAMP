<?xml version="1.0" encoding="UTF-8"?>
<!-- Processes ArcGIS metadata to remove local machine names from metadata before it is published. -->
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
	
	<!-- exclude machine names from the public version of metadata -->
	<!-- URL or ftp addresses will not be modified -->
  <!-- Remove SDE server connection information if present; leave ArcIMS connection informatin -->
  <xsl:template match="onlink | linkage" priority="1" >
    <xsl:choose>
      <xsl:when test="(contains (., 'http://')) or (contains (., 'ftp://'))">
        <xsl:copy>
          <xsl:apply-templates select="node() | @*" />
        </xsl:copy>
      </xsl:when>
      <xsl:when test="starts-with(., 'Server=')">
        <xsl:choose>
          <xsl:when test="(substring(.,8,4) = 'http')">
            <xsl:copy>
              <xsl:apply-templates select="node() | @* " />
            </xsl:copy>
          </xsl:when>
          <xsl:otherwise>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
    </xsl:choose>
  </xsl:template>
	
	<!-- check all elements to see if their value starts with the double-backslash that begins a UNC path -->
	<!-- if so, remove the machine name from the UNC path, but leave the remaining information -->
	<xsl:template match="*[starts-with(., '\\')]" priority="1" >
		<xsl:copy>
      <xsl:apply-templates select="* | comment() | @*" />
      <xsl:value-of select="substring-after(substring-after(., '\\'), '\')" />
    </xsl:copy>
	</xsl:template>

  <!-- Remove REALLY OLD SDE connection information from FGDC distribution section, if present -->
  <xsl:template match="sdeconn" priority="1" >
  </xsl:template>

</xsl:stylesheet>
