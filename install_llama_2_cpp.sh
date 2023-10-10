#!/bin/bash

# Fonction pour afficher des messages en couleur
function print_color {
    case $2 in
        red) color="\e[31m";;
        green) color="\e[32m";;
        orange) color="\e[33m";;
        purple) color="\e[35m";;
        *) color="\e[39m";;
    esac
    echo -e "$color$1\e[0m"
}

# Message d'accueil
print_color "Ce script a été fait par" purple
cat << "EOF"
     /\                   | |     / ____|    (_)         | \ \   / /   
    /  \   _ __   ___   __| | ___| |  __ _ __ _ _ __   __| |\ \_/ /__  
   / /\ \ | '_ \ / _ \ / _` |/ _ \ | |_ | '__| | '_ \ / _` | \   / _ \ 
  / ____ \| | | | (_) | (_| |  __/ |__| | |  | | | | | (_| |  | | (_) |
 /_/    \_\_| |_|\___/ \__,_|\___|\_____|_|  |_|_| |_|\__,_|  |_|\___/ 
EOF

# Mettre à jour la liste des paquets
print_color "Mise à jour de la liste des paquets..." orange
sudo apt update

# Installer le compilateur C/C++ et Make si nécessaire
if ! command -v gcc &> /dev/null
then
    print_color "Installation de gcc, g++ et make..." orange
    sudo apt install build-essential
else
    print_color "gcc, g++ et make sont déjà installés." green
fi

# Vérifier l'installation de gcc, g++ et make
print_color "Vérification de l'installation de gcc, g++ et make..." orange
gcc --version
g++ --version
make --version

# Installer Git si nécessaire
if ! command -v git &> /dev/null
then
    print_color "Installation de Git..." orange
    sudo apt install git
else
    print_color "Git est déjà installé." green
fi

# Vérifier l'installation de Git
print_color "Vérification de l'installation de Git..." orange
git --version

# Obtenir Llama-2-cpp
print_color "Clonage du répertoire de LLAMA-2-CPP..." orange
git clone https://github.com/ggerganov/llama.cpp

# Se rendre dans le dossier llama.cpp et exécuter la commande make
cd llama.cpp/
print_color "Compilation de LLAMA-2-CPP..." orange
make

# Obtenir les poids du modèle
print_color "Téléchargement des poids du modèle..." orange
mkdir -p models
cd models
wget https://huggingface.co/substratusai/Llama-2-13B-chat-GGUF/resolve/main/model.bin -O model.13B_chat.gguf
cd ..

# Ecrire l'adresse du modèle dans un fichier de config
print_color "Ecriture de l'adresse du modèle dans un fichier de config..." orange
echo '{
    "MODEL_PATH": "./llama.cpp/models/model.13B_chat.gguf"
}' > config.json

# Tester le modèle
print_color "Test du modèle..." orange
./main -t 10 -m ./models/model.13B_chat.gguf --color -c 4096 --temp 0.7 --repeat_penalty 1.1 -n -2 -p "### Instruction: Write a story about unicorns and rainbows\n### Response:"

print_color "Terminé !" green
