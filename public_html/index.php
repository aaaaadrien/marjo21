<!doctype html>
<?php include ('config.php'); ?>
<html>
	<head>
		<meta charset="UTF-8"/> 
		
		<link href="style.css" rel="stylesheet" type="text/css" />	
		<link rel="icon" href="marjo21.ico" type="image/x-icon" />
		<title>marjo21</title>
	</head>

	<body>
	<?php include('menu.php'); ?>
	<h1>marjo21 : Liens postés</h1>

	<meta  http-equiv="refresh" content="300; url=<?php echo $_SERVER['REQUEST_URI'] ;?>" />
	
	<div id="historique">
	
	<?php

	echo '<table>';
	echo '<tr><th>Date et Heure</th><th>Utilisateur</th><th>Lien posté</th></tr>';
	$res = $pdo->query("SELECT * FROM links ORDER BY dateandtime DESC LIMIT 30");
	$res->setFetchMode(PDO::FETCH_ASSOC);
	
	foreach ( $res as $row )
	{
	        echo '<tr><td>'.$row['dateandtime'].'</td><td><a href="search.php?user='.$row['user'].'">'.$row['user'].'</a></td><td><a href="'.$row['link'].'" target="_blank" >'.$row['title'].'</a></td></tr>';
	}

	
	echo '</table>';

	?>
	
	</div>

	</body>
</html>
<?php $pdo = null; ?>
