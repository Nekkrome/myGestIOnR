#!/bin/bash
source ../fonction.sh

# Liste des types de colonnes simplifiés
types_colonnes=("VARCHAR(255)" "INT" "TEXT" "DATE" "FLOAT" "BOOLEAN")

while true; do
    # Liste toutes les bases de données
    echo "Liste des bases de données :"
    mysql -u GestAdmin -e "SHOW DATABASES;"

    # Demande à l'utilisateur de choisir une base de données
    read -p "Entrez le nom de la base de données que vous souhaitez gérer (ou 'exit' pour quitter) : " db_name

    # Permet de quitter le script
    if [[ "$db_name" == "exit" ]]; then
        echo "Au revoir !"
        break
    fi

    # Vérifie si la base de données existe
    if mysql -u GestAdmin -e "USE $db_name;" 2>/dev/null; then
        echo "Vous avez choisi la base de données '$db_name'."

        # Demande à l'utilisateur de choisir une action : Créer une nouvelle table ou modifier un équipement
        echo "Que souhaitez-vous faire ?"
        echo "1. Créer une nouvelle table"
        echo "2. Modifier un équipement dans la table 'equipements'"
        echo "3. Ajouter une colonne à la table 'equipements'"
        read -p "Entrez le numéro de l'action souhaitée : " action_choice

        case $action_choice in
            1)
                # Créer une nouvelle table
                read -p "Entrez le nom de la nouvelle table : " new_table_name
                read -p "Combien de colonnes souhaitez-vous ajouter à cette table ? : " num_columns

                # Création de la table avec les colonnes définies par l'utilisateur
                create_query="CREATE TABLE $new_table_name ("

                for ((i=1; i<=num_columns; i++)); do
                    read -p "Entrez le nom de la colonne $i : " column_name
                    echo "Choisissez le type de la colonne $i :"
                    # Affichage de la liste des types de colonnes
                    select type_choice in "${types_colonnes[@]}"; do
                        if [[ -n "$type_choice" ]]; then
                            new_column_type="$type_choice"
                            break
                        else
                            echo "Choix invalide. Essayez à nouveau."
                        fi
                    done
                    create_query="$create_query$column_name $new_column_type"
                    if [[ $i -lt $num_columns ]]; then
                        create_query="$create_query, "
                    fi
                done

                create_query="$create_query);"

                # Exécuter la requête pour créer la table
                mysql -u GestAdmin -e "USE $db_name; $create_query"
                echo "La table '$new_table_name' a été créée avec succès."
                ;;
            2)
                # Modifier un équipement
                read -p "Entrez l'ID de l'équipement à modifier : " equip_id

                # Vérifier si l'équipement existe
                equip_exists=$(mysql -u GestAdmin -e "USE $db_name; SELECT COUNT(*) FROM Equipement WHERE id = $equip_id;" | tail -n 1)

                if [[ "$equip_exists" -eq 0 ]]; then
                    echo "Erreur : Aucun équipement trouvé avec l'ID '$equip_id'."
                    continue
                fi

                echo "L'équipement avec l'ID '$equip_id' existe."

                # Demander les nouveaux détails de l'équipement
                echo "Que souhaitez-vous modifier ?"
                echo "1. Modifier le type"
                echo "2. Modifier le nom"
                echo "3. Modifier l'adresse MAC"
                echo "4. Modifier l'adresse IP"
                echo "5. Modifier le masque"
                echo "6. Modifier tous les champs"
                read -p "Entrez le numéro de l'option souhaitée : " mod_choice

                case $mod_choice in
                    1)
                        read -p "Entrez le nouveau type (machine/serveur/switch) : " new_type
                        mysql -u GestAdmin -e "USE $db_name; UPDATE Equipement SET idT = '$new_type' WHERE id = $equip_id;"
                        echo "Type modifié avec succès."
                        ;;
                    2)
                        read -p "Entrez le nouveau nom : " new_nom
                        mysql -u GestAdmin -e "USE $db_name; UPDATE Equipements SET nom = '$new_nom' WHERE id = $equip_id;"
                        echo "Nom modifié avec succès."
                        ;;
                    3)
                        read -p "Entrez la nouvelle adresse MAC : " new_mac
                        mysql -u GestAdmin -e "USE $db_name; UPDATE Equipement SET adMAC = '$new_mac' WHERE id = $equip_id;"
                        echo "Adresse MAC modifiée avec succès."
                        ;;
                    4)
                        read -p "Entrez la nouvelle adresse IP : " new_ip
                        mysql -u GestAdmin -e "USE $db_name; UPDATE Equipement SET adIP = '$new_ip' WHERE id = $equip_id;"
                        echo "Adresse IP modifiée avec succès."
                        ;;
                    5)
                        read -p "Entrez le nouveau masque : " new_mask
                        mysql -u GestAdmin -e "USE $db_name; UPDATE Equipement SET CIDR = '$new_mask' WHERE id = $equip_id;"
                        echo "Masque modifié avec succès."
                        ;;
                    6)
                        read -p "Entrez le nouveau type : " new_type
                        read -p "Entrez le nouveau nom : " new_nom
                        read -p "Entrez la nouvelle adresse MAC : " new_mac
                        read -p "Entrez la nouvelle adresse IP : " new_ip
                        read -p "Entrez le nouveau masque : " new_mask
                        mysql -u GestAdmin -e "USE $db_name; UPDATE Equipement SET idT = '$new_type', nom = '$new_nom', adMAC = '$new_mac', adIP = '$new_ip', CIDR = '$new_mask' WHERE id = $equip_id;"
                        echo "Équipement modifié avec succès."
                        ;;
                    *)
                        echo "Choix invalide."
                        ;;
                esac
                ;;
            3)
                # Ajouter une colonne à la table 'equipements'
                read -p "Entrez le nom de la colonne à ajouter à la table 'equipements' : " new_column_name
                echo "Choisissez le type de la colonne :"
                select type_choice in "${types_colonnes[@]}"; do
                    if [[ -n "$type_choice" ]]; then
                        new_column_type="$type_choice"
                        break
                    else
                        echo "Choix invalide. Essayez à nouveau."
                    fi
                done

                # Ajouter la colonne à la table 'equipements'
                mysql -u GestAdmin -e "USE $db_name; ALTER TABLE Equipement ADD COLUMN $new_column_name $new_column_type;"
                echo "Colonne '$new_column_name' ajoutée avec succès à la table 'equipements'."
                ;;
            *)
                echo "Choix invalide."
                ;;
        esac
    else
        echo "Erreur : La base de données '$db_name' n'existe pas."
    fi

    # Demande à l'utilisateur s'il souhaite revenir au menu principal
    read -p "Souhaitez-vous gérer une autre table ? (oui/non) : " back_to_menu
    if [[ "$back_to_menu" != "oui" ]]; then
        echo "Au revoir !"
        break
    fi
done
afficheTitre "Gestion du parc"


     


