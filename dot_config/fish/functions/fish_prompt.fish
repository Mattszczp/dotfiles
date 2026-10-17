function fish_prompt --description 'Robbyrussell-style prompt'
    set -l last_status $status

    if test $last_status -eq 0
        set_color green
    else
        set_color red
    end
    echo -n '➜ '

    set_color cyan
    echo -n (prompt_pwd)

    if git rev-parse --is-inside-work-tree >/dev/null 2>&1
        set -l branch (git branch --show-current 2>/dev/null; or git rev-parse --short HEAD)
        set_color blue
        echo -n ' git:('
        set_color red
        echo -n $branch
        set_color blue
        echo -n ')'
        if test -n "$(git status --porcelain 2>/dev/null)"
            set_color yellow
            echo -n ' ✗'
        end
    end

    set_color normal
    echo -n ' '
end
