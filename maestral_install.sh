#!/usr/bin/env fish

# --- Création de l'environnement virtuel ---

set venv_dir ~/.venvs/maestral

echo "--- Préparation de l'environnement virtuel ---"

if not test -d ~/.venvs
    echo "Création du dossier caché ~/.venvs..."
    mkdir ~/.venvs
end

if test -d $venv_dir
    echo "L'environnement Maestral existe déjà."
else
    echo "Création de l'environnement Maestral dans ~/.venvs/maestral..."
    python -m venv $venv_dir
end

echo "--- Activation de l'environnement ---"
# Utilise un subshell pour activer l'environnement et lancer l'installation
# Cela évite de modifier l'environnement de votre shell actuel
# et garantit que pip est bien le pip de l'environnement virtuel
source $venv_dir/bin/activate.fish
echo "Environnement activé avec succès."

# --- Installation de Maestral ---

echo "--- Installation de Maestral avec l'interface graphique ---"
pip install --upgrade pip
pip install "maestral[gui]"

echo "--- Installation terminée ! ---"
echo ""
echo "Pour lancer Maestral la prochaine fois, suivez ces étapes :"
echo "1. Activez l'environnement :"
echo "   source ~/.venvs/maestral/bin/activate.fish"
echo "2. Lancez l'application :"
echo "   maestral gui"
echo ""

# --- Instructions pour le démarrage automatique ---

echo "---"
echo "Étape finale pour le démarrage automatique :"
echo "Une fois l'application lancée, cliquez sur l'icône de Maestral"
echo "dans la zone de notification (systray), allez dans ses paramètres"
echo "et cochez l'option de démarrage automatique."
echo ""
echo "Vous devrez ensuite redémarrer votre ordinateur pour que les modifications prennent effet."
echo ""
