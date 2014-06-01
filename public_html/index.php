<!doctype html>
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

	
	<div id="selection">
	<select name="historique" onchange="document.location = this.options[this.selectedIndex].value;">
			
		<option value="<?php echo $_SERVER['PHP_SELF'] ; ?>">Sélectionnez le mois à consulter</option>
	
	<?php
		$directory = 'logs';
		$iter = new DirectoryIterator( $directory );  
		foreach($iter as $file ) {  
			if ( !$file->isDot() ) {  
				$fic = $file->getFilename();
				echo '<option ';
				if ( isset ( $_GET['fichier']) && $_GET['fichier'] == $fic) { echo 'selected="selected" '; }
				echo 'value="'.$_SERVER['PHP_SELF'].'?fichier='.$fic.'">'.str_replace("-"," ",substr($fic,9)).'</option>';  
			}  
		}  

	?>

	</select>
	</div>

	<div id="historique">
	
	<?php

	if ( isset( $_GET['fichier'] ) && file_exists("logs/".$_GET['fichier']) )
	{
		
                $fic = array_reverse( file ('logs/'.$_GET['fichier'], FILE_TEXT) );
                
		if ( count($fic) < 1 )
		{
			echo '<h2>Aucun lien posté en '.str_replace("-"," ",substr($_GET['fichier'],9)).'</h2>';
		}
		else
		{
			echo '<h2>Historique '.str_replace("-"," ",substr($_GET['fichier'],9)).'</h2>';
			echo '<table>';
			echo '<tr><th>Date</th><th>Heure</th><th>Utilisateur</th><th>Lien posté</th></tr>';
			echo '';
			#include 'logs/'.$_GET['fichier'];
			foreach($fic as $l)
			{
				#print '<tr><td>'.str_replace(";","</td><td>",$l).'</td></tr>';
				$ligne = explode(";", $l);
				echo '<tr><td>'.$ligne[0].'</td><td>'.$ligne[1].'</td><td>'.$ligne[2].'</td><td><a href="'.$ligne[3].'" />'.$ligne[4].'</a></td></tr>';
			}
			echo '</table>';
		}
	}
	else
	{
		echo '<h3>Aucune données à afficher !</h3>';
	}

	?>
	
	</div>

	</body>
</html>
