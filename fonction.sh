#!/bin/bash
source config.sh

# fonction pour afficher les titres
function afficheTitre () {
    if (( $serveur == 1 ))
    then
        figlet $1
    else
        figlet $1 | lolcat
    fi
    
}