#! /bin/bash

path=`dirname $0`
cd "$path"

me=$0
arg=$1

version="master"

if [[ -z $1 ]]
then
	echo "Mise à jour du programme ..."
	
	rm update-marjo21.sh
	wget https://raw.githubusercontent.com/aaaaadrien/marjo21/$version/update-marjo21.sh
	chmod +x update-marjo21.sh

	./$0 upd
fi


if [[ -n $1 ]]
then

	echo "Mise à jour du robot ..."

	rm bot.pl
	wget https://raw.githubusercontent.com/aaaaadrien/marjo21/$version/bot.pl
	chmod +x bot.pl

	rm bot.cfg.example
	wget https://raw.githubusercontent.com/aaaaadrien/marjo21/$version/bot.cfg.example

	echo "Mise à jour du site ..."

	rm public_html/header.php
	wget -P public_html/ https://raw.githubusercontent.com/aaaaadrien/marjo21/$version/public_html/header.php

	rm public_html/footer.php
	wget -P public_html/ https://raw.githubusercontent.com/aaaaadrien/marjo21/$version/public_html/footer.php

	rm public_html/functions.php
	wget -P public_html/ https://raw.githubusercontent.com/aaaaadrien/marjo21/$version/public_html/functions.php

	rm public_html/index.php
	wget -P public_html/ https://raw.githubusercontent.com/aaaaadrien/marjo21/$version/public_html/index.php

	rm public_html/about.php
	wget -P public_html/ https://raw.githubusercontent.com/aaaaadrien/marjo21/$version/public_html/about.php

	rm public_html/bugs.php
	wget -P public_html/ https://raw.githubusercontent.com/aaaaadrien/marjo21/$version/public_html/bugs.php

	rm public_html/help.php
	wget -P public_html/ https://raw.githubusercontent.com/aaaaadrien/marjo21/$version/public_html/help.php

	rm public_html/menu.php
	wget -P public_html/ https://raw.githubusercontent.com/aaaaadrien/marjo21/$version/public_html/menu.php

	rm public_html/search.php
	wget -P public_html/ https://raw.githubusercontent.com/aaaaadrien/marjo21/$version/public_html/search.php

	rm public_html/stats.php
	wget -P public_html/ https://raw.githubusercontent.com/aaaaadrien/marjo21/$version/public_html/stats.php

	rm public_html/config.php.example
	wget -P public_html/ https://raw.githubusercontent.com/aaaaadrien/marjo21/$version/public_html/config.php.example

	rm public_html/style.css
	wget -P public_html/ https://raw.githubusercontent.com/aaaaadrien/marjo21/$version/public_html/style.css

	rm public_html/rss/index.php
	mkdir public_html/rss
	wget -P public_html/rss https://raw.githubusercontent.com/aaaaadrien/marjo21/$version/public_html/rss/index.php

fi
