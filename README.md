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

* **4** - Faire un ghost du systemùe tout neuf avec Rescuezilla 
----------------------------------------------------------------------------------------------


## ✨ **B - Allégement du système**

* **6** - Faire les réglages proposés par `CachyOS-Hello` : désactiver le bluetooth, activer bpftune, classer les miroirs, NE PAS installer ananicy ni psd (l'installation échoue)

* **7** - Supprimer les `logiciels inutiles` avec Pamac & Octopi
  
* **8** - Compléter en supprimant les `logiciels inutiles` suivants avec pacman :
```
sudo pacman -Rns apache  speech-dispatcher gnome-remote-desktop gnome-backgrounds  gnome-user-share yelp brltty  gnome-weather rygel totem  gnome-user-docs  baobab  f2fs-tools mod_dnssd gnome-user-share orca gnome-user-docs yelp sane colord-sane gvfs-dnssd gvfs-smb mod_dnssd  gnome-user-share rygel nss-mdns gnome-backgrounds paru gnome-usage octopi gedit xfsprogs btrfs-progs

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

* **10** - Alléger les `journaux système` et les mettre en RAM :
```
sudo gnome-text-editor /etc/systemd/journald.conf
```
puis remplacer le contenu du fichier par celui du fichier `journald.conf.txt` & relancer le service :
```
sudo systemctl restart systemd-journald
```

* **11** - Supprimer les `coredump` : 
``` 
sudo systemctl disable --now systemd-coredump.socket
sudo systemctl mask systemd-coredump
sudo systemctl mask systemd-coredump.socket
```
puis empêcher qu'ulimit ne fasse des dumps : 
```
echo '* hard core 0' | sudo tee -a /etc/security/limits.conf
```


* **12** - Blacklister les pilotes inutiles : créer un fichier `blacklist` ```sudo gnome-text-editor /etc/modprobe.d/blacklist.conf``` et l'éditer :
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

* **14 !! EXPERIMENTAL !!** : réduire l`initramfs` en désactivant des modules inutiles : attention prévoir un backup du fichier pour le restaurer en live cd si besoin!
```
sudo gnome-text-editor /etc/mkinitcpio.conf

```
et copier-coller ces options de configuration :
```
HOOKS=(base udev autodetect kms modconf block filesystems plymouth)
```
Puis chosiir entre : lzop (plus rapide, mais à installer) ou zstd et passer `-3` à COMPRESSION_OPTION

Recharger l'initrd avec `sudo mkinitcpio -P`

----------------------------------------------------------------------------------------------

## 🚀 **C - Optimisation du système**

* **16** - Passer `xwayland` en autoclose : sur dconf-editor, modifier la clé suivante.
```
org.gnome.mutter experimental-features
```

En profiter pour activer `scale-monitor-framebuffer` & `xwayland-native-scaling`

* **17** - Optimiser le `kernel` :
Passer les arguments suivants :
| Thème                               | Argument                                   | Description détaillée                                                                                                          |
| ----------------------------------- | ------------------------------------------ | ------------------------------------------------------------------------------------------------------------------------------ |
| **Performance / CPU / Scheduler**   | `rcu_nocbs=0-(nproc-1)`                    | Désactive le traitement RCU sur tous les cœurs pour éviter les interruptions et améliorer la latence.                          |
|                                     | `rcutree.enable_rcu_lazy=1`                | Active le mode « lazy » du RCU pour réduire l’overhead du scheduler et améliorer le temps de boot.                             |
|                                     | `noreplace-smp`                            | Empêche le remplacement des CPUs détectés à chaud, peut stabiliser certaines configurations multi-socket.                      |
|                                     | `tsc=reliable`                             | Indique au kernel que le compteur TSC (Time Stamp Counter) est fiable pour le calcul du temps système.                         |
| **Sécurité / Cryptographie**        | `cryptomgr.notests`                        | Désactive les tests de cryptographie lors du boot, réduit légèrement le temps de démarrage si on utilise des modules crypto.   |
|                                     | `random.trust_cpu=on`                      | Permet de faire confiance à l’instruction RDRAND/RDSEED du CPU pour initialiser l’entropy pool du kernel.                      |
| **ACPI / Matériel / PCI / GPU**     | `acpi_enforce_resources=lax`               | Assouplit la gestion des ressources ACPI pour permettre à certains drivers de fonctionner malgré des conflits d’adresses.      |
|                                     | `amdgpu.ppfeaturemask=0xffffffff`          | Active toutes les fonctionnalités du GPU AMD (PowerPlay, OverDrive, etc.).                                                     |
|                                     | `efi=disable_early_pci_dma`                | Désactive le DMA PCI précoce en early boot sur EFI, peut aider sur certains chipsets à éviter des conflits mémoire.            |
|                                     | `nomce`                                    | Désactive le Machine Check Exception (MCE), évite que le kernel s’arrête pour certaines erreurs CPU matérielles non critiques. |
| **Debug / Logs / Timer / Watchdog** | `nowatchdog`                               | Désactive le watchdog matériel et logiciel pour éviter des reset intempestifs en cas de freeze momentané.                      |
|                                     | `loglevel=0`                               | Limite l’affichage des messages kernel au boot pour réduire le bruit et accélérer le démarrage.                                |
|                                     | `no_timer_check`                           | Désactive certaines vérifications du timer, réduit le boot time et l’overhead de la vérification du timer HPET.                |
| **Swap / Resume / FS**              | `noresume`                                 | Désactive la reprise sur hibernation pour éviter les delays si une partition swap est détectée mais non utilisée.              |
|                                     | `fsck.mode=skip`                           | Ignore le contrôle du système de fichiers au boot, accélère le démarrage.                                                      |
|                                     | `zswap.enabled=0`                          | Désactive zswap, la compression en RAM du swap, pour réduire l’overhead CPU si tu n’utilises pas beaucoup le swap.             |
| **Console / Boot**                  | `console=tty0`                             | Définit la console principale sur tty0 (écran principal), permet de réduire les sorties inutiles.                              |
|                                     | `systemd.show_status=false`                | Masque les messages systemd au boot pour un affichage plus propre.                                                             |
|                                     | `quiet splash`                             | Masque les messages du kernel et affiche un splash screen.                                                                     |
| **Divers / UART**                   | `8250.nr_uarts=0`                          | Désactive tous les ports série 8250, utile si tu n’utilises pas de UART pour libérer des ressources.                           |
| **Cgroup / RDMA**                   | `cgroupdisable=rdma`                       | Désactive les cgroups RDMA, réduit l’overhead si tu n’utilises pas RDMA.                                                       |
| **NVMe**                            | `nvme_core.default_ps_max_latency_us=5500` | Définit la latence maximale du NVMe pour le mode power-saving, améliore la réactivité en choisissant un mode équilibré.        |


```
sudo gnome-text-editor /etc/sdboot-manage.conf
```
Puis saisir :
```
LINUX_OPTIONS="rcu_nocbs=0-(nproc-1) rcutree.enable_rcu_lazy=1 noreplace-smp tsc=reliable cryptomgr.notests random.trust_cpu=on acpi_enforce_resources=lax amdgpu.ppfeaturemask=0xffffffff efi=disable_early_pci_dma nomce nowatchdog loglevel=0 no_timer_check noresume fsck.mode=skip zswap.enabled=0 console=tty0 systemd.show_status=false quiet splash 8250.nr_uarts=0 cgroupdisable=rdma nvme_core.default_ps_max_latency_us=5500"
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


* **18** - Réduire le `temps d'affichage du menu systemd-boot` à 0 seconde  (appuyer sur MAJ pour le faire apparaitre au boot):
```
sudo nano /boot/loader/loader.conf
```
Reboot, puis vérifier que le fichier loader.conf soit à 0 :
```
sudo cat /boot/loader/loader.conf
timeout 1
#console-mode keep
```

* **19** - Editer le mount des `partitions EXT4` avec la commande :
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


Pour la aprtiton `vfat` : 
```
defaults,noatime,umask=0077 0 0
```


* **21** - Régler le `pare-feu` :

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

* **25** - Vérifier que le système utilise bien les DNS du `routeur Xiaomi` (192.168.31.1) :
```
nmcli dev show |grep DNS
```

**Boot time : avant optimisation : 23.7 secondes**

`Startup finished in 5.8s (firmware) + 508ms (loader) + 1.896s (kernel) + 4s (initrd) + 11.5s (userspace) = 23.7s`

**Boot time : après optimisation : 11.5 secondes**

`Startup finished in 2.315s (firmware) + 486ms (loader) + 1.742s (kernel) + 3.863s (initrd) + 3.174s (userspace) = 11.583s`

----------------------------------------------------------------------------------------------

## 📦 **D - Remplacement et installation de logiciels et codecs**

* **30** - Installer les logiciels `Flatpak` suivants : 
```
flatpak install flathub org.jdownloader.JDownloader -y
flatpak install flathub org.onlyoffice.desktopeditors -y
flatpak install flathub de.schmidhuberj.tubefeeder -y
flatpak install flathub app.ytmdesktop.ytmdesktop -y
flatpak install flathub io.github.kolunmi.Bazaar -y
flatpak install flathub com.github.tchx84.Flatseal -y
```
Utiliser Flatseal pour désactiver le maintien en arrière-plan de Bazaar puis le supprimer avec flatpak remove flathub com.github.tchx84.Flatseal

* **31** - Installer les `logiciels` suivants avec pacman :
```
sudo pacman -Syu dconf-editor evince powertop ffmpegthumbnailer profile-cleaner seahorse pamac celluloid extension-manager fragments papers yay nicotine+ resources
```
et

```
yay -S libre-menu-editor
```

* **32** - Installer `Dropbox` avec Maestral : créer le répertoire Dropbox dans /home puis lancer le script *maestral_install* 

----------------------------------------------------------------------------------------------

## 🐾 **E - Réglages de l'UI Gnome Shell** 

* **34** - Installer `nautilus-admin` :

```
#Créer un dossier pour les builds AUR si nécessaire :
mkdir -p ~/aur-build cd ~/aur-build 
#Cloner le dépôt AUR :
git clone https://aur.archlinux.org/nautilus-admin-gtk4.git
#Entrer dans le dossier cloné :
cd nautilus-admin-gtk4 
#Construire et installer le paquet :
makepkg -si
nautilus -q
nautilus
```

* **35** - Régler Nautilus & créer un marque-page pour `Dropbox`, pour l'accès `ftp` au disque SSD sur la TV Android, et pour lancer Nautilus en root depuis le panneau latéral :
```
192.168.31.68:2121
```

* **36** - Modifier le mot de passe au démarrage avec le logiciel `Mots de Passe`, puis laisser les champs vides. Penser à reconnecter le compte Google dans Gnome.

* **37** - Installer le [wallpaper F34](https://fedoraproject.org/w/uploads/d/de/F34_default_wallpaper_night.jpg) OU celui disponible dans le dossier `Images USER`, et le thème de curseurs [Phinger NO LEFT Light](https://github.com/phisch/phinger-cursors/releases) : créer le répertoir de destination avec `mkdir -p ~/.local/share/icons/apps`, y déplacer le dossier *phingers-cursor-light*  puis utiliser `dconf-editor` pour les passer en taille 32 :
```
org/gnome/desktop/interface/cursor-size
```
* **38** - Régler `HiDPI` sur 125, cacher les dossiers Modèles, Bureau, ainsi que le wallaper et l'image user, augmenter la taille des icones dossiers.
  
* **39** Renommer les `logiciels dans l'overview`, cacher ceux qui sont inutiles de faàon à n'avoir qu'une seule et unique page, en utilisant le logiciel `Menu Principal`.
En profiter pour changer avec Menu Principal l'icone de `Ptyxis`, en la remplaçant par celle de [gnome-terminal](https://upload.wikimedia.org/wikipedia/commons/d/da/GNOME_Terminal_icon_2019.svg)

* **40** - Installer diverses `extensions` :

Extensions esthétiques :

a - [Panel Corners](https://extensions.gnome.org/extension/4805/panel-corners/)

c - [Hide Activities Button](https://extensions.gnome.org/extension/744/hide-activities-button/)

d - [Remove World Clock](https://extensions.gnome.org/extension/6973/remove-world-clocks/)

Extensions apportant des fonctions de productivité :

e - [Appindicator](https://extensions.gnome.org/extension/615/appindicator-support/)

g - [Caffeine](https://extensions.gnome.org/extension/517/caffeine/)

h - [Clipboard History](https://extensions.gnome.org/extension/4839/clipboard-history/)

Extensions apportant des fonctions UI :  

i - [Battery Time Percentage Compact](https://extensions.gnome.org/extension/2929/battery-time-percentage-compact/) ou [Battery Time](https://extensions.gnome.org/extension/5425/battery-time/)
     
l - [AutoActivities](https://extensions.gnome.org/extension/5500/auto-activities/)

m - [Auto Screen Brightness](https://extensions.gnome.org/extension/7311/auto-screen-brightness/) & supprimer la luminosité automatique dans Settings de Gnome

n - [Hot Edge](https://extensions.gnome.org/extension/4222/hot-edge/)
    
p - [Frequency Boost Switch](https://extensions.gnome.org/extension/4792/frequency-boost-switch/)

q - [Custom Command Toggle](https://extensions.gnome.org/extension/7012/custom-command-toggle/)  

r - Pop Shell Tiling : `yay -S gnome-shell-extension-pop-shell`
puis supprimer le theme icone Pop dans /usr/share/icons

* **41** - Installer Open with Ptyxis :
```
yay -S nautilus-open-any-terminal
```
et penser à éditer sa clé dconf com.github.stunkymonkey.nautilus-open-any-terminal pour inscrire "ptyxis".

* **42** - Activer le [numpad Asus](https://github.com/asus-linux-drivers/asus-numberpad-driver), disable le service --user, puis créer un toggle button avec icone `accessories-calculator-symbolic` :
```
systemctl enable --user asus_numberpad_driver@ogu.service && systemctl start --user asus_numberpad_driver@ogu.service &&  notify-send "Numpad activé"
systemctl stop --user asus_numberpad_driver@ogu.service && systemctl disable --user asus_numberpad_driver@ogu.service &&  notify-send "Numpad désactivé"
```

* **43** - Régler `Gnome-text-editor`et `Ptyxis`, configurer `fish` avec `sudo gnome-text-editor /usr/share/cachyos-fish-config/cachyos-config.fish` et saisir :
  
```
# Désactive fastfetch en tant que message de bienvenue
# function fish_greeting
#     fastfetch
# end
```
Et recharger la configuration de fish avec `source /usr/share/cachyos-fish-config/cachyos-config.fish`


* **44** - Changer l'icone Pamac:
```
mkdir -p ~/.local/share/icons && \
wget -O ~/.local/share/icons/pamac.svg https://raw.githubusercontent.com/somepaulo/MoreWaita/b439fe8e2df83abc6cf02a0544a101426611e8ea/scalable/apps/pamac.svg 

```
puis éditer le raccourci avec Menu Libre.


  
* **44** - `Celluloid` :
inscrire `vo=gpu-next` dans Paramètres --> Divers --> Options supplémentaires, activer l'option `focus` et `toujours afficher les boutons de titre`, enfin installer les deux scripts lua suivants pour la musique :
[Visualizer](https://www.dropbox.com/scl/fi/bbwlvfhtjnu8sgr4yoai9/visualizer.lua?rlkey=gr3bmjnrlexj7onqrxzjqxafl&dl=0)
[Delete File avec traduction française](https://www.dropbox.com/scl/fi/c2cacmw2a815husriuvc1/delete_file.lua?rlkey=6b9d352xtvybu685ujx5mpv7v&dl=0)

* **45** - `Jdownloader`: réglages de base, font Noto Sans Regular, désactivatioin du dpi et font sur 175; puis désactiver les éléments suivants : tooltip, help, Update Button Flashing, banner, Premium Alert, Donate, speed meter visible.

* **46** - Script de `transfert des vidéos` intitulé `transfert_videos` pour déplacer automatiquement les vidéos vers Vidéos en supprimant le sous-dossier d'origine.
Le télécharger depuis le dossier `SCRIPTS`, le coller dans /home/ogu/.local/bin/, en faire un raccourci avec l'éditeur de menu, passer le chemin `/home/ogu/.local/bin/` et lui mettre l'icone `/usr/share/icons/Adwaita/scalable/devices/drive-multidisk.svg`

* **48** - Accélérer les `animations` :  saisir
```
GNOME_SHELL_SLOWDOWN_FACTOR=0.75
```
dans le fichier 
```
sudo gnome-text-editor /etc/environment
```

* **49** - `Scripts` Nautilus :

`Hide.py` et `Unhide.py` pour masquer/rendre visibles les fichiers
A télécharger depuis le dossier `SCRIPTS` puis à coller dans le dossier `/home/ogu/.local/share/nautilus/scripts/.
Penser à les rendre exécutables!


* **50** Enlever le powersave de la souris Inphic :  créer une règle udev pour que Linux applique power/control=on automatiquement à chaque démarrage :
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
* **51** - Faire le tri dans `~/.local/share/`, `/home/ogu/.config/`, `/usr/share/` et `/etc/`
----------------------------------------------------------------------------------------------

 
## 🌐 **F - Réglages du navigateur Firefox**

* **52** - Réglages internes de `Firefox` (penser à activer CTRL-TAB pour faire défiler dans l'ordre d'utilisation & à passer sur `Sombre` plutot qu'`auto` le paramètre `Apparence des sites web`)

* **53** - Changer le `thème` pour [Gnome Dark ](https://addons.mozilla.org/fr/firefox/addon/adwaita-gnome-dark/?utm_content=addons-manager-reviews-link&utm_medium=firefox-browser&utm_source=firefox-browser)

* **54** - Dans `about:config` :
  
a - `ui.key.menuAccessKey` = 0 pour désactiver la touche Alt qui ouvre les menus
  
b - `browser.sessionstore.interval` à `600000` pour réduire l'intervalle de sauvegarde des sessions

d - `devtools.f12_enabled` = false

e - `accessibility.force_disabled` = 1 pour supprimer l'accessibilité

f - `extensions.screenshots.disabled` = true pour désactiver le screenshot

g - `privacy.userContext.enabled` = false pour désactiver les containers

h - `browser.tabs.crashReporting.sendReport` = false

i - `network.http.max-persistent-connections-per-server` = 10  

j - `image.mem.decode_bytes_at_a_time` = 131072

l - `dom.battery.enabled` = false 

m - `extensions.htmlaboutaddons.recommendations.enabled` = false pour désactiver l'affichage des "extensions recommandées" dans le menu de Firefox

o - `apz.overscroll.enabled` = false pour supprimer le rebonb lors d uscroll jusqu'en fin de page

p - `browser.cache.disk.parent_directory` à créer sour forme de `chaine`, et lui passer l'argument /run/user/1000/firefox, afin de déplacer le cache en RAM. Saisir `
about:cache` pour contrôle. 

q - `media.autoplay.default` sur 2 (les vidéos ne se lancent que si on clique dessus)

r - `telemetry` : passer en false
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
s - `media.ffmpeg.vaapi.enabled` sur true

u - pour activer userChrome : toolkit.legacyUserProfileCustomizations.stylesheets sur true

* **55** - **Extensions**
  
a - [uBlock Origin](https://addons.mozilla.org/fr/firefox/addon/ublock-origin/) : réglages à faire + import des deux listes sauvegardées
  
b - [Auto Tab Discard](https://addons.mozilla.org/fr/firefox/addon/auto-tab-discard/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=featured) : importer les réglages avec le fichier de backup et bien activer les 2 options de dégel des onglets à droite et à gauche de l'onglet courant.

c - [Raindrop](https://raindrop.io/r/extension/firefox) et supprimer `Pocket` de Firefox avec `extensions.pocket.enabled` dans `about:config` puis supprimer le raccourci dans la barre.
  
d - [Clear Browsing Data](https://addons.mozilla.org/fr/firefox/addon/clear-browsing-data/)
  
e - [Undo Close Tab Button](https://addons.mozilla.org/firefox/addon/undoclosetabbutton) et mettre ALT-Z comme raccourci à partir du menu général des extensions (roue dentée)

f - [LocalCDN](https://addons.mozilla.org/fr/firefox/addon/localcdn-fork-of-decentraleyes/), puis faire le [test](https://decentraleyes.org/test/).

g - [Side View](https://addons.mozilla.org/fr/firefox/addon/side-view/)

h - [Scroll To Top](https://addons.mozilla.org/fr/firefox/addon/scroll-to-top-button-extension/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)


* **56** - Activer `openh264` & `widevine` dans les plugins firefox.
  
* **57** - Télécharger le *userChrome et le coller dans le répertoire par défaut de Firefox dans un dossier chrome. Le profil se trouve dans about:support

* **58** - Mettre le profil de Firefox en RAM avec `profile-sync-daemon` :
* ATTENTION : suivre ces consignes avec **Firefox fermé** - utiliser le browser secondaire WEB
  
Installer psd (avec dnf `sudo dnf install profile-sync-daemon`, ou avec make en cas d'échec - voir le fichier INSTALL sur le Github), puis l'activer avec les commandes suivantes (sans quoi le service échoue à démarrer) :
```
psd
systemctl --user daemon-reload
sytemctl --user enable psd
reboots
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



## 🪛 **G - Maintenance de la distribution**
 en cours de rédaction
```
sudo dnf autoremove
sudo dnf -y upgrade --refresh
sudo dnf clean all
flatpak update
profile-cleaner f
```

Unmask temporaire de fwupd puis 
sudo fwupdmgr get-devices 
sudo fwupdmgr refresh --force 
sudo fwupdmgr get-updates 
sudo fwupdmgr update
???

flatpak uninstall --unused
flatpak run io.github.flattool.Warehouse

sudo fsck -n /boot sudo fsck -n /boot/efi

rm -rf /home/ogu/.cache/mozilla/firefox/h12vhg1e.default-release/cache2/*

Regarder script de F39


💡 A TESTER :



  ```

