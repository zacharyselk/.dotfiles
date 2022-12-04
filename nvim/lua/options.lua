--don't call globals unneccessarily
local o = vim.o
local bo = vim.bo --> buffer only use bo
local wo = vim.wo --> window only use wo

-- no need for a global function
local set_options = function(locality, options)
  for key, value in pairs(options) do
    locality[key] = value
  end
end

-- define our options
local options_global = {
cmdheight = 2,
numberwidth = 3,
shiftwidth = 2,
softtabstop = 2,
tabstop = 2,
updatetime = 300,

fileformats = "unix,dos,mac",
guifont = "Hack_Nerd_Font:h11",
--guifont = "LiberationMono:h11",

autoindent = true,
expandtab = true,
hidden = true,
hlsearch = true,
ignorecase = true,
incsearch = true,
number = true,
showcmd = true,
showmatch = true,
showmode = true,
smartcase = true,
smarttab = true,
termguicolors = true,
}

vim.cmd "set listchars=eol:$,tab:--,trail:~,extends:>,precedes:<,space:·"
vim.cmd "set noshiftround"
vim.cmd "set nowrap"

--options_global.listchars = { eol = "$", tab = "--", trail = "~", extends = ">", precedes = "<", space = "·" }
--options_global.listchars = {}
--options_global.listchars.eol = "$"
--options_global.listchars.tab = "--"
--options_global.listchars.trail = "~"
--options_global.listchars.extends = ">"
--options_global.listchars.precedes = "<"
--options_global.listchars.space = "·"


local options_buffer = {
}

local options_window = {
}

--set locally. no need to call elsewhere
set_options(o,  options_global)
set_options(bo, options_buffer)
set_options(wo, options_window)
