abbr -a c cargo
abbr -a m make
abbr -a g git
abbr -a gc 'git checkout'
abbr -a vimdiff 'nvim -d'
abbr -a gah 'git stash; and git pull --rebase; and git stash pop'
abbr -a s! 'sudo !!'
complete --command yay --wraps pacman

if exa --version >/dev/null
    abbr -a l exa
    abbr -a ls 'exa -lh --git'
    abbr -a lls 'exa -lha --git'
else
    abbr -a l ls
    abbr -a ls 'ls -l'
    abbr -a lls 'ls -la'
end

if sk --version >/dev/null
    abbr -a fo sk-open
end

if rg --version >/dev/null
    set -l rgcmd 'rg --files --hidden --follow --glob "!.git/*"'
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

set -x PATH /usr/local/bin/ $PATH
set -x PATH $PATH ~/bin
set -x PATH $PATH ~/.cargo/bin
set -x PATH $PATH ~/.emacs.d/bin

set -x XDG_CONFIG_HOME $HOME/.config
set -l cfg $XDG_CONFIG_HOME
# source the xdg dirs
awk 'BEGIN { FS = "=" } !/^#/ { printf("set -x %s %s\n", $1, $2) }' $cfg/user-dirs.dirs | source

set -x EDITOR neovim
set -x SYSTEMD_EDITOR $EDITOR
set -x BROWSER firefox
set -x TZ 'Europe/Amsterdam'
set -x RUST_BACKTRACE 1
set -x RUSTFLAGS "-C target-cpu=native"
set -x RIPGREP_CONFIG_PATH $cfg/ripgreprc
set -x GNUPGHOME $cfg/gnupg

# source local config
set -l localcfg $cfg/fish/local-config.fish
if test -e $localcfg
    source $localcfg
end

function fish_greeting
    echo
    echo -e (uname -ro | awk '{print " \\\\e[1mOS: \\\\e[0;32m"$0"\\\\e[0m"}')
    echo -e (uptime -p | sed 's/^up //' | awk '{print " \\\\e[1mUptime: \\\\e[0;32m"$0"\\\\e[0m"}')
    echo -e (uname -n | awk '{print " \\\\e[1mHostname: \\\\e[0;32m"$0"\\\\e[0m"}')
    echo -e " \\e[1mDisk usage:\\e[0m"
    # echo
    echo -ne (\
        df -l -h | grep -E 'dev/(xvda|sd|mapper)' | \
        awk '{printf "\\\\t%-10s\\\\t%4s / %4s  %s\\\\n\n", $6, $3, $2, $5}' | \
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
