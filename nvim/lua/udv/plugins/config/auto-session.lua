vim.o.sessionoptions =
    "blank,buffers,curdir,folds,help,"
    .. "tabpages,winsize,winpos,terminal,localoptions"

require('auto-session').setup {
    enabled = true,
    root_dir = vim.fn.stdpath('data') .. "/sessions/",
    auto_save = true,
    auto_restore = true,
    auto_create = true,
    auto_restore_last_session = false,
    suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
    git_use_branch_name = false,
    lazy_support = true,
    bypass_save_filetypes = {},
    close_unsupported_windows = true,
    args_allow_single_directory = true,
    args_allow_files_auto_save = false,
    continue_restore_on_error = true,
    cwd_change_handling = false,
    log_level = 'error',

    session_lens = {
        load_on_setup = true,
        picker_opts = { border = true },
        previewer = false,
        mappings = {
            delete_session = { "i", "<C-D>" },
            alternate_session = { "i", "<C-S>" },
        },
    },

    pre_save_cmds = {
        function()
            vim.api.nvim_exec_autocmds(
                'User', { pattern = 'SessionSavePre' }
            )
        end
    },

    post_save_cmds = {
        function()
            vim.api.nvim_exec_autocmds(
                'User', { pattern = 'SessionSavePost' }
            )
        end
    },
}
