local Terminal = require("devcontainers.ui.terminal")
local Notifier = require("devcontainers.providers.notifier")
local Logger = require("devcontainers.utils.logger")


--- Command provider.
---@class Cmd
---
---@field private Terminal Terminal
---@field private Notifier Notifier
---@field private Logger Logger
local Cmd = {}
Cmd.__index = Cmd

function Cmd.new()
    local instance = setmetatable({}, Cmd)

    instance.Terminal = Terminal.new()
    instance.Notifier = Notifier.new()
    instance.Logger = Logger

    instance.Terminal:write({ "Hello World" })

    return instance
end

return Cmd
