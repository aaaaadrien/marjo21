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
	<h1>marjo21 : Manuel d'utilisation</h1>

	<div id="historique">
	
		<h2>Les commandes essentielles à connaitre</h2>

		<p>
			Dans le canal IRC, il est possible d'utiliser plusieurs commandes pour piloter marjo21 :

			<ul>
			
			<li> <span class="command">!link http://url</span>: Poste sur le canal IRC un lien. Le titre de l'url est cité par marjo21 dans le canal et est référencé sur le site web.</li>
			<li> <span class="command">!last</span> : Rappelle le dernier lien posté.</li>
			<li> <span class="command">!help</span> : Afficher le manuel d'utilisation de marjo21 par message privé.</li>

			</ul>
		</p>

	</div>

	</body>
</html>
<?php $pdo = null; ?>
