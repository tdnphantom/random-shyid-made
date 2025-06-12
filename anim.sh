#!/bin/bash

load=("---LOADING---" "----LOADING--" "-----LOADING-" "Y-----LOADING" "RY-----LOADIN" "ERY-----LOADI" "VERY-----LOAD" "OVERY-----LOA" "COVERY-----LO" "ECOVERY-----L" "RECOVERY-----" "-RECOVERY----" "--RECOVERY---" "---RECOVERY--" "G---RECOVERY-" "NG---RECOVERY" "ING---RECOVER" "DING---RECOVE" "ADING---RECOV" "OADING---RECO" "LOADING---REC" "-LOADING---RE" "--LOADING---R" "---LOADING---" "----LOADING--" "-----LOADING-" "Y-----LOADING" "RY-----LOADIN" "ERY-----LOADI" "VERY-----LOAD" "OVERY-----LOA" "COVERY-----LO" "ECOVERY-----L" "RECOVERY-----" "-RECOVERY----" "--RECOVERY---" "---RECOVERY--" "G---RECOVERY-" "NG---RECOVERY" "ING---RECOVER" "DING---RECOVE" "ADING---RECOV" "OADING---RECO" "LOADING---REC" "-LOADING---RE" "--LOADING---R" "---LOADING---")
for text in "${load[@]}"; do
	echo -ne "\r$text"
	sleep 0.3
done
  echo -ne "\r--COMPLETED--"
  sleep 0.2
  echo -ne "\r             "
  sleep 0.2
  echo -ne "\r--COMPLETED--"
  sleep 0.2
  echo -ne "\r             "
  sleep 0.2
  echo -ne "\r--COMPLETED--"
  sleep 0.2
  echo -ne "\r             "
  sleep 0.2
  echo -ne "\r--COMPLETED--"
  sleep 1
clear
echo Welcome back!
