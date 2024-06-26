MAKEFLAGS += --always-make

# ターゲットを指定しなかったときに実行するものを指定する
.DEFAULT_GOAL := daemon

# .envの環境変数を読み込む
include .env
export

daemon:
	@docker-compose up -d

up:
	@docker-compose up

down:
	@docker-compose down

re: down up

app:
	@docker-compose exec app bash

db:
	@docker-compose exec db mysql -u $$DB_USERNAME -p$$DB_PASSWORD $$DB_DATABASE
