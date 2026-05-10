return {
  "nvim-neo-tree/neo-tree.nvim",
  opts = {
    filesystem = {
      follow_current_file = { enabled = true },
      use_libuv_file_watcher = true,
      follow_symlinks = true,
    },
    default_component_configs = {
      symlink_target = {
        enabled = true,
      },
    },
  },
}
