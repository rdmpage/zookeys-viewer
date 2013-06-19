<?xml version='1.0' encoding='utf-8'?>
<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform' xmlns:xlink='http://www.w3.org/1999/xlink' xmlns:mml="http://www.w3.org/1998/Math/MathML" xmlns:tp="http://www.plazi.org/taxpub"
exclude-result-prefixes="mml tp xlink"


>


<xsl:output method='html' version='1.0' encoding='utf-8' indent='yes' />


<xsl:template match="/">
	<xsl:apply-templates select="//body"/>
</xsl:template>

    <xsl:template match="//body">
        <xsl:apply-templates select="sec"/>
    </xsl:template>

    <xsl:template match="sec">

		<!-- get depth of title -->
		<xsl:variable name="depth" select="count(ancestor::sec)" />

		<!-- set header level based on depth -->
		<xsl:choose>
			<xsl:when test="$depth=0">
				<h2><xsl:value-of select="title"/></h2>
			</xsl:when>
			<xsl:when test="$depth=1">
				<h3><xsl:value-of select="title"/></h3>
			</xsl:when>
			<xsl:when test="$depth=2">
				<h4><xsl:value-of select="title"/></h4>
			</xsl:when>
			<xsl:when test="$depth=3">
				<h5><xsl:value-of select="title"/></h5>
			</xsl:when>
			<xsl:otherwise>
				<b><xsl:value-of select="title"/></b>
			</xsl:otherwise>
		</xsl:choose>
    </xsl:template>



</xsl:stylesheet>