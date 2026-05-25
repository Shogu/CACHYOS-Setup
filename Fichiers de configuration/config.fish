
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
alias stockage='duf'
alias sourcefish='source ~/.config/fish/config.fish'
alias fishedit='xdg-open /home/ogu/.config/fish/config.fish'
alias systemd='isd'
alias lastpackages='rip'
alias liminestats='limine-snapper-info'
alias scrub='sudo btrfs scrub start -B /'




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
# Contrôleur live de _scheduler - commande scx
function scx --description 'scxctl get + check scheduler + monitor sans WARN'
    set -l output (scxctl get 2>/dev/null)

    if test -z "$output"
        set_color red
        echo "KO  scxctl ne retourne rien."
        set_color --reset
        return 1
    end

    echo $output
    echo

    set -l sched_name (string match -rg 'running\s+([[:alnum:]_-]+)' -- $output)

    if test -z "$sched_name"
        set_color red
        echo "KO  Aucun scheduler sched-ext actif."
        set_color --reset
        return 1
    end

    set sched_name (string lower -- $sched_name)
    set -l bin "scx_$sched_name"

    set -l disk nvme0n1
    if test -r /sys/block/$disk/queue/scheduler
        set -l current_io (awk -F'[][]' '{print $2}' /sys/block/$disk/queue/scheduler)

        set_color cyan
        echo "Disk       : $disk"
        set_color --reset
        echo "Scheduler  : $current_io"
    else
        set_color yellow
        echo "WARN Impossible de lire /sys/block/$disk/queue/scheduler"
        set_color --reset
    end

    echo
    set_color brmagenta
    echo "Monitor : sudo $bin --monitor 3"
    set_color --reset

    command sudo $bin --monitor 3 2>/dev/null
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
    set -l cpu0 /sys/devices/system/cpu/cpu0/cpufreq

    set -l epp_raw "n/a"
    set -l epp_label "n/a"
    if test -r $cpu0/energy_performance_preference
        set epp_raw (cat $cpu0/energy_performance_preference 2>/dev/null)
        switch $epp_raw
            case balance_power balance_performance
                set epp_label "balanced"
            case performance
                set epp_label "performance"
            case power
                set epp_label "power"
            case default
                set epp_label $epp_raw
        end
    end

    set -l pprof "n/a"
    if command -q powerprofilesctl
        set pprof (powerprofilesctl get 2>/dev/null)
        if test -z "$pprof"
            set pprof "n/a"
        end
    end

    set -l tuned_ppd "no"
    if command -q systemctl
        if systemctl --user is-active tuned-ppd.service >/dev/null 2>&1; or systemctl is-active tuned-ppd.service >/dev/null 2>&1
            set tuned_ppd "yes"
        end
    end

    set -l scx "n/a"
    if command -q scxctl
        set scx (scxctl get 2>/dev/null)
        if test -z "$scx"
            set scx "n/a"
        end
    end

    set -l batdev (for d in /sys/class/power_supply/*; test -e "$d/type"; and string match -qr '^Battery$' (cat $d/type 2>/dev/null); and basename $d; end | head -n 1)
    set -l bat "none"
    if test -n "$batdev"
        set -l base /sys/class/power_supply/$batdev
        set -l bat_status (cat $base/status 2>/dev/null)
        set -l capacity (cat $base/capacity 2>/dev/null)
        set -l full (cat $base/energy_full 2>/dev/null)
        set -l now (cat $base/energy_now 2>/dev/null)
        set -l power_now (cat $base/power_now 2>/dev/null)

        set bat "$batdev: $bat_status, $capacity%"
        if test -n "$full" -a -n "$now" -a "$full" -gt 0
            set -l pct (math "round($now * 100 / $full)")
            set bat "$bat, $pct% (energy)"
        end
        if test -n "$power_now" -a "$power_now" -gt 0
            set -l w (math "round($power_now / 1000000 * 100) / 100")
            set bat "$bat, $w W"
        end
    end

    echo "EPP: $epp_label ($epp_raw) | PPD: $pprof | tuned-ppd: $tuned_ppd"
    echo "SCX: $scx"
    echo "BAT: $bat"
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

function pacmanstats
    # Afficher le nombre de paquets installés
    echo "Nombre de paquets installés :"
    pacman -Q | wc -l
    
    # Afficher la taille totale des paquets installés
    echo "Taille totale des paquets installés :"
    expac -H M '%m' | awk '{sum += $1} END {printf "%.2f GiB\n", sum/1024}'
end


############################################################################################################################

function vault --description "Vault de commandes utiles"
    set -l vault_labels \
        "MAJ initramfs (limine-mkinitcpio)" \
        "Boot time (systemd-analyze)" \
        "Boot analyze (sytemd-analyze blame)" \
        "Scheduler scx (scx)" \
        "Nettoyage système (clean)" \
        "Erreurs journalctl" \
        "Flags kernel" \
        "fstab" \
        "mkinitcpio.conf" \
        "Afficher EPP / power" \
        "fwupd" \
        "control" \
        "pacmanstats" \
        "liminestats" \
        "stockage (duf)" \
        "sourcefish (reload config)" \
        "fishedit (edit config)" \
        "systemd (isd)" \
        "lastpackages (rip)"
        "scrub"

    set -l vault_cmds \
        "sudo limine-mkinitcpio" \
        "systemd-analyze" \
        "systemd-analyze blame" \
        "scx" \
        "clean" \
        "journal" \
        "flags" \
        "sudo bat --language=fstab --paging=never --style=plain /etc/fstab" \
        "sudo bat --language=ini --paging=never --style=plain /etc/mkinitcpio.conf" \
        "power" \
        "fwupdate" \
        "control" \
        "pacmanstats" \
        "liminestats" \
        "stockage" \
        "sourcefish" \
        "fishedit" \
        "systemd" \
        "lastpackages"
        "scrub"

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
