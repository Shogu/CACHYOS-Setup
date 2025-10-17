# CACHYOS-Setup
Setup, tips & tweaks pour CachyOS sur ZENBOOK 14 OLED KA

<table>
  <tr>
    <td style="vertical-align: middle;">
      <img src="https://github.com/Shogu/Fedora41-setup-config/blob/main/Images%20USER/.user-astronaut.png" alt="logo_user" width="150">
    </td>
    <td style="vertical-align: middle; padding-left: 10px;">
      <h2 style="margin: 0;">CachyOS Setup</h2>
    </td>
  </tr>
</table>

🐧 Mémo pour le setup complet de **CachyOS** sur laptop **ASUS ZENBOOK 14 OLED UM3406KA**

---

# Table des matières

### 💾 A - Installation
- [1 - Désactiver Secure Boot dans le BIOS](#id-1)
- [2 - Désactiver caméra et lecteur de carte](#id-2)
- [3 - Utiliser systemd-boot et EXT4](#id-3)
- [4 - Supprimer entrées NVRAM inutiles](#id-4)
- [5 - Faire un ghost du système](#id-5)

### ✨ B - Allégement du système
- [6 - Réglages CachyOS-Hello](#id-6)
- [7 - Supprimer logiciels inutiles avec pacman](#id-7)
- [8 - JamesDSP](#id-8)
- [9 - Supprimer et masquer services SYSTEM & USER](#id-9)
- [10 - Désactiver autostart gnome-wellbeing](#id-10)
- [11 - Alléger journaux système et mettre en RAM](#id-11)
- [12 - Supprimer coredump](#id-12)
- [13 - Blacklister pilotes inutiles](#id-13)
- [14 - Réduire l'initramfs et le firmware](#id-14)
- [15 - Désactiver capteur de luminosité Gnome](#id-15)

### 🚀 C - Optimisation du système
- [16 - Activer scheduler ADIOS](#id-16)
- [17 - Passer xwayland en autoclose et activer scale-monitor](#id-17)
- [18 - Réduire le temps d'affichage du menu systemd-boot](#id-18)
- [19 - Editer mount des partitions EXT4](#id-19)
- [20 - Activer fast_commit pour EXT4](#id-20)
- [21 - Désactiver mitigate split lock](#id-21)
- [22 - Activer le mode EPP `power_performance` pour le profil Gnome `Balanced` quand le PC est sur batterie](#id-22) 
- [23 - Régler le pare-feu](#id-23)
- [24 - Passer à 0 le nombre de ttys au boot](#id-24)
- [25 - Optimiser le kernel](#id-25) avec des arguments et le sched-ext Rusty
- [26 - Régler wifi](#id-26)

### 📦 D - Remplacement et installation de logiciels et codecs
- [27 - Installer logiciels avec pacman et yay](#id-27)
- [28 - Installer Dropbox avec Maestral](#id-28)

### 🐾 E - Réglages de l'UI Gnome Shell
- [29 - Suspension en fermant le capot](#id-29)
- [30 - Régler Nautilus et marque-pages](#id-30)
- [31 - Modifier mot de passe au démarrage](#id-31)
- [32 - Installer wallpaper et thème curseurs](#id-32)
- [33 - Régler HiDPI et cacher dossiers](#id-33)
- [34 - Renommer logiciels dans overview](#id-34)
- [35 - Installer extensions Gnome](#id-35)
- [36 - Installer Open with Ptyxis](#id-36)
- [37 - Activer numpad Asus](#id-37)
- [38 - Configurer fish et gnome-text-editor](#id-38)
- [39 - Changer icône Pamac](#id-39)
- [40 - Configurer Celluloid](#id-40)
- [41 - Configurer JDownloader & Fragments](#id-41)
- [42 - Script transfert vidéos](#id-42)
- [43 - Accélérer animations](#id-43)
- [44 - Scripts Nautilus Hide/Unhide](#id-44)
- [45 - Supprimer Plymouth](#id-45)
- [46 - Modifier nom toggle profil énergétique](#id-46)
- [47 - Créer raccourcis boot to BIOS, gradia-screenshot, Ressources & Ptyxis](#id-47)
- [48 - Faire le tri dans les LOCALES & ~/.local/share, ~/.config et /etc](#id-48)

### 🌐 F - Réglages du navigateur Firefox
- [49 - Réglages internes Firefox](#id-49)
- [50 - Changer thème Firefox](#id-50)
- [51 - Réglages about:config](#id-51)
- [52 - Extensions Firefox](#id-52)
- [53 - Activer "Rechercher avec Perplexity"](#id-53)
- [54 - Alléger le clic droit avec userChrome](#id-54)
- [55 - Mettre profil Firefox en RAM avec psd](#id-55)

---

# 💾 A - Installation

<a id="id-1"></a>
## 1 - Désactiver Secure Boot dans le BIOS
Même si cachyOS est en mesure de signer les noyaux.


<a id="id-2"></a>
## 2 - Désactiver caméra et lecteur de carte
Et penser à fermer le volet coulissant de la webcam


<a id="id-3"></a>
## 3 - Utiliser systemd-boot
puis décocher les paquets inutiles (Attention : la plupart s'installeront quand même), et EXT4
A envisager si trop de bugs lors des maj ou des rebbots : BTRFS+Limine+snapshots


<a id="id-4"></a>
## 4 - Supprimer entrées NVRAM inutiles
```
sudo efibootmgr -v

```
Puis lister les entrées inutiles et redondnates et les supprimer avec :
```
sudo efibootmgr -b 0000 -B
sudo efibootmgr -b 0001 -B
sudo efibootmgr -b 0002 -B
etc
```

<a id="id-5"></a>
## 5 - Faire un ghost du système avec Rescuezilla
Puis en refaire un une fois les étapes du Github terminées



----------------------------------------------------------------------------------------------

# ✨ B - Allégement du système

<a id="id-6"></a>
## 6 - Réglages CachyOS-Hello
Faire les réglages proposés par `CachyOS-Hello` : désactiver le bluetooth, activer cachy-update tray et bpftune, classer les miroirs, NE PAS installer psd (il faut l'installer en --user) ni ananicy-cpp (le boot du service échoue - lui préférer ADIOS pour AMD).


<a id="id-7"></a>
## 7 - Supprimer logiciels inutiles avec pacman
```
sudo pacman -Rns apache  speech-dispatcher gnome-remote-desktop gnome-backgrounds gnome-user-share yelp brltty  gnome-weather rygel totem  gnome-user-docs  baobab  f2fs-tools mod_dnssd gnome-user-share orca gnome-user-docs yelp sane colord-sane gvfs-dnssd gvfs-smb mod_dnssd  gnome-user-share rygel nss-mdns gnome-backgrounds gnome-usage octopi gedit xfsprogs btrfs-progs cpupower gnome-screenshot openvpn networkmanager-openvpn networkmanager-vpn-plugin-openvpn fwupd
```
Penser à supprimer l'extension `Pamac Updater` dans usr/share/gnome-shell/extensions et à supprimer les logiciels inutiles de Gnome avec Pamac.


<a id="id-8"></a>
## 8 - JamesDSP

!! A mettre dans la rubrique Optimisation !!
Installer Jamesdsp avec yay ou pamac, modifier son nom en Audio et passer StartupWMClass=jamesdsp, le régler conformément à ce [tuto](https://discuss.cachyos.org/t/tutorial-make-linux-sound-better-easier-with-jamesdsp/16098/5), avec le *.conf ClearPenguin disponible dans le Github.

Suppriemr l'icone du menu et créer un Custom Command Toggle (voir fichier *.ini)


<a id="id-9"></a>
## 9 - Supprimer et masquer services SYSTEM & USER
**SYSTEM**
```
sudo systemctl mask plymouth-quit-wait.service
sudo systemctl mask avahi-daemon.service
sudo systemctl mask sys-kernel-debug.mount
sudo systemctl mask sys-kernel-tracing.mount
sudo systemctl mask avahi-daemon.socket
sudo systemctl mask NetworkManager-wait-online.service
sudo systemctl mask dev-tpmrm0.device
sudo systemctl mask tpm2.target
sudo systemctl mask lvm2-lvmpolld.service lvm2-monitor.service lvm2-lvmpolld.socket
sudo systemctl mask  pamac-cleancache.service
sudo systemctl mask  pamac-cleancache.timer
sudo systemctl mask bluetooth.service
sudo systemctl mask colord.service
sudo systemctl mask systemd-vconsole-setup.service
sudo systemctl mask systemd-tpm2-clear.service
sudo systemctl mask systemd-tpm2-setup-early.service
sudo systemctl mask systemd-tpm2-setup.service
sudo systemctl mask systemd-pcrmachine.service
sudo systemctl mask systemd-pcrphase-initrd.service
sudo systemctl mask systemd-pcrphase-sysinit.service
sudo systemctl mask systemd-pcrphase.service
```
```
Vérifier si `ananicy-cpp` est lancé par défaut : si oui :
sudo systemctl mask ananicy-cpp
```
Enfin, reboot puis controle de l'état des services avec :
```
systemd-analyze blame | grep -v '\.device$'
```
et :
```
systemctl list-unit-files --type=service --state=enabled
```

**USER**
```
systemctl --user mask evolution-addressbook-factory.service
systemctl --user mask org.gnome.SettingsDaemon.Sharing.service
systemctl --user mask org.gnome.SettingsDaemon.UsbProtection.service
systemctl --user mask org.gnome.SettingsDaemon.Wacom.service
systemctl --user mask org.gnome.SettingsDaemon.Keyboard.service
systemctl --user mask org.gnome.SettingsDaemon.PrintNotifications.service
systemctl --user mask org.gnome.SettingsDaemon.A11ySettings.service
systemctl --user mask org.gnome.SettingsDaemon.Smartcard.service
systemctl --user mask org.gnome.SettingsDaemon.Datetime.service
systemctl --user mask arch-update.service
systemctl --user mask arch-update.timer
systemctl --user mask org.gnome.SettingsDaemon.Color.service
systemctl --user disable arch-update-tray.service

```
Puis contrôler avec :
```
systemd-analyze --user blame
```


<a id="id-10"></a>
## 10 - Désactiver autostart gnome-wellbeing
```
cp /usr/share/applications/gnome-wellbeing-panel.desktop ~/.config/autostart/ && sudo gnome-text-editor ~/.config/autostart/gnome-wellbeing-panel.desktop 

```
Saisir `Hidden=true` puis contrôler avec `grep Hidden ~/.config/autostart/gnome-wellbeing-panel.desktop`


<a id="id-11"></a>
## 11 - Alléger journaux système et les mettre en RAM
```
sudo gnome-text-editor /etc/systemd/journald.conf
```
puis remplacer le contenu du fichier par celui du fichier `journald.conf.txt` & relancer le service :
```
sudo systemctl restart systemd-journald
```


<a id="id-12"></a>
## 12 - Supprimer les coredump
``` 
sudo systemctl disable --now systemd-coredump.socket
sudo systemctl mask systemd-coredump
sudo systemctl mask systemd-coredump.socket
```
puis empêcher qu'ulimit ne fasse des dumps : 
```
echo '* hard core 0' | sudo tee -a /etc/security/limits.conf
```


<a id="id-13"></a>
## 13 - Blacklister pilotes inutiles
créer un fichier `blacklist` ```sudo gnome-text-editor /etc/modprobe.d/blacklist.conf``` et l'éditer :
```
# ==============================
# Intel et watchdog
# ==============================
blacklist iTCO_vendor_support
blacklist iTCO_wdt
blacklist wdat_wdt
blacklist intel_pmc_bxtvidia

# ==============================
# Nvidia
# ==============================
blacklist nouveau 

# ==============================
# Drivers inutiles
# ==============================
blacklist btusb
blacklist joydev

# ==============================
# Netbios
# ==============================
blacklist nf_conntrack_netbios_ns
blacklist nf_conntrack_broadcast

# ==============================
# Audio inutilisé
# ==============================
blacklist snd_seq_dummy
blacklist snd_sof_amd_acp70
blacklist snd_sof_amd_acp63
blacklist snd_sof_amd_vangogh
blacklist snd_sof_amd_rembrandt
blacklist snd_sof_amd_renoir

# ==============================
# PS/2 et périphériques anciens
# ==============================
blacklist pcspkr          # bip interne
blacklist mousedev        # souris PS/2

# ==============================
# Crypto inutile si pas de chiffrement (LUKS, WireGuard, etc.)
# ==============================
blacklist aesni_intel
blacklist polyval_clmulni
blacklist ghash_clmulni_intel
blacklist sha1_ssse3
blacklist sha512_ssse3

# ==============================
# capteurs
# ==============================
blacklist hid_sensor_als
blacklist industrialio
blacklist industrialio_triggered_buffer

# ==============================
# tty
# ==============================
blacklist serial8250
blacklist 8250_pci

# ==============================
# TPM
# ==============================
blacklist tpm
blacklist tpm_tis
blacklist tpm_crb
blacklist tpm_tis_core
blacklist tpm_vtpm_proxy

# ==============================
# IA NPU AMD
# ==============================
blacklist amdxdna
```
Puis lancer `sudo mkinitcpio -P`
Au reboot, vérifier avec la commande `lsmod | grep serial8250`


<a id="id-14"></a>
## 14 - Réduire l'initramfs & le firmware
En désactivant des modules inutiles : attention prévoir un backup du fichier pour le restaurer en live cd si besoin!
```
sudo gnome-text-editor /etc/mkinitcpio.conf

```
et copier-coller ces options de configuration dans les rubriques correspondantes :
```
MODULES=(ext4 vfat)
HOOKS=(base udev autodetect microcode kms modconf block plymouth fsck)
COMPRESSION="lz4"
COMPRESSION_OPTIONS=()
```
Recharger l'initrd avec `sudo mkinitcpio -P`

Firmware : utiliser seulement les paquets vendor
```
# installer uniquement les firmwares nécessaires
sudo pacman -S linux-firmware-amdgpu linux-firmware-mediatek linux-firmware-cirrus

# Supprimer le méta-paquet général et les firmwares inutiles
sudo pacman -R linux-firmware linux-firmware-intel linux-firmware-atheros linux-firmware-nvidia linux-firmware-broadcom linux-firmware-realtek linux-firmware-radeon linux-firmware-other

# Marquer les firmwares utiles comme explicitement installés pour éviter qu'ils soient considérés comme orphelins
sudo pacman -D --asexplicit linux-firmware-amdgpu linux-firmware-cirrus linux-firmware-mediatek
```

<a id="id-15"></a>
## 15 - Désactiver capteur de luminosité Gnome

```
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false
```
Puis modifier à 600 la durée avant mise en veille.

----------------------------------------------------------------------------------------------

# 🚀 C - Optimisation du système

<a id="id-16"></a>
## 16 - Activer scheduler ADIOS
Activer le scheduler ADIOS sur AMD CPU :
```
sudo nano /etc/udev/rules.d/60-ioschedulers.rules
```
Puis saisir :
```
# HDD
ACTION=="add|change", KERNEL=="sd[a-z]*", ATTR{queue/rotational}=="1", \
    ATTR{queue/scheduler}="bfq"

# SSD
ACTION=="add|change", KERNEL=="sd[a-z]*|mmcblk[0-9]*", ATTR{queue/rotational}=="0", \
    ATTR{queue/scheduler}="adios"

# NVMe SSD
ACTION=="add|change", KERNEL=="nvme[0-9]*", ATTR{queue/rotational}=="0", \
    ATTR{queue/scheduler}="adios"
```
Relancer udev : 
```
sudo udevadm control --reload-rules
sudo udevadm trigger
```
Vérifier avec `cat /sys/block/nvme0n1/queue/scheduler`


<a id="id-17"></a>
## 17 - Passer xwayland en autoclose et activer scale-monitor
Sur dconf-editor, modifier la clé suivante.
```
org.gnome.mutter experimental-features
```

En profiter pour activer `scale-monitor-framebuffer` & `xwayland-native-scaling`


<a id="id-18"></a>
## 18 - Réduire le temps d'affichage du menu systemd-boot
Réduire le `temps d'affichage du menu systemd-boot` à 0 seconde  (appuyer sur MAJ pour le faire apparaitre au boot):
```
sudo nano /boot/loader/loader.conf
```
Reboot, puis vérifier que le fichier loader.conf soit à 0 :
```
sudo cat /boot/loader/loader.conf
timeout 1
#console-mode keep
```


<a id="id-19"></a>
## 19 - Editer mount des partitions EXT4
Editer le mount des `partitions EXT4` avec la commande :
`sudo gnome-text-editor /etc/fstab` et rajouter après 'noatime' : 
```
data=writeback,commit=60,barrier=0 0 0
```
| Option                   | Rôle                                                                 | Avantage                                       | Inconvénient / Risque                                      |
|---------------------------|----------------------------------------------------------------------|------------------------------------------------|--------------------------------------------------------                |
| `noatime`                | Désactive la mise à jour de la date         |
| `data=writeback`         | Journalise seulement les **métadonnées**, pas le contenu des fichiers. | Écritures plus rapides, moins de charge disque. 
| `commit=60`              | Force l’écriture du journal toutes les 60 secondes.                  | Moins d’écritures → plus de perf + moins d’usure SSD.          |
| `barrier=0`              | Désactive les barrières d’écriture (cache flush).                    | Réduit la latence et accélère les commits.   
| `0 0`                    | Désactive `dump` et `fsck` automatiques au boot.                                     | Pas de vérification 


Pour la partiton `vfat` : 
```
defaults,noatime,umask=0077 0 0
```


<a id="id-20"></a>
## 20 - Activer fast_commit pour EXT4

Démarrer sur un live-cd Fedora, puis identifier la partition root (en général dev/nvme0n1p2) et s'assurer qu'elle est bien en EXT4 :
```
lsblk -f
sudo file -s /dev/nvme0n1p2
```
Passer *fast_commit* avec tune2fs
```
sudo tune2fs -O fast_commit /dev/nvme0n1p2
```
Puis vérifier/réparer le Fs : ATTENTION ETAPE INDISPENSABLE!
```
sudo e2fsck -f /dev/nvme0n1p2
```
Sortir du live Fedora & contrôler la présence de fast_commit avec :
```
sudo tune2fs -l /dev/nvme0n1p2 | grep 'Filesystem features'
```


<a id="id-21"></a>
## 21 - Désactiver mitigate split lock
MAJ : utiliser plutot le parametre kernel `split_lock_detect=off`

Ou bien éditer `sudo nano /etc/sysctl.d/99-splitlock.conf` et saisir :
  
```
kernel.split_lock_mitigate=0
```
Puis recharger avec `sudo sysctl --system`

<a id="id-22"></a>
## 22 - Activer le mode EPP `power_performance` pour le profil Gnome `Balanced` quand le PC est sur batterie
Vérifier le profil EPP correspondant au profil Balanced/Batterie 
```
powerprofilesctl query-battery-aware 
```
Le passer en *disable* :
```
powerprofilesctl configure-battery-aware --disable
```
Contrôler le nouveau profil après avoir sélectionné Balanced dans le panel Gnome :
```
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
cat /sys/devices/system/cpu/cpufreq/policy*/energy_performance_preference
```
Pour le rendre permanent au boot :
```
nano ~/.config/autostart/disable-battery-aware.desktop
```

Et copier-coller le contenu suivant :
```
[Desktop Entry]
Type=Application
Name=Disable Battery Aware
Exec=powerprofilesctl configure-battery-aware --disable
X-GNOME-Autostart-enabled=true
```
Créer un Custom Command Toggle pour activer/désactiver ce booster (le fichier *.ini à télécharger contient toute la configuration)

<a id="id-23"></a>
## 23 - Régler le pare-feu ufw
```
sudo ufw --force reset
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw logging off

# Autoriser WebDAV (HTTP/HTTPS)
sudo ufw allow in 80/tcp
sudo ufw allow in 443/tcp

# Autoriser FTP (standard + passif 50000-51000)
sudo ufw allow in 21/tcp
sudo ufw allow in 50000:51000/tcp

# Autoriser torrents (TCP/UDP 6881-6999)
sudo ufw allow out 6881:6999/tcp
sudo ufw allow out 6881:6999/udp

# Autoriser Nicotine+ (TCP/UDP 2234-2235)
sudo ufw allow out 2234:2235/tcp
sudo ufw allow out 2234:2235/udp

!! Passer `wlan0` dans les paramètres de Nicotine accélère considérablement la connexion.

# Autoriser JDownloader HTTP/HTTPS
sudo ufw allow out 80/tcp
sudo ufw allow out 443/tcp

# Activer UFW
sudo ufw --force enable
sudo ufw status numbered
```


<a id="id-24"></a>
## 24 - Passer à 0 le nombre de ttys au boot
```
sudo gnome-text-editor /etc/systemd/logind.conf
```
puis saisir : `NautoVTS=1`


<a id="id-25"></a>
## 25 - Optimiser le `kernel` :
**a - Appliquer les arguments suivants :**
```
sudo gnome-text-editor /etc/sdboot-manage.conf
```
Puis saisir :
```
LINUX_OPTIONS="noreplace-smp tsc=reliable cryptomgr.notests random.trust_cpu=on efi=disable_early_pci_dma nomce nowatchdog loglevel=0 no_timer_check noresume fsck.mode=skip zswap.enabled=0 console=tty0 systemd.show_status=false quiet splash 8250.nr_uarts=0 cgroupdisable=rdma nvme_core.default_ps_max_latency_us=5500 disable_ipv6=1 amd_iommu=off split_lock_detect=off transparent_hugepage=madvise rcupdate.rcu_normal_after_boot=1 rcu_nocbs=0-(nproc-1) rcutree.enable_rcu_lazy=1"
```
Relancer systemd-boot conformément à la méthode CachyOS :
```
sudo sdboot-manage gen
```

| Thème                     | Arguments / Options                                                                 | Description                                                                                   |
|----------------------------|------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------|
| **Perf / CPU / Scheduler** | `rcu_nocbs=0-(nproc-1)`, `rcupdate.rcu_normal_after_boot=1, `noreplace-smp`, `tsc=reliable` | Optimisations RCU, scheduler et compteur TSC pour réduire latence et améliorer le boot.      |
| **Sécurité / Crypto**      | `cryptomgr.notests`, `random.trust_cpu=on`, `tpm.disable=1`                        | Désactive PUCE TPM & tests crypto au boot et fait confiance aux instructions RDRAND/RDSEED.             |
| **ACPI / Matériel / GPU**  | `efi=disable_early_pci_dma`, `nomce`, `split_lock_detect=off`                                             | Désactive DMA PCI précoce, MCE non critiques pour éviter conflits et arrêts intempestifs, et désactive le split lock   |
| **Debug / Logs / Timer**   | `nowatchdog`, `loglevel=0`, `no_timer_check`                                       | Désactive watchdog, limite logs et vérifications timer HPET pour accélérer le boot.          |
| **Swap / FS**              | `noresume`, `fsck.mode=skip`, `zswap.enabled=0`                                    | Désactive reprise hibernation, fsck et zswap pour réduire overhead CPU et boot time.         |
| **Console / Boot**         | `console=tty0`, `systemd.show_status=false`, `quiet splash`                        | Définit la console principale et masque la majorité des messages kernel/systemd.             |
| **Divers / UART**          | `8250.nr_uarts=0`                                                                  | Désactive tous les ports série 8250 si non utilisés.                                          |
| **Cgroup / RDMA**          | `cgroupdisable=rdma`                                                               | Désactive les cgroups RDMA si non utilisés.                                                  |
| **NVMe**                   | `nvme_core.default_ps_max_latency_us=5500`                                         | Limite latence NVMe pour un mode power-saving équilibré.                                      |
| **Wifi / Réseau**          | `disable_ipv6=1`                                                                   | Désactive IPv6.                                                                               |
| **Virtualisation**         | `amd_iommu=off`                                                                    | Désactive l’IOMMU AMD si pas de virtualisation/VFIO.                                         |

Penser à créer un timer (1/semaine) pour lancer fsck vu qu'il est désactivé au niveau kernel :
```
sudo tune2fs -c 0 -i 7d /dev/nvme0n1p2
```
Vérifier avec  `sudo tune2fs -l /dev/nvme0n1p2 | grep -i 'check'

**b - Sched-ext Rusty :**

Activer le scheduler `Rusty` avec sched-ext, et penser à supprimer Ananicy pour éviter les conflits :
```
sudo pacman -Rdd ananicy-cpp
```


<a id="id-26"></a>
## 26 - Régler wifi
Passer le wifi en mode FR :
```
sudo nano /etc/conf.d/wireless-regdom
```
et décommenter la ligne *WIRELESS_REGDOM="FR"*

Puis régler la connexion Wifi 5Ghz en dur : ip 192.168.31.102 // masque 255.255.255.0 // passerelle 192.168.31.1 // dns 1.1.1.1, 1.0.0.1, désactiver ipv6



----------------------------------------------------------------------------------------------

# 📦 D - Remplacement et installation de logiciels et codecs

<a id="id-27"></a>
## 27 - Installer logiciels avec pacman et yay
Installer les `logiciels` suivants :
```
sudo pacman -Syu dconf-editor evince powertop ffmpegthumbnailer profile-cleaner seahorse pamac celluloid extension-manager fragments papers yay nicotine+ resources onlyoffice fuse2 jamesdsp xournal++
```
et

```
yay -S libre-menu-editor gradia monophony jdownloader2 
```
Enfin installer [l'appimage de Beeper](https://api.beeper.com/desktop/download/linux/x64/stable/com.automattic.beeper.desktop), la déplacer dans .local/bin, éditer le raccourci avec le chemin de l'éxecutable et  `StartupWMClass=Beeper` pour faire apparaitre l'icone dans le dash.

<a id="id-28"></a>
## 28 - Installer Dropbox avec Maestral
créer le répertoire Dropbox dans /home puis lancer le script *maestral_install* 



----------------------------------------------------------------------------------------------

# 🐾 E - Réglages de l'UI Gnome Shell

<a id="id-29"></a>
## 29 - Suspension en fermant le capot
Editer le service logind :
```
gnome-text-editor admin:///etc/systemd/logind.conf
```
puis remplacer les lignes HandleLid par 
```
HandleLidSwitch=suspend
HandleLidSwitchExternalPower=suspend
```


<a id="id-30"></a>
## 30 - Régler Nautilus et marque-pages
Régler Nautilus & créer un marque-page pour `Dropbox`, pour l'accès `ftp` au disque SSD sur la TV Android, et pour lancer Nautilus en root depuis le panneau latéral :
```
192.168.31.68:2121
```
Remplacer les icones folder pour Dropbox, MP3, Root, Domestique & Lycée dans Dropbox, Extensions Gnome etc à partir des icones Places à télécharger dans `icons & backgrounds"


<a id="id-31"></a>
## 31 - Modifier mot de passe au démarrage
avec le logiciel `Seahorse`, puis laisser les champs vides. Penser à reconnecter le compte Google dans Gnome.


<a id="id-32"></a>
## 32 - Installer wallpaper et thème curseurs
Installer le [wallpaper F34](https://fedoraproject.org/w/uploads/d/de/F34_default_wallpaper_night.jpg) OU cosmos_dark_blue, et le thème de curseurs [Phinger NO LEFT Light](https://github.com/phisch/phinger-cursors/releases) : créer le répertoire de destination avec `mkdir -p ~/.local/share/icons/`, y déplacer le dossier *phingers-cursor-light*  puis utiliser `dconf-editor` pour les passer en taille 32 :
```
org/gnome/desktop/interface/cursor-size
```
Continuer avec GDM Settings (pour mettre le wallpaper dans GDM, entre autres) : importer le fichier de configuration `gdm-settings.ini`
```
yay -S gdm-settings
```
Puis supprimer le paquet.

<a id="id-33"></a>
## 33 - Régler HiDPI et cacher dossiers
Régler `HiDPI` sur 125, cacher les dossiers Modèles, Bureau, ainsi que le wallpaper et l'image user, augmenter la taille des icones dossiers, mettre un dossier avec icone pour Dropbox.
  

<a id="id-34"></a>
## 34 - Renommer logiciels dans overview
Renommer les `logiciels dans l'overview`, cacher ceux qui sont inutiles de façon à n'avoir qu'une seule et unique page, en utilisant le logiciel `Menu Principal`.
En profiter pour changer avec Menu Principal l'icone de `Ptyxis`, en la remplaçant par celle de [gnome-terminal](https://upload.wikimedia.org/wikipedia/commons/d/da/GNOME_Terminal_icon_2019.svg)


<a id="id-35"></a>
## 35 - Extensions Gnome

!! En cas de màj de Gnome-Shell, passer `gsettings set org.gnome.shell disable-extension-version-validation "true"` plutôt que d'éditer un à un les metadata.json des extensions non à jour.

**Extensions esthétiques :**

a - [Panel Corners](https://extensions.gnome.org/extension/4805/panel-corners/)

b - [Just Perfection](https://extensions.gnome.org/extension/3843/just-perfection/) qui permet de réunir en une extension Grand Theft Focus, Hide Worldclocks, Hide Activities Button, Hide Screenshot, Impatience etc...

c - [Lilypad Topbar Organizer](https://extensions.gnome.org/extension/7266/lilypad/)


**Extensions apportant des fonctions de productivité :**

d - [Appindicator](https://extensions.gnome.org/extension/615/appindicator-support/)

d - [Caffeine](https://extensions.gnome.org/extension/517/caffeine/) ATTENTIon à n'activer que si le suspend est réparé

f - [Clipboard History](https://extensions.gnome.org/extension/4839/clipboard-history/)

**Extensions apportant des fonctions UI :**

g - [Battery Time Percentage Compact](https://extensions.gnome.org/extension/2929/battery-time-percentage-compact/) ou [Battery Time](https://extensions.gnome.org/extension/5425/battery-time/)  

h - [AutoActivities](https://extensions.gnome.org/extension/5500/auto-activities/)

i - [Screen Brightness Governor](https://extensions.gnome.org/extension/8277/screen-brightness-governor/) & supprimer la luminosité automatique dans Settings de Gnome. !! NE FONCTIONNE PLUS AVEC GNOME 49

j - [Hot Edge](https://extensions.gnome.org/extension/4222/hot-edge/)

k - [Custom Command Toggle](https://extensions.gnome.org/extension/7012/custom-command-toggle/)  

l - Pop Shell Tiling : `sudo pacman -S gnome-shell-extension-pop-shell-git`
puis supprimer le theme icone Pop : `sudo pacman -Rdd  pop-icon-theme-git` & `/usr/share/icons`

m - [Quick Close Overview](https://extensions.gnome.org/extension/352/middle-click-to-close-in-overview/)

n - [Auto Power Profile](https://extensions.gnome.org/extension/6583/auto-power-profile/)

o - [Battery Monitor](https://extensions.gnome.org/extension/8348/battery-monitor/)

p - [https://extensions.gnome.org/extension/4491/privacy-settings-menu/](Privacy Settings) puis la supprimer une fois les réglages faits.

<a id="id-36"></a>
## 36 - Installer Open with Ptyxis
```
yay -S nautilus-open-any-terminal ou yay -S nautilus-open-in-ptyxis
```
et penser à éditer sa clé dconf com.github.stunkymonkey.nautilus-open-any-terminal pour inscrire "ptyxis" + mettre "new tab" sur true pour que Ptyxis s'ouvre dans la session en cours. En cas d'erreur avec Gnome 49, se référer à [ce fil](https://github.com/Stunkymonkey/nautilus-open-any-terminal/issues/242).


<a id="id-37"></a>
## 37 - Activer numpad Asus
Activer le [numpad Asus](https://github.com/asus-linux-drivers/asus-numberpad-driver), disable le service --user, puis créer un toggle button et importer le fichier de configuration hosté dans le répertoire github Fichiers de configuration.
Sinon, lui passer l'icone `accessories-calculator-symbolic` et les commandes suivantes :
```
systemctl enable --user asus_numberpad_driver@ogu.service && systemctl start --user asus_numberpad_driver@ogu.service &&  notify-send "Numpad activé"
systemctl stop --user asus_numberpad_driver@ogu.service && systemctl disable --user asus_numberpad_driver@ogu.service &&  notify-send "Numpad désactivé"
```
Note : si le script d'installationé choue, réparer comme suit :
```
# 1️⃣ Installer la dépendance manquante pour envsubst
sudo pacman -S gettext

# 2️⃣ Supprimer les services masqués résiduels
rm -f ~/.config/systemd/user/asus_numberpad_driver@*.service
rm -f /etc/systemd/user/asus_numberpad_driver@*.service
sudo rm -f /usr/lib/systemd/user/asus_numberpad_driver@.service

# Recharger systemd utilisateur
systemctl --user daemon-reload
systemctl --user daemon-reexec

# 3️⃣ Corriger les permissions sur uinput (temporaire immédiat)
sudo chmod 666 /dev/uinput

# 3️⃣b Solution persistante pour uinput
echo 'KERNEL=="uinput", MODE="0666"' | sudo tee /etc/udev/rules.d/99-uinput.rules
sudo udevadm control --reload
sudo udevadm trigger

# 4️⃣ Ajouter l’utilisateur aux groupes nécessaires
sudo usermod -aG input $USER
sudo usermod -aG i2c $USER

# Après ça, se déconnecter et se reconnecter pour appliquer les groupes

# 5️⃣ Tester manuellement le driver
/usr/share/asus-numberpad-driver/.env/bin/python3 /usr/share/asus-numberpad-driver/numberpad.py up5401ea /usr/share/asus-numberpad-driver/

# Si des modules Python manquent, les installer
cd /usr/share/asus-numberpad-driver/
./.env/bin/pip install -r requirements.txt

# 6️⃣ Lancer et activer le service systemd utilisateur
systemctl --user daemon-reload
systemctl --user start asus_numberpad_driver@ogu.service
systemctl --user enable asus_numberpad_driver@ogu.service
systemctl --user status asus_numberpad_driver@ogu.service
```

<a id="id-38"></a>
## 38 - Configurer fish et gnome-text-editor
Régler `Gnome-text-editor`et `Ptyxis`, configurer `fish` avec `gnome-text-editor ~/.config/fish/config.fish` et coller :
  
```
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
```
Et recharger la configuration de fish avec `source ~/.config/fish/config.fish`


<a id="id-39"></a>
## 39 - Changer icône Pamac
Changer l'icone Pamac:
```
mkdir -p ~/.local/share/icons && \
wget -O ~/.local/share/icons/pamac.svg https://raw.githubusercontent.com/somepaulo/MoreWaita/b439fe8e2df83abc6cf02a0544a101426611e8ea/scalable/apps/pamac.svg 

```
puis éditer le raccourci avec Menu Libre.


<a id="id-40"></a>
## 40 - Configurer Celluloid

inscrire `vo=gpu-next` dans Paramètres --> Divers --> Options supplémentaires, activer l'option `focus` et `toujours afficher les boutons de titre`, enfin télécharger et installer les deux scripts lua suivants pour la musique : Visualizer & Delete File


<a id="id-41"></a>
## 41 - Configurer JDownloader & Fragments
`Jdownloader` : réglages de base, font Adwaita Sans, et désactiver les éléments suivants : tooltip, help, Update Button Flashing, banner, Premium Alert, Donate, speed meter visible.
Modifier le raccourci d'icone grace à l'éditeur de texte présent dans Menu Libre et passer `StartupWMClass=org-jdownloader-update-launcher-JDLauncher` pour que l'icone apparaisse dans le dock.

`Fragments` : Général, Ouvrir l'interface Web, onglet Peers : copier-coller cette url de règles de blocage : 
```
https://raw.githubusercontent.com/Naunter/BT_BlockLists/master/bt_blocklists.gz
```


<a id="id-42"></a>
## 42 - Script transfert vidéos
Script de `transfert des vidéos` intitulé `transfert_videos` pour déplacer automatiquement les vidéos vers Vidéos en supprimant le sous-dossier d'origine.
Le télécharger depuis le dossier `SCRIPTS`, le coller dans /home/ogu/.local/bin/, en faire un raccourci avec l'éditeur de menu, passer le chemin d'exécution `/usr/bin/fish /home/ogu/.local/bin/transfert_videos.sh` et lui mettre l'icone `/usr/share/icons/Adwaita/scalable/devices/drive-multidisk.svg`


<a id="id-43"></a>
## 43 - Accélérer animations Gnome Shell

Note : deprecated? A remplacer par l'etexnsion GS *Impatience*

```
GNOME_SHELL_SLOWDOWN_FACTOR=0.75
```
dans le fichier 
```
sudo gnome-text-editor /etc/environment
```


<a id="id-44"></a>
## 44 - Scripts Nautilus Hide/Unhide, Dropbox, Copier le chemin
Scripts Nautilus `Hide.py` `Unhide.py` pour masquer/rendre visibles les fichiers à la volée, et `Dropbox` pour ouvrir un fichier dans l'interface web Dropbox afin de copier-coller son iurl de partage et ainsi mimer le copmportmeent de Dropbox Nautilus.
A télécharger depuis le dossier `SCRIPTS` puis à coller dans le dossier `/home/ogu/.local/share/nautilus/scripts/.
Penser à les rendre exécutables!

Ajouter `nautilus-copy-path` & `nautilus-admin`
```
yay -S nautilus-copy-path nautilus-admin
```
Et éditer les ficheirs `/usr/share/nautilus-python/extensions/nautilus-copy-path/nautilus_copy_path.py` & `/usr/share/nautilus-python/extensions/nautilus-copy-path.py` pour passer URI & Content en `false`, puis `/usr/share/nautilus-python/extensions/nautilus-admin.py` pour traduire "Open as admin" en "Ouvrir en administrateur root".

Enfin `pkill nautilus && nautilus`.

<a id="id-45"></a>
## 45 - Supprimer Plymouth

Supprimer Plymouth avec `sudo pacman -Rns plymouth` puis éditer mkinitcpio pour retirer le hook Plymouth :
```
sudo gnome-text-editor /etc/mkinitcpio.conf
```
Recharger avec `sudo mkinitcpio -P`

Enfin modifier les arguments kernel :
```
sudo gnome-text-editor /etc/sdboot-manage.conf
```
Retirer `splash`, ajouter `consoleblank vt.global_cursor_default=0 rd.udev.log_level=0`, puis régénérer avec `sudo sdboot-manage gen` et `sudo mkinitcpio -P`

En cas de maintien de Plymouth, supprimer l'animation Cachy-boot-animation avec Pamac et installer le theme CachyOS, puis :
```
sudo plymouth-set-default-theme cachyos
```

Remplacer l'image `watermark.png` dans /usr/share/plymouth/themes/cachyos avec le logo CachyOS blanc.
Puis :
```
sudo mkinitcpio -P
```


<a id="id-46"></a>
## 46 - Modifier nom toggle profil énergétique dans le menu Gnome
Modifier le nom du *toggle de changement de profil énergétique* dans l'applet Gnome : sans quoi le nom est tellement long qu'il est coupé dans le bouton
Installer l'outil de traduction :
```
sudo pacman -S gettext
```
Récupérer le po français de gnome-shell :
```
wget https://gitlab.gnome.org/GNOME/gnome-shell/-/raw/main/po/fr.po -O fr.po
```
Éditer fr.po avec `sudo gedit fr.po` et modifier le nom du bouton "Mode puissance" par "Energie" ou "Profil", puis compiler :
```
msgfmt fr.po -o gnome-shell.mo
```
Sauvegarder l’original avec `sudo cp /usr/share/locale/fr/LC_MESSAGES/gnome-shell.mo{,.bak}` puis remplacer par le nouveau fichier : 
```
sudo cp gnome-shell.mo /usr/share/locale/fr/LC_MESSAGES/gnome-shell.mo
```
Enfin supprimer les fichiers créés à la racine de Home.


<a id="id-47"></a>
## 47 - Créer raccourcis et Places
Créer un raccourci "boot to bios" avec confirmation : télécharger le script, le déposer dans /home/ogu/.local/bin, le rendre exécutable, puis créer un raccourci avec l'icone jockey et la commande :
```
ptyxis -- /home/ogu/.local/bin/reboot_bios.sh
```
Dans les Paramètres Gnome, créer un raccourci Ptyxis avec la touche Copilot, Gradia-screenshot avec `gradia --screenshot=INTERACTIVE`, Ressources avec ctrl-alt-supp
Enfin modifier les folder par défauts Dropbox, Nicotine, Téléchargements, etc, usr, root, Extensions, Icons etc avec les Places personnalisés.

<a id="id-48"></a>
## 48 - Faire le tri dans les LOCALES, ~/.local/share, ~/.config et /etc

Supprimer les locales sauf EN, en_US, fr, Fr_FR dans `usr/share/locales` : penser à les sauvegarder puis à vérifier au reboot. 

----------------------------------------------------------------------------------------------

# 🌐 F - Réglages du navigateur Firefox

<a id="id-49"></a>
## 49 - Réglages internes Firefox
Réglages internes de `Firefox` (penser à activer CTRL-TAB pour faire défiler dans l'ordre d'utilisation & à passer sur `Sombre` plutôt qu'`auto` le paramètre `Apparence des sites web`), interdire le lancement auto des vidéos dans `Lecture automatique -- paramètres`, activer le plugin H264.
Enfin éditer le raccourci Firefox pour lancer le browser avec un nouvel onglet vide  :
```
/usr/lib/firefox/firefox  %u -new-tab about:blank
```


<a id="id-50"></a>
## 50 - Thème Firefox Gnome Dark
Changer le `thème` pour [Gnome Dark ](https://addons.mozilla.org/fr/firefox/addon/adwaita-gnome-dark/?utm_content=addons-manager-reviews-link&utm_medium=firefox-browser&utm_source=firefox-browser)


<a id="id-51"></a>
## 51 - Réglages about:config
En complément des [réglages Firefox CachyOS](https://github.com/CachyOS/CachyOS-PKGBUILDS/blob/master/cachyos-firefox-settings/cachyos.js), dans `about:config` :

Nota : certains intitulés ont changé au gré des mises à jour Firefox.

**Interface / UI**

a - `ui.key.menuAccessKey` = 0 pour désactiver la touche Alt qui ouvre les menus

b - `apz.overscroll.enabled` = false pour supprimer le rebond lors du scroll jusqu'en fin de page

c - pour activer userChrome : `toolkit.legacyUserProfileCustomizations.stylesheets` sur true

**Session**

d - `browser.sessionstore.interval` à `600000` pour réduire l'intervalle de sauvegarde des sessions

**Développement / Accessibilité**

e - `devtools.f12_enabled` = false

f - `accessibility.force_disabled` = 1 pour supprimer l'accessibilité

**Extensions / Contenus**

g - `extensions.screenshots.disabled` = true pour désactiver le screenshot

h - `privacy.userContext.enabled` = false pour désactiver les containers

**Réseau / HTTP / Cache**

i - `image.mem.decode_bytes_at_a_time` = 131072

j - `browser.cache.disk.parent_directory` à créer sous forme de chaîne, et lui passer l'argument /run/user/1000/firefox, afin de déplacer le cache en RAM. 
Saisir `about:cache` pour contrôle. 

k - `browser.frames-lazy-load.enabled` à créer en booléen, valeur false

l - `nglayout.initialpaint.delay` sur 0

m - !! Attention : complique la connexion à Perplexity - Changer le useragent en créant une chaine `general.useragent.override`, et passer `Mozilla/5.0 (Wayland; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/139.0.0.0 Safari/537.36
`
Pour tester : https://www.whatismybrowser.com/

**Téléchargements / Médias**

n - `media.ffmpeg.vaapi.enabled` sur true

**Batterie**

o -`dom.battery.enabled` = false 

**Conteneurs**
p - `privacy.userContext.enabled` = false pour désactiver les conteneurs

**Chatbot Perplexity**

q - `browser.ml.chat.provider` et saisir 
```
https://www.perplexity.ai/
```
**Rapports d'erreur**
r - `browser.tabs.crashReporting.sendReport` sur false

**Google Lens**
s - `browser.search.visualSearch.featureGate` sur true

<a id="id-52"></a>


## 52 - Extensions Firefox
a - [uBlock Origin](https://addons.mozilla.org/fr/firefox/addon/ublock-origin/) : réglages à faire + import des la liste sauvegardées + interdire les sites IA avec ce [lien](https://subscribe.adblockplus.org/?location=https%3A%2F%2Fraw.githubusercontent.com%2Flaylavish%2FuBlockOrigin-HUGE-AI-Blocklist%2Fmain%2Flist.txt&title=Sites%20using%20AI%20generated%20content) 

b - [Auto Tab Discard](https://addons.mozilla.org/fr/firefox/addon/auto-tab-discard/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=featured) : importer les réglages avec le fichier de backup et bien activer les 2 options de dégel des onglets à droite et à gauche de l'onglet courant.

c - [Raindrop](https://raindrop.io/r/extension/firefox) 

d - [Undo Close Tab Button](https://addons.mozilla.org/firefox/addon/undoclosetabbutton) et mettre ALT-Z comme raccourci à partir du menu général des extensions (roue dentée)

e - [LocalCDN](https://addons.mozilla.org/fr/firefox/addon/localcdn-fork-of-decentraleyes/), puis faire le [test](https://decentraleyes.org/test/).

f - [Side View](https://addons.mozilla.org/fr/firefox/addon/side-view/)

g - [Scroll To Top](https://addons.mozilla.org/fr/firefox/addon/scroll-to-top-button-extension/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)

h - [Workspaces](https://addons.mozilla.org/fr/firefox/addon/workspacesplus/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)

i - [Copy URL](https://addons.mozilla.org/en-US/firefox/addon/copy-frame-or-page-url/)

j - [Youtube Sidebar](https://addons.mozilla.org/en-US/firefox/addon/youtube-sidebar/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)

k - [Gmail Sidebar](https://addons.mozilla.org/fr/firefox/addon/gmail-sidebar-search/)

l - [Sticky Note Sidebar](https://addons.mozilla.org/fr/firefox/addon/sidebar-sticky-note/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)

m - [Translate Sidebar](https://addons.mozilla.org/fr/firefox/addon/lingva-in-sidebar/)

n - [History Auto Delete](https://addons.mozilla.org/fr/firefox/addon/history-auto-delete/)

<a id="id-53"></a>
## 53 - Activer Rechercher avec Perplexity
 Activer `perplexity` en se rendant sur leur [site](https://www.perplexity.ai/) : faire une recherche dans la batrre d'adresse, sélectionner "Rechercher avec Perplexity" dans le menu qui apparait, puis autoriser l'installation de la recherche Perplexity. Ajouter un champ de recherche dans la toolbar Firefox.


<a id="id-54"></a>
## 54 - userChrome pour allèger le clic droit
Télécharger le *userChrome* et le coller dans le répertoire par défaut de Firefox dans un dossier *chrome*. Le profil se trouve dans `about:support`


<a id="id-55"></a>
## 55 - Mettre profil Firefox en RAM avec psd
Mettre le profil de Firefox en RAM avec `profile-sync-daemon` :
* ATTENTION : suivre ces consignes avec **Firefox fermé** - utiliser un browser secondaire
  
Installer psd (avec dnf `sudo pacman -S profile-sync-daemon`, ou avec make en cas d'échec - voir le fichier INSTALL sur le Github), puis l'activer avec les commandes suivantes (sans quoi le service échoue à démarrer) :
```
psd
systemctl --user daemon-reload
systemctl --user enable psd
reboot
```
Puis vérifier que psd fonctionne en contrôlant d'abord les profils Firefox :
```
cat ~/.mozilla/firefox/profiles.ini  #default=1 correspond au profil par défaut
cd ~/.mozilla/firefox/
ls ~/.mozilla/firefox/
```
Puis se rendre dans le dossier `~/.mozilla/firefox/` et copier-coller les profils dans un dossier de sauvegarde. Les supprimer un par un en relançant Firefox pour contrôle. Une fois le dossier unique par défaut établi, le renommer avec
```
firefox --ProfileManager #renommer le profil par défaut et eventuellement supprimer le profil en double  
```
Enfin régler & contrôler le bon fonctionnement de psd : passer à 2 le nombre de backups au lieu de 5 avec `BACKUP_LIMIT=2`, & circonscrire psd au seul Firefox avec `BROWSERS=(firefox)`:
```
psd -p
sudo gnome-text-editor /home/ogu/.config/psd/psd.conf # The default is to save the most recent 5 crash recovery snapshots BACKUP_LIMIT=2 & BROWSERS=(firefox)
```
Lancer Firefox et s'assurer que le profil originel ne pèse que quelques Ko :
```
cd ~/.mozilla/firefox
du -sh ~/.mozilla/firefox/
```
Puis s'assurer que les centaines de Mo du profil sont bien en ram :
```
cd /run/user/1000
ls /run/user/1000
cd psd
ls
cd firefox
ls
du -sh /run/user/1000/psd/nom du profil/
```
Enfin désactiver le service --user de backup au boot :
```
systemctl --user mask psd-resync.service
systemctl --user mask psd-resync.timer
```

