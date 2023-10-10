import json
import subprocess

CONFIG_PATH = 'config.json'
LLAMA_PATH = './llama.cpp'
MAIN_PATH = LLAMA_PATH + '/main'

class Chat:
    def __init__(self):
        # Charger les paramètres depuis config.json
        with open(CONFIG_PATH, 'r') as file:
            config = json.load(file)

        # Attribuer les valeurs aux attributs de l'instance
        self.model_path = config.get('MODEL_PATH')
        self.threads = config.get('THREADS', 1)  # Valeur par défaut 1 si THREADS n'est pas trouvé
        self.color = config.get('COLOR', False)  # Valeur par défaut False si COLOR n'est pas trouvé
        self.context_size = config.get('CONTEXT_SIZE', 512)  # Valeur par défaut 512 si CONTEXT_SIZE n'est pas trouvé
        self.temperature = config.get('TEMPERATURE', 1.0)  # Valeur par défaut 1.0 si TEMPERATURE n'est pas trouvé
        self.repeat_penalty = config.get('REPEAT_PENALTY', 1.1)  # Valeur par défaut 1.1 si REPEAT_PENALTY n'est pas trouvé
        self.nb_tokens_to_predict = config.get('NUMBER_OF_TOKEN_TO_PREDICT', 128)  # Valeur par défaut 128 si NUMBER_OF_TOKEN_TO_PREDICT n'est pas trouvé

    def print_attr(self):
        # Imprimer les attributs et leurs valeurs
        print(f'Threads: {self.threads}')
        print(f'Color: {self.color}')
        print(f'Context Size: {self.context_size}')
        print(f'Temperature: {self.temperature}')
        print(f'Repeat Penalty: {self.repeat_penalty}')
        print(f'Number of Tokens to Predict: {self.nb_tokens_to_predict}')
    
    def create_query(self, user_text):
        color_option = '--color' if self.color else ''
        query_string = (
            f"{MAIN_PATH} -t {self.threads} -m {self.model_path} {color_option} "
            f"-c {self.context_size} --temp {self.temperature} "
            f"--repeat_penalty {self.repeat_penalty} -n {self.nb_tokens_to_predict} "
            f"-p \"### Instruction: {user_text}\n### Response:\""
        )
        return query_string
    
    def execute_query(self, user_text):
        query_string = self.create_query(user_text)
        completed_process = subprocess.run(query_string, shell=True, capture_output=True, text=True)
        return completed_process.stdout

# Créer une instance de la classe Chat
chat_instance = Chat()

# Appeler la méthode print_attr pour imprimer les attributs et leurs valeurs
chat_instance.print_attr()

# Test de la méthode query
user_text = "Racontez-moi une histoire sur les licornes."
query_string = chat_instance.create_query(user_text)
print(query_string)