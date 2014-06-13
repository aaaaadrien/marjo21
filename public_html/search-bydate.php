<!doctype html>
<?php include ('config.php'); ?>
<html>
	<head>
		<meta charset="UTF-8"/> 
		
		<link href="style.css" rel="stylesheet" type="text/css" />	
		<link rel="icon" href="marjo21.ico" type="image/x-icon" />
		<title>marjo21</title>

		<!-- Debut des scripts datepicker en attendant l'HTML5 sur Firefox .... -->
		 <link rel="stylesheet" href="//code.jquery.com/ui/1.10.4/themes/smoothness/jquery-ui.css">
		 <script src="//code.jquery.com/jquery-1.10.2.js"></script>
		 <script src="//code.jquery.com/ui/1.10.4/jquery-ui.js"></script>
		 <link rel="stylesheet" href="/resources/demos/style.css">
		 <script>
		 	$(function() {
		 		$( ".date" ).datepicker({ dateFormat: "yy-mm-dd" });
			});
		 </script>
		 <!-- Fin des scripts datepicker -->


	</head>

	<body>
	<?php include('menu.php'); ?>
	<h1>marjo21 : Recherche par date</h1>

	<div id="selection">
		<form method="POST" action="<?php echo $_SERVER['PHP_SELF'] ;?>">
			<label>Du :</label>
			<input type="text" name="start" required="required" class="date"/>
			<label>au</label>
			<input type="text" name="end" required="required" class="date"/>
			<input type="submit" value="Filtrer" />
		</form>
	</div>


	<div id="historique">
	
	<?php


	function chkdte($dte){
	
		if (preg_match("/^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/",$dte))
		{
			return true;
		}else{
			return false;
		}
	}

	//select * from links where dateandtime between "2014-06-05" and "2014-06-10";
	
	if ( isset ($_POST['start']) && chkdte($_POST['start']) == true)
		$startdate = $_POST['start'];

	if ( isset ($_POST['end']) && chkdte($_POST['end']) == true)
		$enddate = $_POST['end'];
	
		
	if ( $startdate && $enddate && $startdate < $enddate )
	{
			$res = $pdo->query("SELECT * FROM links WHERE dateandtime BETWEEN \"$startdate 00:00:00\" AND \"$enddate 23:59:59\" ORDER BY dateandtime DESC LIMIT 30");
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
		echo '<h2>Erreur, vérifiez les dates...</h2>';
	}



	?>
	
	</div>

	</body>
</html>
<?php $pdo = null; ?>
