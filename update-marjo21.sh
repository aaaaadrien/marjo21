#! /bin/bash

path=`dirname $0`
cd "$path"

rm bot.pl
wget https://raw.githubusercontent.com/aaaaadrien/marjo21/master/bot.pl
chmod +x bot.pl

rm update-marjo21.sh
wget https://raw.githubusercontent.com/aaaaadrien/marjo21/master/update-marjo21.sh
chmod +x update-marjo21.sh


rm public_html/header.php
wget -P public_html/ https://raw.githubusercontent.com/aaaaadrien/marjo21/master/public_html/header.php

rm public_html/footer.php
wget -P public_html/ https://raw.githubusercontent.com/aaaaadrien/marjo21/master/public_html/footer.php

rm public_html/functions.php
wget -P public_html/ https://raw.githubusercontent.com/aaaaadrien/marjo21/master/public_html/functions.php

rm public_html/index.php
wget -P public_html/ https://raw.githubusercontent.com/aaaaadrien/marjo21/master/public_html/index.php

rm public_html/about.php
wget -P public_html/ https://raw.githubusercontent.com/aaaaadrien/marjo21/master/public_html/about.php

rm public_html/help.php
wget -P public_html/ https://raw.githubusercontent.com/aaaaadrien/marjo21/master/public_html/help.php

rm public_html/menu.php
wget -P public_html/ https://raw.githubusercontent.com/aaaaadrien/marjo21/master/public_html/menu.php

rm public_html/search.php
wget -P public_html/ https://raw.githubusercontent.com/aaaaadrien/marjo21/master/public_html/search.php

rm public_html/stats.php
wget -P public_html/ https://raw.githubusercontent.com/aaaaadrien/marjo21/master/public_html/stats.php

rm public_html/style.css
wget -P public_html/ https://raw.githubusercontent.com/aaaaadrien/marjo21/master/public_html/style.css

