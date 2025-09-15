#!/usr/bin/env fish

read -P "Redémarrer dans le firmware ? (o/N) " reponse
if test "$reponse" = "o"
    systemctl reboot --firmware-setup
else
    echo "Annulé."
end

