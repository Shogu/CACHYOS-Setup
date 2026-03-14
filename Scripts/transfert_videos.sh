#!/usr/bin/env fish

set SOURCE_DIR ~/Téléchargements
set DEST_DIR ~/Vidéos
set VIDEO_EXTENSIONS .mp4 .mkv .avi .mov .flv .wmv .mpeg .mpg .webm
set VDH_PATH "$SOURCE_DIR/VDH"  # Dossier à préserver

function move_and_cleanup
    set file $argv[1]
    set dest $argv[2]

    echo "Déplacement : $file → $dest"
    mkdir -p "$dest"
    mv "$file" "$dest"

    set dir (dirname "$file")
    
    # Vérifie si c'est le dossier VDH à préserver
    if test "$dir" = "$VDH_PATH"
        echo "⚠️  Dossier VDH préservé : $dir"
        return 0
    end
    
    # Supprime le dossier entier (récursivement) s'il existe encore
    if test -d "$dir"
        rm -rf "$dir"
        echo "🗑️  Dossier supprimé : $dir"
    end
end

for ext in $VIDEO_EXTENSIONS
    for file in (find $SOURCE_DIR -type f -name "*$ext")
        move_and_cleanup "$file" "$DEST_DIR"
    end
end

echo "Traitement terminé."
