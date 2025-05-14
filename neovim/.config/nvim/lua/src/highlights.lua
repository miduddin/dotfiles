-- Based on https://github.com/rebelot/kanagawa.nvim

local config = {
	undercurl = true,
	commentStyle = { italic = true },
	functionStyle = {},
	keywordStyle = { italic = true },
	statementStyle = { bold = true },
	typeStyle = {},
}

local colors = {
	bg = "#1F1F28",
	bg_cursorline = "#363646",
	bg_float = "#16161D",
	bg_visual = "#2D4F67",
	comment = "#727169",
	diag_error = "#E82424",
	diag_hint = "#6A9589",
	diag_info = "#658594",
	diag_warn = "#FF9E3B",
	diff_bg_add = "#2B3328",
	diff_bg_change = "#29293B",
	diff_bg_delete = "#43242B",
	diff_bg_text = "#49443C",
	diff_add = "#76946A",
	diff_change = "#DCA561",
	diff_delete = "#C34043",
	fg = "#DCD7BA",
	fg_border = "#54546D",
	func = "#7E9CD8",
	identifier = "#E6C384",
	keyword = "#957FB8",
	number = "#D27E99",
	operator = "#C0A36E",
	parameter = "#b8b4d0",
	ret = "#E46876",
	special = "#938AA9",
	special1 = "#7FB4CA",
	string = "#98BB6C",
	type = "#7AA89F",
}

local M = {
	ui = {
		bg = colors.bg,
		bg_cursorline = colors.bg_cursorline,
		bg_float = colors.bg_float,
		bg_gutter = colors.bg,
		bg_visual = colors.bg_visual,
		fg = colors.fg,
		nontext = colors.fg_border,
		special = colors.special,

		pmenu = {
			bg = colors.bg_visual,
			bg_sbar = colors.bg_visual,
			bg_sel = colors.bg_visual,
			bg_thumb = colors.bg_visual,
			fg = colors.fg,
		},
		float = {
			bg = colors.bg_float,
			bg_border = colors.bg_float,
			fg = colors.fg,
			fg_border = colors.fg_border,
		},
	},
	syn = {
		comment = colors.comment,
		constant = colors.fg,
		fun = colors.func,
		identifier = colors.identifier,
		keyword = colors.keyword,
		number = colors.number,
		operator = colors.operator,
		parameter = colors.parameter,
		preproc = colors.ret,
		punct = colors.parameter,
		regex = colors.operator,
		ret = colors.ret,
		special = colors.special1,
		statement = colors.keyword,
		string = colors.string,
		type = colors.type,
	},
	diff = {
		bg_add = colors.diff_bg_add,
		bg_delete = colors.diff_bg_delete,
		bg_change = colors.diff_bg_change,
		bg_text = colors.diff_bg_text,

		add = colors.diff_add,
		delete = colors.diff_delete,
		change = colors.diff_change,
	},
	diag = {
		ok = colors.string,
		error = colors.diag_error,
		warning = colors.diag_warn,
		info = colors.diag_info,
		hint = colors.diag_hint,
	},
	term = {
		colors.bg_float, -- black
		colors.diff_delete, -- red
		colors.diff_add, -- green
		colors.operator, -- yellow
		colors.func, -- blue
		colors.keyword, -- magenta
		colors.diag_hint, -- cyan
		colors.fg, -- white
		colors.comment, -- bright black
		colors.diag_error, -- bright red
		colors.string, -- bright green
		colors.identifier, -- bright yellow
		colors.special1, -- bright blue
		colors.special, -- bright magenta
		colors.type, -- bright cyan
		colors.fg, -- bright white
		colors.diag_warn, -- extended color 1
		colors.ret, -- extended color 2
	},
}

local set = vim.api.nvim_set_hl

-- Built in
set(0, "@attribute", { link = "Constant" })
set(0, "@comment.error", { fg = M.ui.fg, bg = M.diag.error, bold = true })
set(0, "@comment.note", { fg = M.ui.bg, bg = M.diag.hint, bold = true })
set(0, "@comment.warning", { fg = M.ui.bg, bg = M.diag.warning, bold = true })
set(0, "@constructor", { fg = M.syn.special })
set(0, "@constructor.lua", { fg = M.syn.keyword })
set(0, "@diff.delta", { fg = M.diff.change })
set(0, "@diff.minus", { fg = M.diff.delete })
set(0, "@diff.plus", { fg = M.diff.add })
set(0, "@keyword.exception", vim.tbl_extend("force", { fg = M.syn.ret }, config.statementStyle))
set(0, "@keyword.import", { link = "PreProc" })
set(0, "@keyword.luap", { link = "@string.regex" })
set(0, "@keyword.operator", { fg = M.syn.operator, bold = true })
set(0, "@keyword.return", vim.tbl_extend("force", { fg = M.syn.ret }, config.keywordStyle))
set(0, "@lsp.mod.readonly", { link = "Constant" })
set(0, "@lsp.mod.typeHint", { link = "Type" })
set(0, "@lsp.type.builtinConstant", { link = "@constant.builtin" })
set(0, "@lsp.type.comment", { fg = "none" })
set(0, "@lsp.type.macro", { link = "Macro" })
set(0, "@lsp.type.magicFunction", { link = "@function.builtin" })
set(0, "@lsp.type.method", { link = "@function.method" })
set(0, "@lsp.type.namespace", { link = "@module" })
set(0, "@lsp.type.parameter", { link = "@variable.parameter" })
set(0, "@lsp.type.selfParameter", { link = "@variable.builtin" })
set(0, "@lsp.type.variable", { fg = "none" })
set(0, "@lsp.typemod.function.builtin", { link = "@function.builtin" })
set(0, "@lsp.typemod.function.defaultLibrary", { link = "@function.builtin" })
set(0, "@lsp.typemod.function.readonly", { fg = M.syn.fun, bold = true })
set(0, "@lsp.typemod.keyword.documentation", { link = "Special" })
set(0, "@lsp.typemod.method.defaultLibrary", { link = "@function.builtin" })
set(0, "@lsp.typemod.operator.controlFlow", { link = "@keyword.exception" })
set(0, "@lsp.typemod.operator.injected", { link = "Operator" })
set(0, "@lsp.typemod.string.injected", { link = "String" })
set(0, "@lsp.typemod.variable.defaultLibrary", { link = "Special" })
set(0, "@lsp.typemod.variable.global", { link = "Constant" })
set(0, "@lsp.typemod.variable.injected", { link = "@variable" })
set(0, "@lsp.typemod.variable.static", { link = "Constant" })
set(0, "@markup.environment", { link = "Keyword" })
set(0, "@markup.heading", { link = "Function" })
set(0, "@markup.italic", { italic = true })
set(0, "@markup.link.url", { link = "@string.special.url" })
set(0, "@markup.math", { link = "Constant" })
set(0, "@markup.quote", { link = "@variable.parameter" })
set(0, "@markup.raw", { link = "String" })
set(0, "@markup.strikethrough", { strikethrough = true })
set(0, "@markup.strong", { bold = true })
set(0, "@markup.underline", { underline = true })
set(0, "@operator", { link = "Operator" })
set(0, "@punctuation.bracket", { fg = M.syn.punct })
set(0, "@punctuation.delimiter", { fg = M.syn.punct })
set(0, "@punctuation.special", { fg = M.syn.special })
set(0, "@string.escape", { fg = M.syn.regex, bold = true })
set(0, "@string.regexp", { fg = M.syn.regex })
set(0, "@string.special.symbol", { fg = M.syn.identifier })
set(0, "@string.special.url", { fg = M.syn.special })
set(0, "@tag.attribute", { fg = M.syn.identifier })
set(0, "@tag.delimiter", { fg = M.syn.punct })
set(0, "@variable", { fg = M.ui.fg })
set(0, "@variable.builtin", { fg = M.syn.ret, italic = true })
set(0, "@variable.member", { fg = M.syn.identifier })
set(0, "@variable.parameter", { fg = M.syn.parameter })
set(0, "Bold", { bold = true })
set(0, "Boolean", { fg = M.syn.number })
set(0, "Character", { link = "String" })
set(0, "ColorColumn", { bg = M.ui.bg_gutter })
set(0, "Comment", vim.tbl_extend("force", { fg = M.syn.comment }, config.commentStyle))
set(0, "Conceal", { fg = M.ui.special, bold = true })
set(0, "Constant", { fg = M.syn.constant })
set(0, "CurSearch", { fg = M.ui.fg, bg = M.ui.bg_visual, bold = true })
set(0, "Cursor", { fg = M.ui.bg, bg = M.ui.fg })
set(0, "CursorColumn", { link = "CursorLine" })
set(0, "CursorIM", { link = "Cursor" })
set(0, "CursorLine", { bg = M.ui.bg_cursorline })
set(0, "CursorLineNr", { fg = M.diag.warning, bg = M.ui.bg_gutter, bold = true })
set(0, "Delimiter", { fg = M.syn.punct })
set(0, "DiagnosticError", { fg = M.diag.error })
set(0, "DiagnosticFloatingError", { fg = M.diag.error })
set(0, "DiagnosticFloatingHint", { fg = M.diag.hint })
set(0, "DiagnosticFloatingInfo", { fg = M.diag.info })
set(0, "DiagnosticFloatingOk", { fg = M.diag.ok })
set(0, "DiagnosticFloatingWarn", { fg = M.diag.warning })
set(0, "DiagnosticHint", { fg = M.diag.hint })
set(0, "DiagnosticInfo", { fg = M.diag.info })
set(0, "DiagnosticOk", { fg = M.diag.ok })
set(0, "DiagnosticSignError", { fg = M.diag.error, bg = M.ui.bg_gutter })
set(0, "DiagnosticSignHint", { fg = M.diag.hint, bg = M.ui.bg_gutter })
set(0, "DiagnosticSignInfo", { fg = M.diag.info, bg = M.ui.bg_gutter })
set(0, "DiagnosticSignWarn", { fg = M.diag.warning, bg = M.ui.bg_gutter })
set(0, "DiagnosticUnderlineError", { undercurl = config.undercurl, sp = M.diag.error })
set(0, "DiagnosticUnderlineHint", { undercurl = config.undercurl, sp = M.diag.hint })
set(0, "DiagnosticUnderlineInfo", { undercurl = config.undercurl, sp = M.diag.info })
set(0, "DiagnosticUnderlineWarn", { undercurl = config.undercurl, sp = M.diag.warning })
set(0, "DiagnosticVirtualTextError", { link = "DiagnosticError" })
set(0, "DiagnosticVirtualTextHint", { link = "DiagnosticHint" })
set(0, "DiagnosticVirtualTextInfo", { link = "DiagnosticInfo" })
set(0, "DiagnosticVirtualTextWarn", { link = "DiagnosticWarn" })
set(0, "DiagnosticWarn", { fg = M.diag.warning })
set(0, "DiffAdd", { bg = M.diff.bg_add })
set(0, "DiffChange", { bg = M.diff.bg_change })
set(0, "DiffDelete", { fg = "NONE", bg = M.diff.bg_delete })
set(0, "DiffText", { bg = M.diff.bg_text })
set(0, "Directory", { fg = M.syn.fun })
set(0, "EndOfBuffer", { fg = M.ui.bg })
set(0, "Error", { fg = M.diag.error })
set(0, "ErrorMsg", { fg = M.diag.error })
set(0, "Exception", { fg = M.syn.ret })
set(0, "Float", { link = "Number" })
set(0, "FloatBorder", { fg = M.ui.float.fg_border, bg = M.ui.float.bg_border })
set(0, "FloatFooter", { fg = M.ui.nontext, bg = M.ui.float.bg_border })
set(0, "FloatTitle", { fg = M.ui.special, bg = M.ui.float.bg_border, bold = true })
set(0, "FoldColumn", { fg = M.ui.nontext, bg = M.ui.bg_gutter })
set(0, "Folded", { fg = M.ui.special, bg = "NONE" })
set(0, "Function", vim.tbl_extend("force", { fg = M.syn.fun }, config.functionStyle))
set(0, "Identifier", { fg = M.syn.identifier })
set(0, "Ignore", { link = "NonText" })
set(0, "IncSearch", { fg = M.ui.bg, bg = M.diag.warning })
set(0, "Italic", { italic = true })
set(0, "Keyword", vim.tbl_extend("force", { fg = M.syn.keyword }, config.keywordStyle))
set(0, "LineNr", { fg = M.ui.nontext, bg = M.ui.bg_gutter })
set(0, "LspCodeLens", { fg = M.syn.comment })
set(0, "LspReferenceRead", { link = "LspReferenceText" })
set(0, "LspReferenceText", { bg = M.diff.bg_text })
set(0, "LspReferenceWrite", { bg = M.diff.bg_text, underline = true })
set(0, "LspSignatureActiveParameter", { fg = M.diag.warning })
set(0, "MatchParen", { fg = M.diag.warning, bold = true })
set(0, "ModeMsg", { fg = M.diag.warning, bold = true })
set(0, "MoreMsg", { fg = M.diag.info })
set(0, "MsgArea", vim.o.cmdheight == 0 and { link = "StatusLine" } or { fg = M.ui.fg })
set(0, "MsgSeparator", { bg = vim.o.cmdheight == 0 and M.ui.bg or M.ui.bg_float })
set(0, "NonText", { fg = M.ui.nontext })
set(0, "Normal", { fg = M.ui.fg, bg = M.ui.bg })
set(0, "NormalFloat", { fg = M.ui.float.fg, bg = M.ui.float.bg })
set(0, "NormalNC", { link = "Normal" })
set(0, "Number", { fg = M.syn.number })
set(0, "Operator", { fg = M.syn.operator })
set(0, "Pmenu", { fg = M.ui.fg, bg = M.ui.bg_float })
set(0, "PmenuExtra", { fg = M.ui.special, bg = M.ui.pmenu.bg })
set(0, "PmenuExtraSel", { fg = M.ui.special, bg = M.ui.pmenu.bg_sel })
set(0, "PmenuKind", { fg = M.ui.fg, bg = M.ui.pmenu.bg })
set(0, "PmenuKindSel", { fg = M.ui.fg, bg = M.ui.pmenu.bg_sel })
set(0, "PmenuSbar", { bg = M.ui.bg_float })
set(0, "PmenuSel", { fg = "NONE", bg = M.ui.bg_cursorline })
set(0, "PmenuThumb", { bg = M.ui.bg_cursorline })
set(0, "PreProc", { fg = M.syn.preproc })
set(0, "Question", { link = "MoreMsg" })
set(0, "QuickFixLine", { link = "CursorLine" })
set(0, "Search", { fg = M.ui.fg, bg = M.ui.bg_visual })
set(0, "SignColumn", { fg = M.ui.special, bg = M.ui.bg_gutter })
set(0, "Special", { fg = M.syn.special })
set(0, "SpecialKey", { fg = M.ui.special })
set(0, "SpellBad", { undercurl = config.undercurl, underline = not config.undercurl, sp = M.diag.error })
set(0, "SpellCap", { undercurl = config.undercurl, underline = not config.undercurl, sp = M.diag.warning })
set(0, "SpellLocal", { undercurl = config.undercurl, underline = not config.undercurl, sp = M.diag.warning })
set(0, "SpellRare", { undercurl = config.undercurl, underline = not config.undercurl, sp = M.diag.warning })
set(0, "Statement", vim.tbl_extend("force", { fg = M.syn.statement }, config.statementStyle))
set(0, "StatusLine", { fg = M.ui.fg, bg = M.ui.bg_float })
set(0, "StatusLineNC", { fg = M.ui.nontext, bg = M.ui.bg_float })
set(0, "String", { fg = M.syn.string })
set(0, "Substitute", { fg = M.ui.fg, bg = M.diff.delete })
set(0, "TabLine", { bg = M.ui.bg_float, fg = M.ui.special })
set(0, "TabLineFill", { bg = M.ui.bg })
set(0, "TabLineSel", { fg = M.ui.fg, bg = M.ui.bg_gutter })
set(0, "Title", { fg = M.syn.fun, bold = true })
set(0, "Todo", { fg = M.ui.bg, bg = M.diag.info, bold = true })
set(0, "Type", vim.tbl_extend("force", { fg = M.syn.type }, config.typeStyle))
set(0, "Underlined", { fg = M.syn.special, underline = true })
set(0, "VertSplit", { link = "WinSeparator" })
set(0, "Visual", { bg = M.ui.bg_visual })
set(0, "VisualNOS", { link = "Visual" })
set(0, "WarningMsg", { fg = M.diag.warning })
set(0, "Whitespace", { fg = M.ui.bg_cursorline })
set(0, "WildMenu", { link = "Pmenu" })
set(0, "WinBar", { fg = M.ui.fg, bg = "NONE" })
set(0, "WinBarNC", { fg = M.ui.fg, bg = "NONE" })
set(0, "WinSeparator", { fg = M.ui.float.fg_border, bg = "NONE" })
set(0, "debugBreakpoint", { fg = M.syn.special, bg = M.ui.bg_gutter })
set(0, "debugPC", { bg = M.diff.bg_delete })
set(0, "diffAdded", { fg = M.diff.add })
set(0, "diffChanged", { fg = M.diff.change })
set(0, "diffDeleted", { fg = M.diff.delete })
set(0, "diffNewFile", { fg = M.diff.add })
set(0, "diffOldFile", { fg = M.diff.delete })
set(0, "diffRemoved", { fg = M.diff.delete })
set(0, "lCursor", { link = "Cursor" })
set(0, "markdownCode", { fg = M.syn.string })
set(0, "markdownCodeBlock", { fg = M.syn.string })
set(0, "markdownEscape", { fg = "NONE" })
set(0, "qfFileName", { link = "Directory" })
set(0, "qfLineNr", { link = "lineNr" })

-- Plugins
set(0, "CmpItemKindClass", { link = "Type" })
set(0, "CmpItemKindColor", { link = "Special" })
set(0, "CmpItemKindConstant", { link = "Constant" })
set(0, "CmpItemKindConstructor", { link = "@constructor" })
set(0, "CmpItemKindCopilot", { link = "String" })
set(0, "CmpItemKindDefault", { fg = M.ui.fg })
set(0, "CmpItemKindEnum", { link = "Type" })
set(0, "CmpItemKindEnumMember", { link = "Constant" })
set(0, "CmpItemKindEvent", { link = "Type" })
set(0, "CmpItemKindField", { link = "@variable.member" })
set(0, "CmpItemKindFile", { link = "Directory" })
set(0, "CmpItemKindFolder", { link = "Directory" })
set(0, "CmpItemKindFunction", { link = "Function" })
set(0, "CmpItemKindInterface", { link = "Type" })
set(0, "CmpItemKindKeyword", { link = "Keyword" })
set(0, "CmpItemKindMethod", { link = "@function.method" })
set(0, "CmpItemKindModule", { link = "@module" })
set(0, "CmpItemKindOperator", { link = "Operator" })
set(0, "CmpItemKindProperty", { link = "@property" })
set(0, "CmpItemKindReference", { link = "Special" })
set(0, "CmpItemKindSnippet", { link = "Special" })
set(0, "CmpItemKindStruct", { link = "Type" })
set(0, "CmpItemKindText", { fg = M.ui.fg })
set(0, "CmpItemKindTypeParameter", { link = "Type" })
set(0, "CmpItemKindUnit", { link = "Number" })
set(0, "CmpItemKindValue", { link = "String" })
set(0, "CmpItemKindVariable", { fg = M.ui.fg })
set(0, "DiffviewDiffDeleteDim", { fg = M.ui.bg_cursorline })
set(0, "FzfLuaBorder", { link = "FloatBorder" })
set(0, "FzfLuaNormal", { link = "NormalFloat" })
set(0, "FzfLuaPreviewNormal", { link = "Normal" })
set(0, "FzfLuaTitle", { link = "FloatTitle" })
set(0, "LazyProgressTodo", { fg = M.ui.nontext })
set(0, "MultiCursorCursor", { link = "Visual" })
set(0, "NeotestAdapterName", { fg = M.syn.ret })
set(0, "NeotestDir", { fg = M.syn.fun })
set(0, "NeotestExpandMarker", { fg = M.syn.punct, bold = true })
set(0, "NeotestFailed", { fg = M.diag.error })
set(0, "NeotestFile", { fg = M.syn.fun })
set(0, "NeotestFocused", { bold = true, underline = true })
set(0, "NeotestIndent", { fg = M.ui.special, bold = true })
set(0, "NeotestMarked", { fg = M.diag.warning, italic = true })
set(0, "NeotestNamespace", { fg = M.syn.fun })
set(0, "NeotestPassed", { fg = M.diag.ok })
set(0, "NeotestRunning", { fg = M.diff.change })
set(0, "NeotestSkipped", { fg = M.syn.special })
set(0, "NeotestTarget", { fg = M.syn.ret })
set(0, "NeotestTest", { fg = M.ui.float.fg })
set(0, "NeotestUnknown", { fg = M.syn.comment })
set(0, "NeotestWatching", { fg = M.diff.change })
set(0, "NeotestWinSelect", { fg = M.diag.hint })
set(0, "OilDirHidden", { link = "OilDir" })
set(0, "OilFileHidden", { link = "OilFile" })
set(0, "OilLinkHidden", { link = "OilLink" })
set(0, "OilLinkTargetHidden", { link = "OilLinkTarget" })
set(0, "OilOrphanLinkHidden", { link = "OilOrphanLink" })
set(0, "OilOrphanLinkTargetHidden", { link = "OilOrphanLinkTarget" })
set(0, "OilSocketHidden", { link = "OilSocket" })
set(0, "TreesitterContextLineNumber", { fg = M.ui.nontext, bg = M.ui.bg_float })
set(0, "healthError", { fg = M.diag.error })
set(0, "healthSuccess", { fg = M.diag.ok })
set(0, "healthWarning", { fg = M.diag.warning })

for i, tcolor in ipairs(M.term) do
	vim.g["terminal_color_" .. i - 1] = tcolor
end

return M
