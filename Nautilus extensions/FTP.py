#!/usr/bin/env python3
import sys
import os
import ftplib
import gi
gi.require_version('Gtk', '3.0')
from gi.repository import Gtk

# Paramètres FTP
FTP_HOST = '192.168.31.68'
FTP_PORT = 2121
FTP_USER = 'ogu'
FTP_PASS = 'sara'
REMOTE_DIR = '/DEV/DEV1/DEV2/DEV3/DEV4'

def send_file(ftp, local_path, remote_dir):
    basename = os.path.basename(local_path)
    try:
        ftp.cwd(remote_dir)
    except ftplib.error_perm:
        # Crée le dossier si nécessaire
        parts = remote_dir.strip('/').split('/')
        path = ''
        for p in parts:
            path += f'/{p}'
            try:
                ftp.mkd(path)
            except:
                pass
        ftp.cwd(remote_dir)

    if os.path.isfile(local_path):
        with open(local_path, 'rb') as f:
            ftp.storbinary(f'STOR {basename}', f)
    elif os.path.isdir(local_path):
        for root, dirs, files in os.walk(local_path):
            rel_path = os.path.relpath(root, local_path)
            ftp_dir = os.path.join(remote_dir, rel_path).replace("\\","/")
            try:
                ftp.mkd(ftp_dir)
            except:
                pass
            ftp.cwd(ftp_dir)
            for file in files:
                local_file = os.path.join(root, file)
                with open(local_file, 'rb') as f:
                    ftp.storbinary(f'STOR {file}', f)

def main():
    files = sys.argv[1:]
    if not files:
        dialog = Gtk.MessageDialog(None, 0, Gtk.MessageType.INFO, Gtk.ButtonsType.OK, "Aucun fichier sélectionné")
        dialog.run()
        dialog.destroy()
        return

    try:
        ftp = ftplib.FTP()
        ftp.connect(FTP_HOST, FTP_PORT)
        ftp.login(FTP_USER, FTP_PASS)
        for f in files:
            send_file(ftp, f, REMOTE_DIR)
        ftp.quit()
        dialog = Gtk.MessageDialog(None, 0, Gtk.MessageType.INFO, Gtk.ButtonsType.OK, "Fichiers envoyés sur FTP !")
        dialog.run()
        dialog.destroy()
    except Exception as e:
        dialog = Gtk.MessageDialog(None, 0, Gtk.MessageType.ERROR, Gtk.ButtonsType.OK, f"Erreur FTP: {e}")
        dialog.run()
        dialog.destroy()

if __name__ == "__main__":
    main()

