#! /bin/bash

path=`dirname $0`
cd "$path"

rm -f blacklists.tar.gz
wget ftp://ftp.ut-capitole.fr/pub/reseau/cache/squidguard_contrib/blacklists.tar.gz
tar xvf blacklists.tar.gz
rm -f blacklists.tar.gz

