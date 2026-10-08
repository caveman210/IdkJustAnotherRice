return {-- Default options:
    "rebelot/kanagawa.nvim",
    name = 'kanagawa',
    lazy = false,
    priority = 1000,
    config = function()
        require('kanagawa').setup({
            compile = false,             -- enable compiling the colorscheme
            undercurl = true,            -- enable undercurls
            commentStyle = { italic = true },
            functionStyle = {},
            keywordStyle = { italic = true },
            statementStyle = { bold = true },
            typeStyle = {},
            transparent = true,
            dimInactive = false,         -- dim inactive window `:h hl-NormalNC`
            terminalColors = true,       -- define vim.g.terminal_color_{0,17}
            colors = {                   -- add/modify theme and palette colors
                palette = {},
                theme = { wave = {}, lotus = {}, dragon = {}, all = {} },
            },
            overrides = function(colors) -- add/modify highlights
                local theme = colors.theme
                return {
                    -- Standard editor line numbers
                    LineNr = { fg = theme.ui.fg_dim, bg = "NONE" },
                    CursorLineNr = { fg = theme.ui.special, bold = true, bg = "NONE" },

                    -- Global Neovim Floating Window Transparency (Required for Snacks)
                    NormalFloat = { bg = "NONE" },
                    FloatBorder = { fg = theme.ui.float.fg_border, bg = "NONE" },
                    FloatTitle = { fg = theme.ui.special, bold = true, bg = "NONE" },
                    FloatFooter = { fg = theme.ui.nontext, bg = "NONE" },

                    -- Snacks Specific Floating Windows & Explorer Sidebar
                    SnacksNormal = { bg = "NONE" },
                    SnacksNormalNC = { bg = "NONE" },
                    SnacksWinBar = { bg = "NONE" },
                    SnacksWinBarNC = { bg = "NONE" },
                    SnacksBackdrop = { bg = "NONE" },

                    -- Snacks Picker & Explorer Sections
                    SnacksPicker = { bg = "NONE" },
                    SnacksPickerNormal = { bg = "NONE" },
                    SnacksPickerBorder = { fg = theme.ui.float.fg_border, bg = "NONE" },
                    SnacksPickerTitle = { fg = theme.ui.special, bold = true, bg = "NONE" },
                    SnacksPickerList = { bg = "NONE" },
                    SnacksPickerListBorder = { fg = theme.ui.float.fg_border, bg = "NONE" },
                    SnacksPickerPreview = { bg = "NONE" },
                    SnacksPickerPreviewBorder = { fg = theme.ui.float.fg_border, bg = "NONE" },
                    SnacksPickerInput = { bg = "NONE" },
                    SnacksPickerInputBorder = { fg = theme.ui.float.fg_border, bg = "NONE" },
                    SnacksPickerBox = { bg = "NONE" },
                    SnacksPickerTree = { bg = "NONE" },
            }
            end,
            theme = "dragon",              -- Load "wave" theme
            background = {               -- map the value of 'background' option to a theme
                dark = "dragon",           -- try "dragon" !
                light = "lotus"
            },
        })
    vim.cmd("colorscheme kanagawa")
    end,
}
