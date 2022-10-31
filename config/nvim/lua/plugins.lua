local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP =
  fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
  print("Installing packer close and reopen Neovim...")
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
  display = {
    open_fn = function()
      return require("packer.util").float({ border = "single" })
    end,
  },
})

-- Install your plugins here
return packer.startup(function(use)
  use("wbthomason/packer.nvim") -- Have packer manage itself

  -- Look
  use("nvim-lualine/lualine.nvim")
  use("morhetz/gruvbox")
  use("luisiacc/gruvbox-baby")
  use("sainnhe/gruvbox-material")
  use("rafamadriz/neon")
  use({
    "f-person/auto-dark-mode.nvim",
    config = function()
      local dark_mode = require("auto-dark-mode")
      dark_mode.setup({})
      -- dark_mode.init()
    end,
  })

  -- Editing & Navigation
  use({
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  })
  use("junegunn/goyo.vim")
  use("mtth/scratch.vim")
  use("simnalamburt/vim-mundo")
  use({
    "numToStr/Comment.nvim",
    config = function()
      require("Comment").setup()
    end,
  })
  use("tpope/vim-repeat")
  use("tpope/vim-surround")
  use("tpope/vim-unimpaired")
  use({
    "guns/vim-sexp",
    ft = { "clojure", "scheme", "racket", "lisp" },
    requires = {
      "tpope/vim-sexp-mappings-for-regular-people",
    },
  })
  use("kana/vim-textobj-user")
  use("mattn/emmet-vim")
  use("tpope/vim-speeddating") -- ctrl-a ctrl-x for date and time
  use("lyokha/vim-xkbswitch")
  use("bronson/vim-visual-star-search")
  use({ "junegunn/fzf.vim", requires = {
    "/usr/local/opt/fzf",
  } })

  -- Integrations
  use("mileszs/ack.vim")
  use({ "tpope/vim-fugitive", requires = {
    "tpope/vim-rhubarb",
  } })
  use("tpope/vim-vinegar") -- nice things for netrw
  use("tpope/vim-projectionist")
  use({ "Shougo/vimproc.vim", run = "make" })
  use("kassio/neoterm")

  -- Syntax
  use("rizzatti/dash.vim")
  use({
    "tpope/vim-fireplace",
    ft = { "clojure" },
  })
  use({ "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" })
  use({ "sheerun/vim-go", ft = { "go" } })
  use({ "tpope/vim-jdaddy", ft = { "json" } })
  use({ "neoclide/jsonc.vim", ft = "json" })
  use({ "b0o/schemastore.nvim" })
  use({ "ap/vim-css-color", ft = { "html", "css", "javascript", "typescript", "vue", "less", "sass", "stylus" } })
  use({ "wuelnerdotexe/vim-astro", ft = { "astro" } })
  use({ "ellisonleao/glow.nvim", ft = { "markdown" } })

  -- LSP
  use("nvim-lua/plenary.nvim")
  use({
    "neovim/nvim-lspconfig",
    requires = {
      "williamboman/nvim-lsp-installer",
      "jose-elias-alvarez/null-ls.nvim",
    },
  })
  use({
    "hrsh7th/nvim-cmp",
    requires = {
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
      "L3MON4D3/LuaSnip",
      "hrsh7th/cmp-emoji",
    },
  })
  use("folke/neodev.nvim")

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
