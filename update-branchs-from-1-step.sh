# Guardar el nombre de la rama origen
rama_origen="1-step"
ramas_excluidas=("master" "2-step")

# Cambiar a la rama origen
git checkout "$rama_origen"

# Construir el filtro de exclusión dinámicamente
filtro_grep=""
for excl in "${ramas_excluidas[@]}"; do
  filtro_grep="$filtro_grep -e $excl"
done

# Iterar sobre todas las ramas locales, excluyendo la rama origen
git branch --list | grep -v -e "$rama_origen" $filtro_grep | while read -r rama; do
  # Limpiar el nombre de la rama (elimina el asterisco y espacios)
  rama=$(echo "$rama" | sed 's/[* ]//g')

  # Cambiar a la rama
  git checkout "$rama"

  # Fusionar los cambios de la rama origen
  git merge "$rama_origen" --no-edit

  # Verificar si hay conflictos
  if [ $? -ne 0 ]; then
    echo "Conflicto detectado en $rama. Resuelve manualmente y luego haz commit."
    exit 1
  else
    echo "Merge exitoso en $rama"
  fi
done

# Si los cambios funcionan en todas las ramas, este comando actualiza las ramas en el repositorio remoto
# git push origin --all
