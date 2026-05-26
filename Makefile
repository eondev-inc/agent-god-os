.PHONY: up down build shell logs restart ps

up:
	docker compose up -d --build
	docker exec -it opencode_sandbox bash

down:
	docker compose down

build:
	docker compose build --no-cache

shell:
	docker exec -it opencode_sandbox bash

logs:
	docker compose logs -f

restart:
	docker compose restart

ps:
	docker compose ps
