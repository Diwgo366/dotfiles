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
  local output='' input_dir='.' recursive=0 have_input=0

  while (( $# )); do
    case "$1" in
      -o|--output)
        if (( $# < 2 )) || [[ -z "$2" ]]; then
          print -u2 -- 'Uso: 2pdf [-r] [-o salida.pdf] [carpeta]'
          return 2
        fi
        output="$2"
        shift 2
        ;;
      -r|--recursive)
        recursive=1
        shift
        ;;
      -h|--help)
        print -- 'Uso: 2pdf [-r|--recursive] [-o|--output salida.pdf] [carpeta]'
        print -- 'Busca imágenes JPG, PNG, TIFF, BMP, GIF y WebP; las ordena alfabéticamente.'
        print -- 'Sin carpeta, usa el directorio actual. La salida predeterminada es <carpeta>.pdf.'
        print -- 'Requiere img2pdf. No sobrescribe archivos existentes.'
        return 0
        ;;
      --)
        shift
        break
        ;;
      -* )
        print -u2 -- "2pdf: opción desconocida: $1"
        print -u2 -- 'Prueba: 2pdf --help'
        return 2
        ;;
      *)
        if (( have_input )); then
          print -u2 -- 'Uso: 2pdf [-r] [-o salida.pdf] [carpeta]'
          return 2
        fi
        input_dir="$1"
        have_input=1
        shift
        ;;
    esac
  done

  if (( $# )); then
    print -u2 -- '2pdf: solo se admite una carpeta de entrada.'
    return 2
  fi
  if [[ ! -d "$input_dir" ]]; then
    print -u2 -- "2pdf: no existe la carpeta: $input_dir"
    return 1
  fi
  if ! (( $+commands[img2pdf] )); then
    print -u2 -- '2pdf: se requiere img2pdf (instálalo con tu gestor de paquetes o pip).'
    return 1
  fi

  # glob qualifiers de zsh hacen el filtrado sin dividir nombres con espacios.
  setopt local_options extended_glob null_glob
  local pattern='(#i)*.(jpg|jpeg|png|tif|tiff|bmp|gif|webp)'
  local -a paths
  if (( recursive )); then
    paths=("$input_dir"/**/$~pattern(N.:))
  else
    paths=("$input_dir"/$~pattern(N.:))
  fi
  if (( ${#paths} == 0 )); then
    print -u2 -- "2pdf: no encontré imágenes compatibles en: $input_dir"
    return 1
  fi

  if [[ -z "$output" ]]; then
    local dir_name="${input_dir%/}"
    [[ -z "$dir_name" || "$dir_name" == '.' ]] && dir_name='imagenes'
    output="${dir_name:t}.pdf"
  fi
  [[ "$output" == *.pdf ]] || output+='.pdf'
  if [[ -e "$output" ]]; then
    print -u2 -- "2pdf: ya existe la salida: $output"
    return 1
  fi

  command img2pdf --output "$output" -- "${paths[@]}" || {
    print -u2 -- '2pdf: falló la creación del PDF.'
    return 1
  }
  print -- "PDF creado: $output (${#paths} imágenes)"
}


