-- lua/plugins/snacks.lua
return {
  "folke/snacks.nvim",
  opts = {
    -- applies to all Snacks pickers (and is honored by explorer unless overridden)
    picker = {
      hidden = true,
      ignored = true,
      exclude = { ".git", "**/.git/**" }, -- hide root & nested .git dirs
      sources = {
        -- sources-level opts take precedence, so set them too
        explorer = {
          hidden = true,
          ignored = true,
          exclude = { ".git", "**/.git/**" },
        },
        files    = { hidden = true, ignored = true, exclude = { ".git", "**/.git/**" } },
        grep     = { hidden = true, ignored = true, exclude = { ".git", "**/.git/**" } },
      },
    },

    -- sidebar explorer
    explorer = {
      hidden = true,  -- still show other dotfiles
      ignored = true, -- still show gitignored files if you want
      replace_netrw = true,
      exclude = { ".git", "**/.git/**" },
    },
  },
}
