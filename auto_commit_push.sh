#!/bin/bash

# Directorio del repositorio (carpeta actual)
REPO_PATH="$(pwd)"

# Intervalo en segundos (60 = 1 minuto)
INTERVAL=1

# Mensaje del commit
COMMIT_MESSAGE="AutoPush Gabriel: $(date '+%d-%m-%Y %H:%M:%S')"

# Cambia al directorio del repositorio
cd "$REPO_PATH" || { echo "El repositorio no existe"; exit 1; }

# Bucle infinito para hacer commit, pull y push
while true; do
    # Comprobar si hay cambios en remoto y hacer pull
    echo "[$(date)] Comprobando si hay cambios en remoto..."
    git fetch origin main

    LOCAL_HASH=$(git rev-parse HEAD)
    REMOTE_HASH=$(git rev-parse origin/main)
    BASE_HASH=$(git merge-base HEAD origin/main)

    if [ "$LOCAL_HASH" = "$REMOTE_HASH" ]; then
        echo "[$(date)] Todo está sincronizado con el repositorio remoto."
    elif [ "$LOCAL_HASH" = "$BASE_HASH" ]; then
        echo "[$(date)] Hay cambios en remoto. Haciendo pull..."
        git pull origin main
    elif [ "$REMOTE_HASH" = "$BASE_HASH" ]; then
        echo "[$(date)] Hay cambios locales que aún no se han enviado."
    else
        echo "[$(date)] Conflicto detectado. Necesita resolución manual."
        exit 1
    fi

    # Añadir cambios locales
    git add .

    # Hacer commit solo si hay cambios
    if git diff-index --quiet HEAD; then
        echo "[$(date)] No hay cambios nuevos para commitear. Esperando..."
    else
        git commit -m "$COMMIT_MESSAGE"
        echo "[$(date)] Commit realizado: $COMMIT_MESSAGE"

        # Hacer push al repositorio remoto
        echo "[$(date)] Enviando cambios al repositorio remoto..."
        git push origin main
        echo "[$(date)] Cambios enviados correctamente."
    fi

    # Esperar el intervalo definido
    sleep $INTERVAL
done
