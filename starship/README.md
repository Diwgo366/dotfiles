# ⭐ Configuración de Starship

## Descripción
Prompt personalizado con Starship optimizado para desarrollo, usando caracteres elegantes de CaskayDiamono Nerd Font con hora al inicio y símbolos intuitivos de Git.

## Características

### Layout (2 líneas)
**Línea 1:** Hora (HH:MM) → Usuario → Hostname → Directorio ║ Rama Git (+ estado)  
**Línea 2:** Triángulo (▸) como carácter de entrada

### Módulos Activos

| Módulo | Descripción | Símbolo |
|--------|-------------|---------|
| time | Hora actual (HH:MM) | — |
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
| cmd_duration | Duración del comando (> 500ms) | — |
| status | Estado del comando | ✕ (error) |

### Colores
- **Tema:** Dracula
- **Fuente:** CaskayDiamono Nerd Font

## Separadores

El símbolo `║` divide claramente las secciones principales:

```
00:11 diego - diego-server in ~/ruta ║  main ● ⊕ ⊖ ◯
                                       ║
                                   Separador
```

## Símbolos Git Status - Explicados Claramente

Cuando estés en un repositorio Git, verás símbolos que indican el estado exacto de tus cambios:

### Estados de Archivos

| Símbolo | Significado | Acción Necesaria |
|---------|-------------|-----------------|
| `●` | **Modificado** | Archivos editados sin guardar | `git add` o `git commit` |
| `⊕` | **Staged** | Cambios preparados para commit | `git commit` |
| `⊖` | **Deletado** | Archivos eliminados | `git add` o revisar cambios |
| `⟳` | **Renombrado** | Archivo cambió de nombre | `git add` o revisar cambios |
| `◯` | **Sin seguimiento** | Archivos nuevos | `git add` para incluir |
| `◎` | **Stashed** | Cambios guardados temporalmente | `git stash pop` para recuperar |
| `✕` | **Conflicto** | Conflicto de merge | Resolver conflictos manualmente |

### Estados de Sincronización con Remoto

| Símbolo | Significado | Acción Necesaria |
|---------|-------------|-----------------|
| `⇧2` | **2 commits adelante** | Tu rama va adelante del remoto | `git push` para subir |
| `⇩1` | **1 commit atrás** | Tu rama va atrás del remoto | `git pull` para descargar |
| `⇳ ⇧1 ⇩1` | **Diverged** | Ambas ramas tienen cambios | Sincronizar (merge o rebase) |

## Ejemplos Visuales del Prompt

### Repositorio Limpio (sin cambios)
```
00:11 diego - diego-server in ~/proyecto ║  main
▸ 
```

### Con Cambios Modificados
```
00:11 diego - diego-server in ~/proyecto ║  main ●
▸ 
```
(● = hay archivos modificados, necesitas `git add`)

### Con Cambios Staged y Modificados
```
00:11 diego - diego-server in ~/proyecto ║  main ● ⊕
▸ 
```
(● = modificados, ⊕ = preparados para commit)

### Con Archivos sin Seguimiento
```
00:11 diego - diego-server in ~/proyecto ║  main ◯
▸ 
```
(◯ = archivos nuevos sin rastrear, usa `git add`)

### Con Commits sin Push
```
00:11 diego - diego-server in ~/proyecto ║  main ⇧2
▸ 
```
(⇧2 = 2 commits adelante, necesitas `git push`)

### Con Cambios en Remoto
```
00:11 diego - diego-server in ~/proyecto ║  main ⇩1
▸ 
```
(⇩1 = 1 commit atrás, necesitas `git pull`)

## Configuración de Colores para `ls`

Se incluye configuración de colores automática para `ls` usando la paleta Dracula:

- **Directorios:** Azul (34)
- **Archivos normales:** Blanco (37)
- **Enlaces simbólicos:** Cyan (36)
- **Ejecutables:** Verde (32)
- **Archivos JSON/YAML:** Amarillo (33)
- **Archivos con errores:** Rojo (31)

### Alias Disponibles
```bash
ls       # Lista con colores
la       # Lista todos los archivos (incluyendo ocultos)
ll       # Lista larga con tamaños legibles
ld       # Lista solo directorios
```

## Personalización

### Cambiar formato de hora
En `[time]`, modificar:
```toml
time_format = "%H:%M"     # Solo hora (actual)
time_format = "%H:%M:%S"  # Con segundos
time_format = "%d/%m %H:%M"  # Con fecha
```

### Cambiar símbolos de Git
En `[git_status]`, puedes personalizar:
```toml
modified = "●"      # Cambiar ● por otro símbolo
staged = "⊕"        # Cambiar ⊕ por otro símbolo
deleted = "⊖"       # Cambiar ⊖ por otro símbolo
untracked = "◯"     # Cambiar ◯ por otro símbolo
```

### Cambiar separadores
En cada módulo `format` puedes cambiar `║` por otro símbolo:
```toml
[git_branch]
format = " ▸ [$symbol$branch]($style)"  # Usa ▸ en lugar de ║
```

### Cambiar colores de ls
Editar `LS_COLORS` en `/home/diego/dotfiles/zsh/.zsh.d/30-zsh-config.zsh`

### Cambiar colores del prompt
Modifica la paleta `[palettes.dracula]` en `starship.toml` con valores hex

### Deshabilitar un módulo
Usa `disabled = true` en la sección del módulo

## Archivos de Configuración
- **Prompt:** `/home/diego/dotfiles/starship/.config/starship.toml`
- **Colores ls:** `/home/diego/dotfiles/zsh/.zsh.d/30-zsh-config.zsh`

## Inicialización
Ya configurado automáticamente en `~/.zshrc`:
```bash
eval "$(~/.local/bin/starship init zsh)"
```

## Requisitos
- **Starship:** v1.25.1+
- **Fuente:** CaskayDiamono Nerd Font
- **Shell:** Zsh

## Referencias
- [Documentación de Starship](https://starship.rs/)
- [Colores Dracula](https://draculatheme.com/)
- [Nerd Fonts - CaskayDiamono](https://www.nerdfonts.com/font-downloads)
