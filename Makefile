.PHONY: prod-build

init:
	make build
	docker-compose -f .devcontainer/docker-compose.yml run --rm app rails db:create
	docker-compose -f .devcontainer/docker-compose.yml run --rm app rails db:migrate
	docker-compose -f .devcontainer/docker-compose.yml run --rm app rails db:seed_fu

prod-build:
	docker build -t slack-freee-hrm-sync .

