local M = {}

M.plugin_root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h")

M.PROJECT_CONFIG_DIR = ".nvim"

function M.find_project_root()
    local root = vim.fn.finddir(M.PROJECT_CONFIG_DIR, ".;")
    if root ~= "" then
        return vim.fn.fnamemodify(root, ":p:h")
    end
    return nil
end

return M