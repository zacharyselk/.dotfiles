""" Misc """"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"echo  "  MMM"
"echo  "d(^_^)b"
"echo " \\| |/"
"echo  "  (#)"
"echo  "  |||"
"echo  "  d^b"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

execute 'lua require("variables")'
execute 'lua require("options")'
execute 'lua require("package-manager")'
execute 'lua require("keymaps")'
execute 'lua require("plugins")'

autocmd BufReadPost * if @% !~# '\.git[\/\\]COMMIT_EDITMSG$' && line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif 
syntax enable
highlight NvimTreeFolderIcon guibg=blue

"aug fix_eol
"  au!
"  BufReadPost * if &ff!=unix | keepp %s/\r$//e | endif
"aug END
