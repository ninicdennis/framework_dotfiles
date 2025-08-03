return {
  {
    "ravitemer/mcphub.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    -- installs the mcp-hub CLI used to launch/manage servers
    build = "npm install -g mcp-hub@latest",
    config = function()
      require("mcphub").setup({
        port   = 3000, -- port mcp-hub will listen on
        config = vim.fn.expand("~/.config/nvim/mcpservers.json"),
      })
    end,
  },
}
