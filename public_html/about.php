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
	<h1>marjo21 : A propos</h1>

	<div id="historique">
	
		<h2>Marjo21 : le collecteur de liens sur canal IRC</h2>

		<p>
			<b>Marjo21</b> est codée en PERL pour la partie robot, et en PHP pour la partie web. Le robot est optimisé pour fonctionner sur un serveur GNU/Linux. Le multiplexeur de terminal <b>screen</b> est conseillé pour exécuter le robot dans un shell détaché. PERL 5.12 ou supérieur est requis.
		</p>

		<p>
			Vous pouvez retrouver les sources du projet sur GitHub dans le dépôt <a href="https://github.com/aaaaadrien/marjo21" target="_blank" >aaaaadrien/marjo21</a>.
		</p>

		<p>
			N'oubliez pas de lire la licence, le projet est sous la license <a href="http://opensource.org/licenses/MIT" target="_blank" >MIT</a>
		</p>

		<p>
			N'hésitez pas à contacter l'auteur si vous souhaitez contribuer au projet...
		</p>

	</div>

	</body>
</html>
<?php $pdo = null; ?>
