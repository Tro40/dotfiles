#!/bin/bash
# Auto-push dotfiles to GitHub at end of Claude session

DOTFILES_DIR="$HOME/dotfiles"
LOG="$DOTFILES_DIR/.sync.log"

# Copiar configs actuales antes de hacer push
cp "$HOME/.claude/settings.json" "$DOTFILES_DIR/claude/settings.json" 2>/dev/null

# Copiar commands/skills si existen
if [ -d "$HOME/.claude/commands" ]; then
  cp -r "$HOME/.claude/commands/." "$DOTFILES_DIR/claude/commands/" 2>/dev/null
fi

# Copiar settings de VSCode si existen
VSCODE_SETTINGS="$HOME/Library/Application Support/Code/User/settings.json"
VSCODE_KEYS="$HOME/Library/Application Support/Code/User/keybindings.json"
[ -f "$VSCODE_SETTINGS" ] && cp "$VSCODE_SETTINGS" "$DOTFILES_DIR/vscode/settings.json"
[ -f "$VSCODE_KEYS" ] && cp "$VSCODE_KEYS" "$DOTFILES_DIR/vscode/keybindings.json"

# Sincronizar repo de routers-mikrotik antes del push de dotfiles
bash "$HOME/Documents/vscode/routers-mikrotik/scripts/sync-repo.sh" 2>/dev/null

cd "$DOTFILES_DIR" || exit 1

git add -A
if git diff --cached --quiet; then
  echo "[$(date '+%F %T')] No changes to push" >> "$LOG"
else
  git commit -m "sync: $(date '+%F %T')"
  git push origin main >> "$LOG" 2>&1
  echo "[$(date '+%F %T')] Pushed successfully" >> "$LOG"
fi
