<?php
	include_once('../config.php');
    
	header("Content-Type: application/rss+xml; charset=UTF-8");
 
 	(isset($_SERVER['HTTPS'])) ? $protocol = "https://" : $protocol = "http://" ;
 
	$rssfeed = '<rss xmlns:atom="http://www.w3.org/2005/Atom" version="2.0">'.PHP_EOL;
	$rssfeed .= '	<channel>'.PHP_EOL;
	$rssfeed .= '		<title>Marjo21</title>'.PHP_EOL;
	$rssfeed .= '		<atom:link href="'.$protocol.$_SERVER['HTTP_HOST'].'/rss/" rel="self" type="application/rss+xml"/>'.PHP_EOL;
	$rssfeed .= '		<description>Derniers liens postés sur marjo21</description>'.PHP_EOL;
	$rssfeed .= '		<language>en-us</language>'.PHP_EOL;
	$rssfeed .= '		<copyright>Copyright (C) 2016 Adrien_D</copyright>'.PHP_EOL;

	$pdo = new PDO('mysql:host='.$dbhost.';port='.$dbport.';dbname='.$db.'', $dbuser, $dbpasswd);
	$pdo->exec("SET CHARACTER SET utf8");                                                                     

	$res = $pdo->query("SELECT * FROM links ORDER BY dateandtime DESC LIMIT 100");
	$res->setFetchMode(PDO::FETCH_ASSOC);

	foreach ( $res as $row )
	{
		$rssfeed .= '		<item>'.PHP_EOL;
		$rssfeed .= '			<title>' . htmlspecialchars($row['user']) . ': ' . htmlspecialchars($row['title']) . '</title>'.PHP_EOL;
		$rssfeed .= '			<link>' . htmlspecialchars($row['link']) . '</link>'.PHP_EOL;
		$rssfeed .= '			<guid>' . htmlspecialchars($row['link']) . '</guid>'.PHP_EOL;
		$rssfeed .= '			<description>' . htmlspecialchars($row['title']) . '</description>'.PHP_EOL;
		$rssfeed .= '			<pubDate>' . date("D, d M Y H:i:s O", strtotime($row['dateandtime'])) . '</pubDate>'.PHP_EOL;
		$rssfeed .= '		</item>'.PHP_EOL;
	}
	
	$rssfeed .= '	</channel>'.PHP_EOL;
	$rssfeed .= '</rss>'.PHP_EOL;
 
	echo $rssfeed;

	$pdo = null;
?>
