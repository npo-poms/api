<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:media="urn:vpro:media:2009"
    >
  <xsl:param name="platform">PLUSVOD</xsl:param>
  <xsl:output method="text"/>
  <xsl:template match="/">
    <xsl:for-each select="//media:*/media:prediction[text() = $platform]">
      <xsl:value-of select="text()" />
      <xsl:text> </xsl:text>
      <xsl:value-of select="@publishStart" />
      <xsl:text> - </xsl:text>
      <xsl:value-of select="@publishStop" />
      <xsl:text> - </xsl:text>
      <xsl:value-of select="../@lastModified" />
      <xsl:text>&#xa;</xsl:text>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
