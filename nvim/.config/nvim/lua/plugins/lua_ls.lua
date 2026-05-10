-- ~/.dotfiles/nvim/.config/nvim/lua/plugins/lua-ls.lua
return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                checkThirdParty = false,
                ignoreDir = { "/home/prometheus/.config/yazi" },
              },
            },
          },
        },
      },
    },
  },
}
