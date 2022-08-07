.PHONY: $(shell egrep -o ^[a-zA-Z_-]+: $(MAKEFILE_LIST) | sed 's/://')

TEMPFILE = .test_output.tmp

test: deps
	@nvim --headless --noplugin -u tests/init.vim -c "PlenaryBustedFile tests/init.lua" | tee $(TEMPFILE)
	@FAILED=$$(tail -n 1 $(TEMPFILE) | grep 'Tests Failed');\
	rm -f $(TEMPFILE); [ -z "$$FAILED" ]

deps:
	@mkdir -p vendor
ifeq (,$(wildcard ./vendor/plenary.nvim))
	git clone https://github.com/nvim-lua/plenary.nvim.git ./vendor/plenary.nvim
endif
