local set = vim.api.nvim_set_hl

-- Built in
set(0, "DiffAdd", { bg = "NvimDarkGreen" })
set(0, "DiffChange", { bg = "NvimDarkGrey4" })
set(0, "DiffDelete", { bg = "NvimDarkRed" })
set(0, "DiffText", { bg = "NvimDarkCyan" })
set(0, "Whitespace", { fg = "NvimDarkGrey3" })

-- Plugins
set(0, "DiffviewDiffDeleteDim", { link = "NonText" })
set(0, "diffAdded", { link = "Added" })
set(0, "diffRemoved", { link = "Removed" })
