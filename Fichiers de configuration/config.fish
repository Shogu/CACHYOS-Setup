source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

# Désactive le message d'accueil de Fish.
function fish_greeting
end

alias vim='nano'
alias vi='nano'
alias gedit='gnome-text-editor'
alias micro='nano'
alias notepad='gnome-text-editor'
alias edit='gnome-text-editor'

# utiliser sudo pour les alias
function sudo
    if test (count $argv) -eq 0
        command sudo
    else
        # Transforme le premier argument en alias/commande à exécuter avec sudo
        switch $argv[1]
            case gedit
                command sudo gnome-text-editor $argv[2..-1]
            case '*'
                command sudo $argv
        end
    end
end

