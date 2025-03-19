#!/bin/bash
source fonction.sh

# Liste les bases de données
echo "Récupération des bases de données..."
databases=$(mysql -u GestAdmin -e "SHOW DATABASES;" -B | tail -n +2)

echo "Bases de données disponibles :"
echo "$databases"

# Demande à l'utilisateur de choisir une base de données
read -p "Entrez le nom de la base de données : " db_name

# Vérifie que la base de données existe
if ! echo "$databases" | grep -q "^$db_name$"; then
    echo "Erreur : La base de données '$db_name' n'existe pas."
    exit 1
fi

# Liste les tables de la base de données choisie
echo "Récupération des tables dans '$db_name'..."
tables=$(mysql -u GestAdmin -e "USE $db_name; SHOW TABLES;" -B | tail -n +2)

echo "Tables disponibles dans '$db_name' :"
echo "$tables"

# Demande à l'utilisateur de choisir une table
read -p "Entrez le nom de la table : " table_name

# Vérifie que la table existe
if ! echo "$tables" | grep -q "^$table_name$"; then
    echo "Erreur : La table '$table_name' n'existe pas dans la base '$db_name'."
    exit 1
fi

# Récupération des colonnes et de leurs types
columns=$(mysql -u GestAdmin -e "USE $db_name; DESCRIBE $table_name;" -B | tail -n +2 | awk '{print $1}')

echo "Colonnes et types de la table '$table_name' :"
echo "$columns"

# Demande à l'utilisateur s'il veut extraire des adresses IP ou rechercher des mots
echo "Voulez-vous :"
echo "1) Extraire les adresses IP des équipements de la table 'Equipement' ?"
echo "2) Voir les détails des équipements (IP, MAC, Type, etc.) ?"
echo "3) Rechercher un mot dans la base de données ?"
read -p "Entrez le numéro de votre choix (1, 2 ou 3) : " choice

if [ "$choice" -eq 1 ]; then
    # Assurez-vous que la table existe
    if [ "$table_name" == "Equipement" ]; then
        echo "Récupération des adresses IP..."
        # Récupération des adresses IP depuis la table "equipements"
        ip_addresses=$(mysql -u GestAdmin -e "USE $db_name; SELECT adIP FROM $table_name;" -B | tail -n +2)
        
        echo "Adresses IP disponibles :"
        echo "$ip_addresses"
        
        # Demande à l'utilisateur un nom de fichier de sortie
        read -p "Entrez le nom du fichier de sortie (sans extension .txt) : " output_filename
        output_file="$output_filename.txt"

        # Écriture des adresses IP dans le fichier
        echo "Adresses IP des équipements dans la table '$table_name' :" > "$output_file"
        echo "$ip_addresses" >> "$output_file"

        # Confirmation
        echo "Les adresses IP ont été enregistrées dans '$output_file'."
    else
        echo "Erreur : La table '$table_name' n'est pas 'equipements'."
        exit 1
    fi
elif [ "$choice" -eq 2 ]; then
    # Assurez-vous que la table est bien "equipements"
    if [ "$table_name" == "Equipement" ]; then
        echo "Récupération des détails des équipements (ID, Nom, Type, IP, MAC, Masque)..."
        # Récupération des informations de chaque équipement
        equipment_details=$(mysql -u GestAdmin -e "USE $db_name; SELECT id, nom, idT, adIP, adMAC, CIDR FROM $table_name;" -B | tail -n +2)
        
        echo "Détails des équipements dans '$table_name' :"
        echo "$equipment_details"
        
        # Demande à l'utilisateur un nom de fichier de sortie
        read -p "Entrez le nom du fichier de sortie pour les détails (sans extension .txt) : " output_filename
        output_file="$output_filename.txt"

        # Écriture des détails dans le fichier
        echo "Détails des équipements (ID, Nom, Type, IP, MAC, Masque) :" > "$output_file"
        echo "$equipment_details" >> "$output_file"

        # Confirmation
        echo "Les détails des équipements ont été enregistrés dans '$output_file'."
    else
        echo "Erreur : La table '$table_name' n'est pas 'equipements'."
        exit 1
    fi
elif [ "$choice" -eq 3 ]; then
    # Demande à l'utilisateur quel mot il veut rechercher
    read -p "Entrez le mot à rechercher : " search_word

    # Recherche du mot dans toute la base de données
    echo "Recherche du mot '$search_word' dans la base '$db_name'..."
    results=$(mysql -u GestAdmin -e "USE $db_name; SELECT * FROM $table_name WHERE CONCAT_WS(' ', $columns) LIKE '%$search_word%';" -B)

    echo "Résultats de la recherche :"
    echo "$results"

    # Demande à l'utilisateur un nom de fichier de sortie pour les résultats
    read -p "Entrez le nom du fichier de sortie pour les résultats (sans extension .txt) : " output_filename
    output_file="$output_filename.txt"

    # Écriture des résultats dans le fichier
    echo "Résultats de la recherche du mot '$search_word' dans la table '$table_name' :" > "$output_file"
    echo "$results" >> "$output_file"

    # Confirmation
    echo "Les résultats de la recherche ont été enregistrés dans '$output_file'."
else
    echo "Choix invalide, veuillez réessayer."
    exit 1
fi
afficheTitre 'Outils reseau'
