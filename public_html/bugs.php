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
	<h1>marjo21 : Bugs postés</h1>

	<meta  http-equiv="refresh" content="300; url=<?php echo $_SERVER['REQUEST_URI'] ;?>" />
	
	<div id="historique">
	
	<?php

	echo '<table>';
	echo '<tr><th>#</th><th>Date et Heure</th><th>Utilisateur</th><th>Message</th><th></th></tr>';
	$res = $pdo->query("SELECT * FROM bugs ORDER BY solved,dateandtime ASC LIMIT 100");
	$res->setFetchMode(PDO::FETCH_ASSOC);
	
	foreach ( $res as $row )
	{
		if ($row['solved'] == 1) { $solved="&#x2713;"; } else { $solved="&#x2717;";}
	        echo '<tr><td>'.$row['id'].'</td><td>'.$row['dateandtime'].'</td><td>'.$row['user'].'</td><td>'.$row['message'].'</td><td>'.$solved.'</td></tr>';
	}

	
	echo '</table>';

	?>
	
	</div>

	</body>
</html>
<?php include('footer.php'); ?>
