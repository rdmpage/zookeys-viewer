<?xml version='1.0' encoding='utf-8'?>
<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform' xmlns:xlink='http://www.w3.org/1999/xlink' xmlns:mml="http://www.w3.org/1998/Math/MathML" xmlns:tp="http://www.plazi.org/taxpub"
exclude-result-prefixes="mml tp xlink"


>


<xsl:output method='html' version='1.0' encoding='utf-8' indent='yes' />

<!-- http://www.dzone.com/snippets/trim-template-xslt -->
<xsl:template name="left-trim">
  <xsl:param name="s" />
  <xsl:choose>
    <xsl:when test="substring($s, 1, 1) = ''">
      <xsl:value-of select="$s"/>
    </xsl:when>
    <xsl:when test="normalize-space(substring($s, 1, 1)) = ''">
      <xsl:call-template name="left-trim">
        <xsl:with-param name="s" select="substring($s, 2)" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$s" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="right-trim">
  <xsl:param name="s" />
  <xsl:choose>
    <xsl:when test="substring($s, 1, 1) = ''">
      <xsl:value-of select="$s"/>
    </xsl:when>
    <xsl:when test="normalize-space(substring($s, string-length($s))) = ''">
      <xsl:call-template name="right-trim">
        <xsl:with-param name="s" select="substring($s, 1, string-length($s) - 1)" />
      </xsl:call-template>
    </xsl:when>
    <xsl:otherwise>
      <xsl:value-of select="$s" />
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template name="trim">
  <xsl:param name="s" />
  <xsl:call-template name="right-trim">
    <xsl:with-param name="s">
      <xsl:call-template name="left-trim">
        <xsl:with-param name="s" select="$s" />
      </xsl:call-template>
    </xsl:with-param>
  </xsl:call-template>
</xsl:template>

	<!-- from http://aspn.activestate.com/ASPN/Cookbook/XSLT/Recipe/65426 -->
	<!-- reusable replace-string function -->
	<xsl:template name="replace-string">
		<xsl:param name="text"/>
		<xsl:param name="from"/>
		<xsl:param name="to"/>
		<xsl:choose>
			<xsl:when test="contains($text, $from)">
				<xsl:variable name="before" select="substring-before($text, $from)"/>
				<xsl:variable name="after" select="substring-after($text, $from)"/>
				<xsl:variable name="prefix" select="concat($before, $to)"/>
				<xsl:value-of select="$before"/>
				<xsl:value-of select="$to"/>
				<xsl:call-template name="replace-string">
					<xsl:with-param name="text" select="$after"/>
					<xsl:with-param name="from" select="$from"/>
					<xsl:with-param name="to" select="$to"/>
				</xsl:call-template>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>


<xsl:template match="/">
	<xsl:apply-templates select="//article-meta"/>
	<xsl:apply-templates select="//abstract"/>
	<xsl:apply-templates select="//body"/>
</xsl:template>

<xsl:template match="//article-meta">
	<h1><xsl:value-of select="//article-title" /></h1>

		<script>
				<xsl:text>document.title='</xsl:text>
	<xsl:call-template name="trim">
        <xsl:with-param name="s" select="//article-title" />
      </xsl:call-template>
				<xsl:text>';</xsl:text>
		</script>

	<xsl:apply-templates select="//contrib-group"/>
</xsl:template>

<!-- authors -->
<xsl:template match="//contrib-group">
	<h2>
		<xsl:apply-templates select="contrib"/>
	</h2>
</xsl:template>

    <xsl:template match="contrib">
        <xsl:if test="@contrib-type='author'">
            <xsl:if test="position() != 1"><xsl:text>, </xsl:text></xsl:if>
            <xsl:value-of select="name/given-names" />
            <xsl:text> </xsl:text>
            <xsl:value-of select="name/surname" />
        </xsl:if>
        
    </xsl:template>

    <xsl:template match="//abstract">
            <xsl:apply-templates/>
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

        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="title">

    </xsl:template>


    <!-- basic elements -->
    <xsl:template match="p"><p><xsl:apply-templates /></p></xsl:template>
    <xsl:template match="italic"><i><xsl:apply-templates /></i></xsl:template>
    <xsl:template match="bold"><b><xsl:apply-templates /></b></xsl:template>

	<!-- label -->
    <xsl:template match="label"><b><xsl:apply-templates /></b></xsl:template>

	<!-- title -->
    <!--<xsl:template match="title"><b><xsl:apply-templates /></b></xsl:template>-->

	<xsl:template match="xref">
		<xsl:choose>

			<!-- citation -->
			<xsl:when test="@ref-type='bibr'">
				<span class="bibr">
					<xsl:attribute name = "onclick">
						<xsl:text>show_reference('</xsl:text>
						<xsl:value-of select="@rid" />
						<xsl:text>');</xsl:text>
					</xsl:attribute> 
					<xsl:apply-templates/>
				</span>
			</xsl:when>


			<!-- figure -->
			<xsl:when test="@ref-type='fig'">
				<span class="fig">
					<xsl:attribute name = "onclick">
						<xsl:text>show_figure('</xsl:text>
						<xsl:value-of select="@rid" />
						<xsl:text>');</xsl:text>
					</xsl:attribute> 
					<xsl:apply-templates/>
				</span>
			</xsl:when>

			<!-- table -->			
			<xsl:when test="@ref-type='table'">
				<span class="fig">
					<xsl:attribute name = "onclick">
						<xsl:text>show_table('</xsl:text>
						<xsl:value-of select="@rid" />
						<xsl:text>');</xsl:text>
					</xsl:attribute> 
					<xsl:apply-templates/>
				</span>
			</xsl:when>
			<xsl:otherwise>
				<xsl:apply-templates/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>



	<!-- taxpub -->
	<xsl:template match="tp:taxon-name">
		<span class="taxon-name">
			<!-- <a>
				<xsl:attribute name="href">
					<xsl:text>../search/</xsl:text>
					<xsl:value-of select="." />
				</xsl:attribute>	
				<xsl:apply-templates />
			</a> -->

					<xsl:attribute name = "onclick">

						<xsl:text>show_taxon_name('name-</xsl:text>
				<xsl:call-template name="replace-string">
					<xsl:with-param name="text" select="."/>
					<xsl:with-param name="from" select="' '"/>
					<xsl:with-param name="to" select="'-'"/>
				</xsl:call-template>
						<xsl:text>');</xsl:text>
					</xsl:attribute> 
					<xsl:apply-templates/>



		</span>
	</xsl:template>

<!-- eat -->
<xsl:template match="table-wrap">
</xsl:template>
<xsl:template match="table">
</xsl:template>
<xsl:template match="fig">
</xsl:template>
<xsl:template match="object-id">
</xsl:template>


</xsl:stylesheet>