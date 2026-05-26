#!/bin/bash
set -e

# Si el config de opencode referencia rutas absolutas del usuario host
# (ej: /home/johndoe o /Users/johndoe), creamos un symlink dentro del
# contenedor para que esas rutas resuelvan a /home/agent.
# Esto cubre el caso de opencode.json con paths hardcodeados al host user.

if [ -n "$HOST_USER" ] && [ "$HOST_USER" != "agent" ]; then
  HOST_HOME_IN_CONTAINER="/home/${HOST_USER}"

  # macOS usa /Users/, Linux usa /home/
  MACOS_PATH="/Users/${HOST_USER}"

  if [ ! -e "$HOST_HOME_IN_CONTAINER" ]; then
    sudo mkdir -p "$(dirname "$HOST_HOME_IN_CONTAINER")"
    sudo ln -sf /home/agent "$HOST_HOME_IN_CONTAINER"
  fi

  # Symlink adicional para rutas estilo macOS /Users/...
  if [ ! -e "$MACOS_PATH" ]; then
    sudo mkdir -p /Users
    sudo ln -sf /home/agent "$MACOS_PATH"
  fi
fi

exec "$@"
