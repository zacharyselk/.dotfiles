local rtp = vim.api.nvim_list_runtime_paths()[1]
vim.api.nvim_set_var("RTP", rtp)
vim.api.nvim_set_var("NVIM_HOME", rtp)
vim.api.nvim_set_var("NVIM_INIT", vim.env.MYVIMRC)
