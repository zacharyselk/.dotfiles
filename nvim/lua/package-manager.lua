local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost package-manager.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

return packer.startup(function(use)
  use "wbthomason/packer.nvim"

  -- Libraries -----------------------------------------------------------------
  use "nvim-lua/plenary.nvim"  -- Common library
  use "kyazdani42/nvim-web-devicons"  -- Adds various icons
  ------------------------------------------------------------------------------

  -- Cursor movement -----------------------------------------------------------
  --use "unblevable/quick-scope"  -- Hop around the current line
  use "phaazon/hop.nvim"  -- Hop around the screen using work prefixes
  use "chentoast/marks.nvim"
  ------------------------------------------------------------------------------

  -- Theming/Coloring ----------------------------------------------------------
  --use "Mofiqul/dracula.nvim"  -- Dracula theme
  use "rebelot/kanagawa.nvim"  -- Kanagawa theme
  use "lukas-reineke/indent-blankline.nvim"  -- Indentation guides 
  use {
    "nvim-treesitter/nvim-treesitter",  -- Syntax highlighter
    run = ":TSUpdate"
  } 
  ------------------------------------------------------------------------------

  -- UI ------------------------------------------------------------------------
  use {
    "nvim-lualine/lualine.nvim",  -- Adds a statusline
    requires = { "kyazdani42/nvim-web-devicons", opt = true },
  }
  use {
    "akinsho/bufferline.nvim",  -- Adds a bufferline
    requires = { "kyazdani42/nvim-web-devicons" }
  }
  use {
    "kyazdani42/nvim-tree.lua",  -- Tree file structure viewer
    requires = {
      "kyazdani42/nvim-web-devicons", -- optional, for file icon
    },
    tag = "nightly" -- optional, updated every week. (see issue #1193)
  }
  ------------------------------------------------------------------------------
  
  -- LSP -----------------------------------------------------------------------
  use "williamboman/nvim-lsp-installer"
  use "neovim/nvim-lspconfig"
  use "nvim-lua/lsp-status.nvim"
  use "mfussenegger/nvim-jdtls"

  use "Olical/conjure"
  use "tpope/vim-dispatch"
  use "clojure-vim/vim-jack-in"
  use "radenling/vim-dispatch-neovim"

  use "clojure-vim/vim-jack-in"
  use "radenling/vim-dispatch-neovim"
  ------------------------------------------------------------------------------

  -- Completion ----------------------------------------------------------------
  use "hrsh7th/nvim-cmp"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-nvim-lsp"
  
  use "L3MON4D3/LuaSnip"
  use "saadparwaiz1/cmp_luasnip"
  ------------------------------------------------------------------------------

  -- Other ---------------------------------------------------------------------
  use "moll/vim-bbye"  -- Close buffers without exiting nvim
  use {
    "nvim-telescope/telescope.nvim",  -- File finder
    requires = { "nvim-lua/plenary.nvim" }
  }
  use "norcalli/nvim-colorizer.lua"  -- Colors hex codes
  use "akinsho/toggleterm.nvim"  -- Toogles a terminal buffer
  use "folke/which-key.nvim"  -- Interactivly show key bindings
  use "mrjones2014/legendary.nvim"  -- Creates Legends
  ------------------------------------------------------------------------------
  
end)
