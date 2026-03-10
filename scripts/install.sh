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

echo "==> Clonando routers-mikrotik..."
ROUTERS_DIR="$HOME/Documents/vscode/routers-mikrotik"
mkdir -p "$HOME/Documents/vscode"
if [ ! -d "$ROUTERS_DIR" ]; then
  git clone https://github.com/Tro40/routers-mikrotik.git "$ROUTERS_DIR"
else
  echo "    Ya existe $ROUTERS_DIR, haciendo pull..."
  cd "$ROUTERS_DIR" && git pull origin main
fi
chmod +x "$ROUTERS_DIR/scripts/sync-repo.sh"

echo "==> Inyectando token de GitHub en ~/.claude/settings.json..."
if command -v gh &>/dev/null && gh auth status &>/dev/null; then
  GH_TOKEN=$(gh auth token)
  sed -i '' "s/\"GITHUB_PERSONAL_ACCESS_TOKEN\": \".*\"/\"GITHUB_PERSONAL_ACCESS_TOKEN\": \"$GH_TOKEN\"/" \
    "$HOME/.claude/settings.json"
  echo "    Token inyectado correctamente."
else
  echo "    gh no autenticado — ejecuta 'gh auth login' y vuelve a correr este script."
fi

echo ""
echo "✓ Instalación completada."
