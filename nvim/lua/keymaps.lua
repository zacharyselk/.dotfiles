local opts = { noremap = true, silent = true }
local loud = { noremap = true }
local term_opts = { silent = true }
local keymap = vim.api.nvim_set_keymap
local wk = require("which-key")

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "


-- Top Level -------------------------------------------------------------------
wk.register({
  ["<Leader>"] = {
    t = { "<Cmd>ToggleTerm<CR>", "Toggle Terminal" },
    v = { "<C-v>", "Visual Block" },
    ["<Tab>"] = { "<Cmd>NvimTreeToggle<CR>", "File Tree" },
    ["/"] = { ":let @/=''<CR>", "Clear Search" },
  },
}, {})

wk.register({
  ["<Leader>"] = {
    ["/"] = { ":let @/=''<CR>", "Clear Search" },
  },
}, { mode = "v" })
--------------------------------------------------------------------------------

-- Buffer Managment ------------------------------------------------------------
keymap("n", "<Leader>fq", "<CMD>Bdelete<CR>", opts)  -- Deletes a buffer without closing nvim
wk.register({
  ["<Leader>b"] = {
    name = "Buffer",
    f = { "<CMD>lua require('telescope.builtin').buffers()<CR>", "Find" },
    p = { "<Cmd>BufferLinePick<CR>", "Pick Buffer" },
    h = { "<Cmd>BufferLineCyclePrev<CR>", "Previous Buffer" },
    l = { "<Cmd>BufferLineCycleNext<CR>", "Next Buffer" },
    c = { "<Cmd>BufferLinePickClose<CR>", "Close Buffer" },
    q = { "<Cmd>Bdelete<CR>", "Close Curent Buffer" },
  },
}, {})
--------------------------------------------------------------------------------

-- Copy ------------------------------------------------------------------------
wk.register({
  ["<Leader>c"] = {
    name = "Copy",
    w = { "yiw", "Word" },
  },
}, {})
--------------------------------------------------------------------------------

-- Edit ------------------------------------------------------------------------
wk.register({
  ["<Leader>e"] = {
    name = "Edit",
  },
}, {})

wk.register({
  ["<Leader>ec"] = {
    name = "Clear",
    l = { "O<ESC>jddk", "Line" },
  },
}, {})

wk.register({
  ["<Leader>ew"] = {
    name = "Word",
    u = { "viwU", "Uppercase" },
    l = { "viwu", "lowercase" },
    ['"'] = { "viw<ESC>a\"<ESC>bi\"<ESC>lel", "\"...\"" },
    ["'"] = { "viw<ESC>a'<ESC>bi'<ESC>lel", "'...'" },
  },
}, {})

wk.register({
  ["<Leader>e"] = {
    name = "Edit",
    ['"'] = { "<ESC>`>a\"<ESC>`<i\"<ESC>`>ll", "\"...\"" },
    ["'"] = { "<ESC>`>a'<ESC>`<i'<ESC>`>ll", "'...'" },
  },
}, { mode = "v" })
--------------------------------------------------------------------------------

-- File Commands ---------------------------------------------------------------
wk.register({
  ["<Leader>f"] = {
    name = "File",
    f = { "<CMD>lua require('telescope.builtin').find_files()<CR>", "Find" },
    g = { "<CMD>lua require('telescope.builtin').live_grep()<CR>", "Grep" },
    s = { "<Cmd>w<CR>", "Save current file" },
  },
}, {})

keymap("n", "<Leader>r", "", opts)  -- Reload meta info
keymap("n", "<Leader>n", "<CMD> NvimTreeFindFile<CR>", opts)  -- Open tree folders to current file
wk.register({
  ["<Leader>ft"] = {
    name = "Tree",
    r = { "<CMD>NvimTreeRefreash<CR>", "Refreash File Tree" },
    r = { "<CMD>NvimTreeFindFile<CR>", "Show File in Tree" },
  },
}, {})


-- init.vim Commands
wk.register({
  ["<Leader>fv"] = {
    name = "NVim",
    g = { "<Cmd>excute 'e' g:NVIM_INIT<CR>", "Goto init.vim" },
    e = { "<Cmd>excute 'vsplit' g:NVIM_INIT<CR>", "Open init.vim" },
    u = { "<Cmd>excute 'source' g:NVIM_INIT<CR>", "source init.vim" },
  },
}, {})
--------------------------------------------------------------------------------

-- Help ------------------------------------------------------------------------
wk.register({
  ["<Leader>h"] = {
    name = "Help",
    f = { "<CMD>lua require('telescope.builtin').find_files()<CR>", "Find" },
  },
}, {})
--------------------------------------------------------------------------------

-- Replace ---------------------------------------------------------------------
wk.register({
  ["<Leader>r"] = {
    name = "Replace",
    w = { "ciw<ESC>\"0p", "Word" },
  },
}, {})
--------------------------------------------------------------------------------

-- Window Managment ------------------------------------------------------------
wk.register({
  ["<Leader>w"] = {
    name = "Window",
    h = { "<C-w>h", "Move Left" },           -- Move to the window to the left
    j = { "<C-w>j", "Move Down" },           -- Move to the window below
    k = { "<C-w>k", "Move Up" },             -- Move to the window above
    l = { "<C-w>l", "Move Right" },          -- Move to the window to the right
    ["|"] = { "<C-w>v", "Split Veritcally" },    -- Split buffer vertically
    ["-"] = { "<C-w>h", "Split horizontally" },  -- Split buffer horizontally
  },
}, {})
--------------------------------------------------------------------------------

-- Options ---------------------------------------------------------------------
wk.register({
  ["<Leader>-"] = {
    name = "Options",
    n = { "<Cmd>set number!", "Toggle Line Numbers" },
    w = { "<Cmd>set lsit!", "Toggle Whitespace Mode" },
    r = { "<Cmd>set set cc=81", "Enable Line Ruler" },
  },
}, {})
--------------------------------------------------------------------------------


-- Movement --------------------------------------------------------------------
keymap("n", "H", "^", opts)  -- Move to the begining of the line
keymap("n", "L", "^", opts)  -- Move to the end of the line
keymap("n", "J", "^", opts)  -- Move to the bottom of the buffer
keymap("n", "K", "^", opts)  -- Move to the top of the buffer
--------------------------------------------------------------------------------

-- Search ----------------------------------------------------------------------
keymap("n", "/", "/\\v", opts)  -- Default escape all searches
keymap("v", "/", "/\\v", opts)  -- Default escape all searches
--------------------------------------------------------------------------------

-- Esc -------------------------------------------------------------------------
keymap("i", "jk", "<ESC>", opts)  -- Make jk act as escape
--------------------------------------------------------------------------------

-- Hop -------------------------------------------------------------------------
keymap('n', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", opts)
keymap('n', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", opts)
keymap('o', 'f', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true, inclusive_jump = true })<cr>", opts) 
keymap('o', 'F', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true, inclusive_jump = true })<cr>", opts)
keymap('', 't', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.AFTER_CURSOR, current_line_only = true })<cr>", opts)
keymap('', 'T', "<cmd>lua require'hop'.hint_char1({ direction = require'hop.hint'.HintDirection.BEFORE_CURSOR, current_line_only = true })<cr>", opts)
--keymap('n', '<leader>e', "<cmd> lua require'hop'.hint_words({ hint_position = require'hop.hint'.HintPosition.END })<cr>", opts)
--keymap('v', '<leader>e', "<cmd> lua require'hop'.hint_words({ hint_position = require'hop.hint'.HintPosition.END })<cr>", opts)
--keymap('o', '<leader>e', "<cmd> lua require'hop'.hint_words({ hint_position = require'hop.hint'.HintPosition.END, inclusive_jump = true })<cr>", opts)
--------------------------------------------------------------------------------

