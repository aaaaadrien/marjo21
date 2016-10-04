<?php
header('Content-Type: text/html; charset=UTF-8');
include('config.php');
$pdo = new PDO('mysql:host='.$dbhost.';port='.$dbport.';dbname='.$db.'', $dbuser, $dbpasswd);
$pdo->exec("SET CHARACTER SET utf8");                                                                                                                        
?>
