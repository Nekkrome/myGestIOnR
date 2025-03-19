#!/bin/bash
source fonction.sh

# Configuration
DB_NAME="MyGest"
DB_USER="GestAdmin"
BACKUP_DIR="/var/backups/MyGest"
MAX_BACKUPS=5  # Nombre maximum de backups à conserver
currentUser=$(whoami)

# Vérifier si le dossier de sauvegarde existe, sinon le créer
sudo mkdir -p "$BACKUP_DIR"
sudo chown $currentUser $BACKUP_DIR

afficheTitre "Backups"

echo "-------------- Gestion des sauvegardes --------------"
echo "1) Sauvegarde de la base de données"
echo "2) Restauration d'une sauvegarde"
echo "3) Quitter"
read -p "Choisissez une option : " choix

case $choix in
    1)  # Sauvegarde
        BACKUP_FILE="$BACKUP_DIR/MyGest-$(date +'%Y%m%d-%H%M%S').sql"
        echo "Sauvegarde en cours..."
        mysqldump -u "$DB_USER" "$DB_NAME" > "$BACKUP_FILE"

        if [[ $? -eq 0 ]]; then
            echo "Sauvegarde réussie : $BACKUP_FILE"
        else
            echo "Erreur lors de la sauvegarde."currentUser=$(whoami)
            exit 1
        fi

        # Suppression des anciennes sauvegardes si le nombre dépasse MAX_BACKUPS
        NUM_BACKUPS=$(ls -1 "$BACKUP_DIR"/*.sql 2>/dev/null | wc -l)
        if [[ $NUM_BACKUPS -gt $MAX_BACKUPS ]]; then
            echo "Nettoyage des anciennes sauvegardes..."
            ls -1t "$BACKUP_DIR"/*.sql | tail -n +$((MAX_BACKUPS+1)) | xargs rm -f
        fi
        ;;
        
    2)  # Restauration
        echo "Sauvegardes disponibles :"
        ls -1 "$BACKUP_DIR"/*.sql
        read -p "Entrez le nom du fichier de sauvegarde à restaurer : " RESTORE_FILE

        if [[ -f "$BACKUP_DIR/$RESTORE_FILE" ]]; then
            echo "Restauration en cours..."
            mysql -u "$DB_USER" "$DB_NAME" < "$BACKUP_DIR/$RESTORE_FILE"
            echo "Restauration terminée."
        else
            echo "Fichier introuvable."
        fi
        ;;

    3)  # Quitter
        echo "Opération annulée."
        exit 0
        ;;

    *)  # Mauvais choix
        echo "Option invalide."
        exit 1
        ;;
esac