# ZSH Configuration 
# HACK: ln -s ~/.config/zsh/.zshrc ~/.zshrc

# ATUIN ENABLE
export PATH="$HOME/.atuin/bin:$PATH"
eval "$(atuin init zsh)"

# Enable colors
autoload -U colors && colors

# FILE TYPE COLORS
# Enable colored output for ls
export CLICOLOR=1

# Set LS_COLORS for different file types
# Format: type=color_code
# di=directories, ex=executables, ln=symlinks, fi=files
export LS_COLORS='di=1;34:ln=1;36:so=1;32:pi=33:ex=1;32:bd=34;46:cd=34;43:su=37;41:sg=30;43:tw=30;42:ow=34;42:*.tar=1;31:*.tgz=1;31:*.zip=1;31:*.gz=1;31:*.bz2=1;31:*.jpg=1;35:*.jpeg=1;35:*.png=1;35:*.gif=1;35:*.mp4=1;35:*.mkv=1;35:*.pdf=1;33:*.md=1;33:*.txt=0;37'

# Aliases for colored ls (choose based on your OS)
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS
    alias ls='ls -G'
else
    # Linux
    alias ls='ls --color=auto'
fi

alias ll='ls -lah'
alias la='ls -A'

# GIT INFORMATION SETUP
autoload -Uz vcs_info
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats ' (%F{#E82424}%b%f)'
zstyle ':vcs_info:git:*' actionformats ' (%F{#E82424}%b%f|%F{#FF9E3B}%a%f)'
setopt PROMPT_SUBST

# Kanagawa color scheme prompt
# Colors used:
# #7E9CD8 - Light blue (user@host)
# #7FB4CA - Cyan (directory path)  
# #E82424 - Red (git branch)
# #98BB6C - Green (prompt symbol)
# #DCD7BA - Light foreground
PROMPT='%F{#7E9CD8}%n@%m%f:%F{#7FB4CA}%~%f%F{#E82424}${vcs_info_msg_0_}%f %F{#98BB6C}$%f '

# Right prompt with time (optional)
# RPROMPT='%F{#727169}[%*]%f'

# HISTORY SETTINGS
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history

# History options
setopt SHARE_HISTORY          # Share history between sessions
setopt HIST_IGNORE_DUPS       # Don't record duplicates
setopt HIST_IGNORE_ALL_DUPS   # Remove older duplicates
setopt HIST_FIND_NO_DUPS      # Don't display duplicates when searching
setopt HIST_IGNORE_SPACE      # Don't record commands starting with space
setopt HIST_REDUCE_BLANKS     # Remove superfluous blanks
setopt INC_APPEND_HISTORY     # Append to history immediately

echo ""
echo -e "\033[38;2;152;187;108mMake it work\033[0m"
echo -e "\033[38;2;127;180;202mMake it right\033[0m" 
echo -e "\033[38;2;255;158;59mMake it fast\033[0m"
echo ""
