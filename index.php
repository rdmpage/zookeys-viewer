<?php

require_once(dirname(__FILE__) . '/lib.php');

$template_filename = 'template.html';

$template = file_get_contents($template_filename);

/*

$base_url = 'http://www.pensoft.net/J_FILES/1/articles/1237/';

$xml = file_get_contents('1237-G-2-layout.xml');

*/


if (isset($_GET['doi']))
{
	$doi = $_GET['doi'];
}
else
{
	echo '<!DOCTYPE html>
<html>
<head>
	<base href="." /><!--[if IE]></base><![endif]-->

	<!-- standard stuff -->
	<meta charset="utf-8" />

	<link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet" media="screen">

	<link href=\'../../images/favicon.png\' rel=\'icon\' type=\'image/png\'>

	<!-- responsive -->
	<meta name="viewport" content="width=device-width, initial-scale=1.0">
	<link href="vendor/bootstrap/css/bootstrap-responsive.css" rel="stylesheet">	

	<script src="js/jquery.js"></script>
	<script src="vendor/bootstrap/js/bootstrap.min.js"></script>

	<!-- Le HTML5 shim, for IE6-8 support of HTML5 elements -->
	<!--[if lt IE 9]>
	  <script src="http://html5shim.googlecode.com/svn/trunk/html5.js"></script>
	<![endif]-->
	

</head>
<body style="background-color:#f2f2f2;">

	<div class="navbar navbar-fixed-top">
		<div class="navbar-inner">
			<div class="container-fluid">
				 <a class="brand" href="http://bionames.org">BioNames</a>
				 <ul class="nav">
				  </ul>
			  </div>
		</div>
	</div>
	
	<div class="container-fluid" style="margin-top:60px;font-family:Helvetica, Arial, Verdana, sans-serif;">
		<h1>ZooKeys viewer examples</h1>
		<div class="row-fluid">

			<div class="span2">
				<a href="?doi=10.3897/zookeys.99.723">The spider family Selenopidae (Arachnida, Araneae) in Australasia and the Oriental Region</a>
			</div>

			<div class="span2">
				<a href="?doi=10.3897/zookeys.183.3073">Description of Alpheus cedrici sp. n., a strikingly coloured snapping shrimp (Crustacea, Decapoda, Alpheidae) from Ascension Island, central Atlantic Ocean</a>
			</div>

			<div class="span2">
				<a href="?doi=10.3897/zookeys.178.1410">Diversity of the strongly rheophilous tadpoles of Malagasy tree frogs, genus Boophis (Anura, Mantellidae), and identification of new candidate species via larval DNA sequence and morphology </a>
			</div>

			<div class="span2">
				<a href="?doi=10.3897/zookeys.290.5114">A review of the Western Australian keeled millipede genus Boreohesperus (Diplopoda, Polydesmida, Paradoxosomatidae) </a>
			</div>

		
		</div>
	</div>


</body>
</html>';

exit();
}


if (0)
{
	// Fetch from ZooKeys site via DOI

	$html = get('http://dx.doi.org/' . $doi);

	if (preg_match('/<meta\s+name="citation_xml_url"\s+content="(?<content>.*)"\/>/m', $html, $m))
	{
		$xml_url = $m['content'];
		
		$xml = get($xml_url);
	}
}
else
{
	$xml_url = 'https://raw.github.com/rdmpage/ZooKeys-xml/master/' . str_replace('/', '_', $doi) . '.xml';
	$xml = get($xml_url);
}

//exit();


$dom = new DOMDocument;
$dom->loadXML($xml);


// Body of article
$xp = new XsltProcessor();
$xsl = new DomDocument;
$xsl->load(dirname(__FILE__) . '/zookeys-body.xsl');
$xp->importStylesheet($xsl);

$text = $xp->transformToXML($dom);

$template = str_replace('<BODY>', $text, $template);

// Info
$xp = new XsltProcessor();
$xsl = new DomDocument;
$xsl->load(dirname(__FILE__) . '/zookeys-info.xsl');
$xp->importStylesheet($xsl);

$text = $xp->transformToXML($dom);

$template = str_replace('<INFO>', $text, $template);

// Table of contents
$xp = new XsltProcessor();
$xsl = new DomDocument;
$xsl->load(dirname(__FILE__) . '/zookeys-contents.xsl');
$xp->importStylesheet($xsl);

$text = $xp->transformToXML($dom);

$template = str_replace('<CONTENTS>', $text, $template);


// References
$xp = new XsltProcessor();
$xsl = new DomDocument;
$xsl->load(dirname(__FILE__) . '/zookeys-references.xsl');
$xp->importStylesheet($xsl);

$text = $xp->transformToXML($dom);

$template = str_replace('<REFERENCES>', $text, $template);


// Figures
$xp = new XsltProcessor();
$xsl = new DomDocument;
$xsl->load(dirname(__FILE__) . '/zookeys-figures.xsl');
$xp->importStylesheet($xsl);

// Construct URL for figures (sigh)

if (preg_match('/\.(?<id>\d+)$/', $doi, $m))
{
	$base_url = 'http://www.pensoft.net/J_FILES/1/articles/' . $m['id'] . '/export.php_files/';
	$xp->setParameter('', 'imagePrefix', $base_url);
}

$text = $xp->transformToXML($dom);

$template = str_replace('<FIGURES>', $text, $template);


// Names
$xpath = new DOMXPath($dom);
$xpath->registerNamespace('tp', 'http://www.plazi.org/taxpub');
$xpath_query = "//tp:taxon-name";

$names = array(); 

$nodeCollection = $xpath->query ($xpath_query);
foreach($nodeCollection as $node)
{
	$parts = array();

	// handle case where name has been atomised
	$nc = $xpath->query ('tp:taxon-name-part', $node);
	foreach ($nc as $n)
	{
		$parts[] = $n->firstChild->nodeValue;
	}
	
	if (count($parts) > 0)
	{
		$namestring = join(' ', $parts);
	}
	else
	{
		$namestring = $node->firstChild->nodeValue;
	}

	$names[] = $namestring;
}

$names = array_unique($names);
sort($names);
//print_r($names);

//exit();

$text = '';
foreach ($names as $name)
{
	$text .= '<div class="info-panel" id="name-' . str_replace(' ', '-', $name) . '">';
	
	$text .= '<div>' . $name . '</div>';
	
	$text .= '<button class="btn btn-info" id="find-name-' . str_replace(' ', '-', $name) . '"';
	$text .= ' onclick="namesearch(\'' . $name . '\',\'name-' . str_replace(' ', '-', $name) . '\')" >';
	$text .= 'Find in BioNames';
	$text .= '</button>';
	
	$text .= '<div id="show-name-' .str_replace(' ', '-', $name) . '"></div>';
	
	$text .= '</div>';
}


$template = str_replace('<TAXA>', $text, $template);


echo $template;

?>