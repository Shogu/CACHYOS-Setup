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



🐧 Mémo pour le setup complet de **CachyOS** sur laptop **ASUS ZENBOOK S13 FLIP OLED UP5302Z** 

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

----------------------------------------------------------------------------------------------


## ✨ **B - Allégement du système**

* **6** - Faire les réglages proposés par `CachyOS-Hello` : désactiver le bluetooth, activer bpftune, classer les miroirs, NE PAS installer ananicy ni psd (l'installation échoue)

* **7** - Supprimer les `logiciels inutiles` avec Gnome-software & Octopi
  
* **8** - Compléter en supprimant les `logiciels inutiles` suivants avec pacman :
```
sudo pacman -Rns apache  speech-dispatcher gnome-remote-desktop gnome-backgrounds  gnome-user-share yelp brltty  gnome-weather rygel totem  gnome-user-docs  baobab  f2fs-tools mod_dnssd gnome-user-share orca gnome-user-docs yelp sane colord-sane
gvfs-dnssd gvfs-smb mod_dnssd  gnome-user-share rygel nss-mdns

```
    
* **9** - Supprimer et masquer les services `SYSTEM` & `USER` inutiles :
**SYSTEM**
```
sudo systemctl mask plymouth-quit-wait.service
sudo systemctl mask avahi-daemon.service
sudo systemctl mask sys-kernel-debug.mount
sudo systemctl mask sys-kernel-tracing.mount
sudo systemctl mask avahi-daemon.socket

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

```
Puis contrôler avec :
```
systemd-analyze --user blame
```


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
#watchdogs
blacklist iTCO_vendor_support
blacklist iTCO_wdt
blacklist wdat_wdt
blacklist intel_pmc_bxtvidia

#driver pour nvidia
blacklist nouveaudrivers

#drivers inutiles
blacklist ELAN:Fingerprint
blacklist btusb
blacklist joydev

#drivers accéléromètre et capteur luminosité
blacklist hid_sensor_accel_3d
blacklist hid_sensor_als
blacklist hid_sensor_trigger
blacklist hid_sensor_iio_common
blacklist hid_sensor_hub
blacklist industrialio
blacklist industrialio_triggered_buffer

#drivers netbios
blacklist nf_conntrack_netbios_ns
blacklist nf_conntrack_broadcast

#drivers son realtek
blacklist snd_hda_codec_realtek
blacklist snd_hda_codec_generic

#tty
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

# COMPRESSION
# Use this to compress the initramfs image. By default, zstd compression
# is used for Linux ≥ 5.9 and gzip compression is used for Linux < 5.9.
# Use 'cat' to create an uncompressed image.
#COMPRESSION="zstd"
#COMPRESSION="gzip"
#COMPRESSION="bzip2"
#COMPRESSION="lzma"
#COMPRESSION="xz"
#COMPRESSION="lzop"
#COMPRESSION="lz4"
COMPRESSION="cat"
```
Recharger l'initrd avec `sudo mkinitcpio -P`

## 🚀 **C - Optimisation du système**

* **16** - Passer `xwayland` en autoclose : sur dconf-editor, modifier la clé suivante.
```
org.gnome.mutter experimental-features
```

* **17** - Optimiser le `kernel` :
```
sudo gnome-text-editor /etc/sdboot-manage.conf
```
Puis saisir :
```
LINUX_OPTIONS="zswap.enabled=0 nowatchdog mitigations=off loglevel=0 noresume console=tty0 systemd.show_status=false ipv6.disable=1 cgroupdisable=rdma 8250.nr_uarts=0 fsck.mode=skip rcu_nocbs=0-(nproc-1) rcutree.enable_rcu_lazy=1 quiet splash"
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
`sudo gnome-text-editor /etc/fstab`

Désactiver le fsck en mettant les partitions sur 0 0

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
flatpak install flathub com.mattjakeman.ExtensionManager -y
flatpak install flathub org.jdownloader.JDownloader -y
flatpak install flathub org.onlyoffice.desktopeditors -y
flatpak install flathub de.haeckerfelix.Fragments -y
flatpak install flathub org.gnome.Papers -y
flatpak install flathub page.codeberg.libre_menu_editor.LibreMenuEditor -y
flatpak install flathub io.github.celluloid_player.Celluloid -y
flatpak install flathub org.nicotine_plus.Nicotine -y
flatpak install flathub de.schmidhuberj.tubefeeder -y
flatpak install flathub app.ytmdesktop.ytmdesktop -y
```

* **31** - Installer les `logiciels` suivants avec dnf :
```
sudo pacman -Syu dconf-editor evince powertop ffmpegthumbnailer profile-cleaner seahorse pamac
```

* **32** - Installer `Dropbox` :
```
sudo pacman -S libappindicator-gtk3
yay -S dropbox
dropbox start -i
yay -S nautilus-dropbox

si erreur 8 :

cd ~/.cache/yay/nautilus-dropbox
rm -rf pkg src
makepkg -si
```
---------------------------------------------------------------------------------------------


## 🐾 **E - Réglages de l'UI Gnome Shell** 

* **34** - Régler le système avec `Paramètres` puis `Ajustements` (Changer les polices d'écriture pour `Noto Sans` en 11)

* **35** - Régler Nautilus & créer un marque-page pour `Dropbox` & pour l'accès `ftp` au disque SSD sur la TV Android :
```
192.168.31.68:2121
```

* **36** - Modifier le mot de passe au démarrage avec le logiciel `Mots de Passe`, puis laisser les champs vides. Penser à reconnecter le compte Google dans Gnome.

* **37** - Installer le [wallpaper F34](https://fedoraproject.org/w/uploads/d/de/F34_default_wallpaper_night.jpg) OU celui disponible dans le dossier `Images USER`, et le thème de curseurs [Phinger NO LEFT Light](https://github.com/phisch/phinger-cursors/releases); utiliser `dconf-editor` pour les passer en taille 32 :
```
org/gnome/desktop/interface/cursor-size
```
* **38** - Régler `HiDPI` sur 125, cacher les dossiers Modèles, Bureau, ainsi que le wallaper et l'image user, augmenter la taille des icones dossiers.
  
* **39** Renommer les `logiciels dans l'overview`, cacher ceux qui sont inutiles de faàon à n'avoir qu'une seule et unique page, en utilisant le logiciel `Menu Principal`.
En profiter pour changer avec Menu Principal l'icone de `Ptyxis`, en la remplaçant par celle de [gnome-terminal](https://upload.wikimedia.org/wikipedia/commons/d/da/GNOME_Terminal_icon_2019.svg)

* **40** - Installer diverses `extensions` :

Extensions esthétiques :

a - [Panel Corners](https://extensions.gnome.org/extension/4805/panel-corners/)

b - [Rounded Windows Corners](https://extensions.gnome.org/extension/7048/rounded-window-corners-reborn/)

c - [Hide Activities Button](https://extensions.gnome.org/extension/744/hide-activities-button/)

d - [Remove World Clock](https://extensions.gnome.org/extension/6973/remove-world-clocks/)

Extensions apportant des fonctions de productivité :

e - [Appindicator](https://extensions.gnome.org/extension/615/appindicator-support/)

f - [Alphabetical Grid](https://extensions.gnome.org/extension/4269/alphabetical-app-grid/)

g - [Caffeine](https://extensions.gnome.org/extension/517/caffeine/)

h - [Clipboard History](https://extensions.gnome.org/extension/4839/clipboard-history/)

Extensions apportant des fonctions UI :  

i - [Battery Time Percentage Compact](https://extensions.gnome.org/extension/2929/battery-time-percentage-compact/) ou [Battery Time](https://extensions.gnome.org/extension/5425/battery-time/)

j - [Privacy Quick Settings](https://extensions.gnome.org/extension/4491/privacy-settings-menu/) puis la supprimer une fois les réglages réalisés.
 
k - [Grand Theft Focus](https://extensions.gnome.org/extension/5410/grand-theft-focus/)
    
l - [AutoActivities](https://extensions.gnome.org/extension/5500/auto-activities/)

m - [Auto Screen Brightness](https://extensions.gnome.org/extension/7311/auto-screen-brightness/) & supprimer la luminosité automatique dans Settings de Gnome

n - [Hot Edge](https://extensions.gnome.org/extension/4222/hot-edge/)
  
o - [Auto Power Profile](https://extensions.gnome.org/extension/6583/auto-power-profile/)
  
p - [Frequency Boost Switch](https://extensions.gnome.org/extension/4792/frequency-boost-switch/)
    
Extension à désactiver :

q - désactiver l'extension native `Background logo`

* **41** - Installer [Nautilus-admin](https://download.copr.fedorainfracloud.org/results/tomaszgasior/mushrooms/fedora-41-x86_64/07341996-nautilus-admin/nautilus-admin-1.1.9-5.fc41.noarch.rpm) puis lancer la commande ```nautilus -q``` pour relancer Fichiers

* **42** - Activer le [numpad Asus](https://github.com/asus-linux-drivers/asus-numberpad-driver)

* **43** - Régler `fish`, en saisissant dans `sudo gnome-text-editor /home/ogu/.config/fish/` le code suivant :
```
source /usr/share/cachyos-fish-config/cachyos-config.fish

# overwrite greeting
# potentially disabling fastfetch
function fish_greeting
#    # smth smth
end
```
Et recharger la configuration de fish avec `source /usr/share/cachyos-fish-config/cachyos-config.fish`

Créer un alias pour sudo -E afin d'éviter les polices floues en root : 

```
function sudo
      command sudo -E $argv
  end
```
puis enregistrer avec :

```
funcsave sudo
```

  
* **44** - `Celluloid` :
inscrire `vo=gpu-next` dans Paramètres --> Divers --> Options supplémentaires, activer l'option `focus` et `toujours afficher les boutons de titre`, enfin installer les deux scripts lua suivants pour la musique :
[Visualizer](https://www.dropbox.com/scl/fi/bbwlvfhtjnu8sgr4yoai9/visualizer.lua?rlkey=gr3bmjnrlexj7onqrxzjqxafl&dl=0)
[Delete File avec traduction française](https://www.dropbox.com/scl/fi/c2cacmw2a815husriuvc1/delete_file.lua?rlkey=6b9d352xtvybu685ujx5mpv7v&dl=0)

* **45** - `Jdownloader`: réglages de base, thème Black Moon puis icones Flat; font Noto Sans Regular, désactivatioin du dpi et font sur 175; puis désactiver les éléments suivants : tooltip, help, Update Button Flashing, banner, Premium Alert, Donate, speed meter visible.

* **46** - Script de `transfert des vidéos` intitulé `.transfert_videos` pour déplacer automatiquement les vidéos vers Vidéos en supprimant le sous-dossier d'origine.
Le télécharger depuis le dossier `SCRIPTS`, en faire un raccourci avec l'éditeur de menu, passer le chemin `sh /home/ogu/.transfert_videos.sh` et lui mettre l'icone `/usr/share/icons/Adwaita/scalable/devices/drive-multidisk.svg`

* **48** - Accélérer les `animations` :  saisir
```
GNOME_SHELL_SLOWDOWN_FACTOR=0.5
```
dans le fichier 
```
sudo gnome-text-editor /etc/environment
```

* **49** - `Scripts` Nautilus :

`Hide.py` et `Unhide.py` pour masquer/rendre visibles les fichiers
A télécharger depuis le dossier `SCRIPTS` puis à coller dans le dossier `/home/ogu/.local/share/nautilus/scripts/.
Penser à les rendre exécutables!

* **50** - `LibreOffice` : régler l'UI et les paramètres, désactiver Java, rajouter `-nologo` au raccourci avec l'éditeur de menu pour supprimer le splash screen, passer à `600000000` la valeur de `Graphic Manager` + `UseOpenGL` = true + `UseSkia` = true dans la Configuration Avancée + désactiver l'enregistrement des données personnelles dans les fichiers (Menu Sécurité). 

* **51** - Faire le tri dans `~/.local/share/`, `/home/ogu/.config/`, `/usr/share/` et `/etc/`
----------------------------------------------------------------------------------------------

 
## 🌐 **F - Réglages du navigateur Firefox**

* **52** - Réglages internes de `Firefox` (penser à activer CTRL-TAB pour faire défiler dans l'ordre d'utilisation & à passer sur `Sombre` plutot qu'`auto` le paramètre `Apparence des sites web`)

* **53** - Changer le `thème` pour [Materia Dark](https://addons.mozilla.org/fr/firefox/addon/materia-dark-theme/) ou [Gnome Dark ](https://addons.mozilla.org/fr/firefox/addon/adwaita-gnome-dark/?utm_content=addons-manager-reviews-link&utm_medium=firefox-browser&utm_source=firefox-browser)

* **54** - Dans `about:config` :
  
a - `ui.key.menuAccessKey` = 0 pour désactiver la touche Alt qui ouvre les menus
  
b - `browser.sessionstore.interval` à `600000` pour réduire l'intervalle de sauvegarde des sessions

c - `extensions.pocket.enabled` = false, `browser.newtabpage.activity-stream.discoverystream.sendToPocket.enable` = false, et supprimer Pocket de la barre d'outils si besoin

d - `devtools.f12_enabled` = false

e - `accessibility.force_disabled` = 1 pour supprimer l'accessibilité

f - `extensions.screenshots.disabled` = true pour désactiver le screenshot

g - `privacy.userContext.enabled` = false pour désactiver les containers

h - `browser.tabs.crashReporting.sendReport` = false

i - `network.http.max-persistent-connections-per-server` = 10  

j - `image.mem.decode_bytes_at_a_time` = 131072

k - `browser.translations.enable` = false

l - `dom.battery.enabled` = false 

m - `extensions.htmlaboutaddons.recommendations.enabled` = false pour désactiver l'affichage des "extensions recommandées" dans le menu de Firefox

n - `sidebar.revamp` = true, puis régler la barre latérale

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

* **55** - **Extensions**
  
a - [uBlock Origin](https://addons.mozilla.org/fr/firefox/addon/ublock-origin/) : réglages à faire + import des deux listes sauvegardées
  
b - [Auto Tab Discard](https://addons.mozilla.org/fr/firefox/addon/auto-tab-discard/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=featured) : importer les réglages avec le fichier de backup et bien activer les 2 options de dégel des onglets à droite et à gauche de l'onglet courant.

c - [Raindrop](https://raindrop.io/r/extension/firefox) et supprimer `Pocket` de Firefox avec `extensions.pocket.enabled` dans `about:config` puis supprimer le raccourci dans la barre.
  
d - [Clear Browsing Data](https://addons.mozilla.org/fr/firefox/addon/clear-browsing-data/)
  
e - [Undo Close Tab Button](https://addons.mozilla.org/firefox/addon/undoclosetabbutton) et mettre ALT-Z comme raccourci à partir du menu général des extensions (roue dentée)

f - [LocalCDN](https://addons.mozilla.org/fr/firefox/addon/localcdn-fork-of-decentraleyes/), puis faire le [test](https://decentraleyes.org/test/).

g - [Side View](https://addons.mozilla.org/fr/firefox/addon/side-view/)

h - [Scroll To Top Lite](https://addons.mozilla.org/fr/firefox/addon/scroll-to-top-lite/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)

* **56** - Activer `openh264` & `widevine` dans les plugins firefox.
  
* **57** - Désactiver les `recherches populaires` : dans la barre d'adresse, cliquer en bas sur la roue dentée correspondant à Recherches populaires et les désactiver.

* **58** - Mettre le profil de Firefox en RAM avec `profile-sync-daemon` :
* ATTENTION : suivre ces consignes avec **Firefox fermé** - utiliser le browser secondaire WEB
  
Installer psd (avec dnf `sudo dnf install profile-sync-daemon`, ou avec make en cas d'échec - voir le fichier INSTALL sur le Github), puis l'activer avec les commandes suivantes (sans quoi le service échoue à démarrer) :
```
psd
systemctl --user daemon-reload
sytemctl --user enable psd
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
sudo gnome-text-editor /home/ogu/.config/psd/psd.conf *# The default is to save the most recent 5 crash recovery snapshots BACKUP_LIMIT=2 & BROWSERS=(firefox)
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





















****************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************************


💡 A TESTER :

* - Remplacement de wpa_supplicant par `iwd` pour le **wifi**
 
ATTENTION : a ureboot la connection auto ne se fait pas, voir les reglages de config de iwd
ATTENTION2 : le service démarre plus lentement que wpa_supplicant, à voir le temps de boot pour network-manager avec iwd plutot que wpa

Installer iwd :
```
sudo dnf install iwd -y
```
Lancer le service iwd et désactiver temporairement wpa_supplicant
```
sudo systemctl start iwd
sudo systemctl stop wpa_supplicant
sudo systemctl disable wpa_supplicant
```
Puis créer le fichier de configuration de NetworkManager : 
```
sudo gnome-text-editor /etc/NetworkManager/conf.d/00-iwd.conf
```
Ajouter les lignes suivantes :
```
[device]
wifi.backend=iwd

[main]
dns=systemd-resolved
```
Redémarrer NetworkManager pour appliquer la configuration :
```
sudo systemctl restart NetworkManager
```
Se reconnecter & vérifier l'état des connexions Wi-Fi avec `nmcli` :
```
nmcli device status
```
Si la connection est fonctionnelle, activer le service iwd au boot :
```
sudo systemctl enable iwd
```
Reboot, puis suppression de wpa_supplicant :
```
sudo dnf remove wpa_supplicant
```
    
* Créer un toggle `Powertop` qui va lancer powertop en `auto-tune` pour économiser encore plus de batterie, et baisser la luminosité sur 5% : rentrer cette commande pour le toggle activé :
```
pkexec powertop --auto-tune && gdbus call --session --dest org.gnome.SettingsDaemon.Power --object-path /org/gnome/SettingsDaemon/Power --method org.freedesktop.DBus.Properties.Set org.gnome.SettingsDaemon.Power.Screen Brightness " <int32 5>"()
```
  
Et cette commande pour le toggle désactivé :
```
gdbus call --session --dest org.gnome.SettingsDaemon.Power --object-path /org/gnome/SettingsDaemon/Power --method org.freedesktop.DBus.Properties.Set org.gnome.SettingsDaemon.Power.Screen Brightness " <int32 2O>"()
```
Enfin rentrer le nom de l'icone : `thunderbolt-symbolic` 

* Créer un toggle "No Touchscreen" et le rendre permanent au boot :
    
```
echo 'i2c-ELAN9008:00' | pkexec tee /sys/bus/i2c/drivers/i2c_hid_acpi/unbind > /dev/null
```
```
echo 'i2c-ELAN9008:00' | pkexec tee /sys/bus/i2c/drivers/i2c_hid_acpi/bind > /dev/null                         
```






  ```

