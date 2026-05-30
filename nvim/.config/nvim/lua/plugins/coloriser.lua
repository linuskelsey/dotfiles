return {
  dir = "~/Projects/OPEN_SRC/nvim-colorizer.lua",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    require("colorizer").setup({ "*" }, { mode = "background" })
  end,
}
