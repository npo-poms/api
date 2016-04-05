<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:media="urn:vpro:media:2009"
    >
  <xsl:output method="text"/>

  <xsl:template match="/*">
    <xsl:value-of select="@url" />
  </xsl:template>
</xsl:stylesheet>
