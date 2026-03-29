set -U fish_greeting
if status is-interactive
    # Commands to run in interactive sessions can go here
    fastfetch
    
    # Функция приглашения с путём на первой строке и ➜ на второй
    function fish_prompt
        # Получаем имя пользователя и хост
        set -l user (whoami)
        set -l host (hostname -s)
        
        # Сокращаем путь (заменяет /home/username на ~)
        set -l pwd (prompt_pwd)
        
        # Первая строка: user@host и путь с цветами
        # Зелёный цвет для пользователя, голубой для хоста
        echo -n -s (set_color green) "$user" (set_color normal) "@" (set_color cyan) "$host" (set_color normal) " " (set_color yellow) "$pwd" (set_color normal)
        echo  # Пустой echo для переноса строки
        
        # Вторая строка: зелёная стрелка для ввода команд
        echo -n -s (set_color green) "➜" (set_color normal) " "
    end
    
    function y
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        command yazi $argv --cwd-file="$tmp"
        if read -z cwd < "$tmp"; and [ "$cwd" != "$PWD" ]; and test -d "$cwd"
            builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
    end
    
    # Алиасы
    alias v='nvim'
    alias t='tmux'
end
