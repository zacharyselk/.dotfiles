-- https://github.com/nvim-lualine/lualine.nvim
local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  print("Error: Lualine did not load!")
  return
end

lualine.setup {
  options = { theme = "dracula-nvim" }
}
