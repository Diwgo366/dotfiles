#!/bin/bash
if ags list | grep -q ags; then
  ags toggle bar
else
  ags run /home/diego/Proyectos/ags/proyecto.js &
fi
