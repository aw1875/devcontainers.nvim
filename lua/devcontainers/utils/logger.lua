-- TODO: Refactor to be dry

--- Logger module.
---@class Logger
---@field private log_file string
local Logger = {}
Logger.log_file = os.getenv("HOME") .. "/.cache/nvim/devcontainers.log"

--- Check if a message is nil or empty.
---
---@param message string Message to check.
---@return boolean
---@private
local nil_check = function(message)
    return message == nil or message == "" or message == "\n"
end

--- Write a message to the log file.
---
---@param message string Message to write.
---@return nil
---@private
local write = function(message)
    local f = io.open(Logger.log_file, "a")
    if f then
        io.output(f)
        io.write(message .. "\n")
        f:close()
    end
end

--- Sanitize input for logging.
---
---@param message string Message to sanitize.
---@return string
Logger.sanitize = function(message)
    -- Remove timestamps
    local sanitized = message:gsub("%d+:%d+:%d+ ", "")

    -- Remove escape sequences
    sanitized = sanitized:gsub("\27%[%?25l", ""):gsub("\27%[%?25h", "")
    sanitized = sanitized:gsub("\27%[u", ""):gsub("\27%[2K", ""):gsub("\27", "")

    return sanitized
end

--- Clear the log file.
---
---@return nil
Logger.clear = function()
    local f = io.open(Logger.log_file, "w")
    if f then
        f:close()
    end
end

--- Log a message to the log file. [INFO]
---
---@param message string|table Message to log.
---@return nil
Logger.INFO = function(message)
    if type(message) == "table" then
        for _, line in ipairs(message) do
            Logger.INFO(line)
        end

        return
    end

    if nil_check(message) then return end

    message = Logger.sanitize(message)
    message = "[INFO][" .. os.date("%Y-%m-%d %H:%M:%S") .. "] " .. message

    write(message)
end

--- Log a message to the log file. [WARN]
---
---@param message string|table Message to log.
---@return nil
Logger.WARN = function(message)
    if type(message) == "table" then
        for _, line in ipairs(message) do
            Logger.WARN(line)
        end
        return
    end

    if nil_check(message) then return end

    message = Logger.sanitize(message)
    message = "[WARN][" .. os.date("%Y-%m-%d %H:%M:%S") .. "] " .. message

    write(message)
end

--- Log a message to the log file. [ERROR]
---
---@param message string|table Message to log.
---@return nil
Logger.ERROR = function(message)
    if type(message) == "table" then
        for _, line in ipairs(message) do
            Logger.ERROR(line)
        end
        return
    end

    if nil_check(message) then return end

    message = Logger.sanitize(message)
    message = "[ERROR][" .. os.date("%Y-%m-%d %H:%M:%S") .. "] " .. message

    write(message)
end

--- Log a message to the log file. [SUCCESS]
---
---@param message string|table Message to log.
---@return nil
Logger.SUCCESS = function(message)
    if type(message) == "table" then
        for _, line in ipairs(message) do
            Logger.SUCCESS(line)
        end
        return
    end

    if nil_check(message) then return end

    message = Logger.sanitize(message)
    message = "[SUCCESS][" .. os.date("%Y-%m-%d %H:%M:%S") .. "] " .. message

    write(message)
end

--- Log a message to the log file. [DEBUG]
---
---@param message string|table Message to log.
---@return nil
Logger.DEBUG = function(message)
    if type(message) == "table" then
        print(vim.inspect(message))
        return
    end

    if nil_check(message) then return end

    print(message)
end

return Logger
