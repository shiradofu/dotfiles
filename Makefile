NAME=dotfiles-test-$*
CMD=/bin/sh

build.%:
	@docker build --target $* -t $(NAME) .

build.i:
	@{ git ls-files | sed 's@^@+ /@' ; printf '+ */\n- *\n'; } | \
		rsync -aR --prune-empty-dirs --filter='. -' . ./test/
	@docker build --target i -t $(NAME)-i .
	@test -d ./test && rm -rf test/

new.%: del.%
	@docker run -it --name $(NAME) $(NAME) $(CMD)

in.%:
	@docker start $(NAME)
	@docker exec -it $(NAME) $(CMD)

del.%:
	@CONTAINER_ID=$(shell docker ps -a -f name=$(NAME) -q); \
	test -n "$$CONTAINER_ID" \
		&& docker stop $(NAME) && docker rm $$CONTAINER_ID \
		|| true
