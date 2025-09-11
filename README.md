# Dotfiles
Based configs I use

Trying to keep things minimal

## Structure
- Each program has its own folder containing all related files and subfolders
- All folders are stored in `~/.config/`
- Chezmoi is no longer being used but might be helpful for less streamlined structures

## Installation
Just git clone and move

### Symlinks
Some programs look for config files in different locations. Use symbolic links to make them accessible without moving files. Only if needed! Wezterm for example looks in multiple locations and is fine with this structure

Example: `ln -s ~/.config/zsh/.zshrc ~/.zshrc`

- `ln` - creates links between files
- `-s` - symbolic (soft) link instead of hard link
- The symlink points from where the program expects the config (`~/.zshrc`) to where it is actually located (`~/.config/zsh/.zshrc`). 
