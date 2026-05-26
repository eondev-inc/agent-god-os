.PHONY: up down build shell logs restart ps setup

# Detectar OS
OS := $(shell uname -s)

# Defaults por OS
ifeq ($(OS), Darwin)
  DEFAULT_PROJECTS_DIR := $(HOME)/Documents/Projects
  VOLUME_OPTS :=
  DOCKER_SOCK := $(HOME)/.docker/run/docker.sock
  ifeq (,$(wildcard $(DOCKER_SOCK)))
    DOCKER_SOCK := /var/run/docker.sock
  endif
else
  DEFAULT_PROJECTS_DIR := $(HOME)/Documentos/Proyectos
  VOLUME_OPTS := :z
  DOCKER_SOCK := /var/run/docker.sock
endif

# Cargar .env si existe
-include .env
export

# Valores finales con fallback a defaults
PROJECTS_DIR     ?= $(DEFAULT_PROJECTS_DIR)
HOST_HOME        ?= $(HOME)
HOST_USER        ?= $(shell whoami)

# Exportar para docker compose
export PROJECTS_DIR
export HOST_HOME
export HOST_USER
export VOLUME_OPTS
export DOCKER_SOCK

setup:
	@if [ ! -f .env ]; then \
		echo "Generando .env para $(OS)..."; \
		echo "PROJECTS_DIR=$(DEFAULT_PROJECTS_DIR)" > .env; \
		echo "HOST_HOME=$(HOME)" >> .env; \
		echo "HOST_USER=$(shell whoami)" >> .env; \
		echo ".env creado. Edítalo si tus proyectos están en otro directorio."; \
	else \
		echo ".env ya existe, no se sobreescribe."; \
	fi
	@mkdir -p $(HOST_HOME)/.local/state/opencode
	@mkdir -p $(HOST_HOME)/.local/share/opencode
	@mkdir -p $(HOST_HOME)/.engram
	@mkdir -p $(PROJECTS_DIR)

up: setup
	docker compose up -d --build
	docker exec -it opencode_sandbox bash

down:
	docker compose down

build: setup
	docker compose build --no-cache

shell:
	docker exec -it opencode_sandbox bash

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps
