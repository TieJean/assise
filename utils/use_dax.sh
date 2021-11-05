#! /bin/bash
if [[ $# < 1 ]];
then
	echo "$0 <bind or unbind>"
	exit
fi

if [[ $1 == "bind" ]];
then
	sudo ndctl create-namespace -m dax -e namespace0.0 -f
	sudo chmod 777 /dev/dax0.0 
elif [[ $1 == "unbind" ]];
then
	sudo ndctl create-namespace -m memory -e namespace0.0 -f
else
	echo "$0 <bind or unbind>"
fi
