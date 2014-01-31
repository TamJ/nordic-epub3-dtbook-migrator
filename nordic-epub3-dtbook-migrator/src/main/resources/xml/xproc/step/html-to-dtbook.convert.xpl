<?xml version="1.0" encoding="UTF-8"?>
<p:declare-step xmlns:p="http://www.w3.org/ns/xproc" xmlns:c="http://www.w3.org/ns/xproc-step" xmlns:px="http://www.daisy.org/ns/pipeline/xproc" xmlns:d="http://www.daisy.org/ns/pipeline/data"
    type="px:nordic-html-to-dtbook-convert" name="main" version="1.0" xmlns:epub="http://www.idpf.org/2007/ops" xmlns:dtbook="http://www.daisy.org/z3986/2005/dtbook/"
    xmlns:html="http://www.w3.org/1999/xhtml" xmlns:cx="http://xmlcalabash.com/ns/extensions">

    <p:input port="fileset.in" primary="true"/>
    <p:input port="in-memory.in" sequence="true"/>

    <p:output port="fileset.out" primary="true">
        <!--        <p:pipe port="fileset" step="result"/>-->
        <p:pipe port="result" step="result.fileset"/>
    </p:output>
    <p:output port="in-memory.out" sequence="true">
        <!--        <p:pipe port="in-memory" step="result"/>-->
        <p:pipe port="result" step="result.in-memory"/>
    </p:output>

    <!--    <p:option name="temp-dir" required="true"/>-->

    <p:import href="../library.xpl"/>
    <p:import href="http://www.daisy.org/pipeline/modules/file-utils/library.xpl"/>
    <p:import href="http://www.daisy.org/pipeline/modules/fileset-utils/library.xpl"/>
    <p:import href="http://www.daisy.org/pipeline/modules/common-utils/library.xpl"/>

    <!--<p:variable name="doc-base" select="base-uri(/)">
        <p:inline>
            <irrelevant/>
        </p:inline>
    </p:variable>-->

    <px:fileset-load media-types="application/xhtml+xml">
        <p:input port="in-memory">
            <p:pipe port="in-memory.in" step="main"/>
        </p:input>
    </px:fileset-load>
    <px:assert test-count-max="1" message="There are multiple HTML files in the fileset; only the first one will be converted."/>
    <px:assert test-count-min="1" message="There must be a HTML file in the fileset." error-code="NORDICDTBOOKEPUB005"/>
    <p:split-sequence initial-only="true" test="position()=1"/>
    <p:identity name="input-html"/>

    <!-- TODO: should the input HTML be validated here ? -->

    <!-- Make sure only sections corresponding to html:h[1-6] are used. -->
    <p:xslt>
        <p:with-param name="name" select="'section article'"/>
        <p:with-param name="namespace" select="'http://www.w3.org/1999/xhtml'"/>
        <p:with-param name="max-depth" select="6"/>
        <p:with-param name="copy-wrapping-elements-into-result" select="true()"/>
        <p:input port="stylesheet">
            <p:document href="http://www.daisy.org/pipeline/modules/common-utils/deep-level-grouping.xsl"/>
        </p:input>
    </p:xslt>

    <p:xslt>
        <p:input port="parameters">
            <p:empty/>
        </p:input>
        <p:input port="stylesheet">
            <p:document href="../../xslt/epub3-to-dtbook.xsl"/>
        </p:input>
    </p:xslt>

    <p:add-attribute match="/*" attribute-name="xml:base">
        <p:with-option name="attribute-value" select="concat(replace(base-uri(/*),'^(.*)\.[^/\.]*$','$1'),'.xml')">
            <p:pipe port="result" step="input-html"/>
        </p:with-option>
    </p:add-attribute>
    <p:identity name="result.in-memory"/>

    <!-- TODO: validate output DTBook ? -->

    <p:identity>
        <p:input port="source">
            <p:pipe port="fileset.in" step="main"/>
        </p:input>
    </p:identity>
    <p:delete match="//d:file[@media-type=('application/xhtml+xml','text/css')]"/>
    <px:fileset-add-entry media-type="application/x-dtbook+xml">
        <p:with-option name="href" select="base-uri(/*)">
            <p:pipe port="result" step="result.in-memory"/>
        </p:with-option>
    </px:fileset-add-entry>
    <p:add-attribute match="//d:file[@media-type='application/x-dtbook+xml']" attribute-name="doctype-public" attribute-value="-//NISO//DTD dtbook 2005-3//EN"/>
    <p:add-attribute match="//d:file[@media-type='application/x-dtbook+xml']" attribute-name="doctype-system" attribute-value="http://www.daisy.org/z3986/2005/dtbook-2005-3.dtd"/>
    <p:add-attribute match="//d:file[@media-type='application/x-dtbook+xml']" attribute-name="omit-xml-declaration" attribute-value="false"/>
    <p:identity name="result.fileset"/>

</p:declare-step>