#! /bin/sh
# @AnAncientForce >> HP

# echo "Autostarting..."
# killall -9 copyq blueman-manager pavucontrol uxterm konsole
# /home/$(whoami)/shell/waybar.sh &
# copyq &
# pavucontrol &
# easyeffects &
# redshift -l 51.5:0.1 &
# librewolf &
# protonvpn &
# flameshot &
# veracrypt &
# uxterm -e sh ~/shell/sensor.sh 0 &
# uxterm -e sh ~/shell/mount.sh m &
# uxterm -e sh ~/shell/battery_monitor.sh &
# sh ~/shell/static_wallpaper.sh &
# blueman-manager &
# nmcli c delete pvpn-killswitch
# nmcli c delete pvpn-routed-killswitch
# nmcli c delete pvpn-ipv6leak-protection
# uxterm -e xhost +SI:localuser:root
# echo "Ready!"
# uxterm -e sh ~/shell/sensor.sh 0 &
# uxterm -e sh ~/shell/auto_reminder.sh &
# easyeffects &
# pavucontrol &
# blueman-manager &
# redshift -l 51.5:0.1 &

# This script is responsible for launching necessary applications on login.

# We must only use absolutely necessary applications due to the CPU we're working with.

/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
nm-applet &
copyq &
uxterm -e sh ~/shell/battery_monitor.sh &

# ProtonVPN fix
nmcli c delete pvpn-killswitch
delete pvpn-routed-killswitch
delete pvpn-ipv6leak-protection
