return {
  {
    "williamboman/mason.nvim",
    config = true,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "mason.nvim" },
    opts = {
      ensure_installed = {
        "lua_ls",
        "pyright",
        "ts_ls",
        "html",
        "cssls",
        "jsonls",
        "yamlls",
        "bashls",
        "clangd",
        "rust_analyzer",
      },
      automatic_installation = true,
    },
  },
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      lightbulb = { enable = false },
    },
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "mason.nvim",
      "mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "nvimdev/lspsaga.nvim",
    },
    config = function()
      local cmp_nvim_lsp = require("cmp_nvim_lsp")
      local format_group = vim.api.nvim_create_augroup("LspFormatOnSave", { clear = false })

      local capabilities = cmp_nvim_lsp.default_capabilities()

      local on_attach = function(client, bufnr)
        local opts = { buffer = bufnr, silent = true }
        local saga_available = pcall(require, "lspsaga")
        local rename = saga_available and "<cmd>Lspsaga rename<cr>" or vim.lsp.buf.rename
        local code_action = saga_available and "<cmd>Lspsaga code_action<cr>" or vim.lsp.buf.code_action
        local definition = saga_available and "<cmd>Lspsaga goto_definition<cr>" or vim.lsp.buf.definition
        local hover = saga_available and "<cmd>Lspsaga hover_doc<cr>" or vim.lsp.buf.hover
        local references = saga_available and "<cmd>Lspsaga finder<cr>" or vim.lsp.buf.references

        if saga_available then
          vim.keymap.set("n", "gd", definition, opts)
          vim.keymap.set("n", "K", hover, opts)
          vim.keymap.set("n", "<leader>rn", rename, opts)
          vim.keymap.set({ "n", "v" }, "<leader>ca", code_action, opts)
          vim.keymap.set("n", "gr", references, opts)
          vim.keymap.set("n", "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<cr>", opts)
          vim.keymap.set("n", "<leader>sl", "<cmd>Lspsaga show_line_diagnostics<cr>", opts)
          vim.keymap.set("n", "<C-k>", "<cmd>Lspsaga signature_help<cr>", opts)
        else
          vim.keymap.set("n", "gd", definition, opts)
          vim.keymap.set("n", "K", hover, opts)
          vim.keymap.set("n", "<leader>rn", rename, opts)
          vim.keymap.set({ "n", "v" }, "<leader>ca", code_action, opts)
          vim.keymap.set("n", "gr", references, opts)
          vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
        end

        vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
        vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
        vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set("n", "<leader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, opts)
        vim.keymap.set("n", "<leader>f", function()
          vim.lsp.buf.format({ async = false })
        end, opts)
        vim.keymap.set("n", "<F2>", rename, opts)
        vim.keymap.set("n", "<F12>", definition, opts)
        vim.keymap.set("n", "<S-F12>", references, opts)
        vim.keymap.set({ "n", "v" }, "<C-.>", code_action, opts)

        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = format_group, buffer = bufnr })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = format_group,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr, async = false })
            end,
          })
        end
      end

      local servers = {
        "pyright",
        "ts_ls",
        "html",
        "cssls",
        "jsonls",
        "yamlls",
        "bashls",
        "clangd",
        "rust_analyzer",
      }

      for _, server in ipairs(servers) do
        vim.lsp.config(server, {
          capabilities = capabilities,
          on_attach = on_attach,
        })
      end

      vim.lsp.config("lua_ls", {
        capabilities = capabilities,
        on_attach = on_attach,
        settings = {
          Lua = {
            runtime = {
              version = "LuaJIT",
            },
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })
    end,
  },
}
