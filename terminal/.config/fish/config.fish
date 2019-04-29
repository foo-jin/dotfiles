abbr -a -g c cargo
abbr -a -g m make
abbr -a -g g git
abbr -a -g gc 'git checkout'
abbr -a -g vimdiff 'nvim -d'
abbr -a -g gah 'git stash; and git pull --rebase; and git stash pop'
abbr -a -g s! 'sudo !!'
abbr -a -g yt youtube-dl
abbr -a -g sys systemctl
complete --command yay --wraps pacman

if exa --version >/dev/null
    alias l exa
    alias ls 'exa -lh --git'
    alias lls 'exa -lha --git'
else
    alias l ls
    alias ls 'ls -l'
    alias lls 'ls -la'
end

if sk --version >/dev/null
    abbr -a -g fo sk-open
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

if nvim --version >/dev/null
    set -x EDITOR (which nvim)
    set -x SUDO_EDITOR $EDITOR
    set -x SYSTEMD_EDITOR $EDITOR
end

set -x BROWSER firefox
set -x TERMCMD alacritty
set -x TZ 'Europe/Amsterdam'
set -x RUST_BACKTRACE 1
set -x RUSTFLAGS "-C target-cpu=native"
set -x RIPGREP_CONFIG_PATH $cfg/ripgreprc
set -x GNUPGHOME $cfg/gnupg
set -x PASSWORD_STORE_GENERATED_LENGTH 20

# source local config
set -l localcfg $cfg/fish/local-config.fish
if test -e $localcfg
    source $localcfg
end

# Start or re-use a gpg-agent.
gpgconf --launch gpg-agent

# Ensure that GPG Agent is used as the SSH agent
set -e SSH_AUTH_SOCK
set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)

