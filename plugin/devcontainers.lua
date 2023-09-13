local completions_list = { "ReopenContainer", "RebuildContainer" }

local get_function = function(name)
    if name == "ReopenContainer" then
        return "Reopen"
    end

    if name == "RebuildContainer" then
        return "Rebuild"
    end
end

vim.api.nvim_create_user_command("DevContainers", function(opts)
    local params = vim.split(opts.args, "%s+", { trimempty = true })

    local action = params[1]
    local ok, call = pcall(require, "devcontainers")
    if not ok then
        error("Error loading command")
        return
    end

    call[get_function(action)]()
end, {
    nargs = "?",
    complete = function()
        return completions_list
    end,
})
