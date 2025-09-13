#!/usr/bin/env python3

import sys
import os
import subprocess
import re

MAESTRAL_BIN = "/home/ogu/.local/bin/maestral"
DROPBOX_ROOT = os.path.expanduser("~/Dropbox")

def extract_url(output):
    match = re.search(r"https?://\S+", output)
    return match.group(0) if match else None

def open_url(url):
    subprocess.run(["xdg-open", url])

def copy_to_clipboard(url):
    subprocess.run(["xclip", "-selection", "clipboard"], input=url.encode())

def main():
    if len(sys.argv) < 2:
        print("Aucun fichier sélectionné.")
        sys.exit(1)

    for file_path in sys.argv[1:]:
        file_path = os.path.abspath(file_path)

        # Vérifie que le fichier est dans Dropbox
        if not file_path.startswith(DROPBOX_ROOT):
            print(f"Le fichier {file_path} n'est pas dans Dropbox ({DROPBOX_ROOT}).")
            continue

        if not os.path.exists(file_path):
            print(f"Le fichier {file_path} n'existe pas.")
            continue

        # Calcul du chemin relatif depuis Dropbox root
        relative_path = os.path.relpath(file_path, DROPBOX_ROOT)

        # Vérifier lien existant
        result = subprocess.run(
            [MAESTRAL_BIN, "sharelink", "list", relative_path],
            capture_output=True, text=True, cwd=DROPBOX_ROOT
        )

        dropbox_url = extract_url(result.stdout)

        if dropbox_url:
            print(f"Lien existant : {dropbox_url}")
        else:
            # Créer un nouveau lien
            create_result = subprocess.run(
                [MAESTRAL_BIN, "sharelink", "create", relative_path],
                capture_output=True, text=True, cwd=DROPBOX_ROOT
            )
            dropbox_url = extract_url(create_result.stdout)

            if not dropbox_url:
                print(f"Impossible de générer un lien pour {relative_path}. Vérifiez que le fichier est synchronisé.")
                continue

        # Ouvrir et copier le lien
        open_url(dropbox_url)
        copy_to_clipboard(dropbox_url)
        print(f"Lien copié et ouvert : {dropbox_url}")

if __name__ == "__main__":
    main()
