#!/usr/bin/env bash
# REQUIERE_SUDO
# Tema de colores para Midnight Commander personalizado

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/common.sh"

main() {
    validate_colors_json
    extract_colors

    echo "Instalando en Midnight Commander..."

    MC_SKINS_DIR="/usr/share/mc/skins"

    if [[ ! -w "$MC_SKINS_DIR" ]]; then
        echo "Sin permisos en $MC_SKINS_DIR"
        echo "Ejecuta con sudo:"
        echo "sudo $0"
        exit 1
    fi

    mkdir -p "$MC_SKINS_DIR"

    python3 << PYEOF
import json, os, sys

MC_SKINS_DIR = "/usr/share/mc/skins"

try:
    with open(os.environ['COLORS_JSON']) as f:
        d = json.load(f)

    s = d["structural"]
    a = d["ansi"]
    sem = d.get("semantic", {})
    name = d.get("name", "custom_dotfiles")

    bg  = s["background"]
    fg  = s["foreground"]
    cur = s["current_line"]
    com = s["comment"]

    sem_err = sem.get("error", a["color9"])
    sem_ok  = sem.get("success", a["color10"])
    sem_warn = sem.get("warning", a["color11"])
    sem_info = sem.get("info", a["color14"])

    # Mapeo lógico = Dracula / Neovim
    c = {
        "bg":        bg,
        "fg":        fg,
        "cur":       cur,
        "com":       com,
        "red":       a["color9"],
        "green":     a["color10"],
        "yellow":    a["color11"],
        "purple":    a["color12"],
        "pink":      a["color13"],
        "cyan":      a["color14"],
        "orange":    a["color15"],
        "dark_red":  a["color1"],
        "dark_cyan": a["color6"],
        "gray":      a["color8"],
    }

    def h(fore, back="default", attr=""):
        """Genera foreground;background;attributes para MC truecolor"""
        parts = [fore]
        if back and back != "default":
            parts.append(back)
        if attr:
            parts.append(attr)
        return ";".join(parts)

    mc_theme = f"""#
# {name} — Dracula-style skin (coherente con Neovim)
# Generado por colors/themes/mc.sh
#

[skin]
    description = {name}
    truecolor = true

[core]
    _default_ = {h(c["fg"], "default")}
    selected = {h(c["bg"], c["purple"])}
    marked = {h(c["fg"], c["cyan"])}
    markselect = {h(c["bg"], c["purple"], "bold")}
    gauge = {h(c["fg"], c["cur"])}
    input = {h(c["fg"], c["cur"])}
    inputmark = {h(c["fg"], c["purple"], "bold")}
    inputunchanged = {h(c["com"], c["cur"])}
    commandlinemark = {h(c["fg"], c["purple"], "bold")}
    reverse = {h(c["fg"], c["purple"])}
    header = {h(c["fg"], c["cur"])}
    disabled = {h(c["gray"], cur)}
    errors = {h(c["fg"], c["red"])}

[menu]
    _default_ = {h(c["fg"], c["cur"])}
    menusel = {h(c["bg"], c["purple"], "bold")}
    menuhot = {h(c["fg"], c["cur"])}
    menuhotsel = {h(c["bg"], c["purple"], "bold")}
    menuinactive = {h(c["com"], c["cur"])}

[dialog]
    _default_ = {h(c["fg"], c["cur"])}
    dhotnormal = {h(c["fg"], c["cur"])}
    dfocus = {h(c["purple"], c["cur"], "bold")}
    dhotfocus = {h(c["purple"], c["cur"], "bold")}
    dtitle = {h(c["cyan"], "default", "bold")}

[popupmenu]
    _default_ = {h(c["fg"], c["cur"])}
    menusel = {h(c["bg"], c["purple"], "bold")}
    menutitle = {h(c["cyan"], "default", "bold")}

[error]
    _default_ = {h(c["fg"], c["red"])}
    errdfocus = {h(c["bg"], c["red"], "bold")}
    errdhotnormal = {h(c["fg"], c["red"])}
    errdhotfocus = {h(c["bg"], c["red"], "bold")}
    errdtitle = {h(c["red"], "default", "bold")}

[filehighlight]
    directory = {h(c["cyan"], "default", "bold")}
    executable = {h(c["green"])}
    symlink = {h(c["cyan"])}
    hardlink = {h(c["cyan"])}
    stalelink = {h(c["red"])}
    device = {h(c["orange"])}
    special = {h(c["pink"])}
    core = {h(c["red"])}
    temp = {h(c["orange"])}
    archive = {h(c["purple"])}
    doc = {h(c["fg"])}
    source = {h(c["yellow"])}
    media = {h(c["pink"])}
    graph = {h(c["gray"])}
    database = {h(c["orange"])}

[buttonbar]
    button = {h(c["fg"], c["cur"])}
    hotkey = {h(c["purple"], c["cur"], "bold")}

[statusbar]
    _default_ = {h(c["fg"], c["cur"])}

[help]
    _default_ = {h(c["fg"], c["bg"])}
    helpitalic = {h(c["com"], c["bg"], "italic")}
    helpbold = {h(c["purple"], c["bg"], "bold")}
    helplink = {h(c["cyan"], c["bg"], "underline")}
    helpslink = {h(c["cyan"], c["bg"], "bold,underline")}
    helptitle = {h(c["cyan"], c["bg"], "bold")}

[editor]
    _default_ = {h(c["fg"], c["bg"])}
    editbold = {h(c["fg"], c["bg"], "bold")}
    editmarked = {h(c["fg"], c["purple"], "bold")}
    editwhitespace = {h(c["com"], c["bg"])}
    editlinestate = {h(c["fg"], c["cur"])}

[viewer]
    _default_ = {h(c["fg"], c["bg"])}
    viewbold = {h("default", "default", "bold")}
    viewunderline = {h("default", "default", "underline")}
    viewselected = {h(c["fg"], c["purple"], "bold")}

[diffviewer]
    changedline = {h(c["yellow"], c["bg"])}
    changednew = {h(c["green"], c["bg"])}
    changed = {h(c["red"], c["bg"])}
    added = {h(c["bg"], c["green"])}
    removed = {h(c["bg"], c["red"])}
    error = {h(c["fg"], c["red"])}

[Lines]
    horiz = ─
    vert = │
    lefttop = ┌
    righttop = ┐
    leftbottom = └
    rightbottom = ┘
    topmiddle = ┬
    bottommiddle = ┴
    leftmiddle = ├
    rightmiddle = ┤
    cross = ┼
    dhoriz = ─
    dvert = │
    dlefttop = ┌
    drighttop = ┐
    dleftbottom = └
    drightbottom = ┘
    dtopmiddle = ─
    dbottommiddle = ─
    dleftmiddle = ├
    drightmiddle = ┤
"""

    theme_file = os.path.join(MC_SKINS_DIR, f"{name}.ini")
    with open(theme_file, "w") as f:
        f.write(mc_theme)
    print(f"MC instalado")

except Exception as e:
    print(f"Error: {e}", file=sys.stderr)
    sys.exit(1)
PYEOF
}

main "$@"
