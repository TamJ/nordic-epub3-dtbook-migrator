<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:f="http://www.daisy.org/ns/pipeline/internal-functions" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0" xmlns:epub="http://www.idpf.org/2007/ops"
    xmlns="http://www.w3.org/1999/xhtml" xpath-default-namespace="http://www.w3.org/1999/xhtml" exclude-result-prefixes="#all" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:c="http://www.w3.org/ns/xproc-step">

    <xsl:output indent="yes"/>

    <xsl:template match="node()">
        <xsl:apply-templates select="node()"/>
    </xsl:template>

    <xsl:template match="/*">
        <c:result>
            <xsl:apply-templates/>
        </c:result>
    </xsl:template>

    <xsl:template match="h1 | h2 | h3 | h4 | h5 | h6">
        <xsl:variable name="sectioning-element" select="parent::*"/>
        <c:result>
            <xsl:attribute name="xml:base" select="base-uri(.)"/>
            <xsl:attribute name="data-sectioning-element" select="$sectioning-element/name()"/>
            <xsl:if test="$sectioning-element/@id">
                <xsl:attribute name="data-sectioning-id" select="$sectioning-element/@id"/>
            </xsl:if>
            <xsl:attribute name="data-heading-element" select="name()"/>
            <xsl:if test="@id">
                <xsl:attribute name="data-heading-id" select="@id"/>
            </xsl:if>
            <xsl:value-of select="normalize-space(string-join(.//text(),''))"/>
        </c:result>
    </xsl:template>

</xsl:stylesheet>
