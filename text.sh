#!/bin/bash

# Array of texts to display
texts=("Daa" "bee" "dee" "daa" "bee" "daa")

# Loop through the texts
 echo -e "I'm \033[0;34mBLUE"
for text in "${texts[@]}"; do
  # Print the text and overwrite the line  
  sleep 0.15
  echo -ne "\r$text"
  # Wait for 0.5 seconds
  sleep 0.2
done

clear

for text in "${texts[@]}"; do
  # Print the text and overwrite the line
  sleep 0.15
  echo -ne "\r$text"
  # Wait for 0.5 seconds
  sleep 0.3
done
sleep 0.2
stegs=("HAA" "\n\n\n\n\n\nHAA" "\n\n\n\n\nHAA" "\n\n\n\n\nHAA")
for tegs in "${stegs[@]}"; do
  # Print the text and overwrite the line
  sleep 0.2
  echo -ne "\033[0;31m\r$tegs"
  # Wait for 0.5 seconds
  sleep 0.2
done

clear


# Move to the next line after the animation
echo

