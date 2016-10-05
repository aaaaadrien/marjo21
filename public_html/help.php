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
	<h1>marjo21 : Manuel d'utilisation</h1>

	<div id="historique">
	
		<h2>Les commandes essentielles à connaitre</h2>

		<p>
			Dans le canal IRC, il est possible d'utiliser plusieurs commandes pour piloter marjo21. Voici la liste des commandes disponibles :

			<ul>
				<li> <span class="command">!help</span> : Affiche ce manuel d'utilisation</li>
				<li> <span class="command">!link http://url (ou !l ou !!)</span> : Affiche le titre dde la page à l'adresse URL et l'indexe.</li>
				<li> <span class="command">!last</span> : Affiche le dernier lien posté.</li>
				<li> <span class="command">!search motclé</span> : Cherche dans la base de marjo21 en fonction du mot clé.</li>
				<li> <span class="command">!bug new description</span> : Envoie un bogue de fonctionnement à l'administrateur.</li>

			</ul>
		</p>

	</div>

	</body>
</html>
<?php $pdo = null; ?>
