local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
if not status_ok then
  print("Error: Treesitter did not load!")
  return
end

treesitter.setup {
  ensure_installed = { "clojure", "cpp", "java", "lua", "python" },

  -- Not compiling
  ignore_install = { "hack", "norg", "pug" },
  highlight = {
    enable = true,
  },
}
