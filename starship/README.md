# ⭐ Configuración de Starship

## Descripción
Prompt personalizado con Starship optimizado para desarrollo, usando caracteres de CaskayDiamono Nerd Font con separadores elegantes entre bloques.

## Características

### Layout (2 líneas)
**Línea 1:** Contexto - usuario, hostname, directorio, rama git, estado y timestamp  
**Línea 2:** Flecha moderna (➜) como carácter de entrada

### Módulos Activos

| Módulo | Descripción | Símbolo |
|--------|-------------|---------|
| username | Usuario actual (siempre visible) | — |
| hostname | Nombre del servidor | — |
| directory | Ruta del directorio (sin truncación) | — |
| git_branch | Rama actual |  |
| git_status | Estado de cambios (modificado, staged, etc.) | — |
| docker_context | Contexto de Docker (auto-detecta) |  |
| conda | Entorno Conda |  |
| nodejs | Versión de Node.js |  |
| python | Versión de Python |  |
| rust | Versión de Rust |  |
| golang | Versión de Go |  |
| time | Hora actual (HH:MM:SS) | — |
| cmd_duration | Duración del comando (> 500ms) | — |
| status | Estado del comando | ✘ (error) |

### Colores
- **Tema:** Dracula
- **Fuente:** CaskayDiamono Nerd Font

## Características Principales

### Git Avanzado ✅
- Rama actual con ícono Nerd Font
- Estado detallado: modificado (!), staged (+), deleted (✘), etc.
- Indicadores: ahead (⇡), behind (⇣), diverged (⇕)
- Conflictos (=) y stash (*)
- Sin seguimiento (?)

### Contexto del Sistema ✅
- **Usuario:** Siempre visible, rojo si root, cyan si usuario normal
- **Hostname:** Mostrado en cada prompt
- **Directorio:** Sin truncación, simplificado con ~ desde home
- **Ícono de lectura:** Solo símbolo si directorio es de solo lectura

### Herramientas y Entornos ✅
- **Docker:** Detecta automáticamente proyectos Docker
- **Conda/Python:** Entornos virtuales y versiones activas
- **Lenguajes:** Node.js, Python, Rust, Go con caracteres Nerd Font

### Información de Ejecución ✅
- **Timestamp:** Hora en tiempo real (HH:MM:SS)
- **Duración:** Tiempo que tardó cada comando (> 500ms)
- **Status:** Indicador visual de éxito/error (✘)

### Separadores ✅
- Separadores elegantes (│) entre bloques principales
- Mejora legibilidad visual del prompt
- Organización clara de secciones

## Caracteres Nerd Font Utilizados

### Símbolos de Git Status
```
✘ = Conflicto/Error
! = Modificado
+ = Staged
? = Sin seguimiento
* = Stashed
» = Renombrado
```

### Entrada y Flechas
```
➜ = Flecha moderna (éxito)
✘ = Equis (error)
```

### Separadores
```
│ = Pipe elegante
```

## Personalización

### Cambiar la duración mínima de comandos
En `[cmd_duration]`, modificar:
```toml
min_time = 500  # En milisegundos
```

### Cambiar formato de hora
En `[time]`, modificar:
```toml
time_format = "%H:%M:%S"  # Otros: %Y-%m-%d, %I:%M %p, etc.
```

### Cambiar símbolos de git
En `[git_status]`, modificar:
```toml
modified = "!"
staged = "+"
deleted = "✘"
# etc...
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
