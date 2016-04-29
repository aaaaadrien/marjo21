#! /bin/bash

path=`dirname $0`
cd "$path"

while :
do
	./bot.pl >> bot.log
	sleep 5
done
