#! /bin/bash
 
echo On definit les variables systeme
 
dte=$(date +%Y-%m-%d--%H-%M-%S)
path=`dirname $0`
pathsav="$path/sauvegarde"

ficrap="$pathsav/sauvegarde-$dte-rapport.log"

dbhost="localhost"
dbuser="marjo21"
dbpasswd="marjo21"
dbname="marjo21"

echo Variables definies.

echo ""

mkdir -p "$pathrap" 2>/dev/null

echo "RAPPORT SAUVEGARDE $site du $dte" > "$ficrap"

echo Iniatalisation du script >> "$ficrap"
cd "$path"
mkdir -p "$pathsav" 2>/dev/null
echo Script initialise >> "$ficrap"
echo "" >> "$ficrap"

echo On lance la sauvegarde de la base de donnees >> "$ficrap"

mysqldump -u "$dbuser" -p"$dbpasswd" -h "$dbhost" "$dbname" > "$pathsav/$dbname-$dte.sql"

if [ $? -eq 0 ]
then
        echo Base de donnees sauvegardee. >> "$ficrap"
else
        echo Echec de la sauvegarde de la base de données >> "$ficrap"
        exit 4
fi

echo "" >> "$ficrap"

echo On compresse la base de données. >> "$ficrap"

bzip2 -z  "$pathsav/$dbname-$dte.sql"

if [ $? -eq 0 ]
then
        echo Base de donnees compressée. >> "$ficrap"
else
        echo Echec de la compression de la base de données >> "$ficrap"
        exit 5
fi

echo "" >> "$ficrap"

echo SAUVEGARDE TERMINEE >> "$ficrap"

echo "" >> "$ficrap"

echo "On purge les anciennes sauvegardes (+ de 14j)" >> "$ficrap"
find "$pathsav" -mtime +14 -exec rm -fv {} \; >> "$ficrap"
echo "Purge terminée"  >> "$ficrap"
