<?xml version='1.0' encoding='utf-8'?>
<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform' xmlns:xlink='http://www.w3.org/1999/xlink' xmlns:mml="http://www.w3.org/1998/Math/MathML" xmlns:tp="http://www.plazi.org/taxpub"
exclude-result-prefixes="mml tp xlink"


>


<xsl:output method='html' version='1.0' encoding='utf-8' indent='yes' />

<xsl:param name="imagePrefix" />

<xsl:template match="/">

<xsl:apply-templates select="//fig"/>
<xsl:apply-templates select="//table-wrap"/>

</xsl:template>


	<!-- table -->
    <xsl:template match="table-wrap">

		<div class="info-panel">
				<xsl:attribute name="id">
					<xsl:value-of select="@id"/>
				</xsl:attribute>

			<h3>
				<xsl:value-of select="label" />
			</h3>
		<div><xsl:value-of select="caption" /></div>

		<xsl:apply-templates select="table"/>

		</div>
	</xsl:template>

   <xsl:template match="table">
		<table class="table table-striped table-condensed" style="background-color:white;">
			<xsl:apply-templates />
		</table>
	</xsl:template>


    <xsl:template match="tbody"><tbody><xsl:apply-templates /></tbody></xsl:template>
    <xsl:template match="tr"><tr><xsl:apply-templates /></tr></xsl:template>
    <xsl:template match="td"><td><xsl:apply-templates /></td></xsl:template>


    <!-- figure -->
    <xsl:template match="fig">
		<div class="info-panel">
				<xsl:attribute name="id">
					<xsl:value-of select="@id"/>
				</xsl:attribute>

			<h3>
				<xsl:value-of select="label" />
			</h3>

		<div style="width:100%">
		<img>
			<xsl:attribute name="src">
				<xsl:value-of select="$imagePrefix" />
				<xsl:text>ZooKeys-</xsl:text>
				<xsl:value-of select="substring-after(graphic/@xlink:href, 'ZooKeys-')" />
			</xsl:attribute>
		</img>
		</div>

		<div><xsl:value-of select="caption" /></div>


		</div>

	</xsl:template>




</xsl:stylesheet>