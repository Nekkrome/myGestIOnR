#!/bin/bash

currentUser=$(whoami)
if [[ $currentUser != 'root' ]]; then
    echo "Connectez vous en root pour continuer l'installation"
    exit 2
fi

echo "--------------Etape 1, installation client/serveur--------------"

read -p "L'outil est-il sur une machine serveur ou cliente ? (0 pour client, 1 pour serveur)" Serv

while [ $Serv -ne 0 -a $Serv -ne 1 ]; do
    echo "Veuillez saisir 0 pour une installation serveur, 1 pour installation client"
    read -p "L'outil est-il sur une machine serveur ou cliente ? (0 pour client, 1 pour serveur)" Serv
done

if [[ $Serv -eq 0 ]]; then
    echo serveur=0 > ../config.sh
    install=0
fi

if [[ $Serv -eq 1 ]]; then
    echo serveur=1 > ../config.sh
    install=1
fi

echo "--------------Etape 2, installation des paquets nécessaires--------------"

apt update && apt install -y mariadb-server figlet netcat-openbsd sudo

if [[ $install -eq 0 ]]; then
    apt install -y lolcat
fi

echo "--------------Etape 3, installation de la BDD--------------"

mysql -e "
CREATE DATABASE MyGest; 
CREATE USER 'GestAdmin'@'localhost';
GRANT ALL PRIVILEGES ON MyGest.* TO 'GestAdmin'@'localhost';
FLUSH PRIVILEGES;"

mysql -u GestAdmin MyGest < myGestIOnR.sql