return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "monokai-pro",
        component_separators = "|",
        section_separators = "",
        globalstatus = true,
      },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        mode = "buffers",
        separator_style = "thin",
        show_buffer_close_icons = false,
        always_show_bufferline = true,
        diagnostics = "nvim_lsp",
        offsets = {
          {
            filetype = "NvimTree",
            text = "Explorer",
            highlight = "Directory",
            text_align = "left",
          },
        },
      },
    },
    keys = {
      { "<C-Tab>", "<cmd>BufferLineCycleNext<cr>", desc = "Next Tab" },
      { "<C-S-Tab>", "<cmd>BufferLineCyclePrev<cr>", desc = "Previous Tab" },
    },
  },
  {
    "folke/trouble.nvim",
    cmd = "Trouble",
    version = "*",
    opts = {},
    keys = {
      { "<leader>pp", "<cmd>Trouble diagnostics toggle<cr>", desc = "Toggle Problems" },
      { "<leader>pr", "<cmd>Trouble lsp_references toggle<cr>", desc = "List References" },
    },
  },
}
