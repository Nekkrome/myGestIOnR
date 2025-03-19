#!/bin/bash

#import des configs et fonctions
source config.sh
source fonction.sh

#bash install/install.sh
#echo $serveur

echo "Bienvenu dans :"
afficheTitre "MyGest IOn ' R"
quitter=1
while [[ $quitter -ne 0 ]]
do
echo ""
afficheTitre "Menu principal"
echo "1) Gestion du parc"
echo "2) Outils réseau"
echo "0) Quitter"
echo -e "Veuillez choisir une option :"
read choix
case $choix in 
	1 )
		bash gestParc/menuParc.sh
		;;
	2 )
		bash outilsRx/menuOutils.sh
		;;
	0 )
		quitter=0
		figlet "Au revoir"|lolcat
		;;
	* )
		echo "Erreur dans la saisie"
		;;
esac
done


