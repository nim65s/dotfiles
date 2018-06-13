# name: Nim
# author: Guilhem "Nim" Saurel − https://github.com/nim65s/dotfiles/

set __fish_git_prompt_showupstream auto

function nim_prompt_wrapper
    set retc $argv[1]
    set tty $argv[2]
    set field_name $argv[3]
    set field_value $argv[4]

    set_color normal
    set_color $retc
    if [ $tty = tty ]
        echo -n '-'
    else
        echo -n '─'
    end
    set_color -o green
    echo -n '['
    set_color normal
    test -n $field_name
    and echo -n $field_name:
    set_color $retc
    echo -n $field_value
    set_color -o green
    echo -n ']'
end

function fish_prompt
    and set retc green
    or set retc red
    tty | string match -q -r tty
    and set tty tty
    or set tty pts

    set_color $retc
    if [ $tty = tty ]
        echo -n .-
    else
        echo -n '┬─'
    end
    set_color -o green
    echo -n [
    if test "$USER" = root -o "$USER" = toor
        set_color -o red
    else
        set_color -o yellow
    end
    echo -n $USER
    set_color -o white
    echo -n @
    if [ -z "$SSH_CLIENT" ]
        set_color -o blue
    else
        set_color -o cyan
    end
    echo -n (prompt_hostname)
    set_color -o white
    echo -n :(prompt_pwd)
    set_color -o green
    echo -n ']'

    nim_prompt_wrapper $retc $tty '' (date +%X)
    set -q VIRTUAL_ENV
    and nim_prompt_wrapper $retc $tty V (basename "$VIRTUAL_ENV")
    test -d .git
    or git rev-parse --git-dir > /dev/null ^ /dev/null
    and nim_prompt_wrapper $retc $tty G (__fish_git_prompt | string trim -c ' ()')
    type -q acpi
    and test (acpi -a 2> /dev/null | string match -r off)
    and nim_prompt_wrapper $retc $tty B (acpi -b | cut -d' ' -f 4-)
    echo

    set_color normal
    for job in (jobs)
        set_color $retc
        if [ $tty = tty ]
            echo -n '; '
        else
            echo -n '│ '
        end
        set_color brown
        echo $job
    end
    set_color normal
    set_color $retc
    if [ $tty = tty ]
        echo -n "'->"
    else
        echo -n '╰─>'
    end
    set_color -o red
    echo -n '$ '
    set_color normal
end
