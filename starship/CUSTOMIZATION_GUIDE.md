# 🎨 Guía de Personalización - Starship & Coffee

Referencia rápida para personalizar tu prompt terminal con los nuevos símbolos y características.

## Símbolos Actuales

### Entrada (Character)
```
✓ Éxito:  ▸ (verde)
✗ Error:  ▸ (rojo)
```

### Separadores (Separator)
```
║ Línea vertical doble
```

### Git Status
```
●  Modificado (archivo editado)
⊕  Staged (cambios preparados para commit)
⊖  Deletado (archivo eliminado)
◯  Sin seguimiento (archivo nuevo)
✕  Conflicto (merge conflict)
```

### Café Nocturno
```
☕ Mostrado entre 20:00 - 05:59 (automático)
```

---

## Cómo Cambiar Símbolos

### 1. Cambiar el símbolo de entrada (▸)

Edita: `/home/diego/dotfiles/starship/.config/starship.toml`

Busca:
```toml
[character]
error_symbol = "[▸](bold red)"
success_symbol = "[▸](bold green)"
```

Reemplaza `▸` con otro símbolo. Opciones recomendadas:
- `❯` - Flecha derecha
- `➜` - Flecha abierta
- `λ` - Lambda
- `→` - Flecha simple

### 2. Cambiar el separador (║)

Edita: `/home/diego/dotfiles/starship/.config/starship.toml`

Busca cada sección de módulos y cambia:
```toml
format = " ║ [$symbol$context]($style)"
```

Por:
```toml
format = " | [$symbol$context]($style)"  # O cualquier otro símbolo
```

Afecta a:
- `[git_branch]`
- `[docker_context]`
- `[conda]`
- `[nodejs]`
- `[python]`
- `[rust]`
- `[golang]`
- `[cmd_duration]`

### 3. Cambiar símbolos de Git Status

Edita: `/home/diego/dotfiles/starship/.config/starship.toml`

Busca:
```toml
[git_status]
modified = "●"
staged = "⊕"
deleted = "⊖"
untracked = "◯"
conflicted = "✕"
```

Reemplaza según prefieras. Opciones recomendadas:

**Círculos simples:**
- `◉` (círculo lleno)
- `◎` (círculo vacío)
- `●` (punto negro)

**Símbolos de operación:**
- `+` (plus para staged)
- `-` (menos para deletado)
- `*` (asterisco para modificado)
- `!` (exclamación para conflicto)

**Símbolos geométricos:**
- `▲` `▼` `◀` `▶` (triángulos)
- `□` `■` (cuadrados)
- `◆` `◇` (diamantes)

---

## Personalizar Café Nocturno

### Cambiar horario nocturno

Edita: `/home/diego/dotfiles/zsh/.zsh.d/20-functions.zsh`

Busca:
```bash
if (( hour >= 20 || hour < 6 )); then
```

Modifica los números:
- `20` = Hora de inicio (8 PM)
- `6` = Hora de fin (6 AM)

Ejemplos:
```bash
# Café desde las 22:00 (10 PM) hasta las 06:00 (6 AM)
if (( hour >= 22 || hour < 6 )); then

# Café solo de noche (21:00 - 07:00)
if (( hour >= 21 || hour < 7 )); then

# Café todo el tiempo (comentar esta línea)
# if (( hour >= 20 || hour < 6 )); then
```

### Cambiar símbolo de café

Edita: `/home/diego/dotfiles/zsh/.zsh.d/20-functions.zsh`

Busca:
```bash
coffee=" ☕"
```

Reemplaza `☕` con otro símbolo:
- `🌙` = Luna
- `🌃` = Ciudad nocturna
- `🎵` = Notas musicales
- `✨` = Estrellas
- `⭐` = Estrella
- `🚀` = Cohete

O usa caracteres Nerd Font:
- `🔥` = Fuego
- `💥` = Explosión
- `⚡` = Rayo

---

## Personalizar Mensaje de Bienvenida

Edita: `/home/diego/dotfiles/zsh/.zshrc`

### Cambiar iconos por hora

Busca:
```bash
if (( hour < 12 )); then
    greeting="Buenos días"
    icon="🌅"  # Salida del sol
elif (( hour < 18 )); then
    greeting="Buenas tardes"
    icon="☀️"  # Sol
else
    greeting="Buenas noches"
    icon="🌙"  # Luna
```

Reemplaza los iconos con otros emoji o caracteres Nerd Font.

### Cambiar bordes

Busca:
```bash
echo "╔════════════════════════════════════════════════════════╗"
```

Reemplaza:
- `╔═╗╚═╝` = Bordes dobles (actual)
- `┌─┐└─┘` = Bordes simples
- `┏━┓┗━┛` = Bordes pesados
- `╔░╗╚░╝` = Bordes decorativos

### Cambiar saludo

En el mismo bloque, modifica:
```bash
greeting="Buenos días"   # Cambiar texto
greeting="Buenas tardes"
greeting="Buenas noches"
```

---

## Referencia de Caracteres

Para explorar más opciones de caracteres:

```bash
# Ver todas las categorías
./starship/view_chars.sh 1-8

# Ver categoría específica
./starship/view_chars.sh 1  # Flechas
./starship/view_chars.sh 2  # Círculos
./starship/view_chars.sh 3  # Cuadrados
./starship/view_chars.sh 4  # Triángulos
./starship/view_chars.sh 5  # Separadores
./starship/view_chars.sh 6  # Símbolos especiales
./starship/view_chars.sh 7  # Diamantes
./starship/view_chars.sh 8  # Bifurcaciones Git
```

O lee la guía completa:
```bash
cat ./starship/NERD_FONT_CHARS.md
```

---

## Temas Predefinidos

El archivo NERD_FONT_CHARS.md contiene 5 temas completos:

1. **MINIMALISTA** - Símbolos simples y limpios
2. **GEOMÉTRICO** - Formas geométricas (actual)
3. **LINEAL** - Líneas y bordes
4. **MODERNO** - Símbolos modernos y actuales
5. **FUERTE** - Símbolos audaces y visibles

---

## Verificar Cambios

Después de editar los archivos, recarga la configuración:

```bash
# Opción 1: Abre una nueva terminal
exec zsh

# Opción 2: Re-ejecuta .zshrc
source ~/.zshrc
```

---

## Revertir Cambios

Si algo sale mal, revierte con Git:

```bash
# Ver cambios
git diff

# Revertir un archivo
git checkout <archivo>

# Revertir todo
git reset --hard
```

---

## Archivos de Configuración

| Archivo | Propósito | Líneas clave |
|---------|-----------|-------------|
| `starship/.config/starship.toml` | Configuración del prompt | `[character]`, `[git_status]`, formatos |
| `zsh/.zshrc` | Configuración general | `precmd()`, welcome message |
| `zsh/.zsh.d/20-functions.zsh` | Funciones | `update_time_with_coffee()` |
| `starship/coffee_time.sh` | Helper script | Lógica de café |
| `starship/README.md` | Documentación | Ejemplos y explicaciones |

---

## Soporte

Si tienes dudas:
1. Lee los comentarios en los archivos de configuración
2. Consulta `NERD_FONT_CHARS.md` para caracteres disponibles
3. Usa `./view_chars.sh` para explorar visualmente
4. Revisa `README.md` para ejemplos completos

¡Disfruta personalizando tu terminal! ✨
