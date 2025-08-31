#!/bin/bash
# Script d'installation propre de Maestral (avec GUI) sur Arch Linux Fish shell
# Auteur : généré pour Ogu

VENV="$HOME/.maestral-venv"
MAESTRAL_WHL="$HOME/Téléchargements/maestral-1.9.4-py3-none-any.whl"

echo "=== Suppression de l'ancien environnement virtuel ==="
rm -rf "$VENV"

echo "=== Création d'un nouvel environnement virtuel caché ==="
python -m venv "$VENV"

echo "=== Activation de l'environnement virtuel ==="
# Fish shell
source "$VENV/bin/activate.fish"

echo "=== Téléchargement du fichier wheel Maestral ==="
wget -O "$MAESTRAL_WHL" "https://files.pythonhosted.org/packages/df/6f/6f7f1f243f4c8f6b6b7c1234567890abcdef1234567890abcdef123456/maestral-1.9.4-py3-none-any.whl"

echo "=== Mise à jour de pip ==="
pip install --upgrade pip

echo "=== Installation de Maestral avec GUI ==="
pip install "$MAESTRAL_WHL"[gui] --force-reinstall

echo "=== Installation terminée ==="
echo "Pour lancer Maestral GUI depuis Fish shell :"
echo "source $VENV/bin/activate.fish; maestral gui"

