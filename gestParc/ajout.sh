#!/bin/bash
source fonction.sh
source testIP.sh
validiteIP=0

# Demande le nom de la base de données
read -p "Entrez le nom de la base de données : " db_name

# Crée la base de données si elle n'existe pas
mysql -u GestAdmin -e "CREATE DATABASE IF NOT EXISTS $db_name;"

# Sélection de la table (on suppose que toutes les bases auront la même table)
table_name="Equipement"

# Crée la table si elle n'existe pas déjà
mysql -u GestAdmin -e "USE $db_name;
    CREATE TABLE IF NOT EXISTS $table_name (
        id INT PRIMARY KEY,
        idT ENUM('machine', 'serveur', 'switch') NOT NULL,
        nom VARCHAR(100) NOT NULL,
        adMAC VARCHAR(17) NOT NULL UNIQUE,
        adIP VARCHAR(15) NOT NULL UNIQUE,
        CIDR VARCHAR(15) NOT NULL
    );"

echo "La base de données '$db_name' et la table '$table_name' sont prêtes."

# Fonction pour ajouter un équipement
ajouter_equipement() {
    echo ""
    read -p "Mettez le numéro de l'ID : " id
    read -p "Entrez le nom de l'équipement : " nom
    read -p "Entrez l'adresse MAC (format XX:XX:XX:XX:XX:XX) : " adresse_mac
    read -p "Entrez l'adresse IP : " adresse_ip
    valider_ip "$adresse_ip"
    while [ $validiteIP -eq 0 ]; do
        read -p "Veuillez saisir une adresse IP valide : " adresse_ip
    done
    read -p "Entrez le masque (CIDR): " masque
    read -p "Entrez le type d'équipement (machine (1)/serveur (3)/switch (2)) : " type

    # Insertion des données
    mysql -u GestAdmin -e "USE $db_name;
        INSERT INTO $table_name (id, nom, adMAC, adIP, CIDR, idT) 
        VALUES ('$id', '$nom', '$adresse_mac', '$adresse_ip', '$masque', '$type');"

    echo "Équipement ajouté avec succès !"
}

# Boucle pour ajouter plusieurs équipements
while true; do
    echo ""
    echo "1 - Ajouter un nouvel équipement"
    echo "0 - Quitter"
    read -p "Votre choix : " choix

    case $choix in
        1) ajouter_equipement ;;
        0) echo "Au revoir !"; afficheTitre "Gestion du parc"; exit 0 ;;
        *) echo "Option invalide, veuillez réessayer." ;;
    esac
done
afficheTitre "Gestion du parc"