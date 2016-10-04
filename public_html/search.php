<?php include ('header.php'); ?>
<!doctype html>
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
		<script>
			function searchradio()
			{
				if(document.getElementById('radiouser').checked) {
					document.getElementById('user').style.visibility="visible";
					document.getElementById('date').style.visibility="hidden";
					document.getElementById('site').style.visibility="hidden";
					document.getElementById('keyword').style.visibility="hidden";
				}

				if(document.getElementById('radiodate').checked) {
					document.getElementById('user').style.visibility="hidden";
					document.getElementById('date').style.visibility="visible";
					document.getElementById('site').style.visibility="hidden";
					document.getElementById('keyword').style.visibility="hidden";
				}

				if(document.getElementById('radiosite').checked) {
					document.getElementById('user').style.visibility="hidden";
					document.getElementById('date').style.visibility="hidden";
					document.getElementById('site').style.visibility="visible";
					document.getElementById('keyword').style.visibility="hidden";
				}

				if(document.getElementById('radiokeyword').checked) {
					document.getElementById('user').style.visibility="hidden";
					document.getElementById('date').style.visibility="hidden";
					document.getElementById('site').style.visibility="hidden";
					document.getElementById('keyword').style.visibility="visible";
				}

				if( !document.getElementById('radiouser').checked && !document.getElementById('radiodate').checked && !document.getElementById('radiosite').checked && !document.getElementById('radiokeyword').checked )
				{
					document.getElementById('user').style.visibility="hidden";
					document.getElementById('date').style.visibility="hidden";
					document.getElementById('site').style.visibility="hidden";
					document.getElementById('keyword').style.visibility="hidden";
				}

			}
			
		</script>
		
	</head>

	<body>
	<?php include('menu.php'); ?>
	<h1>marjo21 : Recherche </h1>

	<div id="selection">
		<div id="forms">
			<div id="user" class="forms">
				<form method="GET" action="<?php echo $_SERVER['PHP_SELF'] ;?>">
					<label>Utilisateur : </label>
					<input type="text" name="user" required="required" value="<?php if (isset($_GET['user'])) echo $_GET['user']; ?>" />
					<input type="submit" value="Filtrer" />
				</form>
			</div>
			
			<div id="date"  class="forms">
				<form method="GET" action="<?php echo $_SERVER['PHP_SELF'] ;?>">
					<label>Du :</label>
					<input type="text" name="start" required="required" value="<?php if (isset($_GET['start'])) echo $_GET['start']; ?>" class="date"/>
					<label>au</label>
					<input type="text" name="end" required="required" value="<?php if (isset($_GET['end'])) echo $_GET['end']; ?>" class="date"/>
					<input type="submit" value="Filtrer" />
				</form>
			</div>

			<div id="site" class="forms">
				<form method="GET" action="<?php echo $_SERVER['PHP_SELF'] ;?>">
					<label>Site : </label>
					<input type="text" name="site" required="required" value="<?php if (isset($_GET['site'])) echo $_GET['site']; ?>" />
					<input type="submit" value="Filtrer" />
				</form>
			</div>

			<div id="keyword" class="forms">
				<form method="GET" action="<?php echo $_SERVER['PHP_SELF'] ;?>">
					<label>Mot clé : </label>
					<input type="text" name="keywords" required="required" value="<?php if (isset($_GET['keywords'])) echo $_GET['keywords']; ?>" />
					<input type="submit" value="Filtrer" />
				</form>
			</div>
	
		</div>

		<label>Recherche par :</label> 
		<input type="radio" name="search" id="radiouser" <?php if ( isset ($_GET['user'])) echo 'checked="checked" '; ?>  value="user" onclick="searchradio();" /> Utilisateur
		<input type="radio" name="search" id="radiodate" <?php if ( isset ($_GET['start'])  && isset ($_GET['end'])) echo 'checked="checked" '; ?> value="date" onclick="searchradio();" /> Date
		<input type="radio" name="search" id="radiosite" <?php if ( isset ($_GET['site'])) echo 'checked="checked" '; ?> value="site" onclick="searchradio();" /> Site
		<input type="radio" name="search" id="radiokeyword" <?php if ( isset ($_GET['keywords'])) echo 'checked="checked" '; ?> value="keyword" onclick="searchradio();" /> Mots clés

	</div>

		<script>
			searchradio();
		</script>


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


	if ( isset($_GET['user']) && preg_match('/^[A-Za-z0-9_]+$/',$_GET['user']) )
	{
		$usersearch = $_GET['user'];
		$res = $pdo->query("SELECT * FROM links WHERE user = \"$usersearch\" ORDER BY dateandtime DESC LIMIT 100");
		$res->setFetchMode(PDO::FETCH_ASSOC);

		echo '<table>';
		echo '<tr><th>Date et Heure</th><th>Utilisateur</th><th>Lien posté</th></tr>';

		foreach ( $res as $row )
		{
			echo '<tr><td>'.$row['dateandtime'].'</td><td><a href="search.php?user='.$row['user'].'">'.$row['user'].'</a></td><td><a href="'.$row['link'].'" target="_blank" >'.$row['title'].'</a></td></tr>';
		}
	
		echo '</table>';
	}



	//select * from links where dateandtime between "2014-06-05" and "2014-06-10";
	if ( isset ($_GET['start']) && chkdte($_GET['start']) == true)
	{
		$startdate = $_GET['start'];
	}

	if ( isset ($_GET['end']) && chkdte($_GET['end']) == true)
	{
		$enddate = $_GET['end'];
	}
		
	if ( isset($startdate) && isset($enddate) && $startdate < $enddate )
	{
			$res = $pdo->query("SELECT * FROM links WHERE dateandtime BETWEEN \"$startdate 00:00:00\" AND \"$enddate 23:59:59\" ORDER BY dateandtime DESC LIMIT 100");
			$res->setFetchMode(PDO::FETCH_ASSOC);
		
		echo '<table>';
		echo '<tr><th>Date et Heure</th><th>Utilisateur</th><th>Lien posté</th></tr>';

		foreach ( $res as $row )
		{
		        echo '<tr><td>'.$row['dateandtime'].'</td><td><a href="search.php?user='.$row['user'].'">'.$row['user'].'</a></td><td><a href="'.$row['link'].'" target="_blank" >'.$row['title'].'</a></td></tr>';
		}

		echo '</table>';
	}

	
	if ( isset($_GET['site']) && preg_match('/^[A-Za-z0-9-.]+$/',$_GET['site']) )
	{
		$sitesearch = $_GET['site'];
		$res = $pdo->query("SELECT * FROM links WHERE link LIKE \"%$sitesearch%\" ORDER BY dateandtime DESC LIMIT 100");
		$res->setFetchMode(PDO::FETCH_ASSOC);

		echo '<table>';
		echo '<tr><th>Date et Heure</th><th>Utilisateur</th><th>Lien posté</th></tr>';

		foreach ( $res as $row )
		{
			echo '<tr><td>'.$row['dateandtime'].'</td><td><a href="search.php?user='.$row['user'].'">'.$row['user'].'</a></td><td><a href="'.$row['link'].'" target="_blank" >'.$row['title'].'</a></td></tr>';
		}

		echo '</table>';
	}


	if ( isset($_GET['keywords']))
	{
		$keywordssearch = $_GET['keywords'];
		
		$sql = "SELECT * FROM links WHERE ";
		$mots = substr_count($keywordssearch,' ');
		
		if ( $mots > 0)
		{
			$tab_word = explode(' ', $keywordssearch);
			for ( $i=0 ; $i< $mots ; $i++ )
			{
				$sql = $sql."title LIKE \"%".addslashes($tab_word["$i"])."%\" AND ";
			}
			$sql = $sql."title LIKE \"%".addslashes($tab_word["$i"])."%\"";
		} else {
			$sql = $sql."title LIKE \"%".addslashes($keywordssearch)."%\" ";
		}
		$sql = $sql."ORDER BY dateandtime DESC LIMIT 100";
		
		$res = $pdo->query($sql);	//SELECT * FROM links WHERE title LIKE \"%$keywordssearch%\" ORDER BY dateandtime DESC LIMIT 30");
		$res->setFetchMode(PDO::FETCH_ASSOC);

		echo '<table>';
		echo '<tr><th>Date et Heure</th><th>Utilisateur</th><th>Lien posté</th></tr>';

		foreach ( $res as $row )
		{
			echo '<tr><td>'.$row['dateandtime'].'</td><td><a href="search.php?user='.$row['user'].'">'.$row['user'].'</a></td><td><a href="'.$row['link'].'" target="_blank" >'.$row['title'].'</a></td></tr>';
		}

		echo '</table>';
	}




	if ( !isset($_GET['user']) && !isset($_GET['start']) && !isset($_GET['end']) && !isset($_GET['site']) && !isset($_GET['keywords']) )
	{
		echo '<h2>Sélectionnez une recherche à effectuer...</h2>';
	}

	?>
	
	</div>

	</body>
</html>
<?php $pdo = null; ?>
