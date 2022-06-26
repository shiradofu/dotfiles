local install_path = vim.fn.stdpath"data".."/site/pack/packer/opt/packer.nvim"
if vim.fn.empty(vim.fn.glob(install_path)) == 1 then
  print(install_path)
  return
end

vim.cmd[[packadd packer.nvim]]
require"plug/packer"

return require"packer".startup(function(use)
	use{"wbthomason/packer.nvim", opt = true}

	-- ------------------------------------------------------------
	-- Library

	--------------------------------
	-- Vim script Library
	use{ "tpope/vim-repeat", event = "VimEnter" }
	-- use {'mattn/webapi-vim'}

	--------------------------------
	-- Lua Library
	-- use{ "nvim-lua/popup.nvim", module = "popup" }
	use{ "nvim-lua/plenary.nvim" } -- do not lazy load
	use{ "tami5/sqlite.lua", module = "sqlite" }
	use{ "MunifTanjim/nui.nvim", module = "nui" }

	--------------------------------
	-- Denops Library
	-- use {'vim-denops/denops.vim'}

	--------------------------------
	-- Treesitter
	use{
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
		config = function()require"plug/treesitter"end,
	}
  use"nvim-treesitter/playground"


	--------------------------------------------------------------
	-- LSP & completion

	--------------------------------
	-- Language Server Protocol(LSP)

	use{
		"neovim/nvim-lspconfig",
		config = function()require"plug/lspconfig"end,
	}
	use{
		"williamboman/nvim-lsp-installer",
		config = function()require"plug/lsp-installer"end,
	}


	use"xiyaowong/nvim-transparent"

	--------------------------------
	-- telescope.nvim
	-- use{
	-- 	"nvim-telescope/telescope.nvim",
	-- 	config = function()require"plug/telescope"end,
	-- }

  -- use{
    -- 'nvim-telescope/telescope-fzf-native.nvim',
    -- run = 'make',
    -- config = function()require('telescope').load_extension('fzf')end,
  -- }

	-- use{
	-- 	"nvim-telescope/telescope-frecency.nvim",
	-- 	after = { "telescope.nvim" },
	-- 	config = function()require"telescope".load_extension"frecency"end,
	-- }


end)
