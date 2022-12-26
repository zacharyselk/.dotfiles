-- https://github.com/neovim/nvim-lspconfig
local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
  print("Error: lspconfig did not load")
  return
end


--lspconfig.ccls.setup{
--  filetypes = { "c", "cpp", "hpp", "objc", "objcpp" },
--  init_options = {
--    cache = {directory = "/tmp/ccls-cache"},
--    compilationDatabaseDirectory = "cmake-build",
--    index = {
--      threads = 0,
--    };
--    clang = {
--      excludeArgs = { "-frounding-math"},
--    },
--  },
--  root_dir = 
--    function (dir)
--      local filename = dir:match("*.+/(.+)$");
--      if (filename == ".ccls") then
--        return true;
--      else
--        return false;
--      end
--    end,
--}
--lspconfig.jdtls.setup{}

--lspconfig.denols.setup{}
lspconfig.rome.setup{}

lspconfig.pylsp.setup{
  settings = {
    pylsp = {
      plugins = {
        autopep8 = {
          enabled = true
        },

        flake8 = {
          enabled = true,
          maxLineLength = 100
        },

        pycodestyle = {
          --ignore = {'W391'},
          maxLineLength = 100
        }
      }
    }
  }
}

lspconfig.clangd.setup{
  cmd = { "clangd", "--log=verbose" },
}

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
  print("Error: Cmp-nvim-lsp did not load")
  return
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
--local servers = { 'ccls' }
local servers = { 'clangd' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
  }
end
