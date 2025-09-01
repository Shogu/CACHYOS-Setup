#!/usr/bin/env bash
set -e

# Installation des dépendances système
sudo pacman -S --needed --noconfirm \
    python \
    python-pip \
    python-virtualenv \
    python-setuptools \
    python-wheel

# Nettoyage d'un éventuel ancien environnement
rm -rf ~/.maestral-venv

# Création de l'environnement virtuel
python3 -m venv ~/.maestral-venv

# Activation (bash/zsh, fish aura activate.fish)
source ~/.maestral-venv/bin/activate

# Mise à jour de pip et installation de Maestral avec l'interface graphique
pip install --upgrade pip
pip install "maestral[gui]"

echo ""
echo "✅ Installation terminée !"
echo "Pour lancer Maestral avec Fish :"
echo "   source ~/.maestral-venv/bin/activate.fish && maestral gui"
