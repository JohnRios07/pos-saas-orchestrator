#!/bin/bash

# Cargar variables de entorno si existe el archivo .env
if [ -f .env ]; then
    export $(cat .env | grep -v '#' | awk '/=/ {print $1}')
fi

BACKUP_DIR="./backups"
DB_USER=${POSTGRES_USER:-pos_user}
DB_NAME=${POSTGRES_DB:-pos_db}
CONTAINER_NAME="pos-postgres"
KEEP_DAYS=7

mkdir -p "$BACKUP_DIR"
TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_${TIMESTAMP}.sql.gz"

echo "Iniciando respaldo de la base de datos..."
docker exec -t $CONTAINER_NAME pg_dump -U "$DB_USER" "$DB_NAME" | gzip > "$BACKUP_FILE"

echo "Respaldo creado en: $BACKUP_FILE"

echo "Eliminando respaldos con más de $KEEP_DAYS días de antigüedad..."
find "$BACKUP_DIR" -type f -name "*.sql.gz" -mtime +$KEEP_DAYS -exec rm {} \;

echo "¡Respaldo completado con éxito!"
