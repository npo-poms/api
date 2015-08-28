<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:api="urn:vpro:api:2013"
    xmlns="urn:vpro:api:2013"
    exclude-result-prefixes="api"
    >
  <xsl:param name="text" />
  <xsl:output method="xml"/>


  <xsl:template match="/">
    <xsl:copy>
      <xsl:apply-templates select="* | @*"/>
    </xsl:copy>
  </xsl:template>

   <xsl:template match="@* | node()">
     <xsl:copy>
       <xsl:apply-templates select="@* | node()"/>
     </xsl:copy>
   </xsl:template>


  <xsl:template match="/api:pagesForm/api:searches/api:text">
    <text><xsl:value-of select="$text" /></text>
  </xsl:template>
</xsl:stylesheet>
