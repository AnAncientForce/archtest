#!/bin/bash
# @AnAncientForce >> HP

# screenshots will work whether mounted or dismounted
# https://github.com/bugaevc/wl-clipboard

# This script is responsible for screen snippets

# f = screenshot full
# s = screenshot region
# o = OCR region

'
if [ -d "$veracrypt" ]; then
            mkdir $veracrypt/Screenshots/full/
            file="$veracrypt/Screenshots/full/$(date +"%Y%m%d-%H%M%S").png"


if [ -d "$veracrypt" ]; then
            mkdir $veracrypt/Screenshots/snips/
            hyprshot -s -o $veracrypt/Screenshots/snips/ -m region
            # grim -o "$veracrypt/Screenshots/snips/" -g "$(slurp)" - | wl-copy
'

valid_flag=false
file=""

for arg in "$@"; do
    case "$arg" in
    f)
        mkdir ~/Pictures/full/
        file="~/Pictures/full/$(date +"%Y%m%d-%H%M%S").png"
        grim "$file"
        wl-copy <$file
        valid_flag=true
        ;;
    s)

        mkdir ~/Pictures/snips/
        hyprshot -s -o ~/Pictures/snips/ -m region
        valid_flag=true
        ;;
    o)
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
    *) ;;
    esac
done
if ! $valid_flag; then
    if [ $# -eq 0 ]; then
        echo -e "${BRed}[!] No flags were supplied.\n${Color_Off}"
    else
        echo -e ${BRed}"[!] Incorrect or misspelled flag.\n" ${Color_Off}
    fi
fi
