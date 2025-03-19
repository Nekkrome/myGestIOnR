#!/bin/bash
source fonction.sh

# Fonction pour afficher toutes les bases de données disponibles
afficher_bases_donnees() {
    echo "Liste des bases de données disponibles :"
    mysql -u GestAdmin -e "SHOW DATABASES;" -B --silent
}

# Fonction pour afficher toutes les tables dans la base de données sélectionnée
afficher_tables() {
    echo "Liste des tables dans la base de données '$db_name' :"
    mysql -u GestAdmin -e "USE $db_name; SHOW TABLES;" -B --silent
}

# Fonction pour afficher les détails d'un équipement
afficher_details_equipement() {
    echo ""
    read -p "Entrez l'ID de l'équipement à afficher : " id

    # Vérifie si l'ID est vide
    if [[ -z "$id" ]]; then
        echo "Erreur : L'ID ne peut pas être vide."
        return
    fi

    # Utilisation des guillemets autour de l'ID pour éviter les problèmes d'espaces ou caractères spéciaux
    equipement=$(mysql -u GestAdmin -e "USE $db_name; SELECT * FROM $table_name WHERE id='$id';" -B --silent)

    # Vérifie si l'équipement existe
    if [[ -z "$equipement" ]]; then
        echo "Erreur : Aucun équipement trouvé avec l'ID '$id'."
        return
    fi

    # Affiche les détails de l'équipement
    echo "Détails de l'équipement avec ID '$id' :"
    mysql -u GestAdmin -e "USE $db_name; SELECT * FROM $table_name WHERE id='$id';"
}

# Fonction pour supprimer des données
supprimer_donnees() {
    afficher_details_equipement  # Affiche les détails avant de commencer

    echo "Que voulez-vous supprimer ?"
    echo "1 - Type (machine, serveur, switch)"
    echo "2 - Nom"
    echo "3 - Adresse MAC"
    echo "4 - Adresse IP"
    echo "5 - Masque de sous-réseau"
    echo "6 - Supprimer toute la ligne"
    echo "0 - Annuler"
    read -p "Votre choix : " choix

    case $choix in
        1) mysql -u GestAdmin -e "USE $db_name; UPDATE $table_name SET idT=NULL WHERE id='$id';"
           echo "Type supprimé !" ;;
        2) mysql -u GestAdmin -e "USE $db_name; UPDATE $table_name SET nom=NULL WHERE id='$id';"
           echo "Nom supprimé !" ;;
        3) mysql -u GestAdmin -e "USE $db_name; UPDATE $table_name SET adMAC=NULL WHERE id='$id';"
           echo "Adresse MAC supprimée !" ;;
        4) mysql -u GestAdmin -e "USE $db_name; UPDATE $table_name SET adIP=NULL WHERE id='$id';"
           echo "Adresse IP supprimée !" ;;
        5) mysql -u GestAdmin -e "USE $db_name; UPDATE $table_name SET CIDR=NULL WHERE id='$id';"
           echo "Masque supprimé !" ;;
        6) read -p "Êtes-vous sûr de vouloir supprimer toute la ligne (O/N) ? " confirm
           if [[ "$confirm" =~ ^[Oo]$ ]]; then
               mysql -u GestAdmin -e "USE $db_name; DELETE FROM $table_name WHERE id='$id';"
               echo "Équipement supprimé !"
           else
               echo "Suppression annulée."
           fi ;;
        0) echo "Suppression annulée."; return ;;
        *) echo "Option invalide, veuillez réessayer." ;;
    esac

    echo
}

# Menu principal
while true; do
    echo "Menu principal :"
    echo "1 - Afficher les bases de données"
    echo "2 - Sélectionner une base de données"
    echo "3 - Afficher les tables dans la base de données sélectionnée"
    echo "4 - Modifier ou supprimer un équipement"
    echo "0 - Quitter"
    read -p "Votre choix : " menu_choice

    case $menu_choice in
        1) afficher_bases_donnees ;;
        2) 
            # Demande à l'utilisateur de sélectionner la base de données
            read -p "Entrez le nom de la base de données à utiliser : " db_name
            echo "Base de données sélectionnée : $db_name"
            afficher_tables ;;
        3)
            # Affiche les tables dans la base de données sélectionnée
            if [[ -z "$db_name" ]]; then
                echo "Veuillez d'abord sélectionner une base de données (option 2)."
            else
                afficher_tables
            fi
            ;;
        4) 
            # Supprimer ou modifier un équipement dans la base de données
            if [[ -z "$db_name" ]]; then
                echo "Veuillez d'abord sélectionner une base de données (option 2)."
            else
                read -p "Entrez le nom de la table : " table_name
                supprimer_donnees
            fi
            ;;
        0) echo "Au revoir !"; afficheTitre "Gestion du parc"; exit 0 ;;
        *) echo "Choix invalide, essayez à nouveau." ;;
    esac
done
afficheTitre "Gestion du parc"

