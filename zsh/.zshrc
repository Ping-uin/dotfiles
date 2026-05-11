# HACK: ln -s ~/.config/zsh/.zshrc ~/.zshrc

# --- ENV & PATHS ---
export PATH="$HOME/.atuin/bin:$HOME/.config/emacs/bin:$PATH"

# --- ATUIN SETUP ---
eval "$(atuin init zsh)"

# --- ALIASES ---
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    export CLICOLOR=1
    alias ls='ls -G'
else
    # Linux
    alias ls='ls --color=auto'
fi

alias asw="~/acc_switch/switch_acc.sh"

# Ubuntu spefici workaround
if [[ ! -f /etc/NIXOS ]]; then
    alias emacs="WAYLAND_DISPLAY=wayland-0 GDK_BACKEND=wayland emacs"
fi

alias et="emacs -nw"
alias sw="cd $HOME/Documents/sw_workspace"
alias pomo="$HOME/Documents/sw_workspace/yapt/pomo"

# --- GIT INFORMATION SETUP ---
autoload -Uz vcs_info
precmd() { vcs_info; }
# Simples Git-Format in Klammern, ohne Farben: (branch) oder (branch|action)
zstyle ':vcs_info:git:*' formats ' (%b)'
zstyle ':vcs_info:git:*' actionformats ' (%b|%a)'
setopt PROMPT_SUBST

# --- PROMPT ---
# Format: user@host:~/pfad (git-branch) $
PROMPT='%n@%m:%~${vcs_info_msg_0_} $ '

# --- HISTORY SETTINGS ---
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

setopt SHARE_HISTORY        # Share history between sessions
setopt HIST_IGNORE_DUPS     # Don't record duplicates
setopt HIST_IGNORE_ALL_DUPS # Remove older duplicates
setopt HIST_FIND_NO_DUPS    # Don't display duplicates when searching
setopt HIST_IGNORE_SPACE    # Don't record commands starting with space
setopt HIST_REDUCE_BLANKS   # Remove superfluous blanks
setopt INC_APPEND_HISTORY   # Append to history immediately

# --- STARTUP (to make active zsh visible) ---

CHARM_PINK='\033[38;2;242;93;148m'   # #F25D94
CHARM_YELLOW='\033[38;2;243;210;80m' # #F3D250
RESET='\033[0m'

echo ""
echo -e "              ______________ "
echo -e " ${CHARM_PINK}⋈${RESET}_         / Make it work  \\\\"
echo -e "( o${CHARM_YELLOW}>${RESET}      < | Make it right |"
echo -e "///\\\\        \\\\ Make it fast  /"
echo -e "\\\\V${CHARM_YELLOW}_${RESET}/${CHARM_YELLOW}_${RESET}         -------------- "
echo ""
