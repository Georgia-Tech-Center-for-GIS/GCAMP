<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 	xmlns:gmd="http://www.isotc211.org/2005/gmd" >

<!-- An XSLT template for displaying metadata in ArcGIS that is stored in the ArcGIS metadata format.

     Copyright (c) 2009-2010, Environmental Systems Research Institute, Inc. All rights reserved.
	
     Revision History: Created 3/19/2009 avienneau
-->

  <xsl:import href = "ArcGIS_Imports\general.xslt" />
  <xsl:import href = "ArcGIS_Imports\ItemDescription.xslt" />
  <xsl:import href = "ArcGIS_Imports\geoprocessing.xslt" />
  <xsl:import href = "ArcGIS_Imports\auxLanguages.xslt" />
  <xsl:import href = "ArcGIS_Imports\auxCountries.xslt" />
  <xsl:import href = "ArcGIS_Imports\auxUCUM.xslt" />

  <xsl:output method="xml" indent="yes" encoding="UTF-8" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd" />
  
  <xsl:param name="flowdirection"/>

  <xsl:template match="/">
  <html xmlns="http://www.w3.org/1999/xhtml">
  <xsl:if test="/*/@xml:lang[. != '']">
	  <xsl:attribute name="xml:lang"><xsl:value-of select="/*/@xml:lang"/></xsl:attribute>
	  <xsl:attribute name="lang"><xsl:value-of select="/*/@xml:lang"/></xsl:attribute>
  </xsl:if>
  
  <head>
    <meta http-equiv="content-type" content="text/html; charset=UTF-8"/>
    <xsl:call-template name="styles" />
    <xsl:call-template name="scripts" />
  </head>

  <body oncontextmenu="return true">
  <xsl:if test="$flowdirection = 'RTL'">
    <xsl:attribute name="style">direction:rtl;</xsl:attribute>
  </xsl:if>
  
	<xsl:choose>
		<xsl:when test="/metadata/tool | /metadata/toolbox">
			<xsl:call-template name="gp"/> 
		</xsl:when>
		<xsl:otherwise>
			<xsl:call-template name="iteminfo"/> 
		</xsl:otherwise>
	</xsl:choose>

  </body>
  </html>

</xsl:template>

</xsl:stylesheet>