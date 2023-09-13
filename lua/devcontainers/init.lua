local Devcontainers = {}

Devcontainers.setup = function(opts)
    _G.Devcontainers = require("devcontainers.config").setup(opts)
end

Devcontainers.Reopen = function()
    -- TODO: Implement
end

Devcontainers.Rebuild = function()
    -- TODO: Implement
end

_G.Devcontainers = Devcontainers

return _G.Devcontainers
