#!/bin/bash
# Se requiere modificar Lista_Usuarios.txt para que funcione

USUARIO_REF="$1"
LISTA_USUARIOS="$2"

CLAVE_USUARIO=$(grep "$USUARIO_REF" /etc/shadow | awk -F ':' '{print $2}')

while IFS="," read -r USUARIO GRUPO HOME_USER; do
    sudo groupadd "$GRUPO"
    sudo useradd -m -d "$HOME_USER" -g "$GRUPO" -p "$CLAVE_USUARIO" "$USUARIO"

done < "$LISTA_USUARIOS"

echo "Proceso completado."
