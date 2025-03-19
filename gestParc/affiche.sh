#!/bin/bash
source fonction.sh

# Fonction pour lister les bases de données
lister_bases() {
    echo "Bases de données disponibles :"
    mysql -u GestAdmin -e "SHOW DATABASES;"
}

# Fonction pour afficher les équipements de la base de données
afficher_equipements() {
    read -p "Entrez le nom de la base de données : " db_name
    table_name="Equipement"

    echo "Équipements dans la table '$table_name' de la base de données '$db_name' :"
    mysql -u GestAdmin -e "USE $db_name; SELECT * FROM $table_name;"
}

# Fonction pour afficher les équipements de type 'machine'
afficher_machines() {
    read -p "Entrez le nom de la base de données : " db_name
    table_name="Equipement"

    echo "Équipements de type 'machine' dans la table '$table_name' de la base de données '$db_name' :"
    mysql -u GestAdmin -e "USE $db_name; SELECT * FROM $table_name WHERE idT = 1;"
}

# Fonction pour afficher les équipements de type 'serveur'
afficher_serveurs() {
    read -p "Entrez le nom de la base de données : " db_name
    table_name="Equipement"

    echo "Équipements de type 'serveur' dans la table '$table_name' de la base de données '$db_name' :"
    mysql -u GestAdmin -e "USE $db_name; SELECT * FROM $table_name WHERE idT = 3;"
}

# Fonction pour afficher les équipements de type 'switch'
afficher_switchs() {
    read -p "Entrez le nom de la base de données : " db_name
    table_name="Equipement"

    echo "Équipements de type 'switch' dans la table '$table_name' de la base de données '$db_name' :"
    mysql -u GestAdmin -e "USE $db_name; SELECT * FROM $table_name WHERE idT = 2;"
}

# Boucle principale
while true; do
    echo ""
    echo "1 - Toutes les informations"
    echo "2 - Seulement les machines"
    echo "3 - Seulement les serveurs"
    echo "4 - Seulement les switchs"
    echo "5 - Lister les bases de données"
    echo "0 - Quitter"
    read -p "Votre choix : " choix

    case $choix in
        1) afficher_equipements ;;
        2) afficher_machines ;;
        3) afficher_serveurs ;;
        4) afficher_switchs ;;
        5) lister_bases ;;
        0) echo "Au revoir !"; afficheTitre "Gestion du parc"; exit 0 ;;
        *) echo "Option invalide, veuillez réessayer." ;;
    esac
done
afficheTitre "Gestion du parc"



