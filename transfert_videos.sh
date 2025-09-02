#!/usr/bin/env fish
set -l SOURCE_DIR ~/Téléchargements
set -l DEST_DIR ~/Vidéos
set -l VIDEO_EXTENSIONS [ "*.mp4", "*.mkv", "*.avi", "*.mov", "*.flv", "*.wmv", "*.mpeg", "*.mpg", "*.webm" ]

function move_and_cleanup(file, dest)
    echo "File found: $file"
    read -p "Do you want to move this file to $dest? (y/n)" choice
    if [ $choice = "y" ] or [ $choice = "Y" ]
        mkdir -p $dest
        mv $file $dest
    end
end

for ext in ${VIDEO_EXTENSIONS}
    find $SOURCE_DIR -type f -iname $ext
    if test $status -eq 0
        find $SOURCE_DIR -name "$ext"
        echo "trouvé: $file"
        read -p "Do you want to move this file to $DEST_DIR? (y/n)" choice
        if [ $choice = "y" ] or [ $choice = "Y" ]
            move_and_cleanup $SOURCE_DIR/$file $DEST_DIR
        end
    end
end


