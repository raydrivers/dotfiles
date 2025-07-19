local log = require('plenary.log')
local Path = require('plenary.path')

local data_path = vim.fn.stdpath('data')
local log_path = Path:new(data_path) / 'pcfg' / 'logs'

local logger = log.new({
    plugin = 'pcfg',
    level = 'trace',
    use_file = true,
    use_console = false,
    highlights = false,
    outfile = tostring(log_path / 'pcfg.log')
})

logger.debug("Logger initialized")
logger.info("Log path: " .. tostring(log_path))

return logger
