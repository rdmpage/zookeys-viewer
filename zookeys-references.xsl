<?xml version="1.0"?>
<xsl:stylesheet xmlns:mml="http://www.w3.org/1998/Math/MathML" xmlns:tp="http://www.plazi.org/taxpub" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" exclude-result-prefixes="mml tp xlink" version="1.0">
	<xsl:output encoding="utf-8" indent="yes" method="html" version="1.0"/>
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
		<xsl:apply-templates select="//back"/>
	</xsl:template>
	<xsl:template match="//back">
		<xsl:apply-templates select="ref-list"/>
	</xsl:template>
	<!-- references -->
	<xsl:template match="ref-list">
			<xsl:apply-templates select="ref"/>
	</xsl:template>

	<!-- Reference list -->
	<xsl:template match="ref">
		<div class="info-panel">
				<xsl:attribute name="id">
					<xsl:value-of select="@id"/>
				</xsl:attribute>
			<xsl:apply-templates select="mixed-citation"/>

		

		</div>
	</xsl:template>

	<!-- authors -->
	<xsl:template match="//person-group">
		<xsl:apply-templates select="name"/>
	</xsl:template>
	<xsl:template match="name">
		<xsl:if test="position() != 1">
			<xsl:text>, </xsl:text>
		</xsl:if>
		<xsl:value-of select="surname"/>
		<xsl:text>, </xsl:text>
		<xsl:value-of select="given-names"/>
	</xsl:template>

	<!-- a citation -->
	<xsl:template match="mixed-citation">
		
		<xsl:choose>
			<xsl:when test="article-title and source and volume">
				<div style="font-weight:bold">

					<xsl:value-of select="article-title"/>
				</div>

				<div>
					<xsl:apply-templates select="person-group"/>
				</div>

				<div class="muted">
				<xsl:value-of select="source"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="volume"/>
				<xsl:text>:</xsl:text>
				<xsl:value-of select="fpage"/>
				<xsl:text>-</xsl:text>
				<xsl:value-of select="lpage"/>
				<xsl:text> (</xsl:text>
					<xsl:value-of select="year"/>
				<xsl:text>) </xsl:text>
				</div>
			</xsl:when>
			<!-- book -->
			<xsl:when test="source and publisher-name">
				<div style="font-weight:bold">
					<xsl:value-of select="source"/>
				</div>

				<div>
					<xsl:apply-templates select="person-group"/>
				</div>

				<xsl:text> </xsl:text>
				<xsl:value-of select="publisher-name"/>
				<xsl:text> </xsl:text>
				<xsl:value-of select="publisher-loc"/>

				<xsl:text> (</xsl:text>
					<xsl:value-of select="year"/>
				<xsl:text>) </xsl:text>

			</xsl:when>
			<!-- other -->
			<xsl:otherwise>
				<xsl:value-of select="source"/>
			</xsl:otherwise>
		</xsl:choose>

		

		<!-- identifiers -->
		<xsl:for-each select="ext-link">
			<xsl:choose>
				<xsl:when test="@ext-link-type='uri'">
					<xsl:if test="starts-with(.,'10.')">
						<div>
							<b>DOI: </b>
							<a target="_new">
								<xsl:attribute name="href">
									<xsl:text>http://dx.doi.org/</xsl:text>
									<xsl:value-of select="."/>
								</xsl:attribute>
								<xsl:value-of select="."/>
							</a>
							
						</div>
					</xsl:if>
				</xsl:when>
				<xsl:otherwise>
						</xsl:otherwise>
			</xsl:choose>
		</xsl:for-each>

		<div>
		<button class="btn btn-info" >
			<xsl:attribute name="id">
				<xsl:text>find_</xsl:text>
				<xsl:value-of select="../@id"/>
			</xsl:attribute>

			<xsl:attribute name="onclick">
				<xsl:text>openurl('</xsl:text>

				<xsl:text>ctx_ver=Z39.88-2004&amp;rft_val_fmt=info:ofi/fmt:kev:mtx:journal</xsl:text>
				<!-- referring entity (i.e., this article -->
				<xsl:text>&amp;rfe_id=info:doi/</xsl:text>
				<xsl:value-of select="//article-meta/article-id[@pub-id-type='doi']"/>
				<!-- authors -->
				<xsl:for-each select="person-group">
					<!-- <xsl:if test="@person-group-type='author'"> -->
					<!-- first author -->
					<xsl:text>&amp;rft.aulast=</xsl:text>
					<xsl:value-of select="name[1]/surname"/>
					<xsl:text>&amp;rft.aufirst=</xsl:text>
					<xsl:value-of select="name[1]/given-names"/>
					<!-- all authors -->
					<xsl:for-each select="name">
						<xsl:text>&amp;rft.au=</xsl:text>
						<xsl:value-of select="given-names"/>
						<xsl:text>+</xsl:text>
						<xsl:value-of select="surname"/>
					</xsl:for-each>
					<!-- </xsl:if> -->
				</xsl:for-each>
				<!-- article title -->
				<xsl:text>&amp;rft.atitle=</xsl:text>
				<xsl:call-template name="replace-string">
					<xsl:with-param name="text" select="article-title"/>
					<xsl:with-param name="from" select="' '"/>
					<xsl:with-param name="to" select="'+'"/>
				</xsl:call-template>
				<!-- journal title -->
				<xsl:text>&amp;rft.jtitle=</xsl:text>
				<xsl:call-template name="replace-string">
					<xsl:with-param name="text" select="source"/>
					<xsl:with-param name="from" select="' '"/>
					<xsl:with-param name="to" select="'+'"/>
				</xsl:call-template>
				<!-- sometimes volume field contains issue -->
				<xsl:choose>
					<xsl:when test="contains(volume, ')')">
						<xsl:variable name="after" select="substring-after(volume, '(')"/>
						<xsl:variable name="issue" select="substring-before($after, ')')"/>
						<xsl:variable name="before" select="substring-before(volume, '(')"/>
						<xsl:text>&amp;rft.volume=</xsl:text>
						<xsl:value-of select="$before"/>
						<xsl:text>&amp;rft.issue=</xsl:text>
						<xsl:value-of select="$issue"/>
					</xsl:when>
					<xsl:otherwise>
						<xsl:text>&amp;rft.volume=</xsl:text>
						<xsl:value-of select="volume"/>
					</xsl:otherwise>
				</xsl:choose>
				<xsl:text>&amp;rft.spage=</xsl:text>
				<xsl:value-of select="fpage"/>
				<xsl:text>&amp;rft.epage=</xsl:text>
				<xsl:value-of select="lpage"/>
				<xsl:text>&amp;rft.date=</xsl:text>
				<xsl:value-of select="year"/>
				<!-- any existing identifiers -->
				<xsl:for-each select="ext-link">
					<xsl:choose>
						<xsl:when test="contains(@xlink:href, 'http://dx.doi.org/')">
							<xsl:text>&amp;rft_id=info:doi/</xsl:text>
							<xsl:value-of select="substring-after(@xlink:href, 'http://dx.doi.org/')"/>
						</xsl:when>
						<xsl:otherwise>
								</xsl:otherwise>
					</xsl:choose>
				</xsl:for-each>

				<xsl:text>','</xsl:text>
				<xsl:value-of select="../@id"/>
				<xsl:text>')</xsl:text>
			</xsl:attribute>

			<xsl:text>Find in BioNames</xsl:text>

		</button>

		<div>
			<xsl:attribute name="id">
				<xsl:text>reference_</xsl:text>
				<xsl:value-of select="../@id"/>
			</xsl:attribute>
		</div>
		</div>
	</xsl:template>


</xsl:stylesheet>
