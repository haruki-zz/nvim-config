return {
  {
    "loctvl842/monokai-pro.nvim",
    priority = 1000,
    opts = {
      transparent_background = false,
      terminal_colors = true,
      devicons = true,
      filter = "pro", -- classic | octagon | pro | machine | ristretto | spectrum
      day_night = {
        enable = false,
        day_filter = "pro",
        night_filter = "spectrum",
      },
      inc_search = "background", -- underline | background
      background_clear = {
        "float_win",
        "toggleterm",
        "telescope",
        "which-key",
        "renamer",
        "notify",
        "nvim-tree",
        "neo-tree",
        "bufferline",
        "lualine",
        "trouble",
      },
      plugins = {
        bufferline = {
          underline_selected = false,
          underline_visible = false,
        },
        indent_blankline = {
          context_highlight = "default", -- default | pro
          context_start_underline = false,
        },
      },
    },
    config = function(_, opts)
      require("monokai-pro").setup(opts)
      vim.cmd.colorscheme("monokai-pro")
    end,
  },
}