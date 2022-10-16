#!/usr/bin/env bash

#This script looks for russian symbols and "help" function in chosen scripts
if [ -z "$*" ]; then
  echo "You should write the name of the file you want to validate!"
  exit
fi
if [ -n "$2" ]; then
  echo "You should write the name of only one file you want to validate!"
  exit
fi
if [ -f $1 ]; then
  if [ -n "$(cat $1 | grep [а-яА-Я])" ]; then
    echo "File contains russian symbols."
  else
    echo "FIle doesn't contain russian symbols."
  fi
  if [ -n "$(cat $1 | grep "help () {")" ]; then
    echo 'File contains the "help" function.'
  else
    echo 'FIle does not contain the "help" function.'
  fi
else
  echo "No such file."
  exit
fi