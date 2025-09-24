#!/usr/bin/env fish

set SOURCE_DIR ~/Téléchargements
set DEST_DIR ~/Vidéos
set VIDEO_EXTENSIONS .mp4 .mkv .avi .mov .flv .wmv .mpeg .mpg .webm

function move_and_cleanup
    set file $argv[1]
    set dest $argv[2]

    echo "Déplacement : $file → $dest"
    mkdir -p "$dest"
    mv "$file" "$dest"

    set dir (dirname "$file")
    # Supprime uniquement le dossier s'il est vide
    if test -d "$dir"
        if test (count (ls -A "$dir")) -eq 0
            rmdir "$dir"
            echo "Dossier supprimé : $dir"
        end
    end
end

for ext in $VIDEO_EXTENSIONS
    for file in (find $SOURCE_DIR -type f -name "*$ext")
        move_and_cleanup "$file" "$DEST_DIR"
    end
end

echo "Traitement terminé."
