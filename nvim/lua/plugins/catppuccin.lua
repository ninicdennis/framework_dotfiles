return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    opts = {
      flavour = "mocha", -- or "latte", "frappe", "macchiato"
      transparent_background = false,
      integrations = {
        cmp = true,
        gitsigns = true,
        nvimtree = true,
        treesitter = true,
        telescope = true,
        which_key = true,
        mini = true,
        notify = true,
        indent_blankline = {
          enabled = true,
        },
      },
    },
  },
  {
    {
      "LazyVim/LazyVim",
      opts = {
        colorscheme = "catppuccin",
      }
    }
  }
}
