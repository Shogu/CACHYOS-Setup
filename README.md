
# CACHYOS-Setup
Setup, tips &amp; tweaks pour CachyOS sur ZENBOOK 14 OLED KA

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

***Table des matières:***

A - [Installation](https://github.com/Shogu/Fedora41-setup-config/blob/main/README.md#-a---installation)

B - [Allégement du système](https://github.com/Shogu/Fedora41-setup-config/blob/main/README.md#-b---all%C3%A9gement-du-syst%C3%A8me)

C - [Optimisation du système](https://github.com/Shogu/Fedora41-setup-config/blob/main/README.md#-c---optimisation-du-syst%C3%A8me)

D - [Remplacement et installation de logiciels](https://github.com/Shogu/Fedora41-setup-config/blob/main/README.md#-d---remplacement-et-installation-de-logiciels-et-codecs)

E - [Réglages de l'UI Gnome Shell](https://github.com/Shogu/Fedora41-setup-config/blob/main/README.md#-e---r%C3%A9glages-de-lui-gnome-shell)

F - [Réglages de Firefox](https://github.com/Shogu/Fedora41-setup-config/blob/main/README.md#-f---r%C3%A9glages-du-navigateur-firefox)

G - [Maintenance et mises à jour](https://github.com/Shogu/Fedora41-setup-config/blob/main/README.md#-g---maintenance-de-la-distribution)

----------------------------------------------------------------------------------------------

## 💾 **A - Installation**

* **1** - Désactiver `Secure Boot` dans le Bios (F2)

* **2** - Désactiver la caméra et le lecteur de carte dans le bios

* **3** - Utiliser `systemd-boot` puis décocher les paquets inutiles (Attention : la plupart s'installeront quand même), et EXT4.

* **4** - Désactiver la `Mise en veille automatique` dans les paramètres de Gnome, du fait d'un bug avec le Zenbook et le noyau < 6.16.7

* **5** - Faire un ghost du système tout neuf avec Rescuezilla
----------------------------------------------------------------------------------------------


## ✨ **B - Allégement du système**

* **6** - Faire les réglages proposés par `CachyOS-Hello` : désactiver le bluetooth, activer cachy-update tray et bpftune, classer les miroirs, NE PAS installer psd (il faut l'installer en --user) ni ananicy-cpp (le boot du service échoue - lui préférer ADIOS pour AMD).

* **7** - Supprimer les `logiciels inutiles` avec Pamac & Octopi
  
* **8** - Compléter en supprimant les `logiciels inutiles` suivants avec pacman :
```
sudo pacman -Rns apache  speech-dispatcher gnome-remote-desktop gnome-backgrounds gnome-user-share yelp brltty  gnome-weather rygel totem  gnome-user-docs  baobab  f2fs-tools mod_dnssd gnome-user-share orca gnome-user-docs yelp sane colord-sane gvfs-dnssd gvfs-smb mod_dnssd  gnome-user-share rygel nss-mdns gnome-backgrounds gnome-usage octopi gedit xfsprogs btrfs-progs yay cpupower

```
    
* **9** - Supprimer et masquer les services `SYSTEM` & `USER` inutiles :
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
```
```
Vérifier si `scx_loader` & `ananicy-cpp` sont lancés par défaut : si oui :
sudo systemctl mask scx_loader ananicy-cpp
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

```
Puis contrôler avec :
```
systemd-analyze --user blame
```

* **10** - Désactiver l'autostart gnome-wellbeing :
```
cp /usr/share/applications/gnome-wellbeing-panel.desktop ~/.config/autostart/ && sudo gnome-text-editor ~/.config/autostart/gnome-wellbeing-panel.desktop 

```
Saisir `Hidden=true` puis contrôler avec `grep Hidden ~/.config/autostart/gnome-wellbeing-panel.desktop`

* **11** - Alléger les `journaux système` et les mettre en RAM :
```
sudo gnome-text-editor /etc/systemd/journald.conf
```
puis remplacer le contenu du fichier par celui du fichier `journald.conf.txt` & relancer le service :
```
sudo systemctl restart systemd-journald
```

* **12** - Supprimer les `coredump` : 
``` 
sudo systemctl disable --now systemd-coredump.socket
sudo systemctl mask systemd-coredump
sudo systemctl mask systemd-coredump.socket
```
puis empêcher qu'ulimit ne fasse des dumps : 
```
echo '* hard core 0' | sudo tee -a /etc/security/limits.conf
```


* **13** - Blacklister les pilotes inutiles : créer un fichier `blacklist` ```sudo gnome-text-editor /etc/modprobe.d/blacklist.conf``` et l'éditer :
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
# modules Asus (facultatif)
# ==============================
#blacklist asus_wmi
#blacklist asus_nb_wmi
#blacklist asus_armoury

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
```
Puis lancer `sudo mkinicpio -P`
Au reboot, vérifier avec la commande `lsmod | grep hid_sensor`

* **14 ** : réduire l`initramfs` en désactivant des modules inutiles : attention prévoir un backup du fichier pour le restaurer en live cd si besoin!
```
sudo gnome-text-editor /etc/mkinitcpio.conf

```
et copier-coller ces options de configuration :
```
HOOKS=(base udev autodetect kms modconf block filesystems plymouth)
```
Puis choisir entre : lz4 ou zstd et passer `-3` à COMPRESSION_OPTION

Recharger l'initrd avec `sudo mkinitcpio -P`

* **15** - Désactiver le capteur de luminosité de Gnome :

```
gsettings set org.gnome.settings-daemon.plugins.power ambient-enabled false
```

----------------------------------------------------------------------------------------------

## 🚀 **C - Optimisation du système**


* **16** Activer le scheduler ADIOS sur AMD CPU, plutôt qu'un scheduler type bpfland ou rusty :
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

* **17** - Passer `xwayland` en autoclose : sur dconf-editor, modifier la clé suivante.
```
org.gnome.mutter experimental-features
```

En profiter pour activer `scale-monitor-framebuffer` & `xwayland-native-scaling`

* **18** - Optimiser le `kernel` :

| Thème                     | Arguments / Options                                                                 | Description                                                                                   |
|----------------------------|------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------|
| **Perf / CPU / Scheduler** | `rcu_nocbs=0-(nproc-1)`, `rcutree.enable_rcu_lazy=1`, `noreplace-smp`, `tsc=reliable` | Optimisations RCU, scheduler et compteur TSC pour réduire latence et améliorer le boot.      |
| **Sécurité / Crypto**      | `cryptomgr.notests`, `random.trust_cpu=on`, `tpm.disable=1`                        | Désactive PUCE TPM & tests crypto au boot et fait confiance aux instructions RDRAND/RDSEED.             |
| **ACPI / Matériel / GPU**  | `efi=disable_early_pci_dma`, `nomce`                                               | Désactive DMA PCI précoce, MCE non critiques pour éviter conflits et arrêts intempestifs.    |
| **Debug / Logs / Timer**   | `nowatchdog`, `loglevel=0`, `no_timer_check`                                       | Désactive watchdog, limite logs et vérifications timer HPET pour accélérer le boot.          |
| **Swap / FS**              | `noresume`, `fsck.mode=skip`, `zswap.enabled=0`                                    | Désactive reprise hibernation, fsck et zswap pour réduire overhead CPU et boot time.         |
| **Console / Boot**         | `console=tty0`, `systemd.show_status=false`, `quiet splash`                        | Définit la console principale et masque la majorité des messages kernel/systemd.             |
| **Divers / UART**          | `8250.nr_uarts=0`                                                                  | Désactive tous les ports série 8250 si non utilisés.                                          |
| **Cgroup / RDMA**          | `cgroupdisable=rdma`                                                               | Désactive les cgroups RDMA si non utilisés.                                                  |
| **NVMe**                   | `nvme_core.default_ps_max_latency_us=5500`                                         | Limite latence NVMe pour un mode power-saving équilibré.                                      |
| **Wifi / Réseau**          | `disable_ipv6=1`                                                                   | Désactive IPv6.                                                                               |
| **Virtualisation**         | `amd_iommu=off`                                                                    | Désactive l’IOMMU AMD si pas de virtualisation/VFIO.                                         |

```
sudo gnome-text-editor /etc/sdboot-manage.conf
```
Puis saisir :
```
LINUX_OPTIONS="rcu_nocbs=0-(nproc-1) rcutree.enable_rcu_lazy=1 noreplace-smp tsc=reliable cryptomgr.notests random.trust_cpu=on efi=disable_early_pci_dma nomce nowatchdog loglevel=0 no_timer_check noresume fsck.mode=skip zswap.enabled=0 console=tty0 systemd.show_status=false quiet splash 8250.nr_uarts=0 cgroupdisable=rdma nvme_core.default_ps_max_latency_us=5500 disable_ipv6=1 amd_iommu=off"
```
Relancer systemd-boot conformément à la méthode CachyOS :
```
sudo sdboot-manage gen
```
Penser à créer un timer (1/semaine) pour lancer fsck vu qu'il est désactivé au niveau kernel :
```
sudo tune2fs -c 0 -i 7d /dev/nvme0n1p2
```
Vérifier avec  `sudo tune2fs -l /dev/nvme0n1p2 | grep -i 'check'


* **19** - Réduire le `temps d'affichage du menu systemd-boot` à 0 seconde  (appuyer sur MAJ pour le faire apparaitre au boot):
```
sudo nano /boot/loader/loader.conf
```
Reboot, puis vérifier que le fichier loader.conf soit à 0 :
```
sudo cat /boot/loader/loader.conf
timeout 1
#console-mode keep
```

* **20** - Editer le mount des `partitions EXT4` avec la commande :
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

* **21** - Activer fast_commit pour les journaux EXT4 :

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

* **22** - Désactiver mitigate split lock : éditer `sudo nano /etc/sysctl.d/99-splitlock.conf` et saisir :
  
```
kernel.split_lock_mitigate=0
```
Puis recharger avec `sudo sysctl --system`


* **23** - Régler le `pare-feu` :

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

# Autoriser JDownloader HTTP/HTTPS
sudo ufw allow out 80/tcp
sudo ufw allow out 443/tcp

# Activer UFW
sudo ufw --force enable
sudo ufw status numbered
```

* **24** - Passer à 1 le nombre de `ttys` au boot  :  
```
sudo gnome-text-editor /etc/systemd/logind.conf
```
puis saisir : `NautoVTS=1`


* **25** Régler wifi sur FR :
```
sudo nano /etc/conf.d/wireless-regdom
```
et décommenter la ligne *WIRELESS_REGDOM="FR"*

----------------------------------------------------------------------------------------------

## 📦 **D - Remplacement et installation de logiciels et codecs**


* **26** - Installer les `logiciels` suivants avec pacman :
```
sudo pacman -Syu dconf-editor evince powertop ffmpegthumbnailer profile-cleaner seahorse pamac celluloid extension-manager fragments papers paru nicotine+ resources onlyoffice
```
et

```
paru -S libre-menu-editor gradia nautilus-admin pacseek jdownloader2

```

* **27** - Installer `Dropbox` avec Maestral : créer le répertoire Dropbox dans /home puis lancer le script *maestral_install* 

----------------------------------------------------------------------------------------------

## 🐾 **E - Réglages de l'UI Gnome Shell** 

* **28** Extinction en fermant le caport du laptop :
Editer le service logind :
```
gnome-text-editor admin:///etc/systemd/logind.conf
```
puis remplacer les lignes HandleLid par 
```
HandleLidSwitch=poweroff
HandleLidSwitchExternalPower=poweroff
```

* **29** - Régler Nautilus & créer un marque-page pour `Dropbox`, pour l'accès `ftp` au disque SSD sur la TV Android, et pour lancer Nautilus en root depuis le panneau latéral :
```
192.168.31.68:2121
```

* **30** - Modifier le mot de passe au démarrage avec le logiciel `Mots de Passe`, puis laisser les champs vides. Penser à reconnecter le compte Google dans Gnome.

* **31** - Installer le [wallpaper F34](https://fedoraproject.org/w/uploads/d/de/F34_default_wallpaper_night.jpg) OU celui disponible dans le dossier `Images USER`, et le thème de curseurs [Phinger NO LEFT Light](https://github.com/phisch/phinger-cursors/releases) : créer le répertoire de destination avec `mkdir -p ~/.local/share/icons/apps`, y déplacer le dossier *phingers-cursor-light*  puis utiliser `dconf-editor` pour les passer en taille 32 :
```
org/gnome/desktop/interface/cursor-size
```
* **32** - Régler `HiDPI` sur 125, cacher les dossiers Modèles, Bureau, ainsi que le wallpaper et l'image user, augmenter la taille des icones dossiers.
  
* **33** Renommer les `logiciels dans l'overview`, cacher ceux qui sont inutiles de façon à n'avoir qu'une seule et unique page, en utilisant le logiciel `Menu Principal`.
En profiter pour changer avec Menu Principal l'icone de `Ptyxis`, en la remplaçant par celle de [gnome-terminal](https://upload.wikimedia.org/wikipedia/commons/d/da/GNOME_Terminal_icon_2019.svg)

* **34** - Installer diverses `extensions` :

**Extensions esthétiques :**

a - [Panel Corners](https://extensions.gnome.org/extension/4805/panel-corners/)

b - [Hide Activities Button](https://extensions.gnome.org/extension/744/hide-activities-button/)

c - [Remove World Clock](https://extensions.gnome.org/extension/6973/remove-world-clocks/)

d - [Topbar Organizer](https://extensions.gnome.org/extension/4356/top-bar-organizer/)]

**Extensions apportant des fonctions de productivité :**

e - [Appindicator](https://extensions.gnome.org/extension/615/appindicator-support/)

f - [Caffeine](https://extensions.gnome.org/extension/517/caffeine/)

g - [Clipboard History](https://extensions.gnome.org/extension/4839/clipboard-history/)

**Extensions apportant des fonctions UI :  **

h - [Battery Time Percentage Compact](https://extensions.gnome.org/extension/2929/battery-time-percentage-compact/) ou [Battery Time](https://extensions.gnome.org/extension/5425/battery-time/)
     
i - [AutoActivities](https://extensions.gnome.org/extension/5500/auto-activities/)

j - [Auto Screen Brightness](https://extensions.gnome.org/extension/7311/auto-screen-brightness/) & supprimer la luminosité automatique dans Settings de Gnome

k - [Hot Edge](https://extensions.gnome.org/extension/4222/hot-edge/)

l - [Custom Command Toggle](https://extensions.gnome.org/extension/7012/custom-command-toggle/)  

m - Pop Shell Tiling : `paru -S gnome-shell-extension-pop-shell`
puis supprimer le theme icone Pop dans /usr/share/icons

n - [Quick Close Overview](https://extensions.gnome.org/extension/352/middle-click-to-close-in-overview/)



* **35** - Installer Open with Ptyxis :
```
paru -S nautilus-open-any-terminal
```
et penser à éditer sa clé dconf com.github.stunkymonkey.nautilus-open-any-terminal pour inscrire "ptyxis".

* **36** - Activer le [numpad Asus](https://github.com/asus-linux-drivers/asus-numberpad-driver), disable le service --user, puis créer un toggle button et importer le fichier de configuration hosté dans le répertoire github Fichiers de configuration.
Sinon, lui passer l'icone `accessories-calculator-symbolic` et les commandes suivantes :
```
systemctl enable --user asus_numberpad_driver@ogu.service && systemctl start --user asus_numberpad_driver@ogu.service &&  notify-send "Numpad activé"
systemctl stop --user asus_numberpad_driver@ogu.service && systemctl disable --user asus_numberpad_driver@ogu.service &&  notify-send "Numpad désactivé"
```

* **37** - Régler `Gnome-text-editor`et `Ptyxis`, configurer `fish` avec `gnome-text-editor ~/.config/fish/config.fish` et coller :
  
```
# Désactive le message d'accueil de Fish.
set -g fish_greeting ""

# Désactiver le pager pour paru et autres programmes
set -Ux PAGER cat

alias yay='paru'
alias vim='nano'
alias vi='nano'
alias gedit='gnome-text-editor'
alias micro='gnome-text-editor'
```
Et recharger la configuration de fish avec `source ~/.config/fish/config.fish`


* **38** - Changer l'icone Pamac:
```
mkdir -p ~/.local/share/icons && \
wget -O ~/.local/share/icons/pamac.svg https://raw.githubusercontent.com/somepaulo/MoreWaita/b439fe8e2df83abc6cf02a0544a101426611e8ea/scalable/apps/pamac.svg 

```
puis éditer le raccourci avec Menu Libre.


  
* **39** - `Celluloid` :
inscrire `vo=gpu-next` dans Paramètres --> Divers --> Options supplémentaires, activer l'option `focus` et `toujours afficher les boutons de titre`, enfin installer les deux scripts lua suivants pour la musique :
[Visualizer](https://www.dropbox.com/scl/fi/bbwlvfhtjnu8sgr4yoai9/visualizer.lua?rlkey=gr3bmjnrlexj7onqrxzjqxafl&dl=0)
[Delete File avec traduction française](https://www.dropbox.com/scl/fi/c2cacmw2a815husriuvc1/delete_file.lua?rlkey=6b9d352xtvybu685ujx5mpv7v&dl=0)

* **40** - `Jdownloader`: réglages de base, font Noto Sans Regular, désactivation du dpi et font sur 175; puis désactiver les éléments suivants : tooltip, help, Update Button Flashing, banner, Premium Alert, Donate, speed meter visible.

* **41** - Script de `transfert des vidéos` intitulé `transfert_videos` pour déplacer automatiquement les vidéos vers Vidéos en supprimant le sous-dossier d'origine.
Le télécharger depuis le dossier `SCRIPTS`, le coller dans /home/ogu/.local/bin/, en faire un raccourci avec l'éditeur de menu, passer le chemin `/home/ogu/.local/bin/` et lui mettre l'icone `/usr/share/icons/Adwaita/scalable/devices/drive-multidisk.svg`

* **42** - Accélérer les `animations` :  saisir
```
GNOME_SHELL_SLOWDOWN_FACTOR=0.75
```
dans le fichier 
```
sudo gnome-text-editor /etc/environment
```

* **43** - `Scripts` Nautilus :

`Hide.py` et `Unhide.py` pour masquer/rendre visibles les fichiers
A télécharger depuis le dossier `SCRIPTS` puis à coller dans le dossier `/home/ogu/.local/share/nautilus/scripts/.
Penser à les rendre exécutables!


* **44** Enlever le powersave de la souris Inphic :  créer une règle udev pour que Linux applique power/control=on automatiquement à chaque démarrage :
```
sudo nano /etc/udev/rules.d/50-inphic.rules
```
et saisir 
```
ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1ea7", ATTR{idProduct}=="0064", TEST=="power/control", ATTR{power/control}="on"
```
Puis recharger udev avec  
```
sudo udevadm control --reload
sudo udevadm trigger
```

* **45** - Modifier le nom du *toggle de changement de profil énergétique* dans l'applet Gnome : sans quoi le nom est tellement long qu'il est coupé dans le bouton...
Installer l'outil de traduction :
```
sudo pacman -S gettext
```
Récupérer le po français de gnome-shell :
```
wget https://gitlab.gnome.org/GNOME/gnome-shell/-/raw/main/po/fr.po -O fr.po
```
Éditer fr.po et modifier le nom du bouton "Mode puissance" par "Energie". Puis compiler :
```
msgfmt fr.po -o gnome-shell.mo
```
Sauvegarder l’original avec `sudo cp /usr/share/locale/fr/LC_MESSAGES/gnome-shell.mo{,.bak}` puis remplacer par le nouveau fichier : 
```
cp gnome-shell.mo /usr/share/locale/fr/LC_MESSAGES/gnome-shell.mo
```
Enfin supprimer les fichiers créés à la racine de Home.

* **46** Créer un raccourci "boot to bios" avec confirmation : télécharger le script, le déposer dans /home/ogu/.local/bin, le rendre exécutable, puis créer un raccourci avec l'icone jockey et la commande :
```
ptyxis -- /home/ogu/.local/bin/reboot_bios.sh
```

* **47** - Faire le tri dans `~/.local/share/`, `/home/ogu/.config/`, `/usr/share/` et `/etc/`
----------------------------------------------------------------------------------------------

 
## 🌐 **F - Réglages du navigateur Firefox**

* **48** - Réglages internes de `Firefox` (penser à activer CTRL-TAB pour faire défiler dans l'ordre d'utilisation & à passer sur `Sombre` plutôt qu'`auto` le paramètre `Apparence des sites web`)

* **49** - Changer le `thème` pour [Gnome Dark ](https://addons.mozilla.org/fr/firefox/addon/adwaita-gnome-dark/?utm_content=addons-manager-reviews-link&utm_medium=firefox-browser&utm_source=firefox-browser)

* **50** - Dans `about:config` :
  
a - `ui.key.menuAccessKey` = 0 pour désactiver la touche Alt qui ouvre les menus
  
b - `browser.sessionstore.interval` à `600000` pour réduire l'intervalle de sauvegarde des sessions

c - `devtools.f12_enabled` = false

d - `accessibility.force_disabled` = 1 pour supprimer l'accessibilité

ge - `extensions.screenshots.disabled` = true pour désactiver le screenshot

h - `privacy.userContext.enabled` = false pour désactiver les containers

i - `browser.tabs.crashReporting.sendReport` = false

j - `network.http.max-persistent-connections-per-server` = 10  

k - `image.mem.decode_bytes_at_a_time` = 131072

l - `dom.battery.enabled` = false 

m - `extensions.htmlaboutaddons.recommendations.enabled` = false pour désactiver l'affichage des "extensions recommandées" dans le menu de Firefox

n - `apz.overscroll.enabled` = false pour supprimer le rebonb lors d uscroll jusqu'en fin de page

o - `browser.cache.disk.parent_directory` à créer sour forme de `chaîne`, et lui passer l'argument /run/user/1000/firefox, afin de déplacer le cache en RAM. Saisir `
about:cache` pour contrôle. 

p - `media.autoplay.default` sur 2 (les vidéos ne se lancent que si on clique dessus)

q - `telemetry` : passer en false
```
browser.newtabpage.activity-stream.telemetry
browser.newtabpage.activity-stream.feeds.telemetry
toolkit.telemetry.bhrPing.enabled
toolkit.telemetry.archive.enabled
toolkit.telemetry.firstShutdownPing.enabled
toolkit.telemetry.reportingpolicy.firstRun
toolkit.telemetry.hybridContent.enabled
toolkit.telemetry.newProfilePing.enabled
toolkit.telemetry.unified
toolkit.telemetry.shutdownPingSender.enabled
toolkit.telemetry.updatePing.enabled
```
r - `media.ffmpeg.vaapi.enabled` sur true

s - pour activer userChrome : toolkit.legacyUserProfileCustomizations.stylesheets sur true

* **51** - **Extensions**
  
a - [uBlock Origin](https://addons.mozilla.org/fr/firefox/addon/ublock-origin/) : réglages à faire + import des deux listes sauvegardées
  
b - [Auto Tab Discard](https://addons.mozilla.org/fr/firefox/addon/auto-tab-discard/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=featured) : importer les réglages avec le fichier de backup et bien activer les 2 options de dégel des onglets à droite et à gauche de l'onglet courant.

c - [Raindrop](https://raindrop.io/r/extension/firefox) 
  
e - [Undo Close Tab Button](https://addons.mozilla.org/firefox/addon/undoclosetabbutton) et mettre ALT-Z comme raccourci à partir du menu général des extensions (roue dentée)

f - [LocalCDN](https://addons.mozilla.org/fr/firefox/addon/localcdn-fork-of-decentraleyes/), puis faire le [test](https://decentraleyes.org/test/).

g - [Side View](https://addons.mozilla.org/fr/firefox/addon/side-view/)

h - [Scroll To Top](https://addons.mozilla.org/fr/firefox/addon/scroll-to-top-button-extension/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)

i - [Workspaces](https://addons.mozilla.org/fr/firefox/addon/workspacesplus/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)


* **52** - Activer `openh264` & `widevine` dans les plugins firefox.
  
* **53** - Télécharger le *userChrome et le coller dans le répertoire par défaut de Firefox dans un dossier chrome. Le profil se trouve dans about:support

* **54** - Mettre le profil de Firefox en RAM avec `profile-sync-daemon` :
* ATTENTION : suivre ces consignes avec **Firefox fermé** - utiliser le browser secondaire WEB
  
Installer psd (avec dnf `sudo dnf install profile-sync-daemon`, ou avec make en cas d'échec - voir le fichier INSTALL sur le Github), puis l'activer avec les commandes suivantes (sans quoi le service échoue à démarrer) :
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
