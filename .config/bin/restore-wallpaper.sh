#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
STATE_FILE="$HOME/.cache/current_wallpaper_index"

# Собираем обои
mapfile -t wallpapers < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | sort)

# Если есть сохранённый индекс - ставим те обои
if [ -f "$STATE_FILE" ] && [ ${#wallpapers[@]} -gt 0 ]; then
    saved_index=$(cat "$STATE_FILE")
    saved_wallpaper="${wallpapers[$saved_index]}"

    if [ -f "$saved_wallpaper" ]; then
        swaybg -o "*" -i "$saved_wallpaper" -m fill &
    else
        # Если файла нет - ставим первые обои
        swaybg -o "*" -i "${wallpapers[0]}" -m fill &
    fi
fi
