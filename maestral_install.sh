#!/usr/bin/env fish
echo "=== Suppression de l'ancien environnement virtuel ==="
rm -rf ~/.maestral-venv

echo "=== Création d'un nouvel environnement virtuel ==="
python3 -m venv ~/.maestral-venv

echo "=== Activation de l'environnement virtuel ==="
source ~/.maestral-venv/bin/activate.fish

echo "=== Mise à jour de pip ==="
pip install --upgrade pip

echo "=== Installation de Maestral avec GUI ==="
pip install "maestral[gui]"

echo "=== Installation terminée ==="
echo "Pour lancer Maestral GUI :"
echo "source ~/.maestral-venv/bin/activate.fish && maestral gui"
