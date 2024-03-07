#!/bin/bash
# @AnAncientForce >> HP

source "$(dirname "$(realpath "$0")")/common.sh"

# vars
restore_pth=""
gap="   "
valid_flag=false

restore_pth="~/.backup"

function trap_ctrlc() {
    echo -e ${BRed}"\n[!] The current operation has been stopped.\n" ${Color_Off}
    exit 2
}
trap "trap_ctrlc" 2

# echo -e ${BBlue}"\n[*] A" ${Color_Off}
# echo -e ${BYellow}"[*] B\n" ${Color_Off}
# echo -e ${BPurple}"[*] C" ${Color_Off}
# echo -e ${BBlue}"[*] D" ${Color_Off}
# echo -e ${BGreen}"[*] E\n" ${Color_Off}
# echo -e ${BRed}"[!] F\n" ${Color_Off}

# ----------------------------- Flag Logic
help() {
    echo -e ${BPurple}"Available flags\n" ${Color_Off}
    echo -e ${BGreen}"[*] yt [URL]       : Downloads a youtube video" ${Color_Off}
    echo -e ${BGreen}"[*] bt-c           : Connects all bluetooth devices" ${Color_Off}
    echo -e ${BGreen}"[*] bt-d           : Disconnects all bluetooth devices" ${Color_Off}
    echo -e ${BGreen}"[*] autostart      : Launches autostart.sh file" ${Color_Off}
    exit 0
}
if [ "$1" = "h" ]; then
    help
fi
for arg in "$@"; do
    case "$arg" in
    autostart)
        /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
        nm-applet &
        copyq &
        uxterm -e sh ~/shell/battery_monitor.sh &

        # ProtonVPN fix
        nmcli c delete pvpn-killswitch
        delete pvpn-routed-killswitch
        delete pvpn-ipv6leak-protection
        ;;
    launch_waybar)
        pkill waybar
        nohup waybar -c ~/.config/waybar/config -s ~/.config/waybar/style.css >/dev/null 2>&1 >/dev/null 2>&1 &
        ;;
        # ------------------------- invoke_clip -------------------------
    invoke_clip_f)
        mkdir ~/Pictures/full/
        file="~/Pictures/full/$(date +"%Y%m%d-%H%M%S").png"
        grim "$file"
        wl-copy <$file
        ;;
    invoke_clip_s)
        mkdir ~/Pictures/snips/
        hyprshot -s -o ~/Pictures/snips/ -m region
        ;;
    invoke_clip_o)
        # Set the path to your OCR folder
        OCR_FOLDER=~/OCR

        # Ensure the OCR folder exists
        mkdir -p "$OCR_FOLDER"

        # Capture selection and save to OCR folder
        IMAGE_PATH="$OCR_FOLDER/$(date +%Y%m%d%H%M%S).png"
        grim -g "$(slurp)" "$IMAGE_PATH"

        # Perform OCR on the saved image
        tesseract -l eng "$IMAGE_PATH" "$OCR_FOLDER/output" && cat "$OCR_FOLDER/output.txt" | wl-copy
        valid_flag=true
        ;;
        # ------------------------- recorder -------------------------
    recorder)
        if pgrep -x "wf-recorder" >/dev/null; then
            # stop recording if already recording
            pkill -SIGINT wf-recorder
        else
            # record if not already recording
            wf-recorder --audio --file=/home/$(whoami)/Videos/$(date +"%Y%m%d-%H%M%S").mp4
        fi
        valid_flag=true
        ;;
        # ------------------------- bluetooth -------------------------
    bt-d)
        bluetoothctl disconnect AC:BF:71:91:31:D5
        bluetoothctl disconnect DC:F4:CA:CB:93:A1
        valid_flag=true
        ;;
    bt-c)
        bluetoothctl connect AC:BF:71:91:31:D5
        bluetoothctl connect DC:F4:CA:CB:93:A1
        valid_flag=true
        ;;
        # ------------------------- Session_Lock -------------------------
    lock)
        playerctl pause
        playerctl -p spotify pause
        pactl set-sink-mute @DEFAULT_SINK@ 1
        swaylock -c 000000FF
        valid_flag=true
        ;;
    unlock)
        playerctl play
        playerctl -p spotify play
        pactl set-sink-mute @DEFAULT_SINK@ 0
        valid_flag=true
        ;;
    vm)
        # sudo virsh list --all
        # virsh start win10
        # virsh net-start default
        # sudo virsh net-start default
        # https://serverfault.com/questions/803283/how-do-i-list-virsh-networks-without-sudo
        dunstify "Windows 10 is starting" "(please ensure a display cable is connected)" -u normal
        kitty -e virsh --connect qemu:///system start win10
        looking-glass-client -a yes &
        valid_flag=true
        ;;
        # ------------------------- waydroid -------------------------
    waydroid-start)
        waydroid prop set persist.waydroid.width ""
        waydroid prop set persist.waydroid.height ""
        waydroid session stop
        echo "About to launch full ui... (3 secs waiting)"
        sleep 3
        waydroid show-full-ui &
        valid_flag=true
        ;;
    waydroid-stop)
        waydroid session stop
        valid_flag=true
        ;;
    droid-1)
        pkill scrcpy
        adb shell wm density 320
        adb shell wm size 1920x1080
        adb shell settings put system screen_brightness 1
        scrcpy --video-codec=h265 --video-bit-rate=24M --max-fps=60 --stay-awake &
        # scrcpy --video-codec=h265 --video-bit-rate=24M --max-fps=144 --turn-screen-off --stay-awake &
        # https://github.com/Genymobile/scrcpy/blob/master/doc/device.md
        valid_flag=true
        ;;
    droid-0)
        pkill scrcpy
        adb shell wm density reset
        adb shell wm size reset
        adb shell settings put system screen_brightness 50
        valid_flag=true
        ;;
        # ------------------------- VPN -------------------------
    vpn-c)
        '
        protonvpn-cli ks --permanent
        To disconnect : nmcli c show
        To disconnect : nmcli c delete pvpn-ipv6leak-protection
        nmcli c delete pvpn-killswitch
        nmcli c delete pvpn-routed-killswitch
        nmcli c delete pvpn-ipv6leak-protection
        protonvpn-cli d
        echo "2 secs to cancel"
        sleep 2
        '
        protonvpn-cli c --cc "NL"
        valid_flag=true
        ;;
    vpn-d)
        protonvpn-cli d
        nmcli c delete pvpn-killswitch
        nmcli c delete pvpn-routed-killswitch
        nmcli c delete pvpn-ipv6leak-protection
        valid_flag=true
        ;;
    backup)
        mkdir -p "$restore_pth"

        # Create list of installed packages
        pacman -Qet | awk '{print $1}' >$restore_pth/arch-pkgs.txt
        pacman -Qqm | awk '{print $1}' >$restore_pth/aur-pkgs.txt
        '
        date=$(date +%Y.%m.%d-%H.%M.%S)
        backup_drive="/run/media/z/BEE8-11ED/2023/archlinux/$date/"
        if [ -f "$backup_drive" ]; then
            mkdir -p "$backup_drive"
            rsync -av --exclude '.cache' /home "$backup_drive"
        else
            echo -e ${BRed}"[!] Backup drive is not connected. Skipping /home/$(whoami) backup." ${Color_Off}
            # excfile="$HOME/media/Documents/exclude.txt"
            # https://man7.org/linux/man-pages/man1/rsync.1.html
            # rsync -av --exclude-from '/home/drmdub/media/Documents/rs' /home "$budir"/"$date"
            # notify-send -h string:fgcolor:#ff4444 "back up running"
        fi
        echo -e ${BRed}"[!] Authentication Required" ${Color_Off}
        sudo timeshift --create
        '
        valid_flag=true
        ;;
    restore)
        # sudo pacman -S --needed - <$restore_pth/arch-pkgs.txt
        # yay -S --needed - <$restore_pth/aur-pkgs.txt
        # ------------------------------------------------------------------------------
        key="Arch"
        echo "Checking $key"
        pacman_packages=($(<$restore_pth/arch-pkgs.txt))
        yay_packages=($(<$restore_pth/aur-pkgs.txt))

        for package in "${pacman_packages[@]}"; do
            if ! pacman -Qi "$package" >/dev/null 2>&1; then
                sudo pacman -S --noconfirm "$package"
            fi
        done
        key="AUR"
        echo "Checking $key"
        for package in "${yay_packages[@]}"; do
            if ! yay -Qs "$package" >/dev/null; then
                yay -S --noconfirm "$package"
            fi
        done
        # ------------------------------------------------------------------------------
        valid_flag=true
        ;;
    wolf)
        librewolf --profile /mnt/veracrypt1/AppData/libre-dev-profile &
        valid_flag=true
        ;;
    push)
        # cp ~/.config/hypr/hyprland.conf ~/dotfiles/
        # cp ~/cmd.sh ~/dotfiles/
        mkdir "~/dotfiles/waybar/"
        mkdir "~/dotfiles/wofi/"
        cp "~/.config/waybar/config" "~/dotfiles/waybar/config"
        cp "~/.config/waybar/style.css" "~/dotfiles/waybar/style.css"
        cp "~/.config/wofi/style.css" "~/dotfiles/wofi/style.css"
        valid_flag=true
        ;;
    wall)
        hyprpaper &
        valid_flag=true
        ;;
        # ------------------------- yt-dlp -------------------------
    yt)
        VIDEO_URL="$2"
        VIDEO_URL=$(echo "$VIDEO_URL" | sed 's/ //g')
        echo -e "${BBlue}yt-dlp\n${Color_Off}"
        # if [[ -n "$VIDEO_URL" && "$VIDEO_URL" == https://* ]]; then
        if [[ -n "$VIDEO_URL" ]]; then
            yt-dlp -f mp4 -o "~/Downloads/%(title)s.%(ext)s" "$VIDEO_URL"
            VIDEO_FILENAME=$(yt-dlp -e -o "~/Downloads/%(title)s.%(ext)s" "$VIDEO_URL")
            wl-copy <"~/Downloads/$VIDEO_FILENAME.mp4"
            echo "~/Downloads/$VIDEO_FILENAME.mp4"
            valid_flag=true
        else
            echo -e "${BRed}[!] No video linked.\n${Color_Off}"
            exit 1
        fi
        ;;
    yt-best)
        VIDEO_URL="$2"
        VIDEO_URL=$(echo "$VIDEO_URL" | sed 's/ //g')
        echo -e "${BBlue}yt-dlp (best quality)\n${Color_Off}"
        if [[ -n "$VIDEO_URL" ]]; then
            yt-dlp -f 'bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best' -o "~/Downloads/%(title)s.%(ext)s" "$VIDEO_URL"
            valid_flag=true
        else
            echo -e "${BRed}[!] No video linked.\n${Color_Off}"
            exit 1
        fi
        ;;
    yt-playlist)
        VIDEO_URL="$2"
        VIDEO_URL=$(echo "$VIDEO_URL" | sed 's/ //g')
        echo -e "${BBlue}yt-dlp\n${Color_Off}"
        if [[ -n "$VIDEO_URL" ]]; then
            yt-dlp -f bestaudio/best --extract-audio --audio-format mp3 --embed-thumbnail --output "~/Downloads/%(playlist_title)s/%(title)s.%(ext)s" "$VIDEO_URL"
            valid_flag=true
        else
            echo -e "${BRed}[!] No playlist linked.\n${Color_Off}"
            exit 1
        fi
        ;;
    yt-channel)
        VIDEO_URL="$2"
        VIDEO_URL=$(echo "$VIDEO_URL" | sed 's/ //g')
        echo -e "${BBlue}yt-dlp\n${Color_Off}"
        if [[ -n "$VIDEO_URL" ]]; then
            echo "Example Format: https://www.youtube.com/@CTStudiosOfficial/playlists"
            yt-dlp -f bestaudio/best --extract-audio --audio-format mp3 --embed-thumbnail --output "~/Downloads/%(playlist)s/%(title)s.%(ext)s" "$VIDEO_URL"
            valid_flag=true
        else
            echo -e "${BRed}[!] No channel linked.\n${Color_Off}"
            exit 1
        fi
        ;;
    *) ;;
    esac
done
if ! $valid_flag; then
    # echo -e ${BRed}"\n[!] Incorrect or misspelled flag.\n\nProceeding with default...\n" ${Color_Off}
    if [ $# -eq 0 ]; then
        echo -e "${BRed}[!] No flags were supplied.\n${Color_Off}"
    else
        echo -e ${BRed}"[!] Incorrect or misspelled flag.\n" ${Color_Off}
    fi
    echo -e ${BBlue}"[?] Usage: cmd h" ${Color_Off}
    exit 2
fi
