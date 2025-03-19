#!/bin/bash
source fonction.sh

# Fonction pour valider l'adresse IP
valider_ip() {
    local ip=$1
    local regex='^([0-9]{1,3}\.){3}[0-9]{1,3}$'
    
    if [[ $ip =~ $regex ]]; then
        IFS='.' read -r octet1 octet2 octet3 octet4 <<< "$ip"
        if (( octet1 >= 0 && octet1 <= 255 )) && \
           (( octet2 >= 0 && octet2 <= 255 )) && \
           (( octet3 >= 0 && octet3 <= 255 )) && \
           (( octet4 >= 0 && octet4 <= 255 )); then
            return 0
        fi
    fi
    return 1
}

# Fonction pour vérifier si le port est valide
valider_port() {
    local port=$1
    # Vérifier si le port est un entier dans la plage de 0 à 65535
    if [[ "$port" =~ ^[0-9]+$ ]] && (( port >= 0 && port <= 65535 )); then
        return 0
    else
        return 1
    fi
}

# Demander à l'utilisateur une adresse IP
read -p "Entrez une adresse IP : " ip

# Vérifier si l'adresse IP est valide
if ! valider_ip "$ip"; then
    echo "L'adresse IP '$ip' n'est pas valide."
    exit 1
fi

# Demander à l'utilisateur un numéro de port
read -p "Entrez un numéro de port : " port

# Vérifier si le port est valide
if ! valider_port "$port"; then
    echo "Le port '$port' n'est pas valide."
    exit 1
fi

# Test du port avec netcat
nc -zv "$ip" "$port" &>/dev/null

# Vérification du statut de la commande précédente
if [ $? -eq 0 ]; then
    echo "Le port $port est ouvert sur l'adresse IP $ip."
else
    echo "Le port $port est fermé sur l'adresse IP $ip."
fi

afficheTitre 'Outils reseau'