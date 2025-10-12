source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

# Désactive le message d'accueil de Fish.
set -g fish_greeting ""

# ~/.config/fish/config.fish
function fish_greeting
    # rien à faire ici, empêche le message global
end

# Désactiver le pager pour paru et autres programmes : à voir si possible sur yay
set -Ux PAGER cat

alias paru='yay'
alias vim='nano'
alias vi='nano'
alias gedit='gnome-text-editor'
alias micro='nano'
alias notepad='gnome-text-editor'
alias edit='gnome-text-editor'

#utilsier sudo pour les alias
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

