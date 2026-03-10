#!/bin/bash
# Auto-pull dotfiles from GitHub at start of Claude session

DOTFILES_DIR="$HOME/dotfiles"
FLAG="$DOTFILES_DIR/.pulled_$(date '+%Y%m%d')"

# Solo pull una vez por día
[ -f "$FLAG" ] && exit 0

cd "$DOTFILES_DIR" || exit 1

git pull origin main --quiet 2>/dev/null

# Aplicar configs
cp "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/settings.json" 2>/dev/null

if [ -d "$DOTFILES_DIR/claude/commands" ] && [ "$(ls -A "$DOTFILES_DIR/claude/commands")" ]; then
  mkdir -p "$HOME/.claude/commands"
  cp -r "$DOTFILES_DIR/claude/commands/." "$HOME/.claude/commands/" 2>/dev/null
fi

VSCODE_USER="$HOME/Library/Application Support/Code/User"
[ -f "$DOTFILES_DIR/vscode/settings.json" ] && cp "$DOTFILES_DIR/vscode/settings.json" "$VSCODE_USER/settings.json"
[ -f "$DOTFILES_DIR/vscode/keybindings.json" ] && cp "$DOTFILES_DIR/vscode/keybindings.json" "$VSCODE_USER/keybindings.json"

# Marcar como hecho hoy
touch "$FLAG"
# Limpiar flags de días anteriores
find "$DOTFILES_DIR" -name ".pulled_*" ! -name ".pulled_$(date '+%Y%m%d')" -delete
