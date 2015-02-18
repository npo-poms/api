<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:exsl="http://exslt.org/common"
                xmlns:api="urn:vpro:api:2013"
                xmlns:pages="urn:vpro:pages:2013"
                xmlns:media="urn:vpro:media:2013"
                extension-element-prefixes="exsl">
  <xsl:output method="xml"/>
  <xsl:template match="/">
    <out>
      <xsl:copy-of select="api:pageSearchResult/api:facets" />
    </out>
  </xsl:template>
</xsl:stylesheet>
