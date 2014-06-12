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
Je suis encore en cours de création, il peut rester encore quelques bogues....
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
	        echo '<tr><td>'.$row['dateandtime'].'</td><td>'.$row['user'].'</td><td><a href="'.$row['link'].'" tagret="_blank" >'.$row['title'].'</a></td></tr>';
	}

	
	echo '</table>';

	?>
	
	</div>

	</body>
</html>
<?php $pdo = null; ?>
