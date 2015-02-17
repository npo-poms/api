<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:exsl="http://exslt.org/common"
                xmlns:api="urn:vpro:api:2013"
                xmlns:pages="urn:vpro:pages:2013"
                xmlns:media="urn:vpro:media:2013"
                extension-element-prefixes="exsl">
  <xsl:param name="tempDir" />

  <xsl:output method="text"/>
  <xsl:template match="/">

    <xsl:value-of select="$tempDir" />
    <xsl:for-each select="api:pageSearchResult/api:facets/*">
      <xsl:variable name="file">
        <xsl:value-of select="$tempDir" />/<xsl:value-of select="name()" /><xsl:value-of select="@value" /><xsl:text>.xml</xsl:text>
      </xsl:variable>
      <exsl:document href="{$file}" method="xml">
        <pagesForm xmlns="urn:vpro:api:2013" xmlns:media="urn:vpro:media:2009" highlight="false">
          <searches>
            <sortDates>
              <matcher>
                <begin><xsl:value-of select="api:begin" /></begin>
                <end><xsl:value-of select="api:end" /></end>
              </matcher>
            </sortDates>
          </searches>
          <sortFields>
            <sort order="ASC">sortDate</sort>
          </sortFields>
          <facets>
            <sortDates>
              <interval>YEAR</interval>
            </sortDates>
          </facets>
        </pagesForm>
      </exsl:document>
    </xsl:for-each>
  </xsl:template>
</xsl:stylesheet>
