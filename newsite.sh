#!/bin/bash
echo "Server Init 30-05-2016"
echo "© Wayne Enterprises Pvt Ltd"
# Root check
if [[ $EUID -ne 0 ]]; then
  echo "You must be a root user" 2>&1
  exit 1
fi
#Input
echo " Domain : "
read Domain
echo " Alias : "
read Alias
echo " HTTP ? ( Y / N ) : "
read HTTP
echo " HTTPS ? ( Y / N ) : "
read HTTPS
echo " GIT ? ( Y / N ) : "
read GIT
if [ "$GIT" == "Y" ]; then
echo "Server : "
read domain
echo "Username : "
read  username
echo "Password : "
read password
echo "Owner : "
read owner
echo "Repository : "
read repository
fi
echo "https://$username:$passowrd@$domain/$owner/$repository"
