local lush = require("lush")
local p = require("udv.aesthetic_dark.palette")

local theme = lush(function(injected_functions)
    local sym = injected_functions.sym

    ---@diagnostic disable: undefined-global
    local theme = {
    -- local base_styles = {
        Normal      { fg = p.light_gray, bg = p.charcoal, },
        NormalFloat { fg = p.light_gray, bg = p.charcoal, },
        FloatBorder { fg = p.teal.darken(32), },
        Comment     { fg = p.light_gray.darken(48), },
        Cursor      { fg = p.charcoal, bg = p.steel_blue,  },
        CurSearch   { fg = p.charcoal, bg = p.tan,},
        -- TabLine     { bg = p.charcoal.darken(48), },
        -- TabLineSel  { bg = p.lavender, fg = p.charcoal },
        StatusLine  { bg = p.charcoal, fg = p.light_gray }, -- Will be set by lualine
    -- }
    -- local base_syntax_styles = {
        Character      { fg = p.tan, },
        Constant       { Character, bold = true, },
        String         { fg = p.muted_green, },
        Number         { Character, },
        Boolean        { Character, },
        Float          { Character, },
        Identifier     { fg = p.light_gray, },
        Function       { fg = p.steel_blue, },
        Statement      { fg = p.lavender, },
        -- Conditional {},
        -- Repeat      {},
        Label          { Character, italic = true, },
        Operator       { fg = p.teal, },
        Keyword        { fg = p.lavender, },
        Exception      { fg = p.dark_red, },
        -- Macros
        PreProc        { fg = p.tan, },
        Include        { fg = p.lavender, },
        -- Define      {},
        -- Macro       {},
        -- PreCondit   {},
        -- Types
        Type           { fg = p.lavender, },
        StorageClass   { Type, },
        Structure      { Type, },
        Typedef        { Type, italic = true, },
        -- Special
        Special        { fg = p.light_gray, },
        SpecialChar    { Character, },
        Tag            { Character, },
        Delimiter      { fg = p.light_gray, },
        SpecialComment { fg = Character.fg.darken(48), },
        Debug          { fg = p.teal, gui = "underline", },
        Underlined     { fg = p.tan, gui = "underline" },
        -- Ignore {},
        Error          { fg = p.dark_red, underlined = true, },
        Todo           { fg = p.tan.rotate(120), standout = true, italic = true, },
    -- }
    -- local lsp_styles = {
        DiagnosticError          { fg = p.dark_red.saturate(16) },
        DiagnosticWarn           { fg = p.tan.saturate(24), },
        DiagnosticInfo           { fg = p.steel_blue, },
        DiagnosticHint           { fg = p.teal.saturate(48), },
        DiagnosticUnderlineError { sp = p.dark_red.saturate(64), undercurl=true, },
        DiagnosticUnderlineWarn  { sp = p.tan.saturate(64), undercurl = true, },
        DiagnosticUnderlineInfo  { sp = p.steel_blue.saturate(64).darken(24), undercurl = true, },
        DiagnosticUnderlineHint  { sp = p.teal.saturate(48), underdashed = true, },
        DiagnosticDeprecated     { sp = p.tan.darken(48), strikethrough = true, },
        -- Extended
        sym("@lsp.typemod.class.deduced.cpp") { fg = p.lavender, },
    -- }
    -- local tree_sitter_styles = {
        sym("@variable")                      { Identifier, },
        sym("@variable.builtin")              { Identifier, fg = p.steel_blue, },
        sym("@variable.parameter")            { Identifier, },
        sym("@variable.parameter.builtin")    { Identifier, },
        sym("@variable.member")               { Identifier, fg = p.light_gray.saturate(120), },
        sym("@constant")                      { Constant, },
        -- sym("@constant.builtin") {},
        -- sym("@constant.macro") {},
        sym("@module")                        { fg = p.light_gray.saturate(120), },
        sym("@module.builtin")                { fg = p.light_gray.saturate(120), },
        sym("@keyword.conditional.ternary")   { Operator, },
        sym("@type")                          { fg = p.light_gray.saturate(120), },
        sym("@type.definition")               { fg = p.light_gray, },
        sym("@type.builtin")                  { fg = p.lavender, },
        sym("@function.macro")                { fg = p.tan.saturate(48), },
        sym("@function.builtin")              { fg = p.steel_blue, },
        sym("@diff.plus")                     { fg = p.vcs.added, },
        sym("@diff.minus")                    { fg = p.vcs.removed, },
        sym("@diff.delta")                    { fg = p.vcs.modified, },
    -- }
    -- local which_key_styles = {
        WhichKey          { bg = p.charcoal, },
        WhichKeyBorder    { fg = p.teal, },
        WhichKeyTitle     { fg = p.dark_red, },
        -- WhichKeySeparator { fg = p.teal, },
        WhichKeyDesc      { fg = p.light_gray, },
        WhichKeyGroup     { fg = p.tan, },
        WhichKeyNormal    { fg = p.dark_red, },
    -- }
    -- local cmp_styles = {
        CmpItemAbbrDeprecated   { DiagnosticDeprecated, },
        CmpItemAbbrMatch        { fg = p.steel_blue, },
        CmpItemAbbrMatchFuzzy   { CmpItemAbbrMatch, },
        CmpItemKindVariable     { fg = Identifier.fg, },
        CmpItemKindInterface    { fg = Type.fg },
        CmpItemKindClass        { fg = Type.fg },
        CmpItemKindStruct       { fg = Type.fg },
        CmpItemKindEnum         { fg = Constant.fg, },
        CmpItemKindEnumMember   { CmpItemKindEnum, bold = true, },
        CmpItemKindModule       { fg = sym("@module").fg },
        CmpItemKindText         { CmpItemKindVariable, },
        CmpItemKindFunction     { fg = Function.fg },
        CmpItemKindMethod       { CmpItemKindFunction, },
        CmpItemKindConstructor  { CmpItemKindFunction, },
        CmpItemKindKeyword      { fg = Keyword.fg },
        CmpItemKindProperty     { fg = CmpItemKindKeyword.fg },
        CmpItemKindUnit         { fg = CmpItemKindKeyword.fg },
    -- }
    -- local lualine_styles = { -- TODO: correct colors
        Lualine             { StatusLine, },
        LualineInactive     { bg = Lualine.bg.lighten(24), },
        LualineIndicator    { fg = p.lavender, },
        LualineModeNormal   { bg = p.teal.darken(24), },
        LualineModeInsert   { bg = p.dark_red, },
        LualineModeReplace  { bg = p.lavender.darken(24), },
        LualineModeSelect   { bg = p.tan, },
        LualineModeVisual   { bg = p.steel_blue.saturate(24), },
        LualineModeTerminal { bg = p.lavender.darken(24), },
        LualineModeCommand  { bg = p.muted_green.darken(24), },
        LualineModePrompt   { bg = p.teal, },
        LualineModeInsertCompletion { LualineModeInsert, },
        LualineCFilename    { fg = p.lavender, bold = true, },
        LualineCProgress    { fg = p.lavender, },
        LualineCDiagnosticError { DiagnosticError, },
        LualineCDiagnosticWarn  { DiagnosticWarn, },
        LualineCDiagnosticInfo  { DiagnosticInfo, },
        LualineCLsp             { StatusLine, },
        LualineCEncoding        { StatusLine, },
        LualineCFileformat      { StatusLine, },
        LualineCVCSBranch       { fg = p.lavender, },
        LualineCVCSDiffAdded    { fg = p.teal, },
        LualineCVCSDiffRemoved  { fg = p.light_gray.darken(48), },
        LualineCVCSDiffModified { fg = p.tan, },
    -- }
    }
    ---@diagnostic enable: undefined-global

    return theme
end)

return theme
