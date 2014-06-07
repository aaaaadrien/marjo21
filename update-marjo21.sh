#! /bin/bash

path=`dirname $0`
cd "$path"

rm bot.pl
wget https://raw.githubusercontent.com/aaaaadrien/marjo21/master/bot.pl
chmod +x bot.pl

rm public_html/index.php
wget -P public_html/ https://raw.githubusercontent.com/aaaaadrien/marjo21/master/public_html/index.php
