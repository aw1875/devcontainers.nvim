-- Imports
local common = require("devcontainers.utils.common")

--- Verify that the terminal is valid.
---
---@param terminal Terminal object.
---@return boolean Validity.
---@private
local is_valid = function(terminal)
    return terminal.bufnr ~= nil
        and terminal.winnr ~= nil
        and vim.api.nvim_buf_is_valid(terminal.bufnr)
        and vim.api.nvim_win_is_valid(terminal.winnr)
end

--- Toggle modifiable on the terminal buffer.
---
---@param terminal Terminal object.
---@return nil
---@private
local toggle_modifiable = function(terminal)
    vim.api.nvim_buf_set_option(terminal.bufnr, "modifiable",
        not vim.api.nvim_buf_get_option(terminal.bufnr, "modifiable"))
end

--- Terminal UI element.
---@class Terminal
---
---@field bufnr number
---@field winnr number
local Terminal = {}
Terminal.__index = Terminal

--- Create a new terminal.
---
---@return table Terminal object.
function Terminal.new()
    local instance = setmetatable({}, Terminal)

    if _G.Devcontainers.config ~= nil and not _G.Devcontainers.config.show_logs then
        instance.bufnr = nil
        instance.winnr = nil
        return instance
    end

    instance.bufnr = vim.api.nvim_create_buf(false, true)
    if instance.bufnr == nil then
        -- TODO: Handle error
    end

    instance.winnr = vim.api.nvim_open_win(instance.bufnr, false, {
        relative = "editor",
        width = vim.api.nvim_list_uis()[1].width,
        height = 10,
        row = vim.api.nvim_get_option("lines"),
        col = 0,
        style = "minimal",
        border = "single",
    })

    -- Set buffer options
    vim.api.nvim_buf_set_option(instance.bufnr, "buftype", "nofile")
    vim.api.nvim_buf_set_option(instance.bufnr, "buflisted", false)
    vim.api.nvim_buf_set_option(instance.bufnr, "swapfile", false)
    vim.api.nvim_buf_set_option(instance.bufnr, "bufhidden", "wipe")
    vim.api.nvim_buf_set_option(instance.bufnr, "modifiable", false)

    -- Set window options
    vim.api.nvim_set_option_value("winhighlight", "Normal:Normal,FloatBorder:Normal",
        { scope = "local", win = instance.winnr }
    )

    -- Autocmd on buffer to clean up instance when it's closed
    vim.api.nvim_buf_attach(instance.bufnr, false, {
        on_detach = function()
            instance.bufnr = nil
            instance.winnr = nil
        end,
    })

    return instance
end

--- Write to the terminal.
---
---@param data table Data to write.
---@return nil
function Terminal:write(data)
    if _G.Devcontainers.config ~= nil and not _G.Devcontainers.config.show_logs then
        return
    end

    data = common.strip_color_codes(data)

    local formatted_lines = {}
    for _, line in ipairs(data) do
        local formatted = "[" .. os.date("%H:%M:%S") .. "] " .. line:gsub("\r", "")
        table.insert(formatted_lines, formatted)
    end

    if not is_valid(self) then return end

    local lines = vim.api.nvim_buf_line_count(self.bufnr)

    toggle_modifiable(self)
    vim.api.nvim_buf_set_lines(self.bufnr, lines - 1, lines, false, formatted_lines)
    vim.api.nvim_win_set_cursor(self.winnr, { lines, 0 })
    toggle_modifiable(self)
end

--- Write error to the terminal.
---
---@param data table Data to write.
---@return nil
function Terminal:error(data)
    if _G.Devcontainers.config ~= nil and not _G.Devcontainers.config.show_logs then
        return
    end

    data = common.strip_color_codes(data)

    local formatted_lines = {}
    for _, line in ipairs(data) do
        local formatted = "[" .. os.date("%H:%M:%S") .. "][ERROR] " .. line:gsub("\r", "")
        table.insert(formatted_lines, formatted)
    end

    if not is_valid(self) then return end

    local lines = vim.api.nvim_buf_line_count(self.bufnr)

    toggle_modifiable(self)
    vim.api.nvim_buf_set_lines(self.bufnr, lines - 1, lines, false, formatted_lines)
    vim.api.nvim_win_set_cursor(self.winnr, { lines, 0 })
    toggle_modifiable(self)
end

--- Clear the terminal.
---
---@return nil
function Terminal:clear()
    toggle_modifiable(self)
    vim.api.nvim_buf_set_lines(self.bufnr, 0, -1, false, {})
    toggle_modifiable(self)
end

--- Close the terminal.
---
---@return nil
function Terminal:close()
    if self.winnr ~= nil then
        vim.api.nvim_win_close(self.winnr, true)
        self.winnr = nil
    end

    if self.bufnr ~= nil then
        vim.api.nvim_buf_delete(self.bufnr, { force = true })
        self.bufnr = nil
    end
end

return Terminal
