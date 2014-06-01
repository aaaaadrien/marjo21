#! /bin/bash

path=`dirname $0`
cd "$path"

while :
do
	./bot.pl
	sleep 30
done
