-- ~/.config/nvim/lua/user/json.lua
return {
  "neovim/nvim-lspconfig",
  opts = {
    servers = {
      jsonls = {
        -- merge in schemastore _and_ our own override
        on_new_config = function(new_config)
          new_config.settings.json         = new_config.settings.json or {}
          new_config.settings.json.schemas = new_config.settings.json.schemas or {}
          -- first let schemastore fill in its defaults
          vim.list_extend(
            new_config.settings.json.schemas,
            require("schemastore").json.schemas()
          )
          -- now add a catch-all that explicitly allows trailing commas
          table.insert(new_config.settings.json.schemas, {
            fileMatch = { "*.json", "*.jsonc" },
            schema    = { allowTrailingCommas = true },
          })
        end,
        settings = {
          json = {
            format   = { enable = true },
            validate = { enable = true },
          },
        },
      },
    },
  },
}
