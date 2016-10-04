<?php
header('Content-Type: text/html; charset=UTF-8');

$db="marjo21dev";
$dbhost="localhost";
$dbport=3306;
$dbuser="marjo21dev";
$dbpasswd="PerlIsTheBestLanguage!!!!";

$pdo = new PDO('mysql:host='.$dbhost.';port='.$dbport.';dbname='.$db.'', $dbuser, $dbpasswd);
$pdo->exec("SET CHARACTER SET utf8");                                                                                                                        
?>
