local M = {}

--- Strip ansii color codes from a table of lines.
---
---@param raw_lines table Raw lines.
---@return table Stripped lines.
M.strip_color_codes = function(raw_lines)
    local lines = {}

    for _, line in ipairs(raw_lines) do
        local stripped_line = line:gsub("\x1b[[0-9][:;0-9]*m", "")
        stripped_line = stripped_line:gsub("%[s", "")
        stripped_line = stripped_line:gsub("%[%?25l%[u%[2K", "")
        stripped_line = stripped_line:gsub("%[%?25h%[u%[2K", "")
        stripped_line = stripped_line:gsub("\27%[%?25l", ""):gsub("\27%[%?25h", "")
        stripped_line = stripped_line:gsub("\27%[u", ""):gsub("\27%[2K", "")

        table.insert(lines, stripped_line)
    end

    return lines
end

return M
