set -U fish_user_abbreviations
set -U fish_user_abbreviations $fish_user_abbreviations 'c=cargo'
set -U fish_user_abbreviations $fish_user_abbreviations 'm=make'
set -U fish_user_abbreviations $fish_user_abbreviations 'o=xdg-open'
set -U fish_user_abbreviations $fish_user_abbreviations 'g=git'
set -U fish_user_abbreviations $fish_user_abbreviations 'gc=git checkout'
set -U fish_user_abbreviations $fish_user_abbreviations 'vimdiff=nvim -d'
set -U fish_user_abbreviations $fish_user_abbreviations 'gah=git stash; and git pull --rebase; and git stash pop'
set -U fish_user_abbreviations $fish_user_abbreviations 's!=sudo !!'
complete --command yay --wraps pacman

# Start X at login
if status is-login
    if test -z "$DISPLAY" -a $XDG_VTNR = 1
        exec startx # -- -keeptty
    end
end

if status --is-interactive
    tmux ^ /dev/null; and exec true
    alias sk sk-tmux
    alias fzf fzf-tmux
end

if exa --version >/dev/null
    set -U fish_user_abbreviations $fish_user_abbreviations 'l=exa'
    set -U fish_user_abbreviations $fish_user_abbreviations 'ls=exa -l'
    set -U fish_user_abbreviations $fish_user_abbreviations 'lls=exa -la'
else
    set -U fish_user_abbreviations $fish_user_abbreviations 'l=ls'
    set -U fish_user_abbreviations $fish_user_abbreviations 'ls=ls -l'
    set -U fish_user_abbreviations $fish_user_abbreviations 'lls=ls -la'
end

if sk --version >/dev/null
    set -U fish_user_abbreviations $fish_user_abbreviations 'fo=xdg-open (sk) 2>/dev/null &'
else if fzf --version >/dev/null
    set -U fish_user_abbreviations $fish_user_abbreviations 'fo=xdg-open (fzf) &'
end

if rg --version >/dev/null
    set rgcmd 'rg --files --hidden --follow --glob "!.git/*"'
    if fzf --version >/dev/null
        set -x FZF_DEFAULT_COMMAND $rgcmd
    end
    if sk --version >/dev/null
        set -x SKIM_DEFAULT_COMMAND $rgcmd
    end
end

function remote_alacritty
    # https://gist.github.com/costis/5135502
    set fn (mktemp)
    infocmp alacritty-256color > $fn
    scp $fn $argv[1]":alacritty-256color.ti"
    ssh $argv[1] tic "alacritty-256color.ti"
    ssh $argv[1] rm "alacritty-256color.ti"
end

set PATH /usr/local/bin/ $PATH
set PATH $PATH ~/bin
set PATH $PATH ~/.cargo/bin

set -x EDITOR nvim
set -x SYSTEMD_EDITOR /usr/bin/nvim
set -x BROWSER firefox
set -x TZ 'Europe/Amsterdam'
set -x RUST_BACKTRACE 1
set -x RUSTFLAGS "-C target-cpu=native"
set -x FZF_LEGACY_KEYBINDINGS 0

function fish_greeting
    echo
    echo -e (uname -ro | awk '{print " \\\\e[1mOS: \\\\e[0;32m"$0"\\\\e[0m"}')
    echo -e (uptime -p | sed 's/^up //' | awk '{print " \\\\e[1mUptime: \\\\e[0;32m"$0"\\\\e[0m"}')
    echo -e (uname -n | awk '{print " \\\\e[1mHostname: \\\\e[0;32m"$0"\\\\e[0m"}')
    echo -e " \\e[1mDisk usage:\\e[0m"
    # echo
    echo -ne (\
        df -l -h | grep -E 'dev/(xvda|sd|mapper)' | \
        awk '{printf "\\\\t%s\\\\t%4s / %4s  %s\\\\n\n", $6, $3, $2, $5}' | \
        sed -e 's/^\(.*\([8][5-9]\|[9][0-9]\)%.*\)$/\\\\e[0;31m\1\\\\e[0m/' -e 's/^\(.*\([7][5-9]\|[8][0-4]\)%.*\)$/\\\\e[0;33m\1\\\\e[0m/' | \
        paste -sd ''\
    )
    # echo

    echo -e " \\e[1mNetwork:\\e[0m"
    # echo
    # http://tdt.rocks/linux_network_interface_naming.html
    echo -ne (\
        ip addr show up scope global | \
            grep -E ': <|inet' | \
            sed \
                -e 's/^[[:digit:]]\+: //' \
                -e 's/: <.*//' \
                -e 's/.*inet[[:digit:]]* //' \
                -e 's/\/.*//'| \
            awk 'BEGIN {i=""} /\.|:/ {print i" "$0"\\\n"; next} // {i = $0}' | \
            sort | \
            column -t -R1 | \
            # public addresses are underlined for visibility \
            sed 's/ \([^ ]\+\)$/ \\\e[4m\1/' | \
            # private addresses are not \
            sed 's/m\(\(10\.\|172\.\(1[6-9]\|2[0-9]\|3[01]\)\|192\.168\.\).*\)/m\\\e[24m\1/' | \
            # unknown interfaces are cyan \
            sed 's/^\( *[^ ]\+\)/\\\e[36m\1/' | \
            # ethernet interfaces are normal \
            sed 's/\(\(en\|em\|eth\)[^ ]* .*\)/\\\e[39m\1/' | \
            # wireless interfaces are purple \
            sed 's/\(wl[^ ]* .*\)/\\\e[35m\1/' | \
            # wwan interfaces are yellow \
            sed 's/\(ww[^ ]* .*\).*/\\\e[33m\1/' | \
            sed 's/$/\\\e[0m/' | \
            sed 's/^/\t/' \
    )
    set_color normal
    echo
end
