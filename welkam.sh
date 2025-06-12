#!/bin/bash

masuk=("-------------" "#-----------#" "-#---------#-" "--#-------#--" "---#-----#---" "---W#---#E---" "---WE#-#ME---" "---WEL#OME---")
for text in "${masuk[@]}"; do
	echo -ne "\r$text"
	sleep 0.05
done 

load=("---WELCOME---" "*--WELCOME---" "-*-WELCOME---" "--*WELCOME---" "---wELCOME---" "---WeLCOME---" "---WElCOME---" "---WELcOME---" "---WELCoME---" "---WELCOmE---" "---WELCOMe---" "---WELCOME*--" "---WELCOME-*-" "---WELCOME--*")
for text in "${load[@]}"; do
	echo -ne "\r$text"
	sleep 0.1
done

done=("---WELCOME---" "---WEL#OME---" "---WE#-#ME---" "---W#---#E---" "---#-----#---" "--#-------#--" "-#---------#-" "#-----------#" "-------------" ">-----------<" "->---------<-" "-->-------<--" "--->-----<---" "---->---<----" "----->-<-----" "------x------" "-----<->-----" "----<--->----" "---<----->---")
for text in "${done[@]}"; do
	echo -ne "\r$text"
	sleep 0.06
done 
  echo -ne "\r---O-----O---"
  sleep 0.7
  echo -ne "\r--->-----<---"
  sleep 0.1
  echo -ne "\r---O-----O---"
  sleep 0.3
  echo -ne "\r--->-----<---"
  sleep 0.1
  echo -ne "\r---O-----O---"
  sleep 1
  echo -ne "\r---O--V--O---"
  sleep 0.7
  echo -ne "\r--->--V--<---"
  sleep 0.2
  echo -ne "\r---O--V--O---"
  sleep 1
  
welkam=("-------------" "------- -----" "------| |----" "-----|e b|---" "----|me ba|--" "---|ome bac|-" "--|come back|" "-|lcome back!" "|elcome back!")
for tegs in "${welkam[@]}"; do
	echo -ne "\r$tegs"
	sleep 0.04
done 

echo -ne "\rWelcome back!\n"
