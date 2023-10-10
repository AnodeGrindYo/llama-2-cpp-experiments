## Linux (Debian)

## 1. Installation de gcc, g++ et make

#### a. Mettre à jour la liste des paquets
Ouvrez votre terminal Debian et exécutez la commande suivante pour vous assurer que la liste des paquets est à jour.
```bash
sudo apt update
```

#### b. Installer le compilateur C/C++ et Make :
Utilisez la commande suivante pour installer le compilateur GNU C/C++ (gcc, g++) et Make.
```bash
sudo apt install build-essential
```

Le paquet **build-essential** inclut **gcc** (le compilateur GNU pour le C), **g++** (le compilateur GNU pour C++), et **make**, ainsi que d'autres outils et dépendances nécessaires pour la compilation de code sur Debian.

#### c. Vérifier l'installation

Après l'installation, vous pouvez vérifier que gcc, g++ et make sont correctement installés en exécutant les commandes suivantes qui afficheront les versions des logiciels installés :

```bash
gcc --version
g++ --version
make --version
```

### 2. Installation de Git

#### a. Tapez la commande suivante pour installer Git :
```bash
sudo apt install git
```

#### b. Vérifiez l'installation :
```bash
git --version
```

### 3. Obtenir Llama-2-cpp
- Clonez le repository de LLAMA-2-CPP :
```bash
git clone https://github.com/ggerganov/llama.cpp
```

- Rendze-vous dans le dossier llama.cpp :
```bash
cd llama.cpp/
```

- Exécutez la commande make :
```bash
make
```

### 4. Obtenir les poids du modèle

Pour la version [llama-7b-chat](https://huggingface.co/TheBloke/Llama-2-7B-Chat-GGML/tree/main), téléchargez l'un des fichiers ".bin". La différence entre ces fichiers réside dans la méthode de quantisation utilisée (une technique utilisée pour compresser les modèles en réduisant la précision des nombres qui représentent les paramètres du modèle. C'est particulièrement utile pour le déploiement de modèles sur des appareils avec des ressources limitées comme les appareils mobiles ou les microcontrôleurs)

exemple (en supposant que vous soyez déjà dans le dossier llama.cpp) :
```bash
cd models
wget https://huggingface.co/substratusai/Llama-2-13B-chat-GGUF/resolve/main/model.bin -O model.q4_k_s.gguf
cd ..
```

### 5. Tester le modèle

```bash
./main -t 10 -m ./models/model.q4_k_s.gguf --color -c 4096 --temp 0.7 --repeat_penalty 1.1 -n -1 -p "### Instruction: Write a story about llamas\n### Response:"
```

Vous pouvez changer le 4 par le nombre de coeurs physiques qu'a votre système. Par exemple, si vous disposez d'un système à 8 cœurs avec 16 threads, vous devez définir le nombre sur 8.

Un avertissement apparaîtra indiquant que le modèle ne prend pas en charge plus de 2048 jetons, mais cela est incorrect et sera probablement corrigé dans une future version de lama.cpp. Llama 2 prend en charge des contextes allant jusqu'à 4 096 jetons, les mêmes que GPT-3 et GPT-3.5.