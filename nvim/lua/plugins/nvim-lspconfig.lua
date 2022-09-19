-- https://github.com/neovim/nvim-lspconfig
local status_ok, lspconfig = pcall(require, "lspconfig")
if not status_ok then
  print("Error: lspconfig did not load")
  return
end


lspconfig.ccls.setup{
  filetypes = { "c", "cpp", "hpp", "objc", "objcpp" },
  --root_dir = "compile_commands.json",
  init_options = {
    compilationDatabaseDirectory = "build",
    index = {
      threads = 0,
    };
    clang = {
      excludeArgs = { "-frounding-math"},
    },
  }
}
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

local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
  print("Error: Cmp-nvim-lsp did not load")
  return
end

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = cmp_nvim_lsp.update_capabilities(capabilities)

-- Enable some language servers with the additional completion capabilities offered by nvim-cmp
local servers = { 'ccls' }
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    -- on_attach = my_custom_on_attach,
    capabilities = capabilities,
  }
end
