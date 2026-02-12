source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

# Désactive le message d'accueil de Fish.
function fish_greeting
end

# Contrôleur live de scx_scheduler - commande scx
function scx
    watch -n 3 '
        printf "\e[93m=== CPU SCHEDULER ===\e[0m\n"; 
        scxctl get; 
        echo ""; 
        printf "\e[92m=== DISK SCHEDULER ===\e[0m\n"; 
        cat /sys/block/nvme0n1/queue/scheduler;
        echo ""
    '
end

# 20 dernières erreurs journalctl - commande journal
function journal
    journalctl -p err -n 20 --no-pager | bat -l log  
end

# Arguments kernel - commande flags
function flags
    clear
    echo "KERNEL FLAGS (/proc/cmdline)"
    echo "============================="

    # Ligne brute colorée (jaune)
    echo "Ligne complète :"
    printf "\e[93m%s\e[0m\n\n" (cat /proc/cmdline)

    echo "Flags par ligne (triés, uniques) :"
    
    set -l all_flags (string split " " (cat /proc/cmdline))
    set -l flags
    for flag in $all_flags
        if not contains $flag $flags
            set flags $flags $flag
        end
    end

    set -l sorted_flags (printf "%s\n" $flags | sort)
    set i 1
    for flag in $sorted_flags
        printf "\e[92m%2d.\e[0m \e[96m%s\e[0m\n" $i $flag
        set i (math $i + 1)
    end

    echo ""
end

# Alias
alias vim='nano'
alias vi='nano'
alias gedit='gnome-text-editor'
alias micro='nano'
alias notepad='gnome-text-editor'
alias edit='gnome-text-editor'
alias systemd-manager='systemd-manager-tui'

# utiliser sudo pour l'alias gedit
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
