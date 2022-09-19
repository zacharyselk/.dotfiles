-- https://github.com/lukas-reineke/indent-blankline.nvim
-- Original background color is #282a36
local status_ok, indent_blankline = pcall(require, "indent_blankline")
if not status_ok then
  print("Error: Indent-Blankline did not load!")
  return
end


vim.cmd [[highlight IndentBlanklineIndent1 guibg=#282a36 gui=nocombine]]
--vim.cmd [[highlight IndentBlanklineIndent2 guibg=#252731 gui=nocombine]]
vim.cmd [[highlight IndentBlanklineIndent2 guibg=#2c2f3a gui=nocombine]]

indent_blankline.setup {
    --char = "",
    --char_highlight_list = {
    --   "IndentBlanklineIndent1",
    --   "IndentBlanklineIndent2",
    --},
    --space_char_highlight_list = {
    --   "IndentBlanklineIndent1",
    --   "IndentBlanklineIndent2",
    --},
    --show_trailing_blankline_indent = false,
}

--require("indent_blankline").setup {
--    char = "|",
--    buftype_exclude = {"terminal"}
--}
