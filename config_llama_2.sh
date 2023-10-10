#!/bin/bash

# Vérifier si jq est installé
if ! command -v jq &> /dev/null
then
    echo "jq n'est pas installé. L'installer maintenant..."
    sudo apt-get update
    sudo apt-get install -y jq
else
    echo "jq est déjà installé."
fi

# Fonction pour obtenir un nombre entier de l'utilisateur
function get_integer {
    while : ; do
        read -p "$1" input
        if [[ $input =~ ^[0-9]+$ ]] && ( [[ -z $2 ]] || [[ $input -le $2 ]] ); then
            echo $input
            break
        else
            echo "Veuillez entrer un nombre entier valide."
        fi
    done
}

# Fonction pour obtenir un booléen de l'utilisateur
function get_boolean {
    while : ; do
        read -p "$1 (Y/n): " input
        case $input in
            [Yy]* ) echo true; break;;
            [Nn]* ) echo false; break;;
            * ) echo "Veuillez répondre oui ou non (Y/n).";;
        esac
    done
}

# Fonction pour obtenir un nombre décimal de l'utilisateur
function get_float {
    while : ; do
        read -p "$1" input
        if [[ $input =~ ^[0-9]+(\.[0-9]+)?$ ]]; then
            echo $input
            break
        else
            echo "Veuillez entrer un nombre décimal."
        fi
    done
}

# Obtenir le nombre de cœurs disponibles
num_cores=$(nproc)

# Obtenir les paramètres de l'utilisateur
threads=$(get_integer "Entrez le nombre de threads (doit être inférieur ou égal au nombre de cœurs disponibles [$num_cores]) : " $num_cores)

color=$(get_boolean "Voulez-vous activer la couleur ?")

context_size=$(get_integer "Entrez la taille du contexte (doit être comprise entre 512 et 4096) : ")
while [[ $context_size -lt 512 || $context_size -gt 4096 ]]; do
    echo "La taille du contexte doit être comprise entre 512 et 4096."
    context_size=$(get_integer "Entrez la taille du contexte (doit être comprise entre 512 et 4096) : ")
done
temperature=$(get_float "Entrez la température (entre 0 et 2) : ")
read -p "Entrez la pénalité de répétition (appuyez sur Entrée pour la valeur par défaut 1.1) : " repeat_penalty
repeat_penalty=${repeat_penalty:-1.1}
read -p "Entrez le nombre de tokens à prédire (-1 pour l'infini, -2 jusqu'à ce que le contexte soit rempli, appuyez sur Entrée pour la valeur par défaut 128) : " number_of_token_to_predict
number_of_token_to_predict=${number_of_token_to_predict:-128}

# Écrire les paramètres dans le fichier config.json
jq --argjson threads "$threads" \
   --argjson color "$color" \
   --argjson context_size "$context_size" \
   --argjson temperature "$temperature" \
   --argjson repeat_penalty "$repeat_penalty" \
   --argjson number_of_token_to_predict "$number_of_token_to_predict" \
   '. + {
       THREADS: $threads,
       COLOR: $color,
       CONTEXT_SIZE: $context_size,
       TEMPERATURE: $temperature,
       REPEAT_PENALTY: $repeat_penalty,
       NUMBER_OF_TOKEN_TO_PREDICT: $number_of_token_to_predict
   }' config.json > tmp.json && mv tmp.json config.json
