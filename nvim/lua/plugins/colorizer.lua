-- https://github.com/norcalli/nvim-colorizer.lua
local status_ok, colorizer = pcall(require, "colorizer")
if not status_ok then
  print("Error: Colorizer did not load!")
  return
end

colorizer.setup {
  "css";
  "javascript";
  html = {
    mode = "foreground";
  }
}
