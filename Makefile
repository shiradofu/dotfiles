BASE=dotfiles-test
NAME=$(BASE)-$*

build.%:
	@docker build --target $* -t $(NAME) .

build.i:
	@{ git ls-files | sed 's@^@+ /@' ; printf '+ */\n- *\n'; } | \
		rsync -aR --prune-empty-dirs --filter='. -' . ./test/
	@docker build --target i -t $(BASE)-i .
	@test -d ./test && rm -rf test/

new.%: del.%
	@docker run -it --name $(NAME) $(NAME)

sh.%:
	@docker start $(NAME)
	@docker exec -it $(NAME) /bin/sh

zsh.%:
	@docker start $(NAME)
	@docker exec -it $(NAME) /home/linuxbrew/.linuxbrew/bin/zsh

del.%:
	@CONTAINER_ID=$(shell docker ps -a -f name=$(NAME) -q); \
	test -n "$$CONTAINER_ID" \
		&& docker stop $(NAME) && docker rm $$CONTAINER_ID \
		|| true
