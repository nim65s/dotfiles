#!/bin/bash
NB=`pacman -Qu | wc -l`
#GPU=`cat /opt/fah-gpu/alpha/FAHlog.txt | grep Completed | tail -n 1 | sed 's/\[..:..:..\] Completed //' | sed 's/%//'`
#SMP=`cat /opt/fah-smp/FAHlog.txt | grep Completed | tail -n 1 | sed 's/.*(//' | sed 's/%)//'`

# google : curl unread, toussa


echo "pacwidget.text = \"$NB \"" | awesome-client

#echo "fahgpuwidget:set_value($GPU/100)" | awesome-client
#echo "fahsmpwidget:set_value($SMP/100)" | awesome-client

exit
