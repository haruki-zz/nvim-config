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
      require("dap")

      local sign = vim.fn.sign_define
      sign("DapBreakpoint", { text = "B", texthl = "DiagnosticSignError", linehl = "" })
      sign("DapStopped", { text = ">", texthl = "DiagnosticSignWarn", linehl = "" })
      sign("DapBreakpointRejected", { text = "!", texthl = "DiagnosticSignWarn", linehl = "" })
    end,
  },
}
