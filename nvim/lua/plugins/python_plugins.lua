return {
  {
    "mfussenegger/nvim-dap",
    config = function (_, opts)
      -- require("core.utils").load_mappings("dap")
    end
  },
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function (_, opts)
      local path = "C:/Users/maximilian.sunkovsky/AppData/Local/nvim-data/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(path)
     -- require("core.utils").load_mappings("dap_python")
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    --- event = "VeryLazy",
    dependencies = "mfussenegger/nvim-dap",
    config = function()
      local dap = require "dap"
      local dapui = require "dapui"
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
  {
    "nvim-neotest/nvim-nio"
  },
}