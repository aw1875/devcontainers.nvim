-- Imports


-- Providers
local Notifier = require("devcontainers.providers.notifier")
local Logger = require("devcontainers.utils.logger")

local Devcontainers = {}

Devcontainers.setup = function(opts)
    _G.Devcontainers.config = require("devcontainers.config").setup(opts)
end

Devcontainers.Reopen = function()
    ---@type Notifier
    local n = Notifier.new()

    -- Clear old logs
    Logger.clear()
end

Devcontainers.Rebuild = function()
    ---@type Notifier
    local n = Notifier.new()

    -- Clear old logs
    Logger.clear()
end

_G.Devcontainers = Devcontainers

return _G.Devcontainers
