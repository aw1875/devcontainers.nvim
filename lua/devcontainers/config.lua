local Devcontainers = {}

--- You can configure certain aspects of the plugin when calling the setup function.
---
--- Default values:
---@eval return MiniDoc.afterlines_to_code(MiniDoc.current.eval_section)
Devcontainers.options = {
    -- Prints useful logs about what event are triggered, and reasons actions are executed.
    debug = true,

    -- Show terminal logs in a small terminal.
    show_logs = true,

    -- Dependencies to install.
    dependencies = {},

    --- Callback function to be called when a connection is established.
    on_connect = function()
    end,
}

--- Define your devcontainers setup.
---
---@param options table Module config table. See |Devcontainers.options|.
---
---@usage `require("devcontainers").setup()` (add `{}` with your |Devcontainers.options| table)
function Devcontainers.setup(options)
    options = options or {}

    Devcontainers.options = vim.tbl_deep_extend("keep", options, Devcontainers.options)

    return Devcontainers.options
end

return Devcontainers
