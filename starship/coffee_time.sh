#!/bin/bash
# Script para mostrar la hora con café en horarios nocturnos
# Rango nocturno: 20:00 - 06:00 (8 PM a 6 AM)

hour=$(date +%H)
time=$(date +%H:%M)

# Si es de noche (20:00-23:59 o 00:00-05:59), agregar café
if (( hour >= 20 || hour < 6 )); then
    echo "$time☕"
else
    echo "$time"
fi
