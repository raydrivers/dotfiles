local cmd = { "echo", "'Hello, World!'", "<CR>", }

local ShellExecutor = {
    shell_buffer = nil,
}

-- TODO: look at toogleterm:spawn
function ShellExecutor:start_shell()
    self.shell_buffer = vim.api.nvim_create_buf(true, true)
    vim.bo[self.shell_buffer].buftype = "terminal"
    -- TODO: setup

    vim.fn.jobstart(vim.o.shell, {
        -- env = "clear-env",
        on_exit = function()
            -- Delete buffer
        end,
    })
end

function ShellExecutor:run(cmd)
    local channel_id = vim.b[self.shell_buffer].terminal_job_id

    print(channel_id)
    vim.api.nvim_chan_send(channel_id, table.concat(cmd, ' '))
end

ShellExecutor:start_shell()
ShellExecutor:run(cmd)
