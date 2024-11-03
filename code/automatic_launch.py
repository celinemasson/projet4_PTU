#!/data/projet4/conda/masson/flye_env/bin/python

import subprocess
import sys

def automatic_launch(file_path, output_file_path):
    with open(file_path, 'r') as file:
        with open(output_file_path, 'w') as output_file:
            execution_count = 0  # Variable de comptage des exécutions
            print("Début de la lecture du fichier...", flush=True)
            for line in file:
                execution_count += 1  # Incrémente le compteur à chaque exécution
                command = line.strip()
                try:
                    print(f"Exécution de la commande {execution_count}", flush=True)  # Affiche le numéro de l'exécution
                    # Exécute la commande en utilisant subprocess
                    subprocess.run(command, shell=True, check=True, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
                    print(f"L'exécution {execution_count} est terminée. Le fichier des scores est prêt.", flush=True)
                except subprocess.CalledProcessError as e:
                    # Capture l'erreur et l'écrit dans le fichier de sortie
                    output_file.write(f"Erreur lors de l'exécution de la commande {execution_count}: {command}\n")
                    output_file.write(f"Message d'erreur : {e.stderr.decode()}\n\n")
                    print(f"Un problème est survenu lors de l'exécution {execution_count}.", flush=True)

if __name__ == "__main__":
    # Vérifier le nombre d'arguments
    if len(sys.argv) != 3:
        print("Usage: python automatic_launch.py chemin_fichier_texte.txt chemin_sortie_erreur.txt")
        sys.exit(1)  # Sortie du script avec une erreur

    # Récupérer les chemins des fichiers à partir des arguments
    chemin_input = sys.argv[1]
    chemin_output = sys.argv[2]

    # Appeler la fonction principale
    automatic_launch(chemin_input, chemin_output)

# nohup python automatic_launch.py file_path.txt output_file_path.txt &