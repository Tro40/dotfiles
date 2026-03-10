# Dotfiles — Eduardo

Configuración sincronizada de Claude Code y VSCode.
Se sincroniza automáticamente al inicio y fin de cada sesión de Claude.

## Contenido

```
dotfiles/
├── claude/
│   ├── settings.json       # Config Claude Code (MCP servers, hooks)
│   └── commands/           # Skills / comandos personalizados
├── vscode/
│   ├── settings.json       # Preferencias VSCode
│   └── keybindings.json    # Atajos de teclado
└── scripts/
    ├── install.sh          # Instalación en máquina nueva
    ├── sync-push.sh        # Push automático (hook Stop)
    └── sync-pull.sh        # Pull automático (hook UserPromptSubmit)
```

## Instalación en máquina nueva

```bash
# 1. Prerrequisitos
brew install gh git
gh auth login

# 2. Instalar dotfiles
curl -fsSL https://raw.githubusercontent.com/Tro40/dotfiles/main/scripts/install.sh | bash

# 3. Clonar proyectos
git clone https://github.com/Tro40/proxmox.git ~/Documents/vscode/Proxmox-mikrotik
```

## Sincronización automática

| Evento | Acción |
|--------|--------|
| Primer mensaje de sesión | `sync-pull.sh` → pull de GitHub |
| Final de respuesta de Claude | `sync-push.sh` → push a GitHub |

La sincronización de pull ocurre **una vez al día** (flag `.pulled_YYYYMMDD`).
