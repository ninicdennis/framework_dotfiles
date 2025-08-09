return {
  "CopilotC-Nvim/CopilotChat.nvim",
  opts = function(_, opts)
    local select = require("CopilotChat.select")
    opts = opts or {}
    -- Make "the whole current buffer" the default context for asks
    opts.selection = select.buffer
    opts.default_model = "gpt-4o"
    return opts
  end,
  keys = {
    -- Open chat already primed with the current buffer as context
    {
      "<leader>aa",
      function()
        require("CopilotChat").toggle()
      end,
      desc = "CopilotChat (uses current buffer by default)",
    },
    {
      "<leader>am",
      function()
        require("CopilotChat").select_model()
      end,
      desc = "Select Model"
    },

    -- Handy one-shots that always include your current buffer
    {
      "<leader>ae",
      function()
        require("CopilotChat").ask("Explain this file.")
      end,
      desc = "Explain current buffer",
    },
    {
      "<leader>ar",
      function()
        require("CopilotChat").ask("Review this file for bugs and improvements.")
      end,
      desc = "Review current buffer",
    },
  },
}
