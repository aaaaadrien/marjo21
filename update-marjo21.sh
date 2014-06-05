#! /bin/bash

path=`dirname $0`
cd "$path"

rm bot.pl
wget https://raw.githubusercontent.com/aaaaadrien/marjo21/master/bot.pl
chmod +x bot.pl
 
