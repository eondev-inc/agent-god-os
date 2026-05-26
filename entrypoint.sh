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

# Cubrir rutas absolutas de herramientas instaladas vía Homebrew en macOS
# opencode.json puede tener "command": ["/opt/homebrew/bin/engram", ...]
# Esos paths no existen en Debian — symlinks los resuelven al binario nativo.
BREW_BIN="/opt/homebrew/bin"
if [ ! -d "$BREW_BIN" ]; then
  sudo mkdir -p "$BREW_BIN"
fi
for tool in engram gentle-ai; do
  BREW_PATH="${BREW_BIN}/${tool}"
  NATIVE_PATH="/usr/local/bin/${tool}"
  if [ ! -e "$BREW_PATH" ] && [ -f "$NATIVE_PATH" ]; then
    sudo ln -sf "$NATIVE_PATH" "$BREW_PATH"
  fi
done

exec "$@"
