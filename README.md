
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



### ✨ A - Allégement du système
- [4 - Supprimer entrées NVRAM inutiles](#id-4)
- [6 - Réglages CachyOS-Hello](#id-6)
- [7 - Supprimer logiciels inutiles avec pacman](#id-7)
- [8 - Améliorer Fonts](#id-8)
- [9 - Supprimer et masquer services SYSTEM & USER](#id-9)
- [10 - Désactiver autostart gnome-wellbeing](#id-10)
- [11 - Alléger journaux système et mettre en RAM](#id-11)
- [12 - Supprimer coredump](#id-12)
- [13 - Blacklister pilotes inutiles](#id-13)
- [14 - Réduire l'initramfs et le firmware](#id-14)
- [15 - Désactiver capteur de luminosité Gnome](#id-15)

### 🚀 B - Optimisation du système
- [16 - Activer scheduler ADIOS](#id-16)
- [17 - Passer xwayland en autoclose et activer scale-monitor](#id-17)
- [18 - Réduire le temps d'affichage du menu systemd-boot](#id-18)
- [19 - Tweaker les partitions EXT4](#id-19)
- [20 - Régler makepkg pour compiler en zenver4](#id-20)
- [21 - Désactiver mitigate split lock](#id-21)
- [22 - Activer le mode EPP `power_performance` pour le profil Gnome `Balanced` quand le PC est sur batterie](#id-22) 
- [23 - Régler le pare-feu](#id-23)
- [24 - Passer à 0 le nombre de ttys au boot](#id-24)
- [25 - Optimiser le kernel](#id-25) avec des arguments et le sched-ext
- [26 - Régler wifi](#id-26)

### 📦 C - Remplacement et installation de logiciels et codecs
- [27 - Installer logiciels avec pacman et paru](#id-27)
- [28 - Installer Dropbox avec Maestral](#id-28)

### 🐾 D - Réglages de l'UI Gnome Shell
- [29 - Suspension en fermant le capot](#id-29)
- [30 - Régler Nautilus et marque-pages](#id-30)
- [31 - Modifier mot de passe au démarrage](#id-31)
- [32 - Installer wallpaper et thème curseurs](#id-32)
- [33 - Régler HiDPI et cacher dossiers](#id-33)
- [34 - Renommer logiciels dans overview](#id-34)
- [35 - Installer extensions Gnome](#id-35)
- [36 - Bonus Ptyxis](#id-36)
- [37 - Activer numpad Asus](#id-37)
- [38 - Configurer fish et gnome-text-editor](#id-38)
- [39 - JamesDSP](#id-39)
- [40 - Configurer Celluloid](#id-40)
- [41 - Configurer JDownloader & Fragments](#id-41)
- [42 - Script transfert vidéos](#id-42)
- [43 - Réglages permissions](#id-43)
- [44 - Scripts Nautilus](#id-44)
- [45 - Supprimer Plymouth](#id-45)
- [46 - Modifier nom toggle profil énergétique](#id-46)
- [47 - Créer raccourcis boot to BIOS, Ressources & Ptyxis](#id-47)
- [48 - Faire le tri dans les LOCALES & ~/.local/share, ~/.config et /etc](#id-48)
- ## 48 - Créer modèles de fichier dans Nautilus

### 🌐 E - Réglages du navigateur Vivaldi
- [57 - Réglages internes Vivaldi](#id-57)
- [58 - Changer thème Vivaldi](#id-58)
- [59 - Extensions Vivaldi](#id-59)
- [60 - Panneau latéral Vivaldi](#id-60)
- [61 - "Nettoyer" Vivaldi](#id-61)










----------------------------------------------------------------------------------------------

# ✨ A - Allégement du système

!! Installer TOUT DE SUITE le fichier config.fish de FISH pour faciliter les opérations (sudoedit etc...). Sourcer fish avec `source ~/.config/fish/config.fish`

<a id="id-4"></a>
## 4 - Supprimer entrées NVRAM inutiles
```
sudo efibootmgr -v

```
Puis lister les entrées inutiles et redondantes et les supprimer avec :
```
sudo efibootmgr -b 0000 -B
sudo efibootmgr -b 0001 -B
sudo efibootmgr -b 0002 -B
etc
```

<a id="id-6"></a>
## 6 - Réglages CachyOS-Hello
Faire les réglages proposés par `CachyOS-Hello` : désactiver le bluetooth, activer cachy-update tray, classer les miroirs, NE PAS installer psd (il faut l'installer en --user)

<a id="id-7"></a>
## 7 - Supprimer logiciels inutiles avec pacman

Accessibilité et aide

- `speech-dispatcher` : synthèse vocale.
- `brltty` : support des afficheurs braille.
- `orca` : lecteur d’écran GNOME.
- `yelp` : visionneuse d’aide GNOME.
- `gnome-user-docs` : documentation utilisateur GNOME.

```
sudo pacman -Rns speech-dispatcher brltty orca yelp gnome-user-docs
```

GNOME optionnel

- `gnome-remote-desktop` : partage et contrôle du bureau à distance.
- `gnome-backgrounds` : fonds d’écran GNOME.
- `gnome-weather` : application météo.
- `totem` : lecteur vidéo GNOME.
- `baobab` : analyseur d’espace disque.
- `gnome-usage` : vue d’usage CPU, RAM et disque.
- `gedit` : éditeur de texte GNOME.
- `gnome-screenshot` : captures d’écran.
- `sushi` : prévisualisation rapide dans Nautilus.

```
sudo pacman -Rns gnome-remote-desktop gnome-backgrounds gnome-weather totem baobab gnome-usage gedit gnome-screenshot sushi
```

Partage réseau, découverte, montage périphériques

- `apache` : serveur web HTTP.
- `mod_dnssd` : annonce Apache via DNS-SD/Zeroconf.
- `gnome-user-share` : partage de fichiers et médias dans GNOME.
- `rygel` : serveur DLNA/UPnP.
- `gvfs-dnssd` : découverte réseau GNOME.
- `gvfs-smb` : accès aux partages Windows/NAS dans Nautilus.
- `nss-mdns` : résolution des noms `.local`.
- `gvfs-afc` : accès iPhone/iPad dans Nautilus.
- `gvfs-gphoto2` : accès aux appareils photo/PTP.
- `netctl` : alternative à NetworkManager.
- `nfs-utils` : outils et services NFS, pour monter un dossier distant comme un dossier local sur un réseau Linux/Unix.
- `gvfs-nfs` : accès NFS via Nautilus et GNOME.
- `gvfs-smb` : accès aux partages SMB dans Nautilus.
- `cifs-utils` : outils de montage SMB/CIFS côté système.

```
sudo pacman -Rns apache mod_dnssd gnome-user-share rygel gvfs-dnssd gvfs-smb nss-mdns gvfs-afc gvfs-gphoto2 netctl nfs-utils gvfs-nfs gvfs-smb
```

VPN

- `openvpn` : client/protocole VPN OpenVPN.
- `networkmanager-openvpn` : intégration OpenVPN dans NetworkManager.
- `networkmanager-vpn-plugin-openvpn` : plugin OpenVPN pour NetworkManager.

```
sudo pacman -Rns openvpn networkmanager-openvpn networkmanager-vpn-plugin-openvpn
```

Systèmes de fichiers et scanners

- `f2fs-tools` : outils pour partitions F2FS.
- `xfsprogs` : outils pour partitions XFS.
- `btrfs-progs` : outils pour Btrfs.
- `sane` : support des scanners.
- `colord-sane` : lien entre scanners et gestion couleur.
- `hwinfo` : inventaire matériel.

```
sudo pacman -Rns f2fs-tools xfsprogs sane colord-sane hwinfo
```

Polices

- `noto-fonts-cjk` : polices chinois, japonais, coréen.
- `noto-fonts-extra` : variantes supplémentaires Noto.
- `ttf-meslo-nerd` : police Nerd Font.
- `cantarell-fonts` : police d’interface GNOME.

```
sudo pacman -Rns noto-fonts-cjk noto-fonts-extra ttf-meslo-nerd
```

+

```
sudo pacman -rdd fastfetch
```


Développement et compilation

- `ninja` : outil de build.
- `tesseract` : OCR.
- `tesseract-data-fra` : données OCR français.
- `tesseract-data-osd` : détection orientation/script.
- `autoconf` : génération de scripts de configuration.
- `base-devel` : groupe d’outils de compilation Arch.
- `rust` : toolchain Rust.
- `lld` : linker LLVM.
- `llvm` : infrastructure de compilation LLVM.
- `pahole` : outil lié au debug/types noyau.
- `linux-cachyos-headers` : headers noyau pour modules externes.
- `linux-cachyos-lts-headers` : headers noyau LTS pour modules externes.
- `mesa-utils` : outils de test OpenGL/EGL.

```
sudo pacman -Rns ninja tesseract tesseract-data-fra tesseract-data-osd autoconf base-devel rust lld llvm pahole linux-cachyos-headers linux-cachyos-lts-headers mesa-utils
```

Flatpak et contrôle parental

- `flatpak` : gestion d’applications Flatpak.
- `malcontent` : contrôle parental et restrictions d’usage.

```
sudo pacman -Rns flatpak malcontent
```

Performances, tuning et divers

- `cpupower` : réglages d’énergie et fréquence CPU.
- `bpftune-git` : tuning via eBPF.
- `kguiaddons` : composants KDE/Qt.
- `kcolorscheme` : gestion des schémas de couleurs KDE/Qt.
- `kwallet` : gestionnaire de secrets KDE.
- `octopi` : frontend graphique pacman.
- `nano` : éditeur terminal simple.
- `plocate` : moteur de `locate`.

```
sudo pacman -Rns cpupower bpftune-git kguiaddons kcolorscheme kwallet octopi nano plocate
```

OpenCL et bibliothèques 32 bits

- `opencl-mesa` : pile OpenCL Mesa, utile pour le calcul GPU/OpenCL, pas pour un usage desktop classique.
- `lib32-opencl-mesa` : version 32 bits d’OpenCL Mesa.
- `lib32-vulkan-radeon` : pile Vulkan Radeon 32 bits, utile surtout pour applis et jeux 32 bits.
- `lib32-mesa` : pile graphique Mesa 32 bits, utile surtout pour applis et jeux 32 bits.

```
sudo pacman -Rns opencl-mesa lib32-opencl-mesa lib32-vulkan-radeon lib32-mesa
```

Orphelins : recherche puis suppression

```
pacman -Qdtq
```
```
sudo pacman -Rns $(pacman -Qdtq)
```


<a id="id-8"></a>
## 8 - Améliorer Fonts (à mettre dans section Gnome!)
Editer `sudo gnome-text-editor /etc/environment` et ajouter puis déconnexion :
FREETYPE_PROPERTIES="cff:no-stem-darkening=0 autofitter:no-stem-darkening=0"

ou moins "gras" : FREETYPE_PROPERTIES="cff:no-stem-darkening=0 autofitter:no-stem-darkening=0"


<a id="id-9"></a>
## 9 - Supprimer et masquer services SYSTEM & USER
**SYSTEM**
```
sudo systemctl mask dev-tpmrm0.device dev-tpm0.device
sudo systemctl mask systemd-tpm2-setup-early.service systemd-tpm2-setup.servicesudo systemctl mask bolt.service 
sudo systemctl mask plymouth-quit-wait.service
sudo systemctl mask systemd-hibernate-resume.service
sudo systemctl mask fwupd
sudo systemctl mask avahi-daemon.service
sudo systemctl mask sys-kernel-tracing.mount
sudo systemctl mask avahi-daemon.socket
sudo systemctl mask NetworkManager-wait-online.service
sudo systemctl mask dev-tpmrm0.device
sudo systemctl mask dev-tpm0.device
sudo systemctl mask tpm2.target
sudo systemctl mask lvm2-lvmpolld.service lvm2-monitor.service lvm2-lvmpolld.socket
sudo systemctl mask  pamac-cleancache.service
sudo systemctl mask  pamac-cleancache.timer
sudo systemctl mask  pamac-daemon.service
sudo systemctl mask bluetooth.service
sudo systemctl mask systemd-vconsole-setup.service
sudo systemctl mask systemd-tpm2-clear.service
sudo systemctl mask systemd-tpm2-setup-early.service
sudo systemctl mask systemd-tpm2-setup.service
sudo systemctl mask systemd-pcrmachine.service
sudo systemctl mask systemd-pcrphase-initrd.service
sudo systemctl mask systemd-pcrphase-sysinit.service
sudo systemctl mask systemd-pcrphase.service
sudo systemctl mask flatpak-system-helper.service
sudo systemctl maskcachyos-rate-mirrors.service
sudo systemctl mask cachyos-rate-mirrors.timer

```

Eventuellement, si pas besoin du Mode Nuit  :
sudo systemctl mask colord.service
sudo systemctl mask geoclue



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
systemctl --user mask gsd-wwan.service
systemctl --user mask gsd-disk-utility-notify.service
systemctl --user mask xdg-desktop-portal.service #service pour flatpak et conteneurs !!ATTENTION : cela désactive le dark theme
```
Puis contrôler avec :
```systemd-userdbd.service

systemd-analyze --user blame
```


<a id="id-10"></a>
## 10 - Désactiver autostart gnome-wellbeing
```
cp /usr/share/applications/gnome-wellbeing-panel.desktop ~/.config/autostart/ && sudoedit ~/.config/autostart/gnome-wellbeing-panel.desktop 

```
Saisir `Hidden=true` puis contrôler avec `grep Hidden ~/.config/autostart/gnome-wellbeing-panel.desktop`


<a id="id-11"></a>
## 11 - Alléger journaux système et les mettre en RAM
```
sudoedit /etc/systemd/journald.conf
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
créer un fichier `blacklist` ```sudoedit /etc/modprobe.d/blacklist.conf``` et l'éditer :
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
sudoedit /etc/mkinitcpio.conf

```
et copier-coller ces options de configuration dans les rubriques correspondantes :
```
MODULES=(ext4 vfat)
HOOKS=(base udev autodetect microcode modconf block plymouth fsck)
COMPRESSION="lz4"
COMPRESSION_OPTIONS=()
```
Recharger l'initrd avec `sudo mkinitcpio -P`

Firmware : utiliser seulement les paquets vendor
```
# installer uniquement les firmwares nécessaires
sudo pacman -S linux-firmware-amdgpu linux-firmware-mediatek linux-firmware-cirrus

# Supprimer le méta-paquet général et les firmwares inutiles
sudo pacman -R linux-firmware linux-firmware-intel linux-firmware-atheros linux-firmware-nvidia linux-firmware-broadcom linux-firmware-realtek linux-firmware-radeon linux-firmware-other sof-firmware alsa-firmware

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

# 🚀 B - Optimisation du système

<a id="id-16"></a>
## 16 - Activer scheduler ADIOS

En lieu et place de Kyber. Attention la méthode WIKi ne fonctionne plus, apsser par systemd plutot que udev:

Créer le service systemd adios-udev-reapply avec `sudo micro /etc/systemd/system/adios-udev-reapply.service`

```
[Unit]
Description=Reapply udev rule for NVMe scheduler
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/sh -c 'sleep 1; udevadm control --reload-rules; udevadm trigger --action=change /sys/block/nvme0n1'

[Install]
WantedBy=multi-user.target
```

Relancer systemd : 
```
sudo systemctl daemon-reload
sudo systemctl enable --now adios-udev-reapply.service
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
## 18 - Réduire le temps d'affichage du menu systemd-boot et Limine (à faire)
Réduire le `temps d'affichage du menu systemd-boot` à 0 seconde: appuyer sur MAJ ou SPACE pour le faire apparaitre au boot et réduire le timeout avec `MAJ t.

Ou bien :
```
sudo micro /boot/loader/loader.conf
```
Reboot, puis vérifier que le fichier loader.conf soit à 0 :
```
sudo cat /boot/loader/loader.conf
timeout 1
#console-mode keep
```
Limine : `sudoedit /boot/limine.conf` et ajouter `quiet: yes` et passer timeout à 1. Utiliser les flêches pour faire apparaitre le menu au boot.

And change the parameter MAX_SNAPSHOT_ENTRIES= to 20 in the file /etc/limine-snapper-sync.conf. Afterwards, I ran limine-snapper-sync to apply the changes. Same on BTRFS-ASSISTANT, set up systemd services and timeline, then remove.

<a id="id-19"></a>
## 19 - Tweaker les partitions EXT4
Editer le mount des `partitions EXT4` avec la commande :
`sudoedit /etc/fstab` et rajouter après 'noatime' : 
```
data=writeback,commit=60,barrier=0 0 1
```
| Option                   | Rôle                                                                 | Avantage                                       | Inconvénient / Risque                                      |
|---------------------------|----------------------------------------------------------------------|------------------------------------------------|--------------------------------------------------------                |
| `noatime`                | Désactive la mise à jour de la date         |
| `data=writeback`         | Journalise seulement les **métadonnées**, pas le contenu des fichiers. | Écritures plus rapides, moins de charge disque. 
| `commit=60`              | Force l’écriture du journal toutes les 60 secondes.                  | Moins d’écritures → plus de perf + moins d’usure SSD.          |
| `barrier=0`              | Désactive les barrières d’écriture (cache flush).                    | Réduit la latence et accélère les commits.   
| `0 1`                    | Désactive `dump`, `fsck` automatique au boot.                                     | 


Pour la partiton `vfat` : 
```
defaults,noatime,umask=0077 0 0
```
Puis activer le **Fast_Commit** : démarrer sur un live-cd Fedora, puis identifier la partition root (en général dev/nvme0n1p2) et s'assurer qu'elle est bien en EXT4 :
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
Sortir du live Fedomcra & contrôler la présence de fast_commit avec :
```
sudo tune2fs -l /dev/nvme0n1p2 | grep 'Filesystem features'
```
Enfin monter directement la partition root en RW plutot que montage RO/contrôle fsck/démontage/remontage RW. FSCK passera par mkinitcpio.
```
sudo micro /etc/sdboot-manage.conf
```
Ajouter :
`rw rootflags=data=writeback,commit=60,noatime,barrier=0`

Puis `sudo sdboot-manage gen`

Commenter la ligne root dans FSTAB:
```
sudoedit /etc/fstab
```
Relancer mkinitcpio avec `sudo mkinitcpio -P`

Enfin masquer le service systemd fsck :
```
sudo systemctl mask systemd-fsck-root.service
```
Et reboot.


Pour FS BTRFS : 
```
 1 # /etc/fstab: static file system information.                                                                                                                                                                                                        
 7 # <file system>             <mount point>  <type>  <options>  <dump>  <pass>                                                                         
 8 UUID=BC0B-F121                            /boot          vfat    defaults,noatime,umask=0077 0 2                                              
 9 UUID=e181248c-3cce-4428-bdc4-b6efd715c470 /              btrfs   subvol=/@,defaults,noatime,discard=async,commit=120,compress=zstd:1 0 0      
10 UUID=e181248c-3cce-4428-bdc4-b6efd715c470 /home          btrfs   subvol=/@home,defaults,noatime,discard=async,commit=120,compress=zstd:1 0 0  
11 UUID=e181248c-3cce-4428-bdc4-b6efd715c470 /root          btrfs   subvol=/@root,defaults,noatime,discard=async,commit=120,compress=zstd:1 0 0  
12 UUID=e181248c-3cce-4428-bdc4-b6efd715c470 /srv           btrfs   subvol=/@srv,defaults,noatime,discard=async,commit=120,compress=zstd:1 0 0   
13 UUID=e181248c-3cce-4428-bdc4-b6efd715c470 /var/cache     btrfs   subvol=/@cache,defaults,noatime,discard=async,commit=120,compress=zstd:1 0 0 
14 UUID=e181248c-3cce-4428-bdc4-b6efd715c470 /var/tmp       btrfs   subvol=/@tmp,defaults,noatime,discard=async,commit=120,compress=zstd:1 0 0   
15 UUID=e181248c-3cce-4428-bdc4-b6efd715c470 /var/log       btrfs   subvol=/@log,defaults,noatime,discard=async,commit=120,compress=zstd:1 0 0   
16 tmpfs                                     /tmp           tmpfs   defaults,noatime,mode=1777 0 0                                                      
```
                                                                       
Relancer FSTAB avec `sudo systemctl daemon-reload` puis vérifier l'intégrité des lignes FSTAB avec :
```
sudo findmnt --verify
```
                                            

Et activer NoCOW avec :
```
sudo chattr -R +C /home/ogu/Musique /home/ogu/Vidéos /home/ogu/Téléchargements ~/.cache /var/cache/pacman/pkg /var/cache/man /var/tmp /var/log/journal /var/abs ~/.local/share/Trash
```

<a id="id-20"></a>
## 20 - Régler makepkg pour compiler en zenver4

Remplacer le fichier `/etc/makepkg.conf` par celui disponible en téléchargement sur le dépôt.


<a id="id-21"></a>
## 21 - Désactiver mitigate split lock
MAJ : tester le parametre kernel `split_lock_detect=off`, qui n'est pas opérationnel avec le kernel 6.18

Ou bien éditer `sudo micro /etc/sysctl.d/99-splitlock.conf` et saisir :
  
```
kernel.split_lock_mitigate=0
```
Puis recharger avec `sudo sysctl --system`

<a id="id-22"></a>
## 22 - a - Activer le mode EPP `power_performance` pour le profil Gnome `Balanced` OU b - remplacer ppd par tuned-ppd
a - Vérifier le profil EPP correspondant au profil Balanced/Batterie 
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
micro ~/.config/autostart/disable-battery-aware.desktop
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

b - Remplacer ppd par tuned-ppd (+ performant) et permettre le switch de SCX en fonction de l'EPP:
```
sudo pacman -Syu tuned-cachy tuned-cachy-ppd
```
Et reboot.

Passer `lavd` en AUTO et passer l'atgument `--autopower` pour suivre l'EPP. Vérifier avec la commande scxctl get et sudo scx_lavd --monitor ou la fucntion fish `scx` qui lance les deux.  

Avec BPFLAND : permettre au scheduler scx BPFland de suivre l'EPP

1. Créer le script scx-tuned.sh

```
sudo micro /usr/local/bin/scx-tuned.sh
```
```
#!/usr/bin/env bash

set -euo pipefail

get_tuned_profile() {
    tuned-adm active | sed -r 's/.*: (.+)$/\1/'
}

update_bpfland_mode() {
    local profile="$1"
    case "$profile" in
        powersave)
            sudo scxctl switch -m powersave
            ;;
        balanced)
            sudo scxctl switch -m auto
            ;;
        balanced-battery)
            sudo scxctl switch -m auto
            ;;
        throughput-performance|performance-power|performance)
            sudo scxctl switch -m gaming
            ;;
        *)
            sudo scxctl switch -m auto
            ;;
    esac
}

current_profile="$(get_tuned_profile)"
echo "Initial tuned profile: $current_profile"
update_bpfland_mode "$current_profile"

while true; do
    sleep 3
    new_profile="$(get_tuned_profile)"
    if [ "$new_profile" != "$current_profile" ]; then
        echo "tuned profile changed: $current_profile -> $new_profile"
        current_profile="$new_profile"
        update_bpfland_mode "$new_profile"
    fi
done
```
```
sudo chmod +x /usr/local/bin/scx-tuned.sh
```
2. Créer le service systemd scx-tuned.service

```
sudo micro /etc/systemd/system/scx-tuned.service

```
```
[Unit]
Description=Sync scx_bpfland mode with tuned power profile
After=tuned.service tuned-ppd.service
Requires=tuned.service

[Service]
Type=simple
ExecStart=/usr/local/bin/scx-tuned.sh
Restart=on-failure
RestartSec=3
User=root

[Install]
WantedBy=multi-user.target
```

3. Activer le service
```
sudo systemctl daemon-reexec
sudo systemctl enable --now scx-tuned.service
```
4. Vérifier :
```
systemctl status scx-tuned.service
```
Tester les profils avec le toggle puis :
```
scxctl get
```
ou la fonction Fish:
```
scx
```



ALTERNATIVE : supprimer scx et se contenter du kernel EEVDF : disable scx et `sudo systemctl mask scx_loader`

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
## 24 - Passer à 1 le nombre de ttys au boot
```
sudoedit /etc/systemd/logind.conf
```
puis saisir : `NautoVTS=1`


<a id="id-25"></a>
## 25 - Optimiser le `kernel` :
**a - Appliquer les arguments suivants :**
```
sudoedit /etc/sdboot-manage.conf
```

Ou Limine :
```
sudo micro /etc/default/limine
```

Puis saisir : 
```
LINUX_OPTIONS="splash systemd.tpm2_wait=false tsc=reliable cryptomgr.notests random.trust_cpu=on efi=disable_early_pci_dma nomce nowatchdog no_timer_check noresume fsck.mode=skip zswap.enabled=0 systemd.show_status=false quiet 8250.nr_uarts=0 ipv6.disable=1 amd_iommu=off rcupdate.rcu_normal_after_boot=1 vt.global_cursor_default=0 consoleblank=0 udev.log_level=0 loglevel=0 systemd.watchdog_sec=0 tpm_crb.disable=1 tpm_tis.disable=1 tpm_tis.interrupts=0 random.trust_tpm=0"

Si bug RSEED32 rajouter clearcpuid=rdseed?
```
Relancer systemd-boot conformément à la méthode CachyOS :
```
sudo sdboot-manage gen
```

Ou pour Limine :
```
sudo limine-mkinitcpio
```
Vérifier que tous les réglages fonctionnent en lançant `sudo dmesg`.

*INFO KERNEL ARGUMENTS*

*Silent boot*:

```
console=tty1 systemd.show_status=false quiet udev.log_level=0 loglevel=0 consoleblank=0 systemd.watchdog_sec=0 vt.global_cursor_default=0
```

*Hardware et Vérifications*:

```
nowatchdog no_timer_check 8250.nr_uarts=0 tpm_crb.disable=1 clearcpuid=rdseed
```

*Sécurité et Crypto*:

```
tsc=reliable cryptomgr.notests random.trust_cpu=on efi=disable_early_pci_dma nomce
```

*Stockage et FS*:

```
noresume fsck.mode=skip zswap.enabled=0 nvme_core.default_ps_max_latency_us=5500 rw rootflags=data=writeback,commit=60,noatime,barrier=0
```

*RCU et Scheduling*:

```
rcupdate.rcu_normal_after_boot=1 rcutree.enable_rcu_lazy=1 rcu_nocbs=0-7
```

*Réseau et Autres*:

```
ipv6.disable=1 amd_iommu=off transparent_hugepage=madvise
```

AUtres flags inutiles sur Zenboo (powersaving & ext4): nvme_core.default_ps_max_latency_us=5500 rcutree.enable_rcu_lazy=1 rcu_nocbs=0-7 rw rootflags=data=writeback,commit=60,noatime,barrier=0

**b - Sched-ext :**

Activer le scheduler `BPFland` en AUTO avec sched-ext ou `Rusty` `Cake` (voir Github), chercher des benchmarks récents. Le dernier sur Reddit montre que le noyau compilé avec le scheduler EEVDF est le plus efficace, donc disable scx et masker le service:
https://www.reddit.com/r/cachyos/comments/1q854z9/comment/nyqylbz/?tl=fr&translated=1&force-legacy-sct=1

Vérifier si Ananicy fonctionne maintenant que les deux peuvent cohabiter : l'installer depuis les sources sans quoi erreur de démarrage :
```
#paquets de build
sudo pacman -Syu --noconfirm base-devel cmake nlohmann-json spdlog fmt gcc make git

#nettoyage install' précédente au cas où
sudo systemctl stop ananicy-cpp || true
sudo rm -f /usr/local/bin/ananicy-cpp /usr/local/lib/systemd/system/ananicy-cpp.service
sudo rm -rf /usr/local/share/ananicy-cpp /etc/ananicy-cpp.conf /etc/ananicy.d /var/lib/ananicy-cpp
sudo systemctl daemon-reload
rm -rf ~/ananicy-cpp

#install depuis les sources
git clone https://gitlab.com/ananicy-cpp/ananicy-cpp.git
cd ananicy-cpp
mkdir -p build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr/local -DUSE_EXTERNAL_SPDLOG=ON -DUSE_EXTERNAL_JSON=ON -DUSE_EXTERNAL_FMTLIB=ON
make -j$(nproc)
sudo make install

#lancement du service
sudo systemctl daemon-reload
sudo systemctl enable --now ananicy-cpp

REBOOT !

#install des règles
sudo pacman -S --noconfirm cachyos-ananicy-rules
sudo systemctl restart ananicy-cpp
sudo systemctl daemon-reload

#suppression de s paquets de build inutiles et maintien des paquets nécessaires pour les maj d'ananicy
sudo pacman -Rns cmake cppdap rhash --noconfirm

REBOOT !

#relance du service une fois les règles installées
sudo systemctl daemon-reload
sudo systemctl restart ananicy-cpp #pas de problème avec le lancement?

#check du service
sudo systemctl status ananicy-cpp
journalctl -u ananicy-cpp -f #mention des 1800 règles? pas de problème avec cgroup?


#fix symlink cgroups v2 si [warning] Cgroups are not available on this platform (or are not enabled)
sudo ln -sf /proc/self/mounts /etc/mtab
sudo systemctl restart ananicy-cpp

#check de focntionnement avec Vivaldi
ps -eo pid,ni,policy,cls,pri,comm | grep vivaldi
# Ou full :
ps -eo pid,ni,cgroup:50,comm | grep vivaldi

#Si échecs, alors réinstaller regles, stopper service, le relancer etc...C'est capricieux!
```

<a id="id-26"></a>
## 26 - Régler wifi
1 - Passer le wifi en mode FR :

inutile depuis la mise en place du service `cachyos-iw-set-regdomain.service`? Ou bien supprimer le service qui se contente de chercher le pays via timezone, autant le faire à la main :
`sudo systemctl mask cachyos-iw-set-regdomain.service`
```
sudo micro /etc/conf.d/wireless-regdom
```
Décommenter la ligne *WIRELESS_REGDOM="FR"* puis supprimer les deux services auto : 


A envisager : 
Puis régler la connexion Wifi 5Ghz en dur : ip 192.168.31.102 // masque 255.255.255.0 // passerelle 192.168.31.1 // dns 1.1.1.1, 1.0.0.1, désactiver ipv6


2 - IWD plutot que wpa_supplicant dans NetworkManager : attention : le wifi est très lent pour se reconnecter en sortie de veille avec iwd

Installer iwd, lancer le service, disable le service wpa_supplicant, editer un fichier NetworkManager.conf dans etc/NetworkMananger/conf et inscrire 
[device]
wifi.backend=iwd

Puis restart NetworkManager

Si ok alors sudo pacman -Rdd wpa_supplicant
 
----------------------------------------------------------------------------------------------

# 📦 C - Remplacement et installation de logiciels et codecs

<a id="id-27"></a>
## 27 - Installer logiciels avec pacman, paru puis PacHub
Installer les `logiciels` suivants :
```
sudo pacman -Syu dconf-editor powertop ffmpegthumbnailer profile-cleaner seahorse extension-manager fragments papers nicotine+ resources onlyoffice fuse2 xournal++ jdownloader2 gnome-calendar duf jamesdsp libgda6 shelly inotify-tools libnotify
```
et le reste avec paru après avoir édité le conf de Paru pour supprimer les dépendances de création de paquets etc
```
mkdir -p ~/.config/paru
cp /etc/paru.conf ~/.config/paru/paru.conf 
gnome-text-editor ~/.config/paru/paru.conf

```
Et activer 
```
[options]
PgpFetch
Devel
Provides
DevelSuffixes = -git -cvs -svn -bzr -darcs -always -hg -fossil
BottomUp
RemoveMake
SudoLoop
CombinedUpgrade
CleanAfter
UpgradeMenu
NewsOnUpgrade
SkipReview #à ajouter à la main

```
```
paru -Syu libre-menu-editor archclean gapless cine cachyos-downgrade isd

```
Bilan : environ 900 packages et 6.5 Go d'applis et paquets
`sudo pacman -Q | wc -l && expac -H M '%m' | awk '{sum += $1} END {printf "%.2f GiB\\n", sum/1024}'`

OPTIONNEL :
installer [PacHub](https://github.com/mrks1469/PacHub) OU
Régler `pacseek` pour inclure paru à la place de yay si besoin, et EnableAutoSuggest=true + ColorScheme=Endeavour OS : soit avec ctrl-s dans Pacseek, soit en éditant le json:

```
gedit ~/.config/pacseek/config.json
```


Enfin installer [l'appimage de Beeper](https://api.beeper.com/desktop/download/linux/x64/stable/com.automattic.beeper.desktop), la déplacer dans .local/bin, éditer le raccourci avec le chemin de l'éxecutable et  `StartupWMClass=Beeper` pour faire apparaitre l'icone dans le dash. Idem pour Puls : https://github.com/word-sys/puls, puis renommer en `monitor`

<a id="id-28"></a>
## 28 - Installer Dropbox avec Maestral
créer le répertoire Dropbox dans /home puis lancer le script *maestral_install* 
NE MARCHE PLUS APRES LA DERNIERE UPDATE - Revenir à l'appli Dropbox générale.
Penser à installer sudo pacman -S libappindicator-gtk3


----------------------------------------------------------------------------------------------

# 🐾 D - Réglages de l'UI Gnome Shell

<a id="id-29"></a>
## 29 - Suspension en fermant le capot
Editer le service logind :
```
gnome-text-editor admin:///etc/systemd/logind.conf
```
puis remplacer les lignes HanbdlePowerKey & HandleLidSwitch par 
```
HandlePowerKey=suspend
HandlePowerKeyLongPress=poweroff

HandleLidSwitch=suspend
HandleLidSwitchExternalPower=suspend
```

Et `gsettings set org.gnome.shell always-show-log-out true` pour activer la fermeture de session sur GNOME50 + `gsettings set org.gnome.login-screen disable-restart-buttons false` pour activer le reboot/sutdown depuis GDM.

Supprimer aussi la notification de don GNOME :
```
gsettings set org.gnome.settings-daemon.plugins.housekeeping donation-reminder-enabled false
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
Installer le [wallpaper F34](https://fedoraproject.org/w/uploads/d/de/F34_default_wallpaper_night.jpg) OU cosmos_dark_blue, et le thème de curseurs [Phinger NO LEFT Light](https://github.com/phisch/phinger-cursors/releases) : déplacer le dossier *phingers-cursor-light* dans `usr/share/icons` puis utiliser `dconf-editor` pour les passer en taille 32 :
```
org/gnome/desktop/interface/cursor-size
```
Passer le theme de curseur dans GDM avec :
```
sudo -u gdm dbus-launch gsettings set org.gnome.desktop.interface cursor-theme phinger-cursors-light
```
Continuer avec `GDM Settings` (pour mettre le wallpaper dans GDM, entre autres) : 

```
paru gdm-settings
```
penser à copier le logo cachyOS `Watermark` (à dl dans le repo) dans /home/ogu/.local/share/icons, puis importer le fichier de configuration `gdm-settings.ini`.

Enfin, supprimer le paquet.

Installer également le **theme GTK4** pour les applications utilisant encore GTK3 : `sudo pacman -S adw-gtk-theme` et activer le thème avec Gnome Tweaks.


Sortie de veille : pour relancer le thème de curseurs en sortie de suspend :
```
sudo micro /etc/systemd/system/reapply-cursor-theme.service
```
et saisir 

:
```
[Unit]
Description=Réapplique thème curseur après sortie de veille
After=suspend.target

[Service]
[Unit]
Description=Réapplique le thème de curseur après sortie de veille
After=suspend.target

[Service]
Type=oneshot
ExecStart=/usr/bin/gsettings set org.gnome.desktop.interface cursor-theme phinger-cursors-light

[Install]
WantedBy=suspend.target

[Install]
WantedBy=suspend.target
```
Puis relancer systemd :
```
sudo systemctl daemon-reload && systemctl enable reapply-cursor-theme.service && systemctl start reapply-cursor-theme.service
```

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

e - [Caffeine](https://extensions.gnome.org/extension/517/caffeine/) ATTENTIon à n'activer que si le suspend est réparé

f - [Clipboard History](https://extensions.gnome.org/extension/4839/clipboard-history/) ou plus graphique avec [Copyous](https://extensions.gnome.org/extension/8834/copyous/) : penser à installer la dépendance libgda6 `sudo pacman -S libgda6`


**Extensions apportant des fonctions UI :**

g - [Battery Time Percentage Compact](https://extensions.gnome.org/extension/2929/battery-time-percentage-compact/) ou [Battery Time](https://extensions.gnome.org/extension/5425/battery-time/)  

h - [AutoActivities](https://extensions.gnome.org/extension/5500/auto-activities/)

i - [Power Switching Manager](https://extensions.gnome.org/extension/9178/power-switching-manager/) & supprimer la luminosité automatique dans Settings de Gnome !!

j - [Hot Edge](https://extensions.gnome.org/extension/4222/hot-edge/)

k - [Custom Command Toggle](https://extensions.gnome.org/extension/7012/custom-command-toggle/)  

l - [Drag'n'Tile](https://extensions.gnome.org/extension/7863/dragntile/)

m - [Quick Close Overview](https://extensions.gnome.org/extension/352/middle-click-to-close-in-overview/)

n - [Auto Power Profile](https://extensions.gnome.org/extension/6583/auto-power-profile/)

o - [Battery Monitor](https://extensions.gnome.org/extension/8348/battery-monitor/)

p - [Privacy Settings](https://extensions.gnome.org/extension/4491/privacy-settings-menu/) puis la supprimer une fois les réglages faits.

q - [Media Controls](https://extensions.gnome.org/extension/4470/media-controls/)

r - [Windows Rounded Corners](https://extensions.gnome.org/extension/7048/rounded-window-corners-reborn/)

s - [Quick Settings Audio Device](https://extensions.gnome.org/extension/5964/quick-settings-audio-devices-hider/) pour masquer l'entrée JamesDSP dans le top menu Gnome.

t - [Night Light Slider](https://extensions.gnome.org/extension/6781/night-light-slider-updated/)

<a id="id-36"></a>
## 36 - Bonus Ptyxis
```
paru -S nautilus-open-any-terminal
```
et penser à éditer sa clé dconf `com.github.stunkymonkey.nautilus-open-any-terminal` pour inscrire "ptyxis":
```
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal terminal ptyxis
```

+ mettre "new tab" sur true pour que Ptyxis s'ouvre dans la session en cours:
```
gsettings set com.github.stunkymonkey.nautilus-open-any-terminal new-tab true
```
   En cas d'erreur avec Gnome 49, se référer à [ce fil](https://github.com/Stunkymonkey/nautilus-open-any-terminal/issues/242).


Ajouter Ptyxis aux terminaux par défaut pour les outils CachyOS :
https://www.reddit.com/r/cachyos/comments/1rry7qh/guide_add_your_terminal_to_cachyos_tools_like/



<a id="id-38"></a>
## 38 - Configurer fish, gnome-text-editor
Régler `Gnome-text-editor`et `Ptyxis`; configurer `fish` avec le fichier config.fish à télécharger dans ce repo : il inclut des alias supplémentaires, la fonction greeting désactivée, et des fonctions maison (scx, journal, flags, sudoedit, vault...)

Recharger la configuration de fish avec `source ~/.config/fish/config.fish`

Gnome-text-editor : se contenter de modifier les réglages internes



## 39 - JamesDSP

Modifier son nom en Audio et passer StartupWMClass=jamesdsp, le régler conformément à ce [tuto](https://discuss.cachyos.org/t/tutorial-make-linux-sound-better-easier-with-jamesdsp/16098/5), avec le *.conf ClearPenguin disponible dans le Github.

Supprimer l'icone du menu et créer un Custom Command Toggle (voir fichier *.ini), ou bien l'activer tout court.

Mieux : le régler, désinstaller sa version GUI, la remplacer par `paru jamesdsp-headless-git`, et créer un fichier desktop pour le lancement auto : à réaliser en bash sur fish :
```
cat > ~/.config/autostart/jamesdsp.desktop << 'EOF'
[Desktop Entry]
Name=JamesDSP
Exec=jamesdsp
Icon=jamesdsp
Type=Application
X-GNOME-Autostart-Delay=5
X-GNOME-Autostart-enabled=true
EOF
chmod +x ~/.config/autostart/jamesdsp.desktop
```

Reboot et vérifier si jamesdsp apparait dans les processus. Puis penser à le passer en explicitely installed sans quoi pacman le voit comme orphelin : sudo pacman -D --asexplicit jamesdsp-headless-git



<a id="id-40"></a>
## 40 - Configurer Celluloid ou Ciné (préférer Cine)
Cine : modifier la navigation dans la vidéo en créant le fichier `input.conf` dans `~/.config/cine/input.conf`:
```
#Modifier la navigation dans la vidéo : 60s fleches horizontales et 5 minutes fleches verticales
RIGHT seek 60
LEFT seek -60
UP seek 300
DOWN seek -300
```


inscrire `vo=gpu-next gpu-api=vulkan` dans Paramètres --> Divers --> Options supplémentaires, activer l'option `focus` et `toujours afficher les boutons de titre`, enfin télécharger et installer les deux scripts lua suivants pour la musique : Visualizer & Delete File


<a id="id-41"></a>
## 41 - Configurer JDownloader & Fragments
`Jdownloader` : réglages de base (font Adwaita Sans, et désactiver les éléments suivants : tooltip, help, Update Button Flashing, banner, Premium Alert, Donate, speed meter visible) en téléchargeant dans le déppot l'archive de configuration jdwonloader.
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
## 43 - Réglages permissions
Installer `malcontent` le temps de faire les réglages d'applis dans Gnome-control-center puis le supprimer
```
sudo pacman -S malcontent
```


<a id="id-44"></a>
## 44 - Scripts Nautilus : Hide/Unhide, Dropbox, Copier le chemin...
Scripts Nautilus `Hide.py` `Unhide.py` pour masquer/rendre visibles les fichiers à la volée, et `Dropbox` pour ouvrir un fichier dans l'interface web Dropbox afin de copier-coller son url de partage et ainsi mimer le copmportmeent de Dropbox Nautilus.
A télécharger depuis le dossier `SCRIPTS` puis à coller dans le dossier `/home/ogu/.local/share/nautilus/scripts/.
Penser à les rendre exécutables!

Ajouter `nautilus-copy-path` & `nautilus-admin`
```
paru -S nautilus-copy-path nautilus-admin && sudo pacamn -Syu nautilus-python
```
Et éditer les fichiers `/usr/share/nautilus-python/extensions/nautilus-copy-path/nautilus_copy_path.py` & `sudoedit /usr/share/nautilus-python/extensions/nautilus-copy-path/config.json
` pour passer URI & Content en `false`, puis `/usr/share/nautilus-python/extensions/nautilus-admin.py` pour traduire "Open as admin" (voir traduction dans les fichiers de config du déoôt Github)

Enfin `pkill nautilus && nautilus`.

<a id="id-45"></a>
## 45 - Supprimer Plymouth

Supprimer Plymouth avec `sudo pacman -Rns plymouth` puis éditer mkinitcpio pour retirer le hook Plymouth :
```
sudoedit /etc/mkinitcpio.conf
```
Recharger avec `sudo mkinitcpio -P`

Enfin modifier les arguments kernel :
```
sudoedit /etc/sdboot-manage.conf
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
Éditer fr.po avec `sudoedit fr.po` et modifier le nom du bouton "Mode puissance" par "Energie" ou "Profil", puis compiler :
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
Dans les Paramètres Gnome, créer un raccourci Ptyxis avec la touche Copilot, Ressources avec ctrl-alt-supp
Enfin modifier les folder par défauts Dropbox, Nicotine, Téléchargements, etc, usr, root, Extensions, Icons etc avec les Places personnalisés.

<a id="id-48"></a>
## 48 - Faire le tri dans les LOCALES, ~/.local/share, ~/.config et /etc

Supprimer les locales sauf EN, en_US, fr, Fr_FR dans `usr/share/locales` : penser à les sauvegarder puis à vérifier au reboot. 


<a id="id-49"></a>
## 49 - Créer modèles de fichier dans Nautilus
1. Renommer l'ancien dossier Modèles en .Modèles (s'il existe) [ -d "$HOME/Modèles" ] && mv "$HOME/Modèles" "$HOME/.Modèles" #
2. S'assurer que le dossier caché existe mkdir -p "$HOME/.Modèles"
3. Créer les deux fichiers modèles touch "$HOME/.Modèles/notepad.txt" touch "$HOME/.Modèles/word.docx"
4. Pointer XDG_TEMPLATES_DIR vers ce dossier : sed -i '/^XDG_TEMPLATES_DIR=/d' "$HOME/.config/user-dirs.dirs" echo 'XDG_TEMPLATES_DIR="$HOME/.Modèles"' >> "$HOME/.config/user-dirs.dirs"
5. Recharger la config XDG xdg-user-dirs-update
6. Redémarrer Nautilus nautilus -q renommer Modèles en .Modèles et créer fichier Notepad.txt et Word.docx, penser à editer ~/.config/user-dirs.dirs puis xdg-user-dirs-update et à relancer gnome xdg-user-dirs-update

<a id="id-49"></a>
## 49 - Modifier Cachy-update (icons et settings)
Générez le fichier de config utilisateur
```
arch-update --gen-config
```
Éditez le fichier pour choisir le thème :
```
arch-update --edit-config
```
Décommentez et modifiez la ligne : `TrayIconStyle=light` + 1 sauvegarde et non 3 etc...

----------------------------------------------------------------------------------------------

### 🌐 E - Réglages du navigateur Vivaldi

<a id="id-57"></a>
## 57 - Réglages internes Vivaldi
Editer le raccourci de lancement pour optimiser la gestion des processus RAM et du cache :
```
--process-per-site --disk-cache-dir=/run/user/1000/vivaldi-cache
```

Puis dans `vivaldi://flags`, passer en **enable* :
```
Smooth Scrolling
Experimental QUIC 
GPU rasterization
Zero-copy rasterizer
Parallel downloading
http-cache-custom-backend
memory-purge-on-freeze-limit
Split View

```
Et en **disable** :
```
Touch UI Layout
```
Régler les settings cachés : vivaldi:settings/system, en aprticulier le préfetch, et décocher les option prefetch disable dans ublock et localcdn. 
Enfin supprimer l'autoplay Youtube avec :  Menu Vivaldi → Settings → Privacy → Website permissions → Autoplay → Block

## 58 - Changer thème Vivaldi

Appliquer le thème custom à télécharger dans le dépôt.
Ativez d'abord les modifications CSS expérimentales: allez sur vivaldi://experiments/, cochez « Allow for using CSS modifications » (Autoriser les modifications CSS), puis redémarrez Vivaldi. 
Dans Paramètres > Apparence > Modifications UI personnalisées, sélectionnez un dossier pour vos fichiers CSS (créez-en un si nécessaire). 

## 59 - Panneau latéral Vivaldi](#id-52)

Ajouter Perplexity et [WhatsApp(https://www.reddit.com/r/vivaldibrowser/comments/1m93s3b/does_anyone_know_how_to_open_whatsapp_as_webpanel/) : https://web.whatsapp.com/

+ Raindrop, Discord, Gmail + traduction, commande rapide extension, sessions





<a id="id-59"></a>
## 60 - Extensions Vivaldi
[Better Scroll To Bottom](https://chromewebstore.google.com/detail/better-scroll-to-topbotto/ifdjdmipgndncbeopapghbohjdiieibl?hl=es)
[Video Download Helper](https://chromewebstore.google.com/detail/video-downloadhelper/lmjnegcaeklhafolokijcfjliaokphfk) et reglages mkv + dossier telechargements VDH pour correspondre au script `transfert`
[Copy URL](https://chromewebstore.google.com/detail/copy-url/ccnghlbhjgabibnajlaklhpikmcannph)
[LocalCDN](https://chromewebstore.google.com/detail/localcdn/njdfdhgcmkocbgbhcioffdbicglldapd)
[Rehistroria Auto Delete](https://chromewebstore.google.com/detail/rehistoria-auto-delete-hi/dheibmdojjjhiahbdmcnmbepnaiilloe)
[ublock Origin](https://chromewebstore.google.com/detail/ublock-origin/cjpalhdlnbpafiamejdnhcphjbkeiagm)
[Raindrop](https://chromewebstore.google.com/detail/raindropio/ldgfbffkinooeloadekpmfoklnobpien?pli=1)
[Stylus](https://chromewebstore.google.com/detail/stylus/clngdbkpkpeebahjckkjfobafhncgmne?hl=fr) pour la couleur de surlignage et insérer:
```
::selection {
    color: white !important;
    background-color: #3584e4 !important;
}
```
Passer `gio mime x-scheme-handler/magnet de.haeckerfelix.Fragments.desktop` pour que le clic sur un magnet ouvre l'interface Fragments.
















Ancienne configuration - 


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






# 🌐 F - Réglages du navigateur Firefox

<a id="id-49"></a>
## 49 - Réglages internes Firefox
Réglages internes de `Firefox` (penser à activer CTRL-TAB pour faire défiler dans l'ordre d'utilisation & à passer sur `Sombre` plutôt qu'`auto` le paramètre `Apparence des sites web`), interdire le lancement auto des vidéos dans `Lecture automatique -- paramètres`, activer le plugin H264.
Enfin éditer le raccourci Firefox pour lancer le browser avec un nouvel onglet vide  :
```
/usr/lib/firefox/firefox  %u -new-tab about:blank
```


<a id="id-50"></a>x
## 50 - Changer thème Firefox
Changer le `thème` pour [Gnome Dark](https://addons.mozilla.org/fr/firefox/addon/adwaita-gnome-dark/?utm_content=addons-manager-reviews-link&utm_medium=firefox-browser&utm_source=firefox-browser) ou [Gnome Light Current Tab Blue](https://addons.mozilla.org/fr/firefox/addon/gnome-current-tab-blue/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=search)


<a id="id-51"></a>
## 51 - Réglages user.js
En complément des [réglages Firefox CachyOS](https://github.com/CachyOS/CachyOS-PKGBUILDS/blob/master/cachyos-firefox-settings/cachyos.js), inspirés par les réglages Betterfox, Fastfox, Peskyfox, & Librewolf.cfg. 
Copier-coller le fichier `user.js` dans le profil Firefox.
ATTENTIUON : user.js orienté vitesse/réduction de features inutiles, au détriment de la securité et de la fonctionnalité.


<a id="id-52"></a>
## 52 - Extensions Firefox
a - [uBlock Origin](https://addons.mozilla.org/fr/firefox/addon/ublock-origin/) : réglages à faire + import des la liste sauvegardées + interdire les sites IA avec ce [lien](https://subscribe.adblockplus.org/?location=https%3A%2F%2Fraw.githubusercontent.com%2Flaylavish%2FuBlockOrigin-HUGE-AI-Blocklist%2Fmain%2Flist.txt&title=Sites%20using%20AI%20generated%20content) 

b - [Auto Tab Discard](https://addons.mozilla.org/fr/firefox/addon/auto-tab-discard/?utm_source=addons.mozilla.org&utm_medium=referral&utm_content=featured) : importer les réglages avec le fichier de backup et bien activer les 2 options de dégel des onglets à droite et à gauche de l'onglet courant.

c - [Raindrop](https://raindrop.io/r/extension/firefox) et autoriser l'ouverture de plusieurs tabs pour lancer les collections de bookmarks d'un coup : lancer la page de settings des popups : vivaldi:settings/content/popups et ajouter l'exception  `[*.]raindrop.io`

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

o - [Bypass Paywalls](https://gitflic.ru/project/magnolia1234/bpc_uploads)

<a id="id-53"></a>
## 53 - Activer Rechercher avec Perplexity

Nota : il semble que Firefox embarque dorénavant cette option par défaut (clic sur la loupe)
 Activer `perplexity` en se rendant sur leur [site](https://www.perplexity.ai/) : faire une recherche dans la batrre d'adresse, sélectionner "Rechercher avec Perplexity" dans le menu qui apparait, puis autoriser l'installation de la recherche Perplexity. Ajouter un champ de recherche dans la toolbar Firefox.


<a id="id-54"></a>
## 54 - userChrome pour allèger le clic droit
Télécharger le *userChrome* et le coller dans le répertoire par défaut de Firefox dans un dossier *chrome*. Le profil se trouve dans `about:support`


<a id="id-55"></a>
## 55 - Mettre profil navigateurs en RAM avec psd

NOTA : NE PAS INSTALLER - annule les réglages Vivaldi après reboot...

Mettre le profil de Firefox & Vivaldi en RAM avec `profile-sync-daemon` :
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
sudoedit /home/ogu/.config/psd/psd.conf # The default is to save the most recent 5 crash recovery snapshots BACKUP_LIMIT=2 & BROWSERS=(firefox)
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

<a id="id-56"></a>
## 56 - "Nettoyer" Firefox
Terminer en allant dans `about:support` pour vérifier les database, vider le cache de démarrage, puis lancer `profile-cleaner f`
