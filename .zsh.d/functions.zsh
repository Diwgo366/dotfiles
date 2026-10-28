# ==============================================================
# FUNCTIONS - Funciones personalizadas
# ==============================================================

# === Gatos ASCII ===
cat1() {
  cat << "EOF"
    ,-.       _,---._ __  / \
   /  )    .-'       `./ /   \
  (  (   ,'            `/    /|
   \  `-"             \'\   / |
    `.              ,  \ \ /  |
     /`.          ,'-`----Y   |
    (            ;        |   '
    |  ,-.    ,-'         |  /
    |  | (   |            | /
    )  |  \  `.___________|/
    `--'   `--'
EOF
}

cat2() {
  cat << "EOF"
        _
        \`*-.
         )  _`-.
        .  : `. .
        : _   '  \
        ; *` _.   `*-._
        `-.-'          `-.
          ;       `       `.
          :.       .        \
          . \  .   :   .-'   .
          '  `+.;  ;  '      :
          :   '  |    ;       ;-.
    .-.   ;  '   : :`-:     _.`* ;
   |   |.*' /  .*' ; .*`- +'  `*'
    °-° '*-*   `*-*  `*-*'

EOF
}

# === Hyprland ===
winls() {
    local json
    json=$(command hyprctl clients -j) || {
        print -u2 -- 'win: no se pudo obtener la lista de ventanas de Hyprland.'
        return 1
    }

    if ! command -v jq >/dev/null 2>&1; then
        print -u2 -- 'win: se requiere jq para formatear la salida.'
        return 1
    fi

    local main_table initial_table
    main_table=$(print -r -- "$json" | command jq -r '
        def cell: if . == null then "—" else tostring end | gsub("[\\t\\r\\n]"; " ");
        (["title", "class", "workspace.id", "floating", "fullscreen"],
         (.[] | [(.title // "unknown"), (.class // "—"), (.workspace.id // "—"), (.floating // false), (.fullscreen // false)] | map(cell)))
        | @tsv
    ') || {
        print -u2 -- 'win: respuesta JSON inválida de Hyprland.'
        return 1
    }

    initial_table=$(print -r -- "$json" | command jq -r '
        def cell: if . == null then "—" else tostring end | gsub("[\\t\\r\\n]"; " ");
        (["initial_title", "initial_class", "address"],
         (.[] | [(.initialTitle // "—"), (.initialClass // "—"), (.address // "—")] | map(cell)))
        | @tsv
    ') || {
        print -u2 -- 'win: respuesta JSON inválida de Hyprland.'
        return 1
    }

    if ! command -v column >/dev/null 2>&1; then
        print -u2 -- 'win: se requiere column para formatear la tabla.'
        return 1
    fi
    local page=1 key
    while true; do
        clear
        if (( page == 1 )); then
            print -P -- "${CL_MORADO_BRIGHT}━━━ Página 1/2 ━━━${CL_RESET}"
            print -r -- "$main_table" | command column -t -s $'\t' -o '  |  ' | awk -v header="$CL_CYAN_BRIGHT" -v muted="$CL_COMMENT" -v yes="$CL_VERDE_BRIGHT" -v no="$CL_GRIS" -v reset=$'\033[0m' 'NR == 1 { count = split($0, cells, /  \|  /); for (i = 1; i <= count; i++) { printf "%s%s%s", header, cells[i], reset; if (i < count) printf "%s  |  %s", muted, reset } printf "\n"; next } { gsub(/true/, yes "true" reset); gsub(/false/, no "false" reset); gsub(/  \|  /, muted "  |  " reset); print }'
        else
            print -P -- "${CL_MORADO_BRIGHT}━━━ Página 2/2 ━━━${CL_RESET}"
            print -r -- "$initial_table" | command column -t -s $'\t' -o '  |  ' | awk -v header="$CL_CYAN_BRIGHT" -v muted="$CL_COMMENT" -v reset=$'\033[0m' 'NR == 1 { count = split($0, cells, /  \|  /); for (i = 1; i <= count; i++) { printf "%s%s%s", header, cells[i], reset; if (i < count) printf "%s  |  %s", muted, reset } printf "\n"; next } { gsub(/  \|  /, muted "  |  " reset); print }'
        fi

        print -- ''
        print -P -- "${CL_COMMENT}← anterior   → siguiente   q salir${CL_RESET}"
        read -k 1 -s key
        case "$key" in
            $'\e')
                read -k 1 -s key
                [[ "$key" == '[' ]] && read -k 1 -s key
                case "$key" in
                    D) page=1 ;;
                    C) page=2 ;;
                esac
                ;;
            q|Q) break ;;
        esac
    done
    clear
}

pdfview() {
  if [[ $# -eq 0 || ! -f "$1" ]]; then
    print -u2 -- "Uso: pdfview <archivo.pdf>"
    return 1
  fi

  local pdf="$1"
  command -v pdftoppm &>/dev/null || { print -u2 -- "Error: pdftoppm no encontrado."; return 1; }
  command -v pdfinfo &>/dev/null || { print -u2 -- "Error: pdfinfo no encontrado."; return 1; }
  command -v kitty &>/dev/null || { print -u2 -- "Error: kitty no encontrado."; return 1; }

  local total
  total=$(command pdfinfo "$pdf" 2>/dev/null | awk '/^Pages:/{print $2}')
  if [[ "$total" != <-> ]] || (( total < 1 )); then
    print -u2 -- "Error: no se pudo leer el número de páginas del PDF."
    return 1
  fi

  local tmpdir
  tmpdir=$(command mktemp -d "${TMPDIR:-/tmp}/pdfview.XXXXXXXX") || {
    print -u2 -- "Error: no se pudo crear el directorio temporal."
    return 1
  }

  local p=1 key imgfile
  local -a fit_modes=(both width height none)
  local -a fit_labels=("↔↕" "↔" "↕" "□")
  local fit_idx=1

  while true; do
    imgfile="$tmpdir/page-${p}.png"
    if [[ ! -f "$imgfile" ]]; then
      # -singlefile evita que pdftoppm añada ceros al número de página
      # (por ejemplo, page-01.png) y permite usar un nombre predecible.
      if ! command pdftoppm -png -singlefile -f "$p" -l "$p" "$pdf" "$tmpdir/page-${p}" 2>/dev/null; then
        print -u2 -- "Error al convertir la página $p."
        command rm -rf -- "$tmpdir"
        return 1
      fi
      if [[ ! -f "$imgfile" ]]; then
        print -u2 -- "Error: no se generó la imagen de la página $p."
        command rm -rf -- "$tmpdir"
        return 1
      fi
    fi

    clear
    if [[ "${fit_modes[$fit_idx]}" == "none" ]]; then
      command kitty +kitten icat "$imgfile" < /dev/null
    else
      command kitty +kitten icat --fit "${fit_modes[$fit_idx]}" "$imgfile" < /dev/null
    fi

    printf "\nPágina %d/%d [%s] — n: siguiente  p: anterior  f: ajuste  q: salir: " "$p" "$total" "${fit_labels[$fit_idx]}"
    read -k 1 key || key=q
    printf "\n"

    case "$key" in
      n)
        if [[ $p -lt $total ]]; then
          ((p++))
        fi
        ;;
      p)
        if [[ $p -gt 1 ]]; then
          ((p--))
        fi
        ;;
      f)
        fit_idx=$(( fit_idx % 4 + 1 ))
        ;;
      q)
        break
        ;;
    esac
  done

  command rm -rf -- "$tmpdir"
  clear
}

# === Crear un PDF a partir de imágenes ===
2pdf() {
  if (( $# )) && [[ "$1" == -h || "$1" == --help ]]; then
    print -- 'Uso: 2pdf [-r|--recursive]'
    print -- 'Abre una interfaz en la terminal para elegir imágenes, ordenarlas y guardar el PDF.'
    print -- 'Por defecto carga las imágenes de la carpeta actual; -r incluye subcarpetas.'
    print -- 'Requiere python3 e img2pdf.'
    return 0
  fi

  local recursive=0
  if (( $# == 1 )) && [[ "$1" == -r || "$1" == --recursive ]]; then
    recursive=1
  elif (( $# )); then
    print -u2 -- 'Uso: 2pdf [-r|--recursive]'
    return 2
  fi
  if ! (( $+commands[python3] )); then
    print -u2 -- '2pdf: se requiere python3.'
    return 1
  fi
  if ! (( $+commands[img2pdf] )); then
    print -u2 -- '2pdf: se requiere img2pdf.'
    return 1
  fi

  local script
  script=$(command cat <<'PY'
import curses
import os
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path
from PIL import Image, ImageOps

EXTENSIONS = {".jpg", ".jpeg", ".png", ".tif", ".tiff", ".bmp", ".gif", ".webp"}
recursive = sys.argv[1] == "1"
folder = Path.cwd()
candidates = folder.rglob("*") if recursive else folder.iterdir()
images = sorted(
    (path for path in candidates if path.is_file() and path.suffix.lower() in EXTENSIONS),
    key=lambda path: str(path).casefold(),
)
selected = set(range(len(images)))
rotations = {path: 0 for path in images}
output = str(folder / "imagenes.pdf")
result = {"message": "", "status": 0}
kitty_available = bool(os.environ.get("KITTY_WINDOW_ID")) and shutil.which("kitty") is not None
preview_temp = tempfile.TemporaryDirectory(prefix="2pdf-preview-")
preview_cache = {}

def preview_file(path, angle):
    if not angle:
        return path
    key = (path, angle)
    if key not in preview_cache:
        with Image.open(path) as source:
            image = ImageOps.exif_transpose(source)
            image = image.rotate(-angle, expand=True)
            image = image.convert("RGBA" if "A" in image.getbands() else "RGB")
            target = Path(preview_temp.name) / f"preview-{len(preview_cache):04d}.png"
            image.save(target, format="PNG")
            preview_cache[key] = target
    return preview_cache[key]

def run_ui(screen):
    global output, selected
    screen.keypad(True)
    curses.curs_set(0)
    current = 0
    offset = 0
    notice = ""
    last_preview = None

    while True:
        preview_request = None
        screen.erase()
        height, width = screen.getmaxyx()
        split = max(30, width * 2 // 5)
        right_x = split + 2
        panel_width = max(1, width - right_x - 1)
        screen.addnstr(0, 0, "  2PDF · Imágenes a PDF", width - 1, curses.A_BOLD)
        screen.addnstr(1, 0, f"  Carpeta: {folder}", width - 1)
        screen.addnstr(2, 0, f"  Seleccionadas: {len(selected)}/{len(images)}  ·  PDF: {output}", width - 1)
        screen.addnstr(3, 0, "─" * max(0, width - 1), width - 1)
        if split < width - 1:
            for y in range(3, max(4, height - 4)):
                screen.addch(y, split, "│")

        list_top = 4
        footer_rows = 4
        visible = max(1, height - list_top - footer_rows)
        if current < offset:
            offset = current
        elif current >= offset + visible:
            offset = current - visible + 1

        for row, index in enumerate(range(offset, min(len(images), offset + visible)), start=list_top):
            mark = "[x]" if index in selected else "[ ]"
            try:
                display_name = str(images[index].relative_to(folder))
            except ValueError:
                display_name = str(images[index])
            attr = curses.A_REVERSE if index == current else curses.A_NORMAL
            screen.addnstr(row, 0, f" {mark} {index + 1:>3}. {display_name}", width - 1, attr)

        help_row = max(list_top, height - 4)
        screen.addnstr(help_row, 0, "↑/↓ mover  espacio marcar  {/} reordenar  r rotar", width - 1)
        screen.addnstr(help_row + 1, 0, "a todas  n ninguna  o nombre  Enter crear  q salir", width - 1)
        if notice:
            screen.addnstr(help_row + 2, 0, notice, width - 1, curses.A_BOLD)

        preview_title_row = 4
        screen.addnstr(preview_title_row, right_x, "Vista previa", panel_width, curses.A_BOLD)
        if images and panel_width >= 8:
            path = images[current]
            angle = rotations.get(path, 0)
            preview_height = max(1, help_row - preview_title_row - 2)
            try:
                with Image.open(path) as image:
                    dimensions = ImageOps.exif_transpose(image).size
                screen.addnstr(preview_title_row + 1, right_x, f"{path.name} · {dimensions[0]}×{dimensions[1]} · {angle}°", panel_width)
                if kitty_available:
                    preview_y = preview_title_row + 2
                    preview_key = (path, angle, panel_width, preview_height, right_x, preview_y)
                    if preview_key != last_preview:
                        preview_request = (preview_key, path, angle, panel_width, preview_height, right_x, preview_y)
                else:
                    screen.addnstr(preview_title_row + 2, right_x, "La vista de imagen requiere Kitty.", panel_width)
            except Exception as error:
                screen.addnstr(preview_title_row + 1, right_x, "No se pudo previsualizar", panel_width)
                screen.addnstr(preview_title_row + 2, right_x, str(error), panel_width)
        elif width < 72:
            screen.addnstr(preview_title_row + 1, right_x, "Amplía la terminal para ver la imagen.", panel_width)
        screen.refresh()
        if preview_request:
            preview_key, path, angle, panel_width, preview_height, right_x, preview_y = preview_request
            subprocess.run(["kitty", "+kitten", "icat", "--clear"], stdout=None, stderr=subprocess.DEVNULL, check=False)
            subprocess.run(
                ["kitty", "+kitten", "icat", "--stdin=no", "--align=left", "--scale-up",
                 "--z-index=1", "--place", f"{panel_width}x{preview_height}@{right_x}x{preview_y}",
                 str(preview_file(path, angle))],
                stdout=None, stderr=subprocess.DEVNULL, check=False,
            )
            last_preview = preview_key

        key = screen.getch()
        if key in (ord("q"), 27):
            return
        if key in (curses.KEY_UP, ord("k")) and images:
            current = max(0, current - 1)
        elif key in (curses.KEY_DOWN, ord("j")) and images:
            current = min(len(images) - 1, current + 1)
        elif key == ord(" ") and images:
            if current in selected:
                selected.remove(current)
            else:
                selected.add(current)
        elif key == ord("a"):
            selected.update(range(len(images)))
        elif key == ord("n"):
            selected.clear()
        elif key == ord("{") and current > 0:
            images[current - 1], images[current] = images[current], images[current - 1]
            selected = {i - 1 if i == current else i + 1 if i == current - 1 else i for i in selected}
            current -= 1
        elif key == ord("}") and current < len(images) - 1:
            images[current + 1], images[current] = images[current], images[current + 1]
            selected = {i + 1 if i == current else i - 1 if i == current + 1 else i for i in selected}
            current += 1
        elif key == ord("r") and images:
            path = images[current]
            rotations[path] = (rotations.get(path, 0) + 90) % 360
        elif key == ord("o"):
            curses.echo()
            curses.curs_set(1)
            screen.addnstr(help_row + 2, 0, "Guardar PDF como: ", width - 1)
            screen.clrtoeol()
            screen.move(help_row + 2, len("Guardar PDF como: "))
            entered = screen.getstr(help_row + 2, len("Guardar PDF como: "), max(1, width - 22)).decode(errors="replace").strip()
            curses.noecho()
            curses.curs_set(0)
            if entered:
                output = entered if entered.lower().endswith(".pdf") else entered + ".pdf"
        elif key in (curses.KEY_ENTER, 10, 13):
            ordered = [str(path) for index, path in enumerate(images) if index in selected]
            if not ordered:
                notice = "Marca al menos una imagen con espacio."
                continue
            if Path(output).exists():
                notice = f"{output} ya existe. Pulsa o para elegir otro nombre, o q para salir."
                continue
            try:
                with tempfile.TemporaryDirectory(prefix="2pdf-") as temp_dir:
                    rotated_files = []
                    for index, image_path in enumerate(images):
                        if index not in selected:
                            continue
                        angle = rotations.get(image_path, 0)
                        if not angle:
                            rotated_files.append(str(image_path))
                            continue
                        with Image.open(image_path) as source:
                            image = ImageOps.exif_transpose(source)
                            image = image.rotate(-angle, expand=True)
                            image = image.convert("RGBA" if "A" in image.getbands() else "RGB")
                            rotated_path = Path(temp_dir) / f"rotated-{len(rotated_files):04d}.png"
                            image.save(rotated_path, format="PNG")
                            rotated_files.append(str(rotated_path))
                    subprocess.run(["img2pdf", "--output", output, "--", *rotated_files], check=True, capture_output=True, text=True)
            except subprocess.CalledProcessError as error:
                result["message"] = error.stderr.strip() or str(error)
                result["status"] = 1
                return
            except Exception as error:
                result["message"] = str(error)
                result["status"] = 1
                return
            result["message"] = f"PDF creado: {output} ({len(ordered)} imágenes)"
            return

if not images:
    print(f"2pdf: no encontré imágenes compatibles en {folder}", file=sys.stderr)
    sys.exit(1)

curses.wrapper(run_ui)
if kitty_available:
    subprocess.run(["kitty", "+kitten", "icat", "--clear"], stdout=None, stderr=subprocess.DEVNULL, check=False)
preview_temp.cleanup()
if result["message"]:
    print(result["message"], file=sys.stderr if result["status"] else sys.stdout)
sys.exit(result["status"])
PY
  ) || return 1
  command python3 -c "$script" "$recursive"
}


