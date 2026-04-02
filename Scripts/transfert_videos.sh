#!/usr/bin/env fish

set SOURCE_DIR ~/Téléchargements
set DEST_DIR /home/ogu/Vidéos/.DEV
set VIDEO_EXTENSIONS .mp4 .mkv .avi .mov .flv .wmv .mpeg .mpg .webm
set VDH_PATH "$SOURCE_DIR/VDH"

function cleanup_empty_dirs --argument-names start_dir
    set current "$start_dir"

    while test "$current" != "$SOURCE_DIR"
        if test "$current" = "$VDH_PATH"
            echo "⚠️  Dossier VDH conservé : $current"
            break
        end

        if test -d "$current"
            rmdir "$current" 2>/dev/null
            if test $status -eq 0
                echo "🗑️  Dossier vide supprimé : $current"
                set current (dirname "$current")
            else
                break
            end
        else
            break
        end
    end
end

function move_and_cleanup --argument-names file dest
    echo "Déplacement : $file → $dest"
    mkdir -p "$dest"

    mv "$file" "$dest"
    if test $status -ne 0
        echo "❌ Échec du déplacement : $file"
        return 1
    end

    set dir (dirname "$file")
    cleanup_empty_dirs "$dir"
end

for ext in $VIDEO_EXTENSIONS
    for file in (find "$SOURCE_DIR" -type f -name "*$ext")
        move_and_cleanup "$file" "$DEST_DIR"
    end
end

echo "Traitement terminé."
