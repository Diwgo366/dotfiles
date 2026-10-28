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
    print -- 'Abre una ventana para elegir imágenes, ordenarlas y guardar el PDF.'
    print -- 'Por defecto carga las imágenes de la carpeta actual; -r incluye subcarpetas.'
    print -- 'Requiere python3, tkinter e img2pdf.'
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

  command python3 - "$recursive" <<'PY'
import os
import subprocess
import sys
import tkinter as tk
from pathlib import Path
from tkinter import filedialog, messagebox, ttk

EXTENSIONS = {".jpg", ".jpeg", ".png", ".tif", ".tiff", ".bmp", ".gif", ".webp"}
recursive = sys.argv[1] == "1"
root = tk.Tk()
root.title("Crear PDF desde imágenes")
root.geometry("760x480")
root.minsize(560, 360)
images = []
folder = Path.cwd()

top = ttk.Frame(root, padding=(12, 12, 12, 6))
top.pack(fill="x")
folder_var = tk.StringVar(value=str(folder))
ttk.Label(top, text="Carpeta:").pack(side="left")
ttk.Label(top, textvariable=folder_var).pack(side="left", padx=8, fill="x", expand=True)

body = ttk.Frame(root, padding=(12, 4, 12, 8))
body.pack(fill="both", expand=True)
listing = tk.Listbox(body, selectmode=tk.EXTENDED, activestyle="dotbox")
listing.pack(side="left", fill="both", expand=True)
scroll = ttk.Scrollbar(body, orient="vertical", command=listing.yview)
scroll.pack(side="left", fill="y")
listing.configure(yscrollcommand=scroll.set)

buttons = ttk.Frame(body, padding=(10, 0, 0, 0))
buttons.pack(side="left", fill="y")

def refresh():
    listing.delete(0, tk.END)
    for path in images:
        listing.insert(tk.END, str(path.relative_to(folder)) if path.is_relative_to(folder) else str(path))

def scan(path, recurse=recursive):
    global folder, images
    folder = Path(path)
    folder_var.set(str(folder))
    candidates = folder.rglob("*") if recurse else folder.iterdir()
    images = sorted((p for p in candidates if p.is_file() and p.suffix.lower() in EXTENSIONS), key=lambda p: str(p).casefold())
    refresh()

def choose_folder():
    path = filedialog.askdirectory(initialdir=folder, title="Seleccionar carpeta")
    if path:
        scan(path)

def add_images():
    chosen = filedialog.askopenfilenames(
        initialdir=folder, title="Agregar imágenes",
        filetypes=[("Imágenes", "*.jpg *.jpeg *.png *.tif *.tiff *.bmp *.gif *.webp"), ("Todos los archivos", "*.*")],
    )
    known = set(images)
    images.extend(Path(p) for p in chosen if Path(p) not in known)
    refresh()

def remove_selected():
    for index in reversed(listing.curselection()):
        del images[index]
    refresh()

def move_selected(direction):
    selected = list(listing.curselection())
    if not selected:
        return
    indexes = selected if direction < 0 else list(reversed(selected))
    for index in indexes:
        target = index + direction
        if 0 <= target < len(images):
            images[index], images[target] = images[target], images[index]
    refresh()
    for index in (i + direction for i in selected):
        if 0 <= index < len(images):
            listing.selection_set(index)

def create_pdf():
    if not images:
        messagebox.showwarning("Sin imágenes", "Agrega al menos una imagen.", parent=root)
        return
    default_name = (folder.name or "imagenes") + ".pdf"
    output = filedialog.asksaveasfilename(
        initialdir=folder, initialfile=default_name, title="Guardar PDF",
        defaultextension=".pdf", filetypes=[("Archivo PDF", "*.pdf")],
    )
    if not output:
        return
    if os.path.exists(output) and not messagebox.askyesno("Confirmar", "El archivo ya existe. ¿Sobrescribirlo?", parent=root):
        return
    try:
        subprocess.run(["img2pdf", "--output", output, "--", *map(str, images)], check=True, capture_output=True, text=True)
    except subprocess.CalledProcessError as error:
        messagebox.showerror("Error al crear el PDF", error.stderr.strip() or str(error), parent=root)
        return
    messagebox.showinfo("PDF creado", f"Se guardó el PDF con {len(images)} imágenes:\n{output}", parent=root)
    root.destroy()

ttk.Button(buttons, text="Elegir carpeta…", command=choose_folder).pack(fill="x", pady=3)
ttk.Button(buttons, text="Agregar imágenes…", command=add_images).pack(fill="x", pady=3)
ttk.Separator(buttons).pack(fill="x", pady=8)
ttk.Button(buttons, text="Subir ↑", command=lambda: move_selected(-1)).pack(fill="x", pady=3)
ttk.Button(buttons, text="Bajar ↓", command=lambda: move_selected(1)).pack(fill="x", pady=3)
ttk.Button(buttons, text="Quitar", command=remove_selected).pack(fill="x", pady=3)
ttk.Label(root, text="El orden de la lista será el orden de las páginas.", padding=(12, 0)).pack(anchor="w")
bottom = ttk.Frame(root, padding=12)
bottom.pack(fill="x")
ttk.Button(bottom, text="Cancelar", command=root.destroy).pack(side="right")
ttk.Button(bottom, text="Crear PDF…", command=create_pdf).pack(side="right", padx=8)

scan(folder)
root.mainloop()
PY
}


