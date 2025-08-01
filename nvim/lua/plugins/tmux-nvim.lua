return {
  "christoomey/vim-tmux-navigator",
  lazy = false,
  config = function()
    vim.g.tmux_navigator_no_mappings = 1

    local map = vim.keymap.set
    local opts = { silent = true }

    map("n", "<C-h>", ":TmuxNavigateLeft<CR>", opts)
    map("n", "<C-j>", ":TmuxNavigateDown<CR>", opts)
    map("n", "<C-k>", ":TmuxNavigateUp<CR>", opts)
    map("n", "<C-l>", ":TmuxNavigateRight<CR>", opts)
  end,
}
