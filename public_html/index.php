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
	<h1>marjo21 : Liens postés</h1>

	<meta  http-equiv="refresh" content="300; url=<?php echo $_SERVER['REQUEST_URI'] ;?>" />
	
	<div id="historique">
	
	<?php


	//Pagination
	$total=$pdo->query('SELECT id FROM links')->rowCount(); 
	$nbpages=ceil($total/$linksbypage);

	if(isset($_GET['page'])) 
	{
		$curpage=intval($_GET['page']);
 
		if($curpage>$nbpages) 
		{
			$curpage=$nbpages;
		}
	}
	else
	{
		$curpage=1;
	}

	$from=($curpage-1)*$linksbypage;


	//echo "TOT $total - LNKPP $linksbypage - NBP $nbpages - PA $curpage";



	echo '<table>';
	echo '<tr><th>Date et Heure</th><th>Utilisateur</th><th>Lien posté</th></tr>';
	$res = $pdo->query("SELECT * FROM links ORDER BY dateandtime DESC LIMIT ".$from.", ".$linksbypage.";");
	$res->setFetchMode(PDO::FETCH_ASSOC);
	
	foreach ( $res as $row )
	{
	        echo '<tr><td>'.$row['dateandtime'].'</td><td><a href="search.php?user='.$row['user'].'">'.$row['user'].'</a></td><td><a href="'.$row['link'].'" target="_blank" >'.$row['title'].'</a></td></tr>';
	}

	
	echo '</table>';

	echo '<br /> <br />';

	echo '<div class="txtcenter">';

	if ( $curpage > 1 )
	{
		echo "<a href='?page=".($curpage-1)."'> <- Page précédente</a>";
	}
	else
	{
		echo "<- Page précédente";
	}

	echo '&nbsp;&nbsp; Page '.$curpage.'/'.$nbpages.' &nbsp;&nbsp;';

	if ( $curpage < $nbpages )
	{
		echo "<a href='?page=".($curpage+1)."'>Page suivante -></a>";
	}
	else
	{
		echo "Page suivante ->";
	}
	?>
	</div>
	
	</div>

	</body>
</html>
<?php include('footer.php'); ?>
