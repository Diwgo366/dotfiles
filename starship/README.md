# ⭐ Configuración de Starship

## Descripción
Prompt personalizado con Starship optimizado para desarrollo, usando caracteres de CaskayDiamono Nerd Font con separadores claros y símbolos Git intuitivos.

## Características

### Layout (2 líneas)
**Línea 1:** Usuario → Hostname → Directorio ║ Rama Git (+ estado) ║ Hora  
**Línea 2:** Flecha moderna (➜) como carácter de entrada

### Módulos Activos

| Módulo | Descripción | Símbolo |
|--------|-------------|---------|
| username | Usuario actual (siempre visible) | — |
| hostname | Nombre del servidor | — |
| directory | Ruta del directorio (sin truncación) | — |
| git_branch | Rama actual |  |
| git_status | Estado de cambios | (ver abajo) |
| docker_context | Contexto de Docker (auto-detecta) |  |
| conda | Entorno Conda |  |
| nodejs | Versión de Node.js |  |
| python | Versión de Python |  |
| rust | Versión de Rust |  |
| golang | Versión de Go |  |
| time | Hora actual (HH:MM) | — |
| cmd_duration | Duración del comando (> 500ms) | — |
| status | Estado del comando | ✖ (error) |

### Colores
- **Tema:** Dracula
- **Fuente:** CaskayDiamono Nerd Font

## Separadores

Los separadores `║` dividen claramente las secciones principales:

```
diego on diego-server in ~/ruta ║  main ●+? 14:32
                                ║
                    Separador entre contexto y rama Git
```

## Símbolos Git Status - Explicados Claramente

Cuando estés en un repositorio Git, verás símbolos que indican el estado de tus cambios:

### Estados de Archivos

| Símbolo | Significado | Ejemplo |
|---------|-------------|---------|
| `●` | **Modificado**: Archivos con cambios no guardados | Editaste un archivo |
| `+` | **Staged**: Cambios preparados para commit | Ya hiciste `git add` |
| `✖` | **Deletado**: Archivos eliminados | Borraste un archivo |
| `»` | **Renombrado**: Archivo cambió de nombre | Renombraste algo |
| `?` | **Sin seguimiento**: Archivos nuevos | Archivo nuevo no rastreado |
| `*` | **Stashed**: Cambios guardados en stash | Guardaste cambios temporales |
| `⚔` | **Conflicto**: Conflicto de merge | Hay conflictos sin resolver |

### Estados de Sincronización con Remoto

| Símbolo | Significado | Ejemplo |
|---------|-------------|---------|
| `↑1` | **Commits adelante**: Tu rama va 1 commit adelante | Hiciste commits sin push |
| `↓2` | **Commits atrás**: Tu rama va 2 commits atrás | Hay cambios en remoto |
| `↕ ↑1 ↓1` | **Diverged**: Ambas ramas tienen cambios | Necesitas sincronizar |

## Ejemplos Visuales

### Repositorio Limpio (sin cambios)
```
diego on diego-server in ~/proyecto ║  main 14:32
➜ 
```

### Con Cambios Modificados
```
diego on diego-server in ~/proyecto ║  main ● 14:32
➜ 
```
(● significa hay archivos modificados)

### Con Cambios Staged y Modificados
```
diego on diego-server in ~/proyecto ║  main ●+ 14:32
➜ 
```
(● = modificados, + = staged)

### Con Commits Pendientes
```
diego on diego-server in ~/proyecto ║  main ↑2 14:32
➜ 
```
(↑2 significa 2 commits adelante del remoto)

## Personalización

### Cambiar la duración mínima de comandos
En `[cmd_duration]`, modificar:
```toml
min_time = 500  # En milisegundos
```

### Cambiar formato de hora
En `[time]`, modificar:
```toml
time_format = "%H:%M"     # Solo hora (actual)
time_format = "%H:%M:%S"  # Con segundos
time_format = "%d/%m"     # Solo fecha
```

### Cambiar símbolos de Git
En `[git_status]`, puedes personalizar:
```toml
modified = "●"      # Cambiar ● por otro símbolo
staged = "+"        # Cambiar + por otro símbolo
deleted = "✖"       # Cambiar ✖ por otro símbolo
# ... etc
```

### Cambiar separadores
En cada módulo puedes cambiar `║` por otro símbolo:
```toml
[git_branch]
format = " ▸ [$symbol$branch]($style)"  # Usa ▸ en lugar de ║
```

### Cambiar colores
Modifica la paleta `[palettes.dracula]` con valores hex

### Deshabilitar un módulo
Usa `disabled = true` en la sección del módulo

## Archivo de Configuración
- **Ubicación:** `~/.config/starship.toml`
- **Enlace del proyecto:** `/home/diego/dotfiles/starship/.config/starship.toml`

## Inicialización
Ya configurado automáticamente en `~/.zshrc`:
```bash
eval "$(~/.local/bin/starship init zsh)"
```

## Requisitos
- **Starship:** v1.25.1+
- **Fuente:** CaskayDiamono Nerd Font
- **Shell:** Zsh (o bash con ajustes)

## Referencias
- [Documentación de Starship](https://starship.rs/)
- [Colores Dracula](https://draculatheme.com/)
- [Nerd Fonts - CaskayDiamono](https://www.nerdfonts.com/font-downloads)
