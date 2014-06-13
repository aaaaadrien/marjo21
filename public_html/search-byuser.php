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
	<h1>marjo21 : Recherche par Utilisateur</h1>

	<div id="selection">
		<form method="GET" action="<?php echo $_SERVER['PHP_SELF'] ;?>">
			<label>Utilisateur : </label>
			<input type="text" name="user" required="required" value="<?php if (isset($_GET['user'])) echo $_GET['user']; ?>" />
			<input type="submit" value="Filtrer" />
		</form>
	</div>


	<div id="historique">
	
	<?php


	if ( isset($_GET['user']) && preg_match('/^[A-Za-z0-9_]+$/',$_GET['user']) )
	{
			$usersearch = $_GET['user'];
			$res = $pdo->query("SELECT * FROM links WHERE user = \"$usersearch\" ORDER BY dateandtime DESC LIMIT 30");
			$res->setFetchMode(PDO::FETCH_ASSOC);
		
		echo '<table>';
		echo '<tr><th>Date et Heure</th><th>Utilisateur</th><th>Lien posté</th></tr>';

		foreach ( $res as $row )
		{
		        echo '<tr><td>'.$row['dateandtime'].'</td><td>'.$row['user'].'</td><td><a href="'.$row['link'].'" tagret="_blank" >'.$row['title'].'</a></td></tr>';
		}

		echo '</table>';
	}
	else
	{
		echo '<h2>Erreur, vérifiez l\'utilisateur...</h2>';
	}



	?>
	
	</div>

	</body>
</html>
<?php $pdo = null; ?>
