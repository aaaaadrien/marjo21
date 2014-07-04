<?php
header('Content-Type: text/html; charset=UTF-8');
$pdo = new PDO('mysql:host=127.0.0.1;dbname=marjo21', 'root', 'root');
$pdo->exec("SET CHARACTER SET utf8");                                                                                                                        
?>
