#!/bin/bash
# @AnAncientForce >> HP

pacman_packages=(
    "adobe-source-han-sans-jp-fonts"
    "adobe-source-han-sans-otc-fonts"
    "adobe-source-han-serif-otc-fonts"
    "noto-fonts-emoji"
    "alacritty"
    "ark"
    "brightnessctl"
    "calcurse"
    "feh"
    "filelight"
    "git"
    "gvfs"
    "kitty"
    "kvantum"
    "mpv-mpris"
    "neofetch"
    "pavucontrol"
    "polybar"
    "rofi"
    "sox"
    "thunar"
    "tldr"
    "wget"
    "zip"
    "python-pip"
    "tk"
    "lxappearance"
    "qt5ct"
    "jq"
    "python-pillow"
    "breeze"
    "base-devel"
    "git"
    "xfce4-screenshooter"
    "copyq"
    "ntfs-3g"
    "fuse"
    "thunar-volman"
    "curl"
    "cmatrix"
    "socat"
    "xdotool"
    "playerctl"
    "bluez"
    "bluez-utils"
    "blueman"
    "conky"
    "noto-fonts"
    "font-manager"
    "timeshift"
    "tumbler"
    "ffmpegthumbnailer"
    "npm"
    "xorg-xinit"
    "xfce4-settings"
    "gedit"
    "dunst"
    "arandr"
    "python-pipx"
    "htop"
    "linux-headers"
)
# Disable "FreeMono"
yay_packages=(
    "xidlehook"
    "vimix-gtk-themes"
    "vimix-cursors"
    "vimix-icon-theme"
    "cava-git"
    "librewolf-bin"
    "picom-simpleanims-git"
    "autotiling"
    "ttf-font-awesome-4"
    "tty-clock"
    "pipes.sh"
    "ungoogled-chromium-bin"
    "droidcam"
)

'
wf-recorder
waybar
grim
wl-copy
hyprshot
tesseract
copyq
uxterm
yt-dlp
playerctl
dunstify
kitty
protonvpn
'

install_rec_pacman() {
    not_installed=0
    key="Arch"
    echo "Checking $key"
    # Check before warning prompt
    for package in "${pacman_packages[@]}"; do
        if ! pacman -Qi "$package" >/dev/null 2>&1; then
            not_installed=1
            break # Break out of the loop as soon as we find a package that needs installation
        fi
    done
    if [ $not_installed -eq 1 ]; then
        # Now for the real install
        echo -e ${BRed}"[*] Attention Required\n" ${Color_Off}
        for package in "${pacman_packages[@]}"; do
            if ! pacman -Qi "$package" >/dev/null 2>&1; then
                sudo pacman -S --noconfirm "$package"
            fi
        done
    else
        echo -e "${BGreen}[*] $key packages are already installed\n${Color_Off}"
    fi
}

install_rec_yay() {
    not_installed=0
    key="AUR"
    echo "Checking $key"
    for package in "${yay_packages[@]}"; do
        if ! yay -Qs "$package" >/dev/null; then
            yay -S --noconfirm "$package"
            not_installed=1
        fi
    done
    if [ $not_installed -eq 1 ]; then
        echo "Some $key packages were installed."
    else
        echo -e "${BGreen}[*] $key packages are already installed\n${Color_Off}"
    fi

    if ! is_package_installed "betterlockscreen"; then
        echo -e "${BRed}[!] Attention Required${Color_Off}"
        yay -S betterlockscreen
    fi
}

install_rec_pacman
install_rec_yay
