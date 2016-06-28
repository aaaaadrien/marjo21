#! /bin/bash

path=`dirname $0`
cd "$path"

while :
do
	./bot.pl 2>&1 >> bot.log
	sleep 5
done
