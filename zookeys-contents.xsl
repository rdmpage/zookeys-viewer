<?xml version='1.0' encoding='utf-8'?>
<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform' xmlns:xlink='http://www.w3.org/1999/xlink' xmlns:mml="http://www.w3.org/1998/Math/MathML" xmlns:tp="http://www.plazi.org/taxpub"
exclude-result-prefixes="mml tp xlink">


<xsl:output method='html' version='1.0' encoding='utf-8' indent='yes' />


<xsl:template match="/">
	<xsl:apply-templates select="//body"/>
</xsl:template>

    <xsl:template match="//body">
		<ul>
        	<xsl:apply-templates />
		</ul>
    </xsl:template>

    <xsl:template match="sec">
			<li>
				<xsl:value-of select="title"/>
				<ul>
					<xsl:apply-templates />
				</ul>
			</li>		
    </xsl:template>

    <xsl:template match="tp:taxon-treatment">
		<li>
			<xsl:text>Treatment</xsl:text>
				<ul>
					<xsl:apply-templates />
				</ul>
		</li>
	</xsl:template>


    <xsl:template match="tp:treatment-sec">
		<li>
			<xsl:value-of select="title"/>
			<ul>
				<xsl:apply-templates />
			</ul>
		</li>
	</xsl:template>

<!-- http://stackoverflow.com/questions/3360017/why-does-xslt-output-all-text-by-default -->
<!-- eat everything else -->
<xsl:template match="text()|@*">
</xsl:template>


</xsl:stylesheet>