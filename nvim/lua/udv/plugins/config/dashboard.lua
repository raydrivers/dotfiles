local dashboard = require("dashboard")
local lazy = require("lazy")

-- Visuals
local function make_header(header)
    local header = string.rep("\n", 8) .. header 
    header = header .. "\n" .. "Let it be, let it be..."
    header = header .. "\n\n"
    header = vim.split(header, "\n")

    return header
end

local yellowsub_header = make_header([[
    ┓┓        ┓ 
┓┏┏┓┃┃┏┓┓┏┏┏┓┏┣┓
┗┫┗ ┗┗┗┛┗┻┛┛┗┻┗┛
 ┛              
]])

local yellowsub_logo_header = make_header([[
           ,--.                           
        __:    )                          
      ,'  | ,-<                           
      `.  |(   )                          
     ,--: | | |                           
     `. | | | |                           
     _;.'.'.'.'.                          
   ,'--'-'-'-'-'--.                       
  |  ,'\_||_/`.  .-\                      
  | :-/ ,--. \-: |  `._____               
,_; |:_:,--.:_:| `.______| `---------,--. 
|                 _________________,'    :
|_______________,',-. ,-. ,-. ,-.      _,'
|  __  __  __  __ `-' `-' `-' `-'    ,'   
| (__)(__)(__)(__)                  ;     
|                        .---.     /      
|      ______________    |   |   ,'       
|      )             )   ;   ; ,'         
|_____/____________ /__ /___;-'           
]])

local custom_footer = function()
    local stats = lazy.stats()
    local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)

    return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
end

-- Actions
local function pick_recent_file()

end

local config = {
    theme = "doom",
    disable_move = false,
    shortcut_type = "letter",
    shuffle_letter = false,
    change_to_vcs_root = true,
    config = {
        header = yellowsub_logo_header,
        center = {
            { action = "ene | startinsert",                              desc = " New File",        icon = " ", key = "n" },
            -- { action = 'lua LazyVim.pick.config_files()()',              desc = " Config",          icon = " ", key = "c" },
            { action = "Lazy",                                           desc = " Lazy",            icon = "󰒲 ", key = "l" },
            { action = function() vim.api.nvim_input("<cmd>qa<cr>") end, desc = " Quit",            icon = " ", key = "q" },
        },
        footer = custom_footer,
    },
    hide = {
        statusline = false,
    },
    -- preview = {
    --     command = true,
    --     file_path = true,
    --     file_height = true,
    --     file_width = true,
    -- }
}

for _, button in ipairs(config.config.center) do
    button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
    button.key_format = "  %s"
end


dashboard.setup(config)