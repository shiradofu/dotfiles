OS=ubuntu
IMAGE=dotfiles-test
CONTAINER=dotfiles-test-$(OS)
CMD=/bin/sh

start:
	@docker start $(CONTAINER)
	@docker exec -it $(CONTAINER) $(CMD)

fresh:
	@docker build --target $(OS)-fresh -t $(IMAGE) .

initialized:
	@{ git ls-files | sed 's@^@+ /@' ; printf '+ */\n- *\n'; } | \
		rsync -aR --prune-empty-dirs --filter='. -' . ./test/
	@docker build --target $(OS)-initialized -t $(IMAGE) .
	@test -d ./test && rm -rf test/

launch: clean
	@docker run -it --name $(CONTAINER) $(IMAGE) $(CMD)

clean:
	@CONTAINER_ID=$(shell docker ps -a -f name=$(CONTAINER) -q); \
	test -n "$$CONTAINER_ID" \
		&& docker stop $(CONTAINER) && docker rm $$CONTAINER_ID \
		|| true
