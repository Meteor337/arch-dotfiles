#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/wallpapers"
STATE_FILE="$HOME/.cache/current_wallpaper_index"

# Собираем обои
mapfile -t wallpapers < <(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) | sort)

# Если нет обоев - выходим
if [ ${#wallpapers[@]} -eq 0 ]; then
    echo "No wallpapers found in $WALLPAPER_DIR"
    exit 1
fi

# Останавливаем старые процессы swww
pkill swww 2>/dev/null

# Запускаем демон swww с правильным форматом
swww-daemon --format xrgb &

# Ждём запуска демона
sleep 0.5

# Функция для установки обоев через swww
set_wallpaper() {
    local wallpaper="$1"
    swww img "$wallpaper" \
        --transition-type center \
        --transition-duration 0.5 \
        --transition-fps 165
}

# Если есть сохранённый индекс - ставим те обои
if [ -f "$STATE_FILE" ] && [ ${#wallpapers[@]} -gt 0 ]; then
    saved_index=$(cat "$STATE_FILE")

    # Проверяем, что индекс валидный
    if [[ "$saved_index" =~ ^[0-9]+$ ]] && [ "$saved_index" -lt ${#wallpapers[@]} ]; then
        saved_wallpaper="${wallpapers[$saved_index]}"

        if [ -f "$saved_wallpaper" ]; then
            set_wallpaper "$saved_wallpaper"
            echo "Restored wallpaper: $(basename "$saved_wallpaper")"
        else
            # Если файла нет - ставим первые обои
            set_wallpaper "${wallpapers[0]}"
            echo "Saved wallpaper not found, using first: $(basename "${wallpapers[0]}")"
        fi
    else
        # Если индекс кривой - ставим первые обои
        set_wallpaper "${wallpapers[0]}"
        echo "Invalid index, using first: $(basename "${wallpapers[0]}")"
    fi
else
    # Если нет файла состояния - ставим первые обои
    set_wallpaper "${wallpapers[0]}"
    echo "No state file, using first: $(basename "${wallpapers[0]}")"
fi
