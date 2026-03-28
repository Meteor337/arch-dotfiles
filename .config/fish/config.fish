set -U fish_greeting
if status is-interactive
    # Commands to run in interactive sessions can go here
    fastfetch
    
    # Функция приглашения с зеленой стрелкой ➜
    function fish_prompt
        # Получаем имя пользователя и хост
        set -l user (whoami)
        set -l host (hostname -s)
        
        # Сокращаем путь (заменяет /home/username на ~)
        set -l pwd (prompt_pwd)
        
        # Выводим приглашение: user@host путь ➜
        echo -n -s "$user" "@" "$host" " " "$pwd" " " (set_color green) "➜" (set_color normal) " "
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
