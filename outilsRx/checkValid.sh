#!/bin/bash
source fonction.sh

# Paramètres de connexion à la base de données
DB_HOST="localhost"

# Afficher les bases de données disponibles
echo "Bases de données disponibles :"
databases=$(mysql -h "$DB_HOST" -u GestAdmin -e "SHOW DATABASES;" -B | tail -n +2)
echo "$databases"

# Demande à l'utilisateur de saisir le nom de la base de données
read -p "Entrez le nom de la base de données que vous souhaitez utiliser : " DB_NAME

# Requête pour récupérer les IPs des équipements
query="SELECT adIP FROM equipements;"

# Fonction pour tester si l'IP est active
check_ip_status() {
    ip="$1"
    
    # On fait un ping sur l'IP et on renvoie le statut
    if ping -c 1 -W 1 "$ip" &> /dev/null; then
        # Machine active (vert)
        echo -e "\e[32m$ip (Active)\e[0m"
    else
        # Machine inactive (rouge)
        echo -e "\e[31m$ip (Inactive)\e[0m"
    fi
}

# Connexion à la base de données et récupération des IPs
echo "Vérification des machines actives/inactives dans la base de données '$DB_NAME'..."
ips=$(mysql -h "$DB_HOST" -u GestAdmin -D "$DB_NAME" -e "$query" -B | tail -n +2)

# Vérifie si des IPs ont été récupérées
if [ -z "$ips" ]; then
    echo "Aucune adresse IP trouvée dans la base de données '$DB_NAME'."
    exit 1
fi

# Parcourir les IPs récupérées et tester leur statut
for ip in $ips; do
    check_ip_status "$ip"
done

afficheTitre 'Outils reseau'

