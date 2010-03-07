#!/bin/bash
NB=`pacman -Qu | wc -l`
#GPU=`cat /opt/fah-gpu/alpha/FAHlog.txt | grep Completed | tail -n 1 | sed 's/\[..:..:..\] Completed //' | sed 's/%//'`
SMP=`cat /opt/fah-smp/FAHlog.txt | grep Completed | tail -n 1 | sed 's/.*(//' | sed 's/%)//'`

if [[ $NB != 0 ]]
  then
    echo "pacwidget.text = \"<b>$NB</b> \"" | awesome-client
  else
    echo "pacwidget.text = \"\"" | awesome-client
  fi

#echo "fahgpuwidget:set_value($GPU/100)" | awesome-client
echo "fahsmpwidget:set_value($SMP/100)" | awesome-client

exit
