<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns="urn:vpro:api:2013"
                >
  <xsl:param name="text" />
  <xsl:output method="xml"/>

  <xsl:template match="*">
    <xsl:copy-of select="." />
  </xsl:template>
  <xsl:template match="/pagesForm/mediaForm/searches/mediaIds">
    <matcher match="MUST"><xsl:value-of select="$text" /></matcher>
  </xsl:template>
</xsl:stylesheet>
