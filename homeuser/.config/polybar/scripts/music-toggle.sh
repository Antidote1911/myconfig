#!/bin/bash
if pgrep -x "cmus" > /dev/null
then
	killall cmus
else
	termite -e cmus &
fi
