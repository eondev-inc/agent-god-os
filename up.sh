#!/bin/bash
echo "Levantando la matriz (Agent Sandbox)..."
docker compose up -d --build

echo "Entrando al contenedor..."
docker exec -it opencode_sandbox bash
