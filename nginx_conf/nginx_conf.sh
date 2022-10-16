#!/usr/bin/env bash

# This script checks if nginx is installed, installs it, removes it, changes its configuration.

#Checks, if nginx is installed, if yes, displays the version, if not, installs it.
check_installation () {

  if [ -n "$(apt list --installed 2>/dev/null | grep nginx)" ]; then
    nginx -v
    echo "Do you want to update nginx? (y/n)"
    read answer      
    if [ "$answer" == "y" ]; then
      echo "Updating nginx..."
      nginx_update           
    elif [ "$answer" == "n" ]; then
      echo "Ok."
    else
      echo "ERROR!"
      exit
    fi
    echo "Do you want to update the configuration?"
    read answer
    if [ "$answer" == "y" ]; then
      conf_update
    elif [ "$answer" == "n" ]; then
      echo "Exiting..."
    else
      echo "ERROR!"
      exit
    fi      
  else
    echo "Nginx is not installed. Installing..."
    installation
    conf_update
  fi
  return 0            
}

#Installs nginx.
installation () {

  sudo apt-get -y install nginx &>/dev/null
  echo "Nginx is installed."
  # mkdir -p /var/www/example.com/html
  # mkdir -p $path
  return 0
}

#Removes nginx.
removal () {

  sudo apt-get -y remove nginx &>/dev/null
  sudo apt-get -y autoremove &>/dev/null
  echo "Nginx is removed."
  return 0
}

#Updates nginx.
nginx_update () {

  sudo apt update &>/dev/null
  sudo apt install nginx &>/dev/null
  echo "Nginx is updated."
  return 0
}

#Updates nginx's configuration.
conf_update () {
  echo "server {
          listen $port;
          listen [::]:$port;    

          server_name example.com;  

           root $dir; 
           index index.nginx-debian.html;

           location / {
             try_files "'$uri $uri'"/ =404;
           }
        }"     > /etc/nginx/sites-available/default
  echo "Port is set to "$port
  echo "Project directory is set to "$dir
  echo "Configuration is updated."
}

#Checks given arguments for parameters.
checkargs () {
  
  if [[ $OPTARG =~ ^-[a-zA-Z]$ ]]; then
    echo "Unknow argument $OPTARG for option -$opt!"
    exit
  fi
}

#Cheks, if there are any parameters and processes them. Also checks if the script is launched as root.
main () {

  if [ $EUID -ne 0 ]; then
    echo "This script must be run as root!" 
    exit
  fi
  if [ -z "$*" ]; then
    echo "No parameters given!"
    echo "Launch with -h to see help."
    exit
  fi
  while getopts "p:w:hd" opt
  do
    case $opt in
      p)  checkargs
          echo "Found port: "$OPTARG
          port=$OPTARG;;
      w)  checkargs
          echo "Found project directory path: "$OPTARG
          dir=$OPTARG;;
      h)  echo "This script's purpose is to check if nginx is installed, install it, remove it, change its configuration."
          echo "These are options available for this script:"
          echo "-p - reads the port to configure nginx. Ex.: -p 80"
          echo "-w - reads the directory of wanted project. Ex.: -w /etc/example.com"
          echo "-d - removes nginx"
          echo "-h - displays help"
          exit;;
      d)  echo "Removing nginx..."
          removal
          exit;;
      *)  echo "ERROR!"
          exit;;
    esac
  done
  check_installation
}
main $*
