<?xml version="1.0" encoding="UTF-8"?>
<!-- Processes ArcGIS metadata to upgrade ESRI-ISO metadata created with previous releases to ArcGIS metadata. -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:esri="http://www.esri.com/metadata/" >
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
	
	<!-- add Esri section including ArcGISFormat if it doesn't already exist -->
	<xsl:template match="metadata" priority="1">
		<xsl:copy>
			<xsl:apply-templates select="node() | @*" />
			<xsl:if test="count (./Esri) = 0">
				<Esri>
					<ArcGISFormat>1.0</ArcGISFormat>
				</Esri>
			</xsl:if>
		</xsl:copy>
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
	
	<!-- need to convert seqId to seqID? -->
	<xsl:template match="seqID" priority="1">
		<xsl:copy>
			<xsl:if test="count (MemberName/aName) > 0">
				<aName><xsl:value-of select="MemberName/aName" /></aName>
			</xsl:if>
			<xsl:if test="count (MemberName/attributeType/aName) > 0">
				<attributeType>
					<aName><xsl:value-of select="MemberName/attributeType/aName" /></aName>
				</attributeType>
			</xsl:if>

			<xsl:apply-templates select="node() | @*" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="seqId" priority="1">
		<seqID>
			<xsl:if test="count (MemberName/aName) > 0">
				<aName><xsl:value-of select="MemberName/aName" /></aName>
			</xsl:if>
			<xsl:if test="count (MemberName/attributeType/aName) > 0">
				<attributeType>
					<aName><xsl:value-of select="MemberName/attributeType/aName" /></aName>
				</attributeType>
			</xsl:if>
			<xsl:if test="count (aName) > 0">
				<aName><xsl:value-of select="aName" /></aName>
			</xsl:if>
			<xsl:if test="count (attributeType/aName) > 0">
				<attributeType>
					<aName><xsl:value-of select="attributeType/aName" /></aName>
				</attributeType>
			</xsl:if>
		</seqID>

		<xsl:copy>
			<xsl:apply-templates select="node() | @*" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="catFetTyps" priority="1">
		<xsl:copy>
			<xsl:if test="(*/aName) or (*/scope)">
				<genericName>
				<xsl:if test="*/scope"><xsl:attribute name="codeSpace"><xsl:value-of select="*/scope" /></xsl:attribute></xsl:if>
				<xsl:value-of select="*/aName" /></genericName>
			</xsl:if>

			<xsl:apply-templates select="node() | @*" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="scaleDist/value | dimResol/value" priority="1">
		<xsl:copy>
			<xsl:attribute name="uom"><xsl:value-of select="../uom/*/uomName" /></xsl:attribute>
			<xsl:apply-templates select="node() | @*" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="valUnit | quanValUnit" priority="1">
		<xsl:copy>
			<xsl:if test="(.//uomName != '')">
				<xsl:variable name="oldType" select="name(./uom/*)" />
				<xsl:variable name="newType">
					<xsl:choose>
						<xsl:when test="$oldType = 'UomMeasure'">measure</xsl:when>
						<xsl:when test="$oldType = 'UomArea'">area</xsl:when>
						<xsl:when test="$oldType = 'UomTime'">time</xsl:when>
						<xsl:when test="$oldType = 'UomLength'">length</xsl:when>
						<xsl:when test="$oldType = 'UomVolume'">volume</xsl:when>
						<xsl:when test="$oldType = 'UomVelocity'">velocity</xsl:when>
						<xsl:when test="$oldType = 'UomAngle'">angle</xsl:when>
						<xsl:when test="$oldType = 'UomScale'">scale</xsl:when>
						<xsl:otherwise>measure</xsl:otherwise>
					</xsl:choose>
				</xsl:variable>
				<UOM>
					<xsl:attribute name="type"><xsl:value-of select ="$newType" /></xsl:attribute>
					<unitSymbol><xsl:value-of select=".//uomName" /></unitSymbol>
				</UOM>
			</xsl:if>

			<xsl:apply-templates select="node() | @*" />
		</xsl:copy>
	</xsl:template>
	
	<!-- cornerPts and polygon needs to split up a set of four coordinates into separate elements -->
	<xsl:template match="centerPt" priority="1">
		<xsl:copy>
			<xsl:if test="(.//coordinates != '')">
				<pos><xsl:value-of select="translate(.//coordinates, ',', ' ')" /></pos>
			</xsl:if>

			<xsl:apply-templates select="node() | @*" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="usrDefFreq" priority="1">
		<xsl:copy>
			<xsl:if test="(./* != '')">
				<duration>P<xsl:if test="(years != '')"><xsl:value-of select="years" />Y</xsl:if><xsl:if test="(months != '')"><xsl:value-of select="months" />M</xsl:if><xsl:if test="(days != '')"><xsl:value-of select="days" />D</xsl:if><xsl:if test="(hours != '') or (minutes != '') or (seconds != '')">T</xsl:if><xsl:if test="(hours != '')"><xsl:value-of select="hours" />H</xsl:if><xsl:if test="(minutes != '')"><xsl:value-of select="minutes" />M</xsl:if><xsl:if test="(seconds != '')"><xsl:value-of select="seconds" />S</xsl:if></duration>
			</xsl:if>

			<xsl:apply-templates select="node() | @*" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="exTemp[TM_GeometricPrimitive/TM_Period]" priority="1">
		<xsl:copy>
			<xsl:if test="(TM_GeometricPrimitive/TM_Period/* != '')">
				<TM_Period>
					<tmBegin><xsl:value-of select="TM_GeometricPrimitive/TM_Period/begin" /></tmBegin>
					<tmEnd><xsl:value-of select="TM_GeometricPrimitive/TM_Period/end" /></tmEnd>
				</TM_Period>
			</xsl:if>

			<xsl:apply-templates select="node() | @*" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="exTemp[TM_GeometricPrimitive/TM_Instant]" priority="1">
		<xsl:copy>
			<xsl:if test="(TM_GeometricPrimitive/TM_Instant/tmPosition/*/calDate != '')">
				<TM_Instant>
					<tmPosition><xsl:value-of select="TM_GeometricPrimitive/TM_Instant/tmPosition/*/calDate" /><xsl:if test="TM_GeometricPrimitive/TM_Instant/tmPosition/*/clkTime">T<xsl:value-of select="TM_GeometricPrimitive/TM_Instant/tmPosition/*/clkTime" /></xsl:if></tmPosition>
				</TM_Instant>
			</xsl:if>

			<xsl:apply-templates select="node() | @*" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="citId" priority="1">
		<xsl:copy>
			<xsl:if test="not(./*)">
				<identCode><xsl:value-of select="." /></identCode>
			</xsl:if>
			<xsl:if test="../citIdType">
				<identAuth>
					<resTitle><xsl:value-of select="../citIdType" /></resTitle>
				</identAuth>
			</xsl:if>
			<xsl:apply-templates select="node() | @*" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="geoBox[@esriExtentType = 'decdegrees']" priority="1">
		<xsl:copy>
			<xsl:apply-templates select="node() | @*" />
		</xsl:copy>
		<dataExt>
			<geoEle>
				<GeoBndBox esriExtentType="search">
					<xsl:copy-of select="*" />
				</GeoBndBox>
			</geoEle>
		</dataExt>
	</xsl:template>

	<xsl:template match="geoBox[@esriExtentType = 'native']" priority="1">
		<xsl:copy>
			<xsl:apply-templates select="node() | @*" />
		</xsl:copy>
		<dataExt>
			<geoEle>
				<GeoBndBox esriExtentType="native">
					<xsl:copy-of select="*" />
				</GeoBndBox>
			</geoEle>
		</dataExt>
	</xsl:template>

	<xsl:template match="geoBox[not(@esriExtentType)]" priority="1">
		<xsl:copy>
			<xsl:apply-templates select="node() | @*" />
		</xsl:copy>
		<dataExt>
			<geoEle>
				<GeoBndBox>
					<xsl:copy-of select="*" />
				</GeoBndBox>
			</geoEle>
		</dataExt>
	</xsl:template>

	<xsl:template match="geoDesc" priority="1">
		<xsl:copy>
			<xsl:apply-templates select="node() | @*" />
		</xsl:copy>
		<dataExt>
			<geoEle>
				<GeoDesc>
					<geoId>
						<xsl:copy-of select=".//identAuth" />
						<xsl:copy-of select=".//identCode" />
					</geoId>
				</GeoDesc>
			</geoEle>
		</dataExt>
	</xsl:template>

	<xsl:template match="GeoDesc/geoId[MdIdent]" priority="1">
		<xsl:copy>
			<xsl:copy-of select="MdIdent/*" />
			<xsl:apply-templates select="node() | @*" />
		</xsl:copy>
	</xsl:template>

	<xsl:template match="measId | imagQuCode | prcTypCde | refSysID" priority="1">
		<xsl:copy>
			<xsl:copy-of select="MdIdent/*" />
			<xsl:copy-of select="RS_Identifier/*" />
			<xsl:apply-templates select="node() | @*" />
		</xsl:copy>
	</xsl:template>
	
	<xsl:template match="idCitation[resRefDate/refDateType/DateTypCd/@value != '']" priority="1">
		<xsl:copy>
			<xsl:apply-templates select="node() | @*" />
			<date>
				<xsl:for-each select="resRefDate[refDateType/DateTypCd/@value != '']">
					<xsl:variable name="dateType" select="refDateType/DateTypCd/@value" />
					<xsl:variable name="date" select="refDate" />
					<xsl:choose>
						<xsl:when test="$dateType = '001'">
							<createDate><xsl:value-of select="$date" /></createDate>
						</xsl:when>
						<xsl:when test="$dateType = '002'">
							<pubDate><xsl:value-of select="$date" /></pubDate>
						</xsl:when>
						<xsl:when test="$dateType = '003'">
							<reviseDate><xsl:value-of select="$date" /></reviseDate>
						</xsl:when>
					</xsl:choose>
				</xsl:for-each>
			</date>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="descKeys" priority="1">
		<xsl:copy>
			<xsl:apply-templates select="node() | @*" />
		</xsl:copy>
		<xsl:choose>
			<xsl:when test="keyTyp/KeyTypCd/@value = '001'">
				<discKeys>
					<xsl:for-each select="*[not(name() = 'keyTyp')]">
						<xsl:copy>
							<xsl:apply-templates select="node() | @*" />
						</xsl:copy>
					</xsl:for-each>
				</discKeys>
			</xsl:when>
			<xsl:when test="keyTyp/KeyTypCd/@value = '002'">
				<placeKeys>
					<xsl:for-each select="*[not(name() = 'keyTyp')]">
						<xsl:copy>
							<xsl:apply-templates select="node() | @*" />
						</xsl:copy>
					</xsl:for-each>
				</placeKeys>
			</xsl:when>
			<xsl:when test="keyTyp/KeyTypCd/@value = '003'">
				<stratKeys>
					<xsl:for-each select="*[not(name() = 'keyTyp')]">
						<xsl:copy>
							<xsl:apply-templates select="node() | @*" />
						</xsl:copy>
					</xsl:for-each>
				</stratKeys>
			</xsl:when>
			<xsl:when test="keyTyp/KeyTypCd/@value = '004'">
				<tempKeys>
					<xsl:for-each select="*[not(name() = 'keyTyp')]">
						<xsl:copy>
							<xsl:apply-templates select="node() | @*" />
						</xsl:copy>
					</xsl:for-each>
				</tempKeys>
			</xsl:when>
			<xsl:when test="keyTyp/KeyTypCd/@value = '005'">
				<themeKeys>
					<xsl:for-each select="*[not(name() = 'keyTyp')]">
						<xsl:copy>
							<xsl:apply-templates select="node() | @*" />
						</xsl:copy>
					</xsl:for-each>
				</themeKeys>
			</xsl:when>
			<xsl:otherwise>
				<otherKeys>
					<xsl:for-each select="*[not(name() = 'keyTyp')]">
						<xsl:copy>
							<xsl:apply-templates select="node() | @*" />
						</xsl:copy>
					</xsl:for-each>
				</otherKeys>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="dqReport" priority="1">
		<xsl:copy>
			<xsl:apply-templates select="node() | @*" />
		</xsl:copy>
		<report>
			<xsl:attribute name="type"><xsl:value-of select="name(*)" /></xsl:attribute>
			<xsl:for-each select="*/*">
				<xsl:copy>
					<xsl:apply-templates select="node() | @*" />
				</xsl:copy>
			</xsl:for-each>
		</report>
	</xsl:template>

	<xsl:template match="axDimProps" priority="1">
		<xsl:copy>
			<xsl:apply-templates select="node() | @*" />
		</xsl:copy>
		<xsl:for-each select="Dimen">
			<axisDimension>
				<xsl:attribute name="type"><xsl:value-of select ="dimName/DimNameTypCd/@value" /></xsl:attribute>
				<xsl:for-each select="*[not(name() = 'dimName')]">
					<xsl:copy>
						<xsl:apply-templates select="node() | @*" />
					</xsl:copy>
				</xsl:for-each>
			</axisDimension>
		</xsl:for-each>
	</xsl:template>

  <xsl:template match="polygon" priority="1">
    <xsl:copy>
      <xsl:apply-templates select="node() | @*" />
      <xsl:for-each select="GM_Polygon/coordinates">
        <exterior>
          <xsl:call-template name="parseString">
            <xsl:with-param name="text" select="." />
          </xsl:call-template>
        </exterior>
      </xsl:for-each>
    </xsl:copy>
  </xsl:template>

  <xsl:template name="parseString">
    <xsl:param name="text" />

    <xsl:choose>
      <xsl:when test="contains($text, ' ')">
        <xsl:variable name="before" select="substring-before($text, ' ')" />
        <xsl:variable name="after" select="substring-after($text, ' ')" />

        <xsl:choose>
          <xsl:when test='$after'>
            <xsl:for-each select='esri:splitcoords($before)'>
              <pos>
                <xsl:for-each select='coord'>
                  <xsl:value-of select='.'/>
                  <xsl:text> </xsl:text>
                </xsl:for-each>
              </pos>
            </xsl:for-each>
            <xsl:call-template name="parseString">
              <xsl:with-param name="text" select="$after" />
            </xsl:call-template>
          </xsl:when>
          <xsl:otherwise>
            <xsl:for-each select='esri:splitcoords($text)'>
              <pos>
                <xsl:for-each select='coord'>
                  <xsl:value-of select='.'/>
                  <xsl:text> </xsl:text>
                </xsl:for-each>
              </pos>
            </xsl:for-each>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:when>
      <xsl:otherwise>
        <xsl:for-each select='esri:splitcoords($text)'>
          <pos>
            <xsl:for-each select='coord'>
              <xsl:value-of select='.'/>
              <xsl:text> </xsl:text>
            </xsl:for-each>
          </pos>
        </xsl:for-each>
      </xsl:otherwise>
    </xsl:choose> 
  </xsl:template>

</xsl:stylesheet>
