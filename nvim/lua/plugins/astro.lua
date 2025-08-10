return {
  -- Conform: format on save with Prettier/Prettierd
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      --     opts.format_on_save = { timeout_ms = 1000, lsp_fallback = true }
      opts.formatters_by_ft = vim.tbl_extend("force", opts.formatters_by_ft or {}, {
        astro = { "prettierd", "prettier" },
        html = { "prettierd", "prettier" },
        javascript = { "prettierd", "prettier" },
        typescript = { "prettierd", "prettier" },
        css = { "prettierd", "prettier" },
        json = { "prettierd", "prettier" },
        markdown = { "prettierd", "prettier" },
        yaml = { "prettierd", "prettier" },
      })
    end,
  },

  -- Make sure the tools exist
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        "astro-language-server",
        "prettierd",
      })
    end,
  },

  -- (optional) Treesitter parser for Astro
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { "astro", "html", "css", "javascript", "typescript" })
    end,
  },
}
