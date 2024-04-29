#!/bin/bash

#Установка докера
apt-get update && apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
echo "<h2>VadimGlinsky</h2>" > /var/www/html/index.html
sudo service nginx start