#!/bin/bash

# Directorio del repositorio (carpeta actual)
REPO_PATH="$(pwd)"

# Intervalo en segundos (60 = 1 minuto)
INTERVAL=60

# Mensaje del commit
COMMIT_MESSAGE="AutoPush Gabriel: $(date '+%d-%m-%Y %H:%M:%S')"

# Cambia al directorio del repositorio
cd "$REPO_PATH" || { echo "El repositorio no existe"; exit 1; }

# Bucle infinito para hacer commit y push cada minuto
while true; do
    # Añadir cambios
    git add .

    # Hacer commit solo si hay cambios
    if git diff-index --quiet HEAD; then
        echo "[$(date)] No hay cambios nuevos para commitear. Esperando..."
    else
        git commit -m "$COMMIT_MESSAGE"
        echo "[$(date)] Commit realizado: $COMMIT_MESSAGE"

        # Hacer push al repositorio remoto
        git push origin main
        echo "[$(date)] Cambios enviados al repositorio remoto."
    fi

    # Esperar el intervalo definido
    sleep $INTERVAL
done
