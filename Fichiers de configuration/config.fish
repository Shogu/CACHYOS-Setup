
source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end


############################################################################################################################
# Alias logiciels
alias vim='micro'
alias vi='micro'
alias gedit='gnome-text-editor'
alias nano='micro'
alias notepad='gnome-text-editor'
alias rm='rm -I'
alias df='duf'



############################################################################################################################
# gnome-text-editor comme éditeur par defaut sudoedit
export SUDO_EDITOR="gnome-text-editor"
export EDITOR="gnome-text-editor"
export VISUAL="gnome-text-editor"


############################################################################################################################
# Désactive le message d'accueil de Fish.
function fish_greeting
end


############################################################################################################################
# Contrôleur live de scx_scheduler - commande scx
function scx --description 'Live monitor scx + disk scheduler'
    while true
        clear
        printf "\e[93m=== SCXCTL ===\e[0m\n"; scxctl get; echo
        printf "\e[92m=== DISK ===\e[0m\n"; cat /sys/block/nvme0n1/queue/scheduler; echo
        sleep 3
    end
end


############################################################################################################################
# 20 dernières erreurs journalctl - commande journal
function journal
    journalctl -p err -n 20 --no-pager | bat -l log  
end


############################################################################################################################
# Arguments kernel - commande flags
function flags
    clear
    echo "KERNEL FLAGS (/proc/cmdline)"
    echo "============================="

    # Ligne brute colorée (jaune)
    echo "Ligne complète :"
    printf "\\e[93m%s\\e[0m\\n\\n" (cat /proc/cmdline)

    echo "Flags par ligne (triés, uniques) :"
    
    set -l all_flags (string split " " (cat /proc/cmdline))
    set -l flags
    for flag in $all_flags
        if not contains $flag $flags
            set flags $flags $flag
        end
    end

    set -l sorted_flags (printf "%s\\n" $flags | sort)
    set i 1
    for flag in $sorted_flags
        printf "\\e[92m%2d.\\e[0m \\e[96m%s\\e[0m\\n" $i $flag
        set i (math $i + 1)
    end

    echo ""
end


############################################################################################################################
# FSTAB - commande fstab
function fstab
    clear
    echo "📁 /etc/fstab"
    echo ""
    sudo bat --language=fstab --paging=never --style=plain /etc/fstab
    echo ""
end


############################################################################################################################
# MKINITCPIO - commande mkinitcpio
function mkinitcpio
    clear
    echo "🔧 /etc/mkinitcpio.conf"
    echo ""
    sudo bat --language=ini --paging=never --style=plain /etc/mkinitcpio.conf
    echo ""
end


############################################################################################################################
# cleanup orphelins, cache paru, cache Vivaldi, caches Arch
function clean
    set orphans (pacman -Qtdq)
    if test (count $orphans) -gt 0
        echo "Suppression des orphelins : $orphans"
        sudo pacman -Rns $orphans
    else
        echo "Aucun paquet orphelin."
    end

    paru -Scc
    profile-cleaner v
    archclean full
end


############################################################################################################################
# afficher l'état power de tuned-ppd
function power
    set -l epp (cat /sys/devices/system/cpu/cpu*/cpufreq/energy_performance_preference | sort | uniq -c | sort -nr)
    echo "EPP (tuned-ppd) : $epp"
end


############################################################################################################################
# Fonction fwupdmgr full : unmask → start → refresh → updates → stop + mask
function fwupdate --description "Mettre à jour firmware (fwupdmgr full)"
    echo
    set_color yellow
    echo "📦 fwupdmgr : mise à jour firmware complète"
    set_color normal

    echo
    set_color green
    echo "1. Unmask du service fwupd…"
    set_color normal
    sudo systemctl unmask fwupd.service

    echo
    set_color green
    echo "2. Démarrage du service fwupd…"
    set_color normal
    sudo systemctl start fwupd.service

    echo
    set_color green
    echo "3. Rafraîchissement metadata (fwupdmgr refresh)…"
    set_color normal
    sudo fwupdmgr refresh --force

    echo
    set_color green
    echo "4. Vérifier les mises à jour disponibles (fwupdmgr get-updates)…"
    set_color normal
    sudo fwupdmgr get-updates

    echo
    set_color green
    echo "5. Installer les mises à jour (fwupdmgr update)…"
    set_color normal
    sudo fwupdmgr update

    echo
    set_color green
    echo "6. Arrêter le service fwupd…"
    set_color normal
    sudo systemctl stop fwupd.service

    echo
    set_color green
    echo "7. Masker le service fwupd…"
    set_color normal
    sudo systemctl mask fwupd.service

    echo
    set_color cyan
    echo "📦 Mise à jour firmware terminée."
    set_color normal
end

############################################################################################################################
# Fonction vault - commandes utiles et functions
function vault --description "Vault de commandes utiles"
    set -l vault_labels \
        "MAJ initramfs (limine-mkinitcpio)" \
        "Boot time (systemd-analyze)" \
        "Boot analyze (systemd-analyze blame)" \
        "Scheduler scx (scx)" \
        "Nettoyage système (clean)" \
        "Erreurs journalctl" \
        "Flags kernel" \
        "fstab" \
        "mkinitcpio.conf" \
        "Afficher EPP / power" \
        "fwupd" \
        "control" \


    set -l vault_cmds \
        "sudo limine-mkinitcpio" \
        "systemd-analyze" \
        "systemd-analyze blame" \
        "scx" \
        "clean" \
        "journal" \
        "flags" \
        "fstab" \
        "mkinitcpio" \
        "power" \
        "fwupdate" \
        "control" \

    set -l count (count $vault_labels)

    echo
    set_color cyan
    echo "================= VAULT COMMANDES ================="
    set_color normal
    echo

    for i in (seq $count)
        printf "%2d) %s\n" $i $vault_labels[$i]
    end

    echo
    set_color yellow
    echo "Choisis un numéro entre 1 et $count (q pour quitter)"
    set_color normal

    while true
        read -P "> " choice

        if test -z "$choice"
            continue
        end

        if test "$choice" = "q"
            echo "Abandon."
            set_color normal
            return 0
        end

        if string match -rq '^[0-9]+$' -- $choice
            if test $choice -ge 1 -a $choice -le $count
                set -l cmd $vault_cmds[$choice]
                echo
                set_color green
                echo "→ Exécution : $cmd"
                set_color normal
                echo
                eval $cmd
                set_color normal
                return $status
            end
        end

        set_color red
        echo "Entrée invalide. Numéro entre 1 et $count, ou q pour quitter."
        set_color normal
    end
end
