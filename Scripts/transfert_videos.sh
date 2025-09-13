#!/usr/bin/env fish

set SOURCE_DIR ~/Téléchargements
set DEST_DIR ~/Vidéos
set VIDEO_EXTENSIONS .mp4 .mkv .avi .mov .flv .wmv .mpeg .mpg .webm

function move_and_cleanup
    set file $argv[1]
    set dest $argv[2]
    echo "File found: $file"

    read -P "Do you want to move this file to $dest ? (o/n) " choice
    if test "$choice" = o -o "$choice" = O
        mkdir -p "$dest"
        mv "$file" "$dest"
        echo "File moved to $dest"

        set dir (dirname "$file")
        while test "$dir" != "$SOURCE_DIR"
            if test ! -d "$dir"
                rmdir "$dir"
                echo "Folder removed: $dir"
            else
                break
            end
            set dir (dirname "$dir")
        end
    else
        echo "File ignored."
    end
end

for ext in $VIDEO_EXTENSIONS
    for file in (find $SOURCE_DIR -type f -name "*$ext")
        move_and_cleanup "$file" "$DEST_DIR"
    end
end

echo "Processing completed."
