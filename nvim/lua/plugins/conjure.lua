-- https://github.com/Olical/conjure
local status_ok, conjure = pcall(require, "conjure")
if not status_ok then
  print("Error: Hop did not load!")
	return
end

vim.g['conjure#extract#tree_sitter#enabled'] = true
