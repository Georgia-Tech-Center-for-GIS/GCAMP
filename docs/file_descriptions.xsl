<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
	<html>
	<h2>Files</h2>
	<table>
		<xsl:for-each select="folder">
			<tr> <td>
				<table>
				<xsl:apply-templates />
				</table>
			</td> </tr>
		</xsl:for-each>
	</table>
	</html>
</xsl:template>

<xsl:template match="file">
	<tr><td> <xsl:value-of select='.' /> </td><td> <xsl:value-of select="@function" /> </td> </tr>
</xsl:template>

</xsl:stylesheet>