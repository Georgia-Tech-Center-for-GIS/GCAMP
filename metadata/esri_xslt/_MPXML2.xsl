<?xml version="1.0" encoding="UTF-8" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xdt="http://www.w3.org/2005/xpath-datatypes">

  <xsl:output method="xml" version="1.0" encoding="UTF-8" indent="yes" omit-xml-declaration="no" />

<!-- An XSLT template for correctly ordering FGDC metadata elements. Any non-FGDC 
     elements and attributes in the source XML are not included in the output XML.
     Revised to support XSLT 2.0.
     	
     Copyright (c) 2007-2010, Environmental Systems Research Institute, Inc. All rights reserved.
     	
     Revision History: Created 6/18/2007 avienneau - upgraded MPXML.xsl to XSLT 1.0
-->

<xsl:template match="/">
    <metadata>

    <xsl:apply-templates select="metadata/idinfo"/>
    <xsl:apply-templates select="metadata/dataqual"/>
    <xsl:apply-templates select="metadata/spdoinfo"/>
    <xsl:apply-templates select="metadata/spref"/>
    <xsl:apply-templates select="metadata/eainfo"/>
    <xsl:apply-templates select="metadata/distinfo"/>
    <xsl:apply-templates select="metadata/metainfo"/>

    </metadata>
</xsl:template>

<!-- Identification -->
<xsl:template match="idinfo">
  <idinfo>
      <xsl:for-each select="citation">
	  <citation>
          <xsl:apply-templates select="citeinfo"/>
	  </citation>
      </xsl:for-each>

      <xsl:for-each select="descript">
	  <descript>
          <xsl:for-each select="abstract">
            <abstract><xsl:value-of select="."/></abstract>      
          </xsl:for-each>

          <xsl:for-each select="purpose">
            <purpose><xsl:value-of select="."/></purpose>
          </xsl:for-each>

          <xsl:for-each select="supplinf">
            <supplinf><xsl:value-of select="."/></supplinf>
          </xsl:for-each>
	  </descript>
      </xsl:for-each>

      <xsl:for-each select="timeperd">
	  <timeperd>
          <xsl:apply-templates select="timeinfo"/>
          <xsl:for-each select="current">
            <current><xsl:value-of select="."/></current>
          </xsl:for-each>
	  </timeperd>
      </xsl:for-each>

      <xsl:for-each select="status">
	  <status>
          <xsl:for-each select="progress">
            <progress><xsl:value-of select="."/></progress>
          </xsl:for-each>
          <xsl:for-each select="update">
            <update><xsl:value-of select="."/></update>
          </xsl:for-each>
	  </status>
      </xsl:for-each>

      <xsl:for-each select="spdom">
	  <spdom>
          <xsl:for-each select="bounding">
		<bounding>
              <westbc> <xsl:value-of select="westbc"/></westbc>
              <eastbc> <xsl:value-of select="eastbc"/></eastbc>
              <northbc> <xsl:value-of select="northbc"/></northbc>
              <southbc> <xsl:value-of select="southbc"/></southbc>
		</bounding>
          </xsl:for-each>
          <xsl:for-each select="dsgpoly">
		<dsgpoly>
              <xsl:for-each select="dsgpolyo">
		    <dsgpolyo>
                  <xsl:apply-templates select="grngpoin"/>
                  <xsl:apply-templates select="gring"/>
		    </dsgpolyo>
              </xsl:for-each>
              <xsl:for-each select="dsgpolyx">
		    <dsgpolyx>
                  <xsl:apply-templates select="grngpoin"/>
                  <xsl:apply-templates select="gring"/>
		    </dsgpolyx>
              </xsl:for-each>
		</dsgpoly>
          </xsl:for-each>
	  </spdom>
      </xsl:for-each>

      <xsl:for-each select="keywords">
        <keywords>
          <xsl:for-each select="theme">
            <theme>
              <xsl:for-each select="themekt">
                <themekt><xsl:value-of select="."/></themekt>
              </xsl:for-each>
              <xsl:for-each select="themekey">
                <themekey><xsl:value-of select="."/></themekey>
              </xsl:for-each>
            </theme>
          </xsl:for-each>

          <xsl:for-each select="place">
            <place>
              <xsl:for-each select="placekt">
                <placekt><xsl:value-of select="."/></placekt>
              </xsl:for-each>
              <xsl:for-each select="placekey">
                <placekey><xsl:value-of select="."/></placekey>
              </xsl:for-each>
            </place>
          </xsl:for-each>

          <xsl:for-each select="stratum">
            <stratum>
              <xsl:for-each select="stratkt">
                <stratkt><xsl:value-of select="."/></stratkt>
              </xsl:for-each>
              <xsl:for-each select="stratkey">
                <stratkey><xsl:value-of select="."/></stratkey>
              </xsl:for-each>
            </stratum>
          </xsl:for-each>
 
          <xsl:for-each select="temporal">
            <temporal>
              <xsl:for-each select="tempkt">
                <tempkt><xsl:value-of select="."/></tempkt>
              </xsl:for-each>
              <xsl:for-each select="tempkey">
                <tempkey><xsl:value-of select="."/></tempkey>
              </xsl:for-each>
            </temporal>
          </xsl:for-each>
        </keywords>
      </xsl:for-each>

      <xsl:for-each select="accconst">
        <accconst><xsl:value-of select="."/></accconst>
      </xsl:for-each>
      <xsl:for-each select="useconst">
        <useconst><xsl:value-of select="."/></useconst>
      </xsl:for-each>

      <xsl:for-each select="ptcontac">
        <ptcontac>
          <xsl:apply-templates select="cntinfo"/>
        </ptcontac>
      </xsl:for-each>

      <xsl:for-each select="browse">
        <browse>
          <xsl:for-each select="browsen">
            <browsen><xsl:value-of select="."/></browsen>
          </xsl:for-each>
          <xsl:for-each select="browsed">
            <browsed><xsl:value-of select="."/></browsed>
          </xsl:for-each>
          <xsl:for-each select="browset">
            <browset><xsl:value-of select="."/></browset>
          </xsl:for-each>
        </browse>
      </xsl:for-each>

      <xsl:for-each select="datacred">
        <datacred><xsl:value-of select="."/></datacred>
      </xsl:for-each>

      <xsl:for-each select="secinfo">
	  <secinfo>
          <xsl:for-each select="secsys">
            <secsys><xsl:value-of select="."/></secsys>
          </xsl:for-each>
          <xsl:for-each select="secclass">
            <secclass><xsl:value-of select="."/></secclass>
          </xsl:for-each>
          <xsl:for-each select="sechandl">
            <sechandl><xsl:value-of select="."/></sechandl>
          </xsl:for-each>
	  </secinfo>
      </xsl:for-each>

      <xsl:for-each select="native">
        <native><xsl:value-of select="."/></native>
      </xsl:for-each>

      <xsl:for-each select="crossref">
        <crossref>
          <xsl:apply-templates select="citeinfo"/>
        </crossref>
      </xsl:for-each>
  </idinfo>
</xsl:template>

<!-- Data Quality -->
<xsl:template match="dataqual">
  <dataqual>
      <xsl:for-each select="attracc">
        <attracc>
          <xsl:for-each select="attraccr">
            <attraccr><xsl:value-of select="."/></attraccr>
          </xsl:for-each>
          <xsl:for-each select="qattracc">
            <qattracc>
              <xsl:for-each select="attraccv">
                <attraccv><xsl:value-of select="."/></attraccv>
              </xsl:for-each>
              <xsl:for-each select="attracce">
                <attracce><xsl:value-of select="."/></attracce>
              </xsl:for-each>
            </qattracc>
          </xsl:for-each>
        </attracc>
      </xsl:for-each>

      <xsl:for-each select="logic">
        <logic><xsl:value-of select="."/></logic>
      </xsl:for-each>
      <xsl:for-each select="complete">
        <complete><xsl:value-of select="."/></complete>
      </xsl:for-each>

      <xsl:for-each select="posacc">
        <posacc>
          <xsl:for-each select="horizpa">
            <horizpa>
              <xsl:for-each select="horizpar">
                <horizpar><xsl:value-of select="."/></horizpar>
              </xsl:for-each>
              <xsl:for-each select="qhorizpa">
                <qhorizpa>
                  <xsl:for-each select="horizpav">
                    <horizpav><xsl:value-of select="."/></horizpav>
                  </xsl:for-each>
                  <xsl:for-each select="horizpae">
                    <horizpae><xsl:value-of select="."/></horizpae>
                  </xsl:for-each>
                </qhorizpa>
              </xsl:for-each>
            </horizpa>
          </xsl:for-each>
          <xsl:for-each select="vertacc">
            <vertacc>
              <xsl:for-each select="vertaccr">
                <vertaccr><xsl:value-of select="."/></vertaccr>
              </xsl:for-each>
              <xsl:for-each select="qvertpa">
                <qvertpa>
                  <xsl:for-each select="vertaccv">
                    <vertaccv><xsl:value-of select="."/></vertaccv>
                  </xsl:for-each>
                  <xsl:for-each select="vertacce">
                    <vertacce><xsl:value-of select="."/></vertacce>
                  </xsl:for-each>
                </qvertpa>
              </xsl:for-each>
            </vertacc>
          </xsl:for-each>
        </posacc>
      </xsl:for-each>

      <xsl:for-each select="lineage">
        <lineage>
          <xsl:for-each select="srcinfo">
            <srcinfo>
              <xsl:for-each select="srccite">
                <srccite>
                  <xsl:apply-templates select="citeinfo"/>
                </srccite>
              </xsl:for-each>
              <xsl:for-each select="srcscale">
                <srcscale><xsl:value-of select="."/></srcscale>
              </xsl:for-each>
              <xsl:for-each select="typesrc">
                <typesrc><xsl:value-of select="."/></typesrc>
              </xsl:for-each>

              <xsl:for-each select="srctime">
                <srctime>
                  <xsl:apply-templates select="timeinfo"/>
                  <xsl:for-each select="srccurr">
                    <srccurr><xsl:value-of select="."/></srccurr>
                  </xsl:for-each>
                </srctime>
              </xsl:for-each>

              <xsl:for-each select="srccitea">
                <srccitea><xsl:value-of select="."/></srccitea>
              </xsl:for-each>
              <xsl:for-each select="srccontr">
                <srccontr><xsl:value-of select="."/></srccontr>
              </xsl:for-each>
            </srcinfo>
          </xsl:for-each>

          <xsl:for-each select="procstep">
            <procstep>
              <xsl:for-each select="procdesc">
                <procdesc><xsl:value-of select="."/></procdesc>
              </xsl:for-each>
              <xsl:for-each select="srcused">
                <srcused><xsl:value-of select="."/></srcused>
              </xsl:for-each>
              <xsl:for-each select="procdate">
                <procdate><xsl:value-of select="."/></procdate>
              </xsl:for-each>
              <xsl:for-each select="proctime">
                <proctime><xsl:value-of select="."/></proctime>
              </xsl:for-each>
              <xsl:for-each select="srcprod">
                <srcprod><xsl:value-of select="."/></srcprod>
              </xsl:for-each>
              <xsl:for-each select="proccont">
                <proccont>
                  <xsl:apply-templates select="cntinfo"/>
                </proccont>
              </xsl:for-each>
            </procstep>
          </xsl:for-each>
        </lineage>
      </xsl:for-each>
      <xsl:for-each select="cloud">
        <cloud><xsl:value-of select="."/></cloud>
      </xsl:for-each>
  </dataqual>
</xsl:template>

<!-- Spatial Data Organization -->
<xsl:template match="spdoinfo">
  <spdoinfo>
      <xsl:for-each select="indspref">
        <indspref><xsl:value-of select="."/></indspref>
      </xsl:for-each>

      <xsl:for-each select="direct">
        <direct><xsl:value-of select="."/></direct>
      </xsl:for-each>

      <xsl:for-each select="ptvctinf">
        <ptvctinf>
          <xsl:for-each select="sdtsterm">
            <sdtsterm>
              <xsl:for-each select="sdtstype">
                <sdtstype><xsl:value-of select="."/></sdtstype>
              </xsl:for-each>
              <xsl:for-each select="ptvctcnt">
                <ptvctcnt><xsl:value-of select="."/></ptvctcnt>
              </xsl:for-each>
            </sdtsterm>
          </xsl:for-each>

          <xsl:for-each select="vpfterm">
            <vpfterm>
              <xsl:for-each select="vpflevel">
                <vpflevel><xsl:value-of select="."/></vpflevel>
              </xsl:for-each>
              <xsl:for-each select="vpfinfo">
                <vpfinfo>
                  <xsl:for-each select="vpftype">
                    <vpftype><xsl:value-of select="."/></vpftype>
                  </xsl:for-each>
                  <xsl:for-each select="ptvctcnt">
                    <ptvctcnt><xsl:value-of select="."/></ptvctcnt>
                  </xsl:for-each>
                </vpfinfo>
              </xsl:for-each>
            </vpfterm>
          </xsl:for-each>
        </ptvctinf>
      </xsl:for-each>

      <xsl:for-each select="rastinfo">
        <rastinfo>
          <xsl:for-each select="rasttype">
            <rasttype><xsl:value-of select="."/></rasttype>
          </xsl:for-each>
          <xsl:for-each select="rowcount">
            <rowcount><xsl:value-of select="."/></rowcount>
          </xsl:for-each>
          <xsl:for-each select="colcount">
            <colcount><xsl:value-of select="."/></colcount>
          </xsl:for-each>
          <xsl:for-each select="vrtcount">
            <vrtcount><xsl:value-of select="."/></vrtcount>
          </xsl:for-each>
        </rastinfo>
      </xsl:for-each>
  </spdoinfo>
</xsl:template>

<!-- Spatial Reference -->
<xsl:template match="spref">
  <spref>
      <xsl:for-each select="horizsys">
        <horizsys>
          <xsl:for-each select="geograph">
            <geograph>
              <xsl:for-each select="latres">
                <latres><xsl:value-of select="."/></latres>
              </xsl:for-each>
              <xsl:for-each select="longres">
                <longres><xsl:value-of select="."/></longres>
              </xsl:for-each>
              <xsl:for-each select="geogunit">
                <geogunit><xsl:value-of select="."/></geogunit>
              </xsl:for-each>
            </geograph>
          </xsl:for-each>

          <xsl:for-each select="planar">
            <planar>
              <xsl:for-each select="mapproj">
                <mapproj>
                  <xsl:for-each select="mapprojn">
                    <mapprojn><xsl:value-of select="."/></mapprojn>
                  </xsl:for-each>
                  <!-- Projection parameters: see end of file. -->
                  <xsl:apply-templates select="*"/>
                </mapproj>
              </xsl:for-each>

              <xsl:for-each select="gridsys">
                <gridsys>
                  <xsl:for-each select="gridsysn">
                    <gridsysn><xsl:value-of select="."/></gridsysn>
                  </xsl:for-each>

                  <xsl:for-each select="utm">
                    <utm>
                      <xsl:for-each select="utmzone">
                        <utmzone><xsl:value-of select="."/></utmzone>
                      </xsl:for-each>
                      <xsl:apply-templates select="transmer"/>
                    </utm>
                  </xsl:for-each>

                  <xsl:for-each select="ups">
                    <ups>
                      <xsl:for-each select="upszone">
                        <upszone><xsl:value-of select="."/></upszone>
                      </xsl:for-each>
                      <xsl:apply-templates select="polarst"/>
                    </ups>
                  </xsl:for-each>

                  <xsl:for-each select="spcs">
                    <spcs>
                      <xsl:for-each select="spcszone">
                        <spcszone><xsl:value-of select="."/></spcszone>
                      </xsl:for-each>
                      <xsl:apply-templates select="lambertc"/>
                      <xsl:apply-templates select="transmer"/>
                      <xsl:apply-templates select="obqmerc"/>
                      <xsl:apply-templates select="polycon"/>
                    </spcs>
                  </xsl:for-each>

                  <xsl:for-each select="arcsys">
                    <arcsys>
                      <xsl:for-each select="arczone">
                        <arczone><xsl:value-of select="."/></arczone>
                      </xsl:for-each>
                      <xsl:apply-templates select="equirect"/>
                      <xsl:apply-templates select="azimequi"/>
                    </arcsys>
                  </xsl:for-each>

                  <xsl:for-each select="othergrd">
                    <othergrd><xsl:value-of select="."/></othergrd>
                  </xsl:for-each>
                </gridsys>
              </xsl:for-each>

              <xsl:for-each select="localp">
                <localp>
                  <xsl:for-each select="localpd">
                    <localpd><xsl:value-of select="."/></localpd>
                  </xsl:for-each>
                  <xsl:for-each select="localpgi">
                    <localpgi><xsl:value-of select="."/></localpgi>
                  </xsl:for-each>
                </localp>
              </xsl:for-each>

              <xsl:for-each select="planci">
                <planci>
                  <xsl:for-each select="plance">
                    <plance><xsl:value-of select="."/></plance>
                  </xsl:for-each>
                  <xsl:for-each select="coordrep">
                    <coordrep>
                      <xsl:for-each select="absres">
                        <absres><xsl:value-of select="."/></absres>
                      </xsl:for-each>
                      <xsl:for-each select="ordres">
                        <ordres><xsl:value-of select="."/></ordres>
                      </xsl:for-each>
                    </coordrep>
                  </xsl:for-each>
                  <xsl:for-each select="distbrep">
                    <distbrep>
                      <xsl:for-each select="distres">
                        <distres><xsl:value-of select="."/></distres>
                      </xsl:for-each>
                      <xsl:for-each select="bearres">
                        <bearres><xsl:value-of select="."/></bearres>
                      </xsl:for-each>
                      <xsl:for-each select="bearunit">
                        <bearunit><xsl:value-of select="."/></bearunit>
                      </xsl:for-each>
                      <xsl:for-each select="bearrefd">
                        <bearrefd><xsl:value-of select="."/></bearrefd>
                      </xsl:for-each>
                      <xsl:for-each select="bearrefm">
                        <bearrefm><xsl:value-of select="."/></bearrefm>
                      </xsl:for-each>
                    </distbrep>
                  </xsl:for-each>
                  <xsl:for-each select="plandu">
                    <plandu><xsl:value-of select="."/></plandu>
                  </xsl:for-each>
                </planci>
              </xsl:for-each>
            </planar>
          </xsl:for-each>

          <xsl:for-each select="local">
            <local>
              <xsl:for-each select="localdes">
                <localdes><xsl:value-of select="."/></localdes>
              </xsl:for-each>
              <xsl:for-each select="localgeo">
                <localgeo><xsl:value-of select="."/></localgeo>
              </xsl:for-each>
            </local>
          </xsl:for-each>

          <xsl:for-each select="geodetic">
            <geodetic>
              <xsl:for-each select="horizdn">
                <horizdn><xsl:value-of select="."/></horizdn>
              </xsl:for-each>
              <xsl:for-each select="ellips">
                <ellips><xsl:value-of select="."/></ellips>
              </xsl:for-each>
              <xsl:for-each select="semiaxis">
                <semiaxis><xsl:value-of select="."/></semiaxis>
              </xsl:for-each>
              <xsl:for-each select="denflat">
                <denflat><xsl:value-of select="."/></denflat>
              </xsl:for-each>
            </geodetic>
          </xsl:for-each>
        </horizsys>
      </xsl:for-each>

      <xsl:for-each select="vertdef">
        <vertdef>
          <xsl:for-each select="altsys">
            <altsys>
              <xsl:for-each select="altdatum">
                <altdatum><xsl:value-of select="."/></altdatum>
              </xsl:for-each>
              <xsl:for-each select="altres">
                <altres><xsl:value-of select="."/></altres>
              </xsl:for-each>
              <xsl:for-each select="altunits">
                <altunits><xsl:value-of select="."/></altunits>
              </xsl:for-each>
              <xsl:for-each select="altenc">
                <altenc><xsl:value-of select="."/></altenc>
              </xsl:for-each>
            </altsys>
          </xsl:for-each>

          <xsl:for-each select="depthsys">
            <depthsys>
              <xsl:for-each select="depthdn">
                <depthdn> <xsl:value-of select="."/></depthdn>
              </xsl:for-each>
              <xsl:for-each select="depthres">
                <depthres><xsl:value-of select="."/></depthres>
              </xsl:for-each>
              <xsl:for-each select="depthdu">
                <depthdu><xsl:value-of select="."/></depthdu>
              </xsl:for-each>
              <xsl:for-each select="depthem">
                <depthem><xsl:value-of select="."/></depthem>
              </xsl:for-each>
            </depthsys>
          </xsl:for-each>
        </vertdef>
      </xsl:for-each>
  </spref>
</xsl:template>

<!-- Entity and Attribute -->
<xsl:template match="eainfo">
  <eainfo>
      <xsl:for-each select="detailed">
        <detailed>
          <xsl:for-each select="enttyp">
            <enttyp>
              <xsl:for-each select="enttypl">
                <enttypl> <xsl:value-of select="."/></enttypl>
              </xsl:for-each>
              <xsl:for-each select="enttypd">
                <enttypd><xsl:value-of select="."/></enttypd>
              </xsl:for-each>
              <xsl:for-each select="enttypds">
                <enttypds><xsl:value-of select="."/></enttypds>
              </xsl:for-each>
            </enttyp>
          </xsl:for-each>

          <xsl:for-each select="attr">
            <attr>
              <xsl:for-each select="attrlabl">
                <attrlabl><xsl:value-of select="."/></attrlabl>
              </xsl:for-each>
              <xsl:for-each select="attrdef">
                <attrdef><xsl:value-of select="."/></attrdef>
              </xsl:for-each>
              <xsl:for-each select="attrdefs">
                <attrdefs><xsl:value-of select="."/></attrdefs>
              </xsl:for-each>

              <xsl:for-each select="attrdomv">
                <attrdomv>
                  <xsl:for-each select="edom">
                    <edom>
                      <xsl:for-each select="edomv">
                        <edomv><xsl:value-of select="."/></edomv>
                      </xsl:for-each>
                      <xsl:for-each select="edomvd">
                        <edomvd><xsl:value-of select="."/></edomvd>
                      </xsl:for-each>
                      <xsl:for-each select="edomvds">
                        <edomvds><xsl:value-of select="."/></edomvds>
                      </xsl:for-each>
                    </edom>
                  </xsl:for-each>

                  <xsl:for-each select="rdom">
                    <rdom>
                      <xsl:for-each select="rdommin">
                        <rdommin><xsl:value-of select="."/></rdommin>
                      </xsl:for-each>
                      <xsl:for-each select="rdommax">
                        <rdommax><xsl:value-of select="."/></rdommax>
                      </xsl:for-each>
                      <xsl:for-each select="attrunit">
                        <attrunit><xsl:value-of select="."/></attrunit>
                      </xsl:for-each>
                      <xsl:for-each select="attrmres">
                        <attrmres><xsl:value-of select="."/></attrmres>
                      </xsl:for-each>
                    </rdom>
                  </xsl:for-each>

                  <xsl:for-each select="codesetd">
                    <codesetd>
                      <xsl:for-each select="codesetn">
                        <codesetn><xsl:value-of select="."/></codesetn>
                      </xsl:for-each>
                      <xsl:for-each select="codesets">
                        <codesets><xsl:value-of select="."/></codesets>
                      </xsl:for-each>
                    </codesetd>
                  </xsl:for-each>

                  <xsl:for-each select="udom">
                    <udom><xsl:value-of select="."/></udom>
                  </xsl:for-each>
                </attrdomv>
              </xsl:for-each>

              <xsl:for-each select="begdatea">
                <begdatea><xsl:value-of select="."/></begdatea>
              </xsl:for-each>
              <xsl:for-each select="enddatea">
                <enddatea><xsl:value-of select="."/></enddatea>
              </xsl:for-each>

              <xsl:for-each select="attrvai">
                <attrvai>
                  <xsl:for-each select="attrva">
                    <attrva><xsl:value-of select="."/></attrva>
                  </xsl:for-each>
                  <xsl:for-each select="attrvae">
                    <attrvae><xsl:value-of select="."/></attrvae>
                  </xsl:for-each>
                </attrvai>
              </xsl:for-each>
              <xsl:for-each select="attrmfrq">
                <attrmfrq><xsl:value-of select="."/></attrmfrq>
              </xsl:for-each>
            </attr>
          </xsl:for-each>
        </detailed>
      </xsl:for-each>

      <xsl:for-each select="overview">
        <overview>
          <xsl:for-each select="eaover">
            <eaover><xsl:value-of select="."/></eaover>
          </xsl:for-each>
          <xsl:for-each select="eadetcit">
            <eadetcit><xsl:value-of select="."/></eadetcit>
          </xsl:for-each>
        </overview>
      </xsl:for-each>
  </eainfo>
</xsl:template>

<!-- Distribution -->
<xsl:template match="distinfo">
  <distinfo>
      <xsl:for-each select="distrib">
        <distrib>
          <xsl:apply-templates select="cntinfo"/>
        </distrib>
      </xsl:for-each>

      <xsl:for-each select="resdesc">
        <resdesc><xsl:value-of select="."/></resdesc>
      </xsl:for-each>
      <xsl:for-each select="distliab">
        <distliab><xsl:value-of select="."/></distliab>
      </xsl:for-each>

      <xsl:for-each select="stdorder">
        <stdorder>
          <xsl:for-each select="nondig">
            <nondig><xsl:value-of select="."/></nondig>
          </xsl:for-each>
          <xsl:for-each select="digform">
            <digform>
              <xsl:for-each select="digtinfo">
                <digtinfo>
                  <xsl:for-each select="formname">
                    <formname><xsl:value-of select="."/></formname>
                  </xsl:for-each>
                  <xsl:for-each select="formvern">
                    <formvern><xsl:value-of select="."/></formvern>
                  </xsl:for-each>
                  <xsl:for-each select="formverd">
                    <formverd><xsl:value-of select="."/></formverd>
                  </xsl:for-each>
                  <xsl:for-each select="formspec">
                    <formspec><xsl:value-of select="."/></formspec>
                  </xsl:for-each>
                  <xsl:for-each select="formcont">
                    <formcont><xsl:value-of select="."/></formcont>
                  </xsl:for-each>
                  <xsl:for-each select="filedec">
                    <filedec><xsl:value-of select="."/></filedec>
                  </xsl:for-each>
                  <xsl:for-each select="transize">
                    <transize><xsl:value-of select="."/></transize>
                  </xsl:for-each>
                </digtinfo>
              </xsl:for-each>

              <xsl:for-each select="digtopt">
                <digtopt>
                  <xsl:for-each select="onlinopt">
                    <onlinopt>
                      <xsl:for-each select="computer">
				<computer>
                          <xsl:for-each select="networka">
                            <networka>
                              <xsl:for-each select="networkr">
                                <networkr><xsl:value-of select="."/></networkr>
                              </xsl:for-each>
                            </networka>
                          </xsl:for-each>

                          <xsl:for-each select="dialinst">
                            <dialinst>
                              <xsl:for-each select="lowbps">
                                <lowbps> <xsl:value-of select="."/></lowbps>
                              </xsl:for-each>
                              <xsl:for-each select="highbps">
                                <highbps><xsl:value-of select="."/></highbps>
                              </xsl:for-each>
                              <xsl:for-each select="numdata">
                                <numdata><xsl:value-of select="."/></numdata>
                              </xsl:for-each>
                              <xsl:for-each select="numstop">
                                <numstop><xsl:value-of select="."/></numstop>
                              </xsl:for-each>
                              <xsl:for-each select="parity">
                                <parity><xsl:value-of select="."/></parity>
                              </xsl:for-each>
                              <xsl:for-each select="ccompress">
                                <ccompress> <xsl:value-of select="."/></ccompress>
                              </xsl:for-each>
                              <xsl:for-each select="dialtel">
                                <dialtel><xsl:value-of select="."/></dialtel>
                              </xsl:for-each>
                              <xsl:for-each select="dialfile">
                                <dialfile><xsl:value-of select="."/></dialfile>
                              </xsl:for-each>
                            </dialinst>
                          </xsl:for-each>
				</computer>
                      </xsl:for-each>
                      <xsl:for-each select="accinstr">
                        <accinstr><xsl:value-of select="."/></accinstr>
                      </xsl:for-each>
                      <xsl:for-each select="oncomp">
                        <oncomp><xsl:value-of select="."/></oncomp>
                      </xsl:for-each>
                    </onlinopt>
                  </xsl:for-each>

                  <xsl:for-each select="offoptn">
                    <offoptn>
                      <xsl:for-each select="offmedia">
                        <offmedia><xsl:value-of select="."/></offmedia>
                      </xsl:for-each>
                      <xsl:for-each select="reccap">
                        <reccap>
                          <xsl:for-each select="recden">
                            <recden><xsl:value-of select="."/></recden>
                          </xsl:for-each>
                          <xsl:for-each select="recdenu">
                            <recdenu><xsl:value-of select="."/></recdenu>
                          </xsl:for-each>
                        </reccap>
                      </xsl:for-each>
                      <xsl:for-each select="recfmt">
                        <recfmt><xsl:value-of select="."/></recfmt>
                      </xsl:for-each>
                      <xsl:for-each select="compat">
                        <compat><xsl:value-of select="."/></compat>
                      </xsl:for-each>
                    </offoptn>
                  </xsl:for-each>
                </digtopt>
              </xsl:for-each>
            </digform>
          </xsl:for-each>

          <xsl:for-each select="fees">
            <fees><xsl:value-of select="."/></fees>
          </xsl:for-each>
          <xsl:for-each select="ordering">
            <ordering><xsl:value-of select="."/></ordering>
          </xsl:for-each>
          <xsl:for-each select="turnarnd">
            <turnarnd><xsl:value-of select="."/></turnarnd>
          </xsl:for-each>
        </stdorder>
      </xsl:for-each>

      <xsl:for-each select="custom">
        <custom><xsl:value-of select="."/></custom>
      </xsl:for-each>
      <xsl:for-each select="techpreq">
        <techpreq><xsl:value-of select="."/></techpreq>
      </xsl:for-each>
      <xsl:for-each select="availabl">
        <availabl>
          <xsl:apply-templates select="timeinfo"/>
        </availabl>
      </xsl:for-each>
  </distinfo>
</xsl:template>

<!-- Metadata -->
<xsl:template match="metainfo">
  <metainfo>
      <xsl:for-each select="metd">
        <metd><xsl:value-of select="."/></metd>
      </xsl:for-each>
      <xsl:for-each select="metrd">
        <metrd><xsl:value-of select="."/></metrd>
      </xsl:for-each>
      <xsl:for-each select="metfrd">
        <metfrd><xsl:value-of select="."/></metfrd>
      </xsl:for-each>

      <xsl:for-each select="metc">
        <metc>
          <xsl:apply-templates select="cntinfo"/>
        </metc>
      </xsl:for-each>

      <xsl:for-each select="metstdn">
        <metstdn><xsl:value-of select="."/></metstdn>
      </xsl:for-each>
      <xsl:for-each select="metstdv">
        <metstdv><xsl:value-of select="."/></metstdv>
      </xsl:for-each>
      <xsl:for-each select="mettc">
        <mettc><xsl:value-of select="."/></mettc>
      </xsl:for-each>

      <xsl:for-each select="metac">
        <metac><xsl:value-of select="."/></metac>
      </xsl:for-each>
      <xsl:for-each select="metuc">
        <metuc><xsl:value-of select="."/></metuc>
      </xsl:for-each>

      <xsl:for-each select="metsi">
        <metsi>
          <xsl:for-each select="metscs">
            <metscs><xsl:value-of select="."/></metscs>
          </xsl:for-each>
          <xsl:for-each select="metsc">
            <metsc><xsl:value-of select="."/></metsc>
          </xsl:for-each>
          <xsl:for-each select="metshd">
            <metshd><xsl:value-of select="."/></metshd>
          </xsl:for-each>
        </metsi>
      </xsl:for-each>

      <xsl:for-each select="metextns">
        <metextns>
          <xsl:for-each select="onlink">
            <onlink><xsl:value-of select="."/></onlink>
          </xsl:for-each>
          <xsl:for-each select="metprof">
            <metprof><xsl:value-of select="."/></metprof>
          </xsl:for-each>
        </metextns>
      </xsl:for-each>
  </metainfo>
</xsl:template>

<!-- Citation -->
<xsl:template match="citeinfo">
  <citeinfo>
    <xsl:for-each select="origin">
      <origin><xsl:value-of select="."/></origin>
    </xsl:for-each>

    <xsl:for-each select="pubdate">
      <pubdate><xsl:value-of select="."/></pubdate>
    </xsl:for-each>
    <xsl:for-each select="pubtime">
      <pubtime><xsl:value-of select="."/></pubtime>
    </xsl:for-each>

    <xsl:for-each select="title">
      <title><xsl:value-of select="."/></title>
    </xsl:for-each>
    <xsl:for-each select="edition">
      <edition><xsl:value-of select="."/></edition>
    </xsl:for-each>

    <xsl:for-each select="geoform">
      <geoform><xsl:value-of select="."/></geoform>
    </xsl:for-each>

    <xsl:for-each select="serinfo">
      <serinfo>
        <xsl:for-each select="sername">
          <sername><xsl:value-of select="."/></sername>
        </xsl:for-each>
        <xsl:for-each select="issue">
          <issue><xsl:value-of select="."/></issue>
        </xsl:for-each>
      </serinfo>
    </xsl:for-each>

    <xsl:for-each select="pubinfo">
      <pubinfo>
        <xsl:for-each select="pubplace">
          <pubplace><xsl:value-of select="."/></pubplace>
        </xsl:for-each>
        <xsl:for-each select="publish">
          <publish><xsl:value-of select="."/></publish>
        </xsl:for-each>
      </pubinfo>
    </xsl:for-each>

    <xsl:for-each select="othercit">
      <othercit><xsl:value-of select="."/></othercit>
    </xsl:for-each>

    <xsl:for-each select="onlink">
      <onlink><xsl:value-of select="."/></onlink>
    </xsl:for-each>

    <xsl:for-each select="lworkcit">
      <lworkcit>
        <xsl:apply-templates select="citeinfo"/>
      </lworkcit>
    </xsl:for-each>
  </citeinfo>
</xsl:template>

<!-- Contact -->
<xsl:template match="cntinfo">
  <cntinfo>
    <xsl:for-each select="cntperp">
      <cntperp>
        <xsl:for-each select="cntper">
          <cntper><xsl:value-of select="."/></cntper>
        </xsl:for-each>
        <xsl:for-each select="cntorg">
          <cntorg><xsl:value-of select="."/></cntorg>
        </xsl:for-each>
      </cntperp>
    </xsl:for-each>
    <xsl:for-each select="cntorgp">
      <cntorgp>
        <xsl:for-each select="cntorg">
          <cntorg><xsl:value-of select="."/></cntorg>
        </xsl:for-each>
        <xsl:for-each select="cntper">
          <cntper><xsl:value-of select="."/></cntper>
        </xsl:for-each>
      </cntorgp>
    </xsl:for-each>
    <xsl:for-each select="cntpos">
      <cntpos><xsl:value-of select="."/></cntpos>
    </xsl:for-each>

    <xsl:for-each select="cntaddr">
      <cntaddr>
        <xsl:for-each select="addrtype">
          <addrtype><xsl:value-of select="."/></addrtype>
        </xsl:for-each>
        <xsl:for-each select="address">
          <address><xsl:value-of select="."/></address>
        </xsl:for-each>
        <xsl:for-each select="city">
          <city><xsl:value-of select="."/></city>
        </xsl:for-each>
        <xsl:for-each select="state">
          <state><xsl:value-of select="."/></state>
        </xsl:for-each>
        <xsl:for-each select="postal">
          <postal><xsl:value-of select="."/></postal>
        </xsl:for-each>
        <xsl:for-each select="country">
          <country><xsl:value-of select="."/></country>
        </xsl:for-each>
      </cntaddr>
    </xsl:for-each>

    <xsl:for-each select="cntvoice">
      <cntvoice><xsl:value-of select="."/></cntvoice>
    </xsl:for-each>
    <xsl:for-each select="cnttdd">
      <cnttdd><xsl:value-of select="."/></cnttdd>
    </xsl:for-each>
    <xsl:for-each select="cntfax">
      <cntfax><xsl:value-of select="."/></cntfax>
    </xsl:for-each>
    <xsl:for-each select="cntemail">
      <cntemail><xsl:value-of select="."/></cntemail>
    </xsl:for-each>

    <xsl:for-each select="hours">
      <hours><xsl:value-of select="."/></hours>
    </xsl:for-each>
    <xsl:for-each select="cntinst">
      <cntinst><xsl:value-of select="."/></cntinst>
    </xsl:for-each>
  </cntinfo>
</xsl:template>

<!-- Time Period Info -->
<xsl:template match="timeinfo">
  <timeinfo>
    <xsl:apply-templates select="sngdate"/>
    <xsl:apply-templates select="mdattim"/>
    <xsl:apply-templates select="rngdates"/>
  </timeinfo>
</xsl:template>

<!-- Single Date/Time -->
<xsl:template match="sngdate">
  <sngdate>
    <xsl:for-each select="caldate">
      <caldate><xsl:value-of select="."/></caldate>
    </xsl:for-each>
    <xsl:for-each select="time">
      <time><xsl:value-of select="."/></time>
    </xsl:for-each>
  </sngdate>
</xsl:template>

<!-- Multiple Date/Time -->
<xsl:template match="mdattim">
  <mdattim>
    <xsl:apply-templates select="sngdate"/>
  </mdattim>
</xsl:template>

<!-- Range of Dates/Times -->
<xsl:template match="rngdates">
  <rngdates>
    <xsl:for-each select="begdate">
      <begdate><xsl:value-of select="."/></begdate>
    </xsl:for-each>
    <xsl:for-each select="begtime">
      <begtime><xsl:value-of select="."/></begtime>
    </xsl:for-each>
    <xsl:for-each select="enddate">
      <enddate><xsl:value-of select="."/></enddate>
    </xsl:for-each>
    <xsl:for-each select="endtime">
      <endtime><xsl:value-of select="."/></endtime>
    </xsl:for-each>
  </rngdates>
</xsl:template>

<!-- G-Ring -->
<xsl:template match="grngpoin">
  <grngpoin>
    <xsl:for-each select="gringlat">
      <gringlat><xsl:value-of select="."/></gringlat>
    </xsl:for-each>
    <xsl:for-each select="gringlon">
      <gringlon><xsl:value-of select="."/></gringlon>
    </xsl:for-each>
  </grngpoin>
</xsl:template>

<xsl:template match="gring">
  <gring><xsl:value-of select="."/></gring>
</xsl:template>


<!-- Map Projections -->
<xsl:template match="albers">
  <albers>
    <xsl:apply-templates select="stdparll"/>
    <xsl:apply-templates select="longcm"/>
    <xsl:apply-templates select="latprjo"/>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </albers>
</xsl:template>

<xsl:template match="equicon">
  <equicon>
    <xsl:apply-templates select="stdparll"/>
    <xsl:apply-templates select="longcm"/>
    <xsl:apply-templates select="latprjo"/>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </equicon>
</xsl:template>

<xsl:template match="lambertc">
  <lambertc>
    <xsl:apply-templates select="stdparll"/>
    <xsl:apply-templates select="longcm"/>
    <xsl:apply-templates select="latprjo"/>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </lambertc>
</xsl:template>

<xsl:template match="gnomonic">
  <gnomonic>
    <xsl:apply-templates select="longpc"/>
    <xsl:apply-templates select="latprjc"/>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </gnomonic>
</xsl:template>

<xsl:template match="lamberta">
  <lamberta>
    <xsl:apply-templates select="longpc"/>
    <xsl:apply-templates select="latprjc"/>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </lamberta>
</xsl:template>

<xsl:template match="orthogr">
  <orthogr>
    <xsl:apply-templates select="longpc"/>
    <xsl:apply-templates select="latprjc"/>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </orthogr>
</xsl:template>

<xsl:template match="stereo">
  <stereo>
    <xsl:apply-templates select="longpc"/>
    <xsl:apply-templates select="latprjc"/>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </stereo>
</xsl:template>

<xsl:template match="gvnsp">
  <gvnsp>
    <xsl:apply-templates select="heightpt"/>
    <xsl:apply-templates select="longpc"/>
    <xsl:apply-templates select="latprjc"/>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </gvnsp>
</xsl:template>

<xsl:template match="miller">
  <miller>
    <xsl:apply-templates select="longcm"/>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </miller>
</xsl:template>

<xsl:template match="sinusoid">
  <sinusoid>
    <xsl:apply-templates select="longcm"/>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </sinusoid>
</xsl:template>

<xsl:template match="vdgrin">
  <vdgrin>
    <xsl:apply-templates select="longcm"/>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </vdgrin>
</xsl:template>

<xsl:template match="equirect">
  <equirect>
    <xsl:apply-templates select="stdparll"/>
    <xsl:apply-templates select="longcm"/>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </equirect>
</xsl:template>

<xsl:template match="mercator">
  <mercator>
    <xsl:apply-templates select="stdparll"/>
    <xsl:apply-templates select="sfequat"/>
    <xsl:apply-templates select="longcm"/>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </mercator>
</xsl:template>

<xsl:template match="azimequi">
  <azimequi>
    <xsl:apply-templates select="longcm"/>
    <xsl:apply-templates select="latprjo"/>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </azimequi>
</xsl:template>

<xsl:template match="polycon">
  <polycon>
    <xsl:apply-templates select="longcm"/>
    <xsl:apply-templates select="latprjo"/>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </polycon>
</xsl:template>

<xsl:template match="transmer">
  <transmer>
    <xsl:apply-templates select="sfctrmer"/>
    <xsl:apply-templates select="longcm"/>
    <xsl:apply-templates select="latprjo"/>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </transmer>
</xsl:template>

<xsl:template match="polarst">
  <polarst>
    <xsl:apply-templates select="svlong"/>
    <xsl:apply-templates select="stdparll"/>
    <xsl:apply-templates select="sfprjorg"/>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </polarst>
</xsl:template>

<xsl:template match="obqmerc">
  <obqmerc>
    <xsl:apply-templates select="sfctrlin"/>
    <xsl:apply-templates select="obqlazim"/>
    <xsl:apply-templates select="obqlpt"/>
    <xsl:apply-templates select="latprjo"/>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </obqmerc>
</xsl:template>

<xsl:template match="modsak">
  <modsak>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </modsak>
</xsl:template>

<xsl:template match="robinson">
  <robinson>
    <xsl:apply-templates select="longpc"/>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </robinson>
</xsl:template>

<xsl:template match="spaceobq">
  <spaceobq>
    <xsl:apply-templates select="landsat"/>
    <xsl:apply-templates select="pathnum"/>
    <xsl:apply-templates select="feast"/>
    <xsl:apply-templates select="fnorth"/>
  </spaceobq>
</xsl:template>



<!-- Map Projection Parameters -->
<xsl:template match="stdparll">
  <stdparll><xsl:value-of select="."/></stdparll>
</xsl:template>

<xsl:template match="longcm">
  <longcm><xsl:value-of select="."/></longcm>
</xsl:template>

<xsl:template match="latprjo">
  <latprjo><xsl:value-of select="."/></latprjo>
</xsl:template>

<xsl:template match="feast">
  <feast><xsl:value-of select="."/></feast>
</xsl:template>

<xsl:template match="fnorth">
  <fnorth><xsl:value-of select="."/></fnorth>
</xsl:template>

<xsl:template match="sfequat">
  <sfequat><xsl:value-of select="."/></sfequat>
</xsl:template>

<xsl:template match="heightpt">
  <heightpt><xsl:value-of select="."/></heightpt>
</xsl:template>

<xsl:template match="longpc">
  <longpc><xsl:value-of select="."/></longpc>
</xsl:template>

<xsl:template match="latprjc">
  <latprjc><xsl:value-of select="."/></latprjc>
</xsl:template>

<xsl:template match="sfctrlin">
  <sfctrlin><xsl:value-of select="."/></sfctrlin>
</xsl:template>

<xsl:template match="obqlazim">
  <obqlazim>
    <xsl:for-each select="azimangl">
      <azimangl><xsl:value-of select="."/></azimangl>
    </xsl:for-each>
    <xsl:for-each select="azimptl">
      <azimptl><xsl:value-of select="."/></azimptl>
    </xsl:for-each>
  </obqlazim>
</xsl:template>

<xsl:template match="obqlpt">
  <obqlpt>
    <xsl:for-each select="obqllat">
      <obqllat><xsl:value-of select="."/></obqllat>
    </xsl:for-each>
    <xsl:for-each select="obqllong">
       <obqllong><xsl:value-of select="."/></obqllong>
    </xsl:for-each>
  </obqlpt>
</xsl:template>

<xsl:template match="svlong">
  <svlong><xsl:value-of select="."/></svlong>
</xsl:template>

<xsl:template match="sfprjorg">
  <sfprjorg><xsl:value-of select="."/></sfprjorg>
</xsl:template>

<xsl:template match="landsat">
  <landsat><xsl:value-of select="."/></landsat>
</xsl:template>

<xsl:template match="pathnum">
  <pathnum><xsl:value-of select="."/></pathnum>
</xsl:template>

<xsl:template match="sfctrmer">
  <sfctrmer><xsl:value-of select="."/></sfctrmer>
</xsl:template>

<xsl:template match="otherprj">
  <otherprj><xsl:value-of select="."/></otherprj>
</xsl:template>

</xsl:stylesheet>
