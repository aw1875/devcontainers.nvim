local notify = require("notify")

--- Handle showing notifications.
---@class Notifier
---
---@field frames string[] List of frames to cycle through.
---@field current_frame number Current frame index.
---@field message string Message to display.
---@field notification any Notification object.
local Notifier = {}
Notifier.__index = Notifier

--- Create a new notifier.
---
---@return table Notifier object.
function Notifier.new()
    local this = setmetatable({}, Notifier)

    this.frames = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
    this.current_frame = nil
    this.message = nil
    this.notification = nil

    return this
end

--- Start the notifier.
---
---@param message string Message to display.
---@return table Notifier object.
function Notifier:start(message)
    self.current_frame = 1
    self.message = message
    self.notification = notify(self:format_message(), "info", {
        timeout = false,
        hide_from_history = true,
        render = "minimal",
    })

    self:run_animation()

    return self
end

--- Update the notifier message.
---
---@param message string Message to display.
---@return nil
function Notifier:update_message(message)
    -- We need to defer this so that the notification has time to render.
    vim.defer_fn(function()
        self.message = message
    end, 250)
end

--- Run the notifier animation.
---
---@return nil
function Notifier:run_animation()
    if self.current_frame then
        self.current_frame = (self.current_frame % #self.frames) + 1

        self.notification = notify(self:format_message(), "info", {
            hide_from_history = true,
            replace = self.notification,
        })

        vim.defer_fn(function()
            self:run_animation()
        end, 100)
    end
end

--- Stop the notifier.
---
---@param message string Message to display.
---@param level? string Notification level.
---@return nil
function Notifier:stop(message, level)
    level = level or "info"
    local icon = level == "error" and "" or ""
    self.notification = notify(icon .. "  " .. message, level, {
        replace = self.notification,
        timeout = 3000,
    })
    self.current_frame = nil
    self.notification = nil
    self.message = nil
end

--- Format the message to display.
---
---@return string Formatted message.
function Notifier:format_message()
    return self.frames[self.current_frame] .. "  " .. self.message .. "  "
end

--- Create a single one off notification.
---
---@param message string Message to display.
---@param level? string Notification level.
---@param timeout? number Notification timeout.
---@return nil
function Notifier:notify(message, level, timeout)
    level = level or "info"
    timeout = timeout or 5000
    local icon = level == "error" and "" or ""

    notify(icon .. "  " .. message, level, {
        timeout = timeout,
        hide_from_history = true,
        render = "minimal",
    })
end

return Notifier
