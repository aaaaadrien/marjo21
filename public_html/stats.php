<?php include ('header.php'); ?>
<!doctype html>
<html>
	<head>
		<meta charset="UTF-8"/> 
		
		<link href="style.css" rel="stylesheet" type="text/css" />	
		<link rel="icon" href="marjo21.ico" type="image/x-icon" />
		<title>marjo21</title>

	</head>

	<body>
	<?php include('menu.php'); ?>
	<h1>marjo21 : Stats</h1>

	<div id="historique">
	<h2>Top 20 des utilisateurs les plus actifs</h2>
	<?php

		$res = $pdo->query("SELECT user, count(id) AS c,  (SELECT count(id) FROM links) as t FROM links GROUP BY user ORDER BY c DESC;");
		$res->setFetchMode(PDO::FETCH_ASSOC);
		
		echo '<table>';
		$limit = 1;
		foreach ( $res as $row )
		{
		        echo '<tr><td><a href="search.php?user='.$row['user'].'" >'.$row['user'].'</a></td><td><progress value="'.$row['c'].'" max="'.$row['t'].'"></progress></td></tr>';
			$limit++;
			if ( $limit > 20 )
				break;
		}

		echo '</table>';

	?>

	<br /><hr />

	<h2>Top 20 des sites les plus postés</h2>

	<?php

	
	$res = $pdo->query("SELECT link FROM links");
	$res->setFetchMode(PDO::FETCH_ASSOC);

	$tabdomain = array();
	$tabcount = array();
	foreach ( $res as $row )
	{

		$domain = str_ireplace('www.', '', parse_url($row['link'], PHP_URL_HOST));	
		
		if ( in_array($domain, $tabdomain) )
		{
			$pos = array_search($domain, $tabdomain);
			$tabcount[$pos]++;
		}
		else
		{
			array_push($tabdomain, $domain);
			array_push($tabcount, 1);
		}
	}

	$tab = array_combine($tabdomain, $tabcount);
	
	$total = 0;
	foreach ( $tabcount as $val)
	{
		$total += $val;
	}

	arsort($tab);
	echo '<table>';
	$limit = 1;
	foreach ($tab as $domain => $count )
	{
		echo '<tr><td>'.$domain.'</td><td><progress value="'.$count.'" max="'.$total.'"></progress></td></tr>';
		$limit ++;
		if ( $limit > 20 )
			break;
	}
	echo '</table>';

	?>

	</div>

	</body>
</html>
<?php $pdo = null; ?>
