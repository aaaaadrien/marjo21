<?php
	include_once('../config.php');
    
	header("Content-Type: application/rss+xml; charset=UTF-8");
 
 	(isset($_SERVER['HTTPS'])) ? $protocol = "https://" : $protocol = "http://" ;
 
	$rssfeed = '<?xml version="1.0" encoding="UTF-8"?>'.PHP_EOL;
	$rssfeed .= '<rss version="2.0">'.PHP_EOL;
	$rssfeed .= '	<channel>'.PHP_EOL;
	$rssfeed .= '		<title>RSS Marjo21</title>'.PHP_EOL;
	$rssfeed .= '		<link>'.$protocol.$_SERVER['HTTP_HOST'].'</link>'.PHP_EOL;
	$rssfeed .= '		<description>Flux RSS pour marjo21</description>'.PHP_EOL;
	$rssfeed .= '		<language>en-us</language>'.PHP_EOL;
	$rssfeed .= '		<copyright>Copyright (C) 2016 marjo21</copyright>'.PHP_EOL;
 
	$pdo = new PDO('mysql:host='.$dbhost.';port='.$dbport.';dbname='.$db.'', $dbuser, $dbpasswd);
	$pdo->exec("SET CHARACTER SET utf8");                                                                     
 
	$res = $pdo->query("SELECT * FROM links ORDER BY dateandtime DESC LIMIT 100");
	$res->setFetchMode(PDO::FETCH_ASSOC);

	foreach ( $res as $row )
	{
        	$rssfeed .= '		<item>'.PHP_EOL;
	        $rssfeed .= '			<title>' . $row['title'] . '</title>'.PHP_EOL;
        	$rssfeed .= '			<description>' . $row['title'] . '</description>'.PHP_EOL;
	        $rssfeed .= '			<link>' . $row['link'] . '</link>'.PHP_EOL;
	        $rssfeed .= '			<pubDate>' . date("D, d M Y H:i:s O", strtotime($row['dateandtime'])) . '</pubDate>'.PHP_EOL;
	        $rssfeed .= '		</item>'.PHP_EOL;
	}
 
    $rssfeed .= '	</channel>'.PHP_EOL;
    $rssfeed .= '</rss>'.PHP_EOL;
 
    echo $rssfeed;

    $pdo = null;
?>
