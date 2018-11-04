#!/bin/bash

filename="toinst.txt"

#While loop to read line by line
while read -r line
do
    readLine=$line

    #if [[ $readLine = ruby* ]] ; then
        echo "$readLine"
        read line
      #  readLine=$line
      #  if [[ $readLine = sudo* ]] ; then
      #      echo "$readLine"
      #  fi
    # fi
done < "$filename"
