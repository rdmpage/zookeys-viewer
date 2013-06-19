<?xml version='1.0' encoding='utf-8'?>
<xsl:stylesheet version='1.0' xmlns:xsl='http://www.w3.org/1999/XSL/Transform' xmlns:xlink='http://www.w3.org/1999/xlink' xmlns:mml="http://www.w3.org/1998/Math/MathML" xmlns:tp="http://www.plazi.org/taxpub"
exclude-result-prefixes="mml tp xlink"


>


<xsl:output method='html' version='1.0' encoding='utf-8' indent='yes' />


<xsl:template match="/">
	<xsl:apply-templates select="//article-meta"/>
	<xsl:apply-templates select="//back/ack"/>


</xsl:template>

    <xsl:template match="//back/ack">
		<div class="info-panel">
		<h3>
			<xsl:value-of select="title" />
		</h3>
        <p><xsl:apply-templates select="p"/></p>
		</div>        
    </xsl:template>


<xsl:template match="//article-meta">
	<div class="info-panel">
	<p>Keywords</p>
	<xsl:apply-templates select="kwd-group"/>

	 <p>Links</p>
	<ul>
		<li>
			<xsl:text>DOI: </xsl:text>
    		<a target="_new">
				<xsl:attribute name="href">
					<xsl:text>http://dx.doi.org/</xsl:text>
					<xsl:value-of select="article-id[@pub-id-type='doi']" />
				</xsl:attribute>
				<xsl:value-of select="article-id[@pub-id-type='doi']" />
			</a>
        </li>
		<xsl:apply-templates select="//self-uri[@content-type='lsid']"/>
	</ul>
	</div>

	<xsl:apply-templates select="contrib-group/contrib"/>
	<xsl:apply-templates select="permissions"/>

</xsl:template>

<!-- ZooBank LSID for article -->
<xsl:template match="//self-uri[@content-type='lsid']">
<li>
	<xsl:text>LSID </xsl:text>
    		<a target="_new">
				<xsl:attribute name="href">
					<xsl:text>http://zoobank.org/?lsid=</xsl:text>
					<xsl:value-of select="." />
				</xsl:attribute>
				<xsl:value-of select="." />
			</a>
</li>
</xsl:template>

    <xsl:template match="contrib">
        <xsl:if test="@contrib-type='author'">
			<div class="info-panel">
			<h3>
            <xsl:value-of select="name/given-names" />
            <xsl:text> </xsl:text>
            <xsl:value-of select="name/surname" />
			</h3>
			<xsl:value-of select="aff" />
			</div>
        </xsl:if>        
    </xsl:template>

     <xsl:template match="kwd-group">
       <div>
   			<xsl:apply-templates select="kwd"/>
		</div>
     </xsl:template>

    <xsl:template match="kwd">
      <xsl:if test="position() != 1"><xsl:text>, </xsl:text></xsl:if>
      <xsl:value-of select="." />
     </xsl:template>

   <xsl:template match="permissions">
     <div class="info-panel">
          <h3>Copyright</h3>
          <p>&#169; <xsl:value-of select="copyright-statement" />. 
          <xsl:value-of select="license/license-p" /></p>
     </div>
    </xsl:template>

</xsl:stylesheet>