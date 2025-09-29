return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      {
        "<leader>db",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "DAP Toggle Breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "DAP Continue",
      },
      {
        "<leader>di",
        function()
          require("dap").step_into()
        end,
        desc = "DAP Step Into",
      },
      {
        "<leader>do",
        function()
          require("dap").step_over()
        end,
        desc = "DAP Step Over",
      },
      {
        "<leader>dO",
        function()
          require("dap").step_out()
        end,
        desc = "DAP Step Out",
      },
      {
        "<leader>dr",
        function()
          require("dap").repl.toggle()
        end,
        desc = "DAP Toggle REPL",
      },
      {
        "<leader>dl",
        function()
          require("dap").run_last()
        end,
        desc = "DAP Run Last",
      },
    },
    config = function()
      local sign = vim.fn.sign_define
      sign("DapBreakpoint", { text = "B", texthl = "DiagnosticSignError", linehl = "" })
      sign("DapStopped", { text = ">", texthl = "DiagnosticSignWarn", linehl = "" })
      sign("DapBreakpointRejected", { text = "!", texthl = "DiagnosticSignWarn", linehl = "" })
    end,
  },
  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = {
      "mfussenegger/nvim-dap",
      "williamboman/mason.nvim",
    },
    opts = {
      ensure_installed = { "codelldb" },
      automatic_setup = true,
    },
    config = function(_, opts)
      local mason_dap = require("mason-nvim-dap")
      mason_dap.setup(opts)

      local ok, registry = pcall(require, "mason-registry")
      if not ok then
        return
      end

      if not registry.has_package("codelldb") then
        return
      end

      local codelldb = registry.get_package("codelldb")
      if not codelldb:is_installed() then
        return
      end

      local mason_root = vim.env.MASON or (vim.fn.stdpath("data") .. "/mason")
      local package_path = vim.fs.joinpath(mason_root, "packages", "codelldb")
      if vim.fn.isdirectory(package_path) == 0 then
        return
      end

      local extension_path = vim.fs.joinpath(package_path, "extension")
      local codelldb_path = vim.fs.joinpath(extension_path, "adapter", "codelldb")
      local liblldb_path = vim.fs.joinpath(extension_path, "lldb", "lib", "liblldb")
      local system = vim.loop.os_uname().sysname

      if system == "Windows_NT" then
        codelldb_path = codelldb_path .. ".exe"
        liblldb_path = vim.fs.joinpath(extension_path, "lldb", "bin", "liblldb.dll")
      elseif system == "Darwin" then
        liblldb_path = liblldb_path .. ".dylib"
      else
        liblldb_path = liblldb_path .. ".so"
      end

      local dap = require("dap")
      dap.adapters.codelldb = function(callback)
        callback({
          type = "server",
          port = "${port}",
          executable = {
            command = codelldb_path,
            args = { "--liblldb", liblldb_path, "--port", "${port}" },
          },
        })
      end

      dap.configurations.rust = {
        {
          type = "codelldb",
          request = "launch",
          name = "Debug executable",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
        {
          type = "codelldb",
          request = "launch",
          name = "Debug unit tests",
          program = function()
            return vim.fn.input("Path to test executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
    end,
  },
}
