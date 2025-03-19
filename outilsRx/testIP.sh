#!/bin/bash
source fonction.sh

validiteIP=0

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

while [ $validiteIP -eq 0 ]; do
    read -p "Veuillez saisir une adresse IP : " ipAddress
    
    if valider_ip "$ipAddress"; then
        echo "Envoie de la requête ICMP ..."
        ping -c 1 -W 1 "$ipAddress" &> /dev/null
        
        if [ $? -eq 0 ]; then
            echo "L'adresse IP répond aux pings."
            validiteIP=1
        else
            echo "L'adresse IP ne répond pas aux pings."
        fi
    else
        echo "L'adresse IP n'est pas valide."
    fi
done

echo "[Appuyez sur entrée pour continuer]"
read

afficheTitre 'Outils reseau'
