#!/bin/bash
NB=`pacman -Qu | wc -l`
if [[ $NB != 0 ]]
  then
    echo "pacwidget.text = \"<b>$NB</b> \"" | awesome-client
  else
    echo "pacwidget.text = \"\"" | awesome-client
  fi
exit
