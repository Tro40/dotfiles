#!/bin/bash
# Instalar dotfiles en una máquina nueva
# Uso: bash install.sh

set -e

DOTFILES_DIR="$HOME/dotfiles"

echo "==> Clonando dotfiles..."
if [ ! -d "$DOTFILES_DIR" ]; then
  git clone https://github.com/Tro40/dotfiles.git "$DOTFILES_DIR"
else
  echo "    Ya existe $DOTFILES_DIR, haciendo pull..."
  cd "$DOTFILES_DIR" && git pull origin main
fi

echo "==> Aplicando configuración de Claude Code..."
mkdir -p "$HOME/.claude/commands"
cp "$DOTFILES_DIR/claude/settings.json" "$HOME/.claude/settings.json"
if [ "$(ls -A "$DOTFILES_DIR/claude/commands" 2>/dev/null)" ]; then
  cp -r "$DOTFILES_DIR/claude/commands/." "$HOME/.claude/commands/"
fi

echo "==> Aplicando configuración de VSCode..."
VSCODE_USER="$HOME/Library/Application Support/Code/User"
mkdir -p "$VSCODE_USER"
[ -f "$DOTFILES_DIR/vscode/settings.json" ] && cp "$DOTFILES_DIR/vscode/settings.json" "$VSCODE_USER/settings.json"
[ -f "$DOTFILES_DIR/vscode/keybindings.json" ] && cp "$DOTFILES_DIR/vscode/keybindings.json" "$VSCODE_USER/keybindings.json"

echo "==> Haciendo ejecutables los scripts..."
chmod +x "$DOTFILES_DIR/scripts/"*.sh

echo ""
echo "✓ Instalación completada."
echo "  Recuerda hacer: gh auth login"
