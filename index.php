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
	$doi = '10.3897/zookeys.81.1111';
}

$html = get('http://dx.doi.org/' . $doi);

//echo $html;

// grab XML URL

if (preg_match('/<meta\s+name="citation_xml_url"\s+content="(?<content>.*)"\/>/m', $html, $m))
{
	$xml_url = $m['content'];
	
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
	$names[] = $node->firstChild->nodeValue;
}

$names = array_unique($names);
sort($names);
//print_r($names);

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