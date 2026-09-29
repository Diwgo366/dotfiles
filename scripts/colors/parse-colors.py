#!/usr/bin/env python3
"""
Universal Theme Color Parser
Usage: python3 parse-colors.py [colors-universal.json]
Outputs: shell-compatible variable assignments
"""

import json
import sys
import os

def load_colors(path=None):
    if path is None:
        path = os.path.join(os.path.dirname(__file__), "colors-universal.json")
    with open(path) as f:
        return json.load(f)

def hex_to_hypr(hex_color, alpha=None):
    """Convert #RRGGBB to 0xRRGGBB or 0xAARRGGBB"""
    hex_color = hex_color.lstrip("#")
    if alpha is not None:
        a = int(round(alpha * 255))
        return f"0x{a:02x}{hex_color.upper()}"
    return f"0x{hex_color.upper()}"

def hex_to_rgb(hex_color):
    """Convert #RRGGBB to (r, g, b)"""
    hex_color = hex_color.lstrip("#")
    return tuple(int(hex_color[i:i+2], 16) for i in (0, 2, 4))

def hex_to_ansi(hex_color):
    """Convert #RRGGBB to ANSI escape sequence"""
    r, g, b = hex_to_rgb(hex_color)
    return f"\\033[38;2;{r};{g};{b}m"

def flatten_colors(colors, prefix="", result=None):
    """Flatten nested dict to KEY=VALUE pairs"""
    if result is None:
        result = {}
    for key, value in colors.items():
        new_key = f"{prefix}{key.upper()}" if prefix else key.upper()
        if isinstance(value, dict):
            flatten_colors(value, f"{new_key}_", result)
        elif isinstance(value, (str, int, float, bool)):
            result[new_key] = value
    return result

def main():
    colors = load_colors(sys.argv[1] if len(sys.argv) > 1 else None)
    
    # Flatten all colors for shell export
    flat = flatten_colors(colors)
    
    # Special conversions
    output = []
    
    # Base colors
    base = colors["base"]
    output.append(f"BG={base['bg']}")
    output.append(f"BG_ALT={base['bg_alt']}")
    output.append(f"BG_ELEVATED={base['bg_elevated']}")
    output.append(f"BG_OVERLAY={base['bg_overlay']}")
    output.append(f"FG={base['fg']}")
    output.append(f"FG_MUTED={base['fg_muted']}")
    output.append(f"FG_SUBTLE={base['fg_subtle']}")
    output.append(f"BORDER={base['border']}")
    output.append(f"BORDER_FOCUS={base['border_focus']}")
    output.append(f"BORDER_SUBTLE={base['border_subtle']}")
    
    # Palette (16 colors)
    palette = colors["palette"]
    for i, (name, hex_val) in enumerate(palette.items()):
        output.append(f"COLOR{i}={hex_val}")
        output.append(f"{name.upper()}={hex_val}")
    
    # Semantic
    for role, vals in colors["semantic"].items():
        for variant, hex_val in vals.items():
            output.append(f"SEM_{role.upper()}_{variant.upper()}={hex_val}")
    
    # State
    for state, vals in colors["state"].items():
        for prop, val in vals.items():
            output.append(f"STATE_{state.upper()}_{prop.upper()}={val}")
    
    # Alpha
    for name, val in colors["alpha"].items():
        output.append(f"ALPHA_{name.upper()}={val}")
    
    # Hyprland-specific (pre-computed)
    hypr = colors["hyprland"]
    output.append(f"HYPR_ACTIVE_OPACITY={hypr['active_opacity']}")
    output.append(f"HYPR_INACTIVE_OPACITY={hypr['inactive_opacity']}")
    output.append(f"HYPR_ROUNDING={hypr['rounding']}")
    output.append(f"HYPR_BORDER_SIZE={hypr['border_size']}")
    output.append(f"HYPR_GAPS_OUT={hypr['gaps_out']}")
    output.append(f"HYPR_BLUR_ENABLED={'true' if hypr['blur']['enabled'] else 'false'}")
    output.append(f"HYPR_SHADOW_ENABLED={'true' if hypr['shadow']['enabled'] else 'false'}")
    
    # Hyprland colors in Hyprland format
    output.append(f"HYPR_ACTIVE_BORDER={hex_to_hypr(base['border_focus'])}")
    output.append(f"HYPR_INACTIVE_BORDER={hex_to_hypr(palette['bright_black'])}")
    output.append(f"HYPR_BG={hex_to_hypr(base['bg'], hypr['active_opacity'])}")
    output.append(f"HYPR_SHADOW={hex_to_hypr('1a1a1a', colors['alpha']['shadow'])}")
    
    # GTK
    gtk = colors["gtk"]
    for k, v in gtk.items():
        output.append(f"GTK_{k.upper()}={v}")
    
    # Typography
    typo = colors["typography"]
    for k, v in typo.items():
        output.append(f"TYPO_{k.upper()}={v}")
    
    # Spacing
    spacing = colors["spacing"]
    for k, v in spacing.items():
        output.append(f"SPACING_{k.upper()}={v}")
    
    # Metadata
    meta = colors["metadata"]
    for k, v in meta.items():
        output.append(f"META_{k.upper()}={v}")
    
    # Print all as shell exports
    for line in output:
        print(f"export {line}")

if __name__ == "__main__":
    main()