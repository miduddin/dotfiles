local set = vim.api.nvim_set_hl

-- Built in
set(0, "DiffAdd", { bg = "NvimDarkGreen" })
set(0, "DiffChange", { bg = "NvimDarkGrey4" })
set(0, "DiffDelete", { bg = "NvimDarkRed" })
set(0, "DiffText", { bg = "NvimDarkCyan" })
set(0, "Normal", { bg = "#141415", update = true })
set(0, "TermCursor", {}) -- Prevents 'reverse' cursor color after going back from terminal mode.

-- Plugins
set(0, "diffAdded", { link = "Added" })
set(0, "diffRemoved", { link = "Removed" })
