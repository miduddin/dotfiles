-- Based on https://github.com/rebelot/kanagawa.nvim
-- Simplified for faster load time.

local config = {
	undercurl = true,
	commentStyle = { italic = true },
	functionStyle = {},
	keywordStyle = { italic = true },
	statementStyle = { bold = true },
	typeStyle = {},
}

local palette = {
	-- Bg Shades
	sumiInk0 = "#16161D",
	sumiInk1 = "#181820",
	sumiInk2 = "#1a1a22",
	sumiInk3 = "#1F1F28",
	sumiInk4 = "#2A2A37",
	sumiInk5 = "#363646",
	sumiInk6 = "#54546D", --fg
	sumiInk7 = "#454559",

	-- Popup and Floats
	waveBlue1 = "#223249",
	waveBlue2 = "#2D4F67",

	-- Diff and Git
	winterGreen = "#2B3328",
	winterYellow = "#49443C",
	winterRed = "#43242B",
	winterBlue = "#252535",
	autumnGreen = "#76946A",
	autumnRed = "#C34043",
	autumnYellow = "#DCA561",

	-- Diag
	samuraiRed = "#E82424",
	roninYellow = "#FF9E3B",
	waveAqua1 = "#6A9589",
	dragonBlue = "#658594",

	-- Fg and Comments
	oldWhite = "#C8C093",
	fujiWhite = "#DCD7BA",
	fujiGray = "#727169",

	oniViolet = "#957FB8",
	oniViolet2 = "#b8b4d0",
	crystalBlue = "#7E9CD8",
	springViolet1 = "#938AA9",
	springViolet2 = "#9CABCA",
	springBlue = "#7FB4CA",
	lightBlue = "#A3D4D5", -- unused yet
	waveAqua2 = "#7AA89F", -- improve lightness: desaturated greenish Aqua

	springGreen = "#98BB6C",
	boatYellow1 = "#938056",
	boatYellow2 = "#C0A36E",
	carpYellow = "#E6C384",

	sakuraPink = "#D27E99",
	waveRed = "#E46876",
	peachRed = "#FF5D62",
	surimiOrange = "#FFA066",
	katanaGray = "#717C7C",
}

local theme = {
	ui = {
		fg = palette.fujiWhite,
		fg_dim = palette.oldWhite,
		fg_reverse = palette.waveBlue1,

		bg_dim = palette.sumiInk1,
		bg_gutter = palette.sumiInk4,

		bg_m3 = palette.sumiInk0,
		bg_m2 = palette.sumiInk1,
		bg_m1 = palette.sumiInk2,
		bg = palette.sumiInk3,
		bg_p1 = palette.sumiInk4,
		bg_p2 = palette.sumiInk5,

		special = palette.springViolet1,
		nontext = palette.sumiInk6,
		whitespace = palette.sumiInk7,

		bg_search = palette.waveBlue2,
		bg_visual = palette.waveBlue1,

		pmenu = {
			fg = palette.fujiWhite,
			fg_sel = "none", -- This is important to make highlights pass-through
			bg = palette.waveBlue1,
			bg_sel = palette.waveBlue2,
			bg_sbar = palette.waveBlue1,
			bg_thumb = palette.waveBlue2,
		},
		float = {
			fg = palette.oldWhite,
			bg = palette.sumiInk0,
			fg_border = palette.sumiInk6,
			bg_border = palette.sumiInk0,
		},
	},
	syn = {
		string = palette.springGreen,
		variable = "none",
		number = palette.sakuraPink,
		constant = palette.surimiOrange,
		identifier = palette.carpYellow,
		parameter = palette.oniViolet2,
		fun = palette.crystalBlue,
		statement = palette.oniViolet,
		keyword = palette.oniViolet,
		operator = palette.boatYellow2,
		preproc = palette.waveRed,
		type = palette.waveAqua2,
		regex = palette.boatYellow2,
		deprecated = palette.katanaGray,
		comment = palette.fujiGray,
		punct = palette.springViolet2,
		special1 = palette.springBlue,
		special2 = palette.waveRed,
		special3 = palette.peachRed,
	},
	vcs = {
		added = palette.autumnGreen,
		removed = palette.autumnRed,
		changed = palette.autumnYellow,
	},
	diff = {
		add = palette.winterGreen,
		delete = palette.winterRed,
		change = palette.winterBlue,
		text = palette.winterYellow,
	},
	diag = {
		ok = palette.springGreen,
		error = palette.samuraiRed,
		warning = palette.roninYellow,
		info = palette.dragonBlue,
		hint = palette.waveAqua1,
	},
	term = {
		palette.sumiInk0, -- black
		palette.autumnRed, -- red
		palette.autumnGreen, -- green
		palette.boatYellow2, -- yellow
		palette.crystalBlue, -- blue
		palette.oniViolet, -- magenta
		palette.waveAqua1, -- cyan
		palette.oldWhite, -- white
		palette.fujiGray, -- bright black
		palette.samuraiRed, -- bright red
		palette.springGreen, -- bright green
		palette.carpYellow, -- bright yellow
		palette.springBlue, -- bright blue
		palette.springViolet1, -- bright magenta
		palette.waveAqua2, -- bright cyan
		palette.fujiWhite, -- bright white
		palette.surimiOrange, -- extended color 1
		palette.peachRed, -- extended color 2
	},
}

local set = vim.api.nvim_set_hl

-- Built in
set(0, "@attribute", { link = "Constant" })
set(0, "@comment.error", { fg = theme.ui.fg, bg = theme.diag.error, bold = true })
set(0, "@comment.note", { fg = theme.ui.fg_reverse, bg = theme.diag.hint, bold = true })
set(0, "@comment.warning", { fg = theme.ui.fg_reverse, bg = theme.diag.warning, bold = true })
set(0, "@constructor", { fg = theme.syn.special1 })
set(0, "@constructor.lua", { fg = theme.syn.keyword })
set(0, "@diff.delta", { fg = theme.vcs.changed })
set(0, "@diff.minus", { fg = theme.vcs.removed })
set(0, "@diff.plus", { fg = theme.vcs.added })
set(0, "@keyword.exception", vim.tbl_extend("force", { fg = theme.syn.special3 }, config.statementStyle))
set(0, "@keyword.import", { link = "PreProc" })
set(0, "@keyword.luap", { link = "@string.regex" })
set(0, "@keyword.operator", { fg = theme.syn.operator, bold = true })
set(0, "@keyword.return", vim.tbl_extend("force", { fg = theme.syn.special3 }, config.keywordStyle))
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
set(0, "@lsp.typemod.function.readonly", { fg = theme.syn.fun, bold = true })
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
set(0, "@punctuation.bracket", { fg = theme.syn.punct })
set(0, "@punctuation.delimiter", { fg = theme.syn.punct })
set(0, "@punctuation.special", { fg = theme.syn.special1 })
set(0, "@string.escape", { fg = theme.syn.regex, bold = true })
set(0, "@string.regexp", { fg = theme.syn.regex })
set(0, "@string.special.symbol", { fg = theme.syn.identifier })
set(0, "@string.special.url", { fg = theme.syn.special1, undercurl = true })
set(0, "@tag.attribute", { fg = theme.syn.identifier })
set(0, "@tag.delimiter", { fg = theme.syn.punct })
set(0, "@variable", { fg = theme.ui.fg })
set(0, "@variable.builtin", { fg = theme.syn.special2, italic = true })
set(0, "@variable.member", { fg = theme.syn.identifier })
set(0, "@variable.parameter", { fg = theme.syn.parameter })
set(0, "Bold", { bold = true })
set(0, "Boolean", { fg = theme.syn.constant, bold = true })
set(0, "Character", { link = "String" })
set(0, "ColorColumn", { bg = theme.ui.bg_p1 })
set(0, "Comment", vim.tbl_extend("force", { fg = theme.syn.comment }, config.commentStyle))
set(0, "Conceal", { fg = theme.ui.special, bold = true })
set(0, "Constant", { fg = theme.syn.constant })
set(0, "CurSearch", { fg = theme.ui.fg, bg = theme.ui.bg_search, bold = true })
set(0, "Cursor", { fg = theme.ui.bg, bg = theme.ui.fg })
set(0, "CursorColumn", { link = "CursorLine" })
set(0, "CursorIM", { link = "Cursor" })
set(0, "CursorLine", { bg = theme.ui.bg_p2 })
set(0, "CursorLineNr", { fg = theme.diag.warning, bg = theme.ui.bg_gutter, bold = true })
set(0, "Delimiter", { fg = theme.syn.punct })
set(0, "DiagnosticError", { fg = theme.diag.error })
set(0, "DiagnosticFloatingError", { fg = theme.diag.error })
set(0, "DiagnosticFloatingHint", { fg = theme.diag.hint })
set(0, "DiagnosticFloatingInfo", { fg = theme.diag.info })
set(0, "DiagnosticFloatingOk", { fg = theme.diag.ok })
set(0, "DiagnosticFloatingWarn", { fg = theme.diag.warning })
set(0, "DiagnosticHint", { fg = theme.diag.hint })
set(0, "DiagnosticInfo", { fg = theme.diag.info })
set(0, "DiagnosticOk", { fg = theme.diag.ok })
set(0, "DiagnosticSignError", { fg = theme.diag.error, bg = theme.ui.bg_gutter })
set(0, "DiagnosticSignHint", { fg = theme.diag.hint, bg = theme.ui.bg_gutter })
set(0, "DiagnosticSignInfo", { fg = theme.diag.info, bg = theme.ui.bg_gutter })
set(0, "DiagnosticSignWarn", { fg = theme.diag.warning, bg = theme.ui.bg_gutter })
set(0, "DiagnosticUnderlineError", { undercurl = config.undercurl, sp = theme.diag.error })
set(0, "DiagnosticUnderlineHint", { undercurl = config.undercurl, sp = theme.diag.hint })
set(0, "DiagnosticUnderlineInfo", { undercurl = config.undercurl, sp = theme.diag.info })
set(0, "DiagnosticUnderlineWarn", { undercurl = config.undercurl, sp = theme.diag.warning })
set(0, "DiagnosticVirtualTextError", { link = "DiagnosticError" })
set(0, "DiagnosticVirtualTextHint", { link = "DiagnosticHint" })
set(0, "DiagnosticVirtualTextInfo", { link = "DiagnosticInfo" })
set(0, "DiagnosticVirtualTextWarn", { link = "DiagnosticWarn" })
set(0, "DiagnosticWarn", { fg = theme.diag.warning })
set(0, "DiffAdd", { bg = theme.diff.add })
set(0, "DiffChange", { bg = theme.diff.change })
set(0, "DiffDelete", { fg = "NONE", bg = theme.diff.delete })
set(0, "DiffText", { bg = theme.diff.text })
set(0, "Directory", { fg = theme.syn.fun })
set(0, "EndOfBuffer", { fg = theme.ui.bg })
set(0, "Error", { fg = theme.diag.error })
set(0, "ErrorMsg", { fg = theme.diag.error })
set(0, "Exception", { fg = theme.syn.special2 })
set(0, "Float", { link = "Number" })
set(0, "FloatBorder", { fg = theme.ui.float.fg_border, bg = theme.ui.float.bg_border })
set(0, "FloatFooter", { fg = theme.ui.nontext, bg = theme.ui.float.bg_border })
set(0, "FloatTitle", { fg = theme.ui.special, bg = theme.ui.float.bg_border, bold = true })
set(0, "FoldColumn", { fg = theme.ui.nontext, bg = theme.ui.bg_gutter })
set(0, "Folded", { fg = theme.ui.special, bg = "NONE" })
set(0, "Function", vim.tbl_extend("force", { fg = theme.syn.fun }, config.functionStyle))
set(0, "Identifier", { fg = theme.syn.identifier })
set(0, "Ignore", { link = "NonText" })
set(0, "IncSearch", { fg = theme.ui.fg_reverse, bg = theme.diag.warning })
set(0, "Italic", { italic = true })
set(0, "Keyword", vim.tbl_extend("force", { fg = theme.syn.keyword }, config.keywordStyle))
set(0, "LineNr", { fg = theme.ui.nontext, bg = theme.ui.bg_gutter })
set(0, "LspCodeLens", { fg = theme.syn.comment })
set(0, "LspReferenceRead", { link = "LspReferenceText" })
set(0, "LspReferenceText", { bg = theme.diff.text })
set(0, "LspReferenceWrite", { bg = theme.diff.text, underline = true })
set(0, "LspSignatureActiveParameter", { fg = theme.diag.warning })
set(0, "MatchParen", { fg = theme.diag.warning, bold = true })
set(0, "ModeMsg", { fg = theme.diag.warning, bold = true })
set(0, "MoreMsg", { fg = theme.diag.info })
set(0, "MsgArea", vim.o.cmdheight == 0 and { link = "StatusLine" } or { fg = theme.ui.fg_dim })
set(0, "MsgSeparator", { bg = vim.o.cmdheight == 0 and theme.ui.bg or theme.ui.bg_m3 })
set(0, "NonText", { fg = theme.ui.nontext })
set(0, "Normal", { fg = theme.ui.fg, bg = theme.ui.bg })
set(0, "NormalFloat", { fg = theme.ui.float.fg, bg = theme.ui.float.bg })
set(0, "NormalNC", { link = "Normal" })
set(0, "Number", { fg = theme.syn.number })
set(0, "Operator", { fg = theme.syn.operator })
set(0, "Pmenu", { fg = theme.ui.shade0, bg = theme.ui.bg_p1 })
set(0, "PmenuExtra", { fg = theme.ui.special, bg = theme.ui.pmenu.bg })
set(0, "PmenuExtraSel", { fg = theme.ui.special, bg = theme.ui.pmenu.bg_sel })
set(0, "PmenuKind", { fg = theme.ui.fg_dim, bg = theme.ui.pmenu.bg })
set(0, "PmenuKindSel", { fg = theme.ui.fg_dim, bg = theme.ui.pmenu.bg_sel })
set(0, "PmenuSbar", { bg = theme.ui.bg_m1 })
set(0, "PmenuSel", { fg = "NONE", bg = theme.ui.bg_p2 })
set(0, "PmenuThumb", { bg = theme.ui.bg_p2 })
set(0, "PreProc", { fg = theme.syn.preproc })
set(0, "Question", { link = "MoreMsg" })
set(0, "QuickFixLine", { bg = theme.ui.bg_p1 })
set(0, "Search", { fg = theme.ui.fg, bg = theme.ui.bg_search })
set(0, "SignColumn", { fg = theme.ui.special, bg = theme.ui.bg_gutter })
set(0, "Special", { fg = theme.syn.special1 })
set(0, "SpecialKey", { fg = theme.ui.special })
set(0, "SpellBad", { undercurl = config.undercurl, underline = not config.undercurl, sp = theme.diag.error })
set(0, "SpellCap", { undercurl = config.undercurl, underline = not config.undercurl, sp = theme.diag.warning })
set(0, "SpellLocal", { undercurl = config.undercurl, underline = not config.undercurl, sp = theme.diag.warning })
set(0, "SpellRare", { undercurl = config.undercurl, underline = not config.undercurl, sp = theme.diag.warning })
set(0, "Statement", vim.tbl_extend("force", { fg = theme.syn.statement }, config.statementStyle))
set(0, "StatusLine", { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 })
set(0, "StatusLineNC", { fg = theme.ui.nontext, bg = theme.ui.bg_m3 })
set(0, "String", { fg = theme.syn.string })
set(0, "Substitute", { fg = theme.ui.fg, bg = theme.vcs.removed })
set(0, "TabLine", { bg = theme.ui.bg_m3, fg = theme.ui.special })
set(0, "TabLineFill", { bg = theme.ui.bg })
set(0, "TabLineSel", { fg = theme.ui.fg_dim, bg = theme.ui.bg_p1 })
set(0, "Title", { fg = theme.syn.fun, bold = true })
set(0, "Todo", { fg = theme.ui.fg_reverse, bg = theme.diag.info, bold = true })
set(0, "Type", vim.tbl_extend("force", { fg = theme.syn.type }, config.typeStyle))
set(0, "Underlined", { fg = theme.syn.special1, underline = true })
set(0, "VertSplit", { link = "WinSeparator" })
set(0, "Visual", { bg = theme.ui.bg_visual })
set(0, "VisualNOS", { link = "Visual" })
set(0, "WarningMsg", { fg = theme.diag.warning })
set(0, "Whitespace", { fg = theme.ui.whitespace })
set(0, "WildMenu", { link = "Pmenu" })
set(0, "WinBar", { fg = theme.ui.fg_dim, bg = "NONE" })
set(0, "WinBarNC", { fg = theme.ui.fg_dim, bg = "NONE" })
set(0, "WinSeparator", { fg = theme.ui.float.fg_border, bg = "NONE" })
set(0, "debugBreakpoint", { fg = theme.syn.special1, bg = theme.ui.bg_gutter })
set(0, "debugPC", { bg = theme.diff.delete })
set(0, "diffAdded", { fg = theme.vcs.added })
set(0, "diffChanged", { fg = theme.vcs.changed })
set(0, "diffDeleted", { fg = theme.vcs.removed })
set(0, "diffNewFile", { fg = theme.vcs.added })
set(0, "diffOldFile", { fg = theme.vcs.removed })
set(0, "diffRemoved", { fg = theme.vcs.removed })
set(0, "lCursor", { link = "Cursor" })
set(0, "markdownCode", { fg = theme.syn.string })
set(0, "markdownCodeBlock", { fg = theme.syn.string })
set(0, "markdownEscape", { fg = "NONE" })
set(0, "qfFileName", { link = "Directory" })
set(0, "qfLineNr", { link = "lineNr" })

-- Plugins
set(0, "CmpCompletion", { link = "Pmenu" })
set(0, "CmpCompletionBorder", { fg = theme.ui.bg_search, bg = theme.ui.pmenu.bg })
set(0, "CmpCompletionSbar", { link = "PmenuSbar" })
set(0, "CmpCompletionSel", { fg = "NONE", bg = theme.ui.pmenu.bg_sel })
set(0, "CmpCompletionThumb", { link = "PmenuThumb" })
set(0, "CmpDocumentation", { link = "NormalFloat" })
set(0, "CmpDocumentationBorder", { link = "FloatBorder" })
set(0, "CmpItemAbbr", { fg = theme.ui.pmenu.fg })
set(0, "CmpItemAbbrDeprecated", { fg = theme.syn.comment, strikethrough = true })
set(0, "CmpItemAbbrMatch", { fg = theme.syn.fun })
set(0, "CmpItemAbbrMatchFuzzy", { link = "CmpItemAbbrMatch" })
set(0, "CmpItemKindClass", { link = "Type" })
set(0, "CmpItemKindColor", { link = "Special" })
set(0, "CmpItemKindConstant", { link = "Constant" })
set(0, "CmpItemKindConstructor", { link = "@constructor" })
set(0, "CmpItemKindCopilot", { link = "String" })
set(0, "CmpItemKindDefault", { fg = theme.ui.fg_dim })
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
set(0, "CmpItemKindText", { fg = theme.ui.fg })
set(0, "CmpItemKindTypeParameter", { link = "Type" })
set(0, "CmpItemKindUnit", { link = "Number" })
set(0, "CmpItemKindValue", { link = "String" })
set(0, "CmpItemKindVariable", { fg = theme.ui.fg_dim })
set(0, "CmpItemMenu", { fg = theme.ui.fg_dim })
set(0, "DapUIBreakpointsCurrentLine", { fg = theme.syn.identifier, bold = true })
set(0, "DapUIBreakpointsDisabledLine", { link = "Comment" })
set(0, "DapUIBreakpointsInfo", { fg = theme.diag.info })
set(0, "DapUIBreakpointsPath", { link = "Directory" })
set(0, "DapUIDecoration", { fg = theme.ui.float.fg_border })
set(0, "DapUIFloatBorder", { fg = theme.ui.float.fg_border })
set(0, "DapUILineNumber", { fg = theme.syn.special1 })
set(0, "DapUIModifiedValue", { fg = theme.syn.special1, bold = true })
set(0, "DapUIPlayPause", { fg = theme.syn.string })
set(0, "DapUIRestart", { fg = theme.syn.string })
set(0, "DapUIScope", { link = "Special" })
set(0, "DapUISource", { fg = theme.syn.special2 })
set(0, "DapUIStepBack", { fg = theme.syn.special1 })
set(0, "DapUIStepInto", { fg = theme.syn.special1 })
set(0, "DapUIStepOut", { fg = theme.syn.special1 })
set(0, "DapUIStepOver", { fg = theme.syn.special1 })
set(0, "DapUIStop", { fg = theme.diag.error })
set(0, "DapUIStoppedThread", { fg = theme.syn.special1 })
set(0, "DapUIThread", { fg = theme.syn.identifier })
set(0, "DapUIType", { link = "Type" })
set(0, "DapUIUnavailable", { fg = theme.syn.comment })
set(0, "DapUIWatchesEmpty", { fg = theme.diag.error })
set(0, "DapUIWatchesError", { fg = theme.diag.error })
set(0, "DapUIWatchesValue", { fg = theme.syn.identifier })
set(0, "DiffviewDiffDeleteDim", { fg = theme.ui.bg_p2 })
set(0, "LazyProgressTodo", { fg = theme.ui.nontext })
set(0, "MiniDiffOverAdd", { link = "DiffAdd" })
set(0, "MiniDiffOverChange", { link = "DiffText" })
set(0, "MiniDiffOverContext", { link = "DiffChange" })
set(0, "MiniDiffOverDelete", { link = "DiffDelete" })
set(0, "MiniDiffSignAdd", { fg = theme.vcs.added, bg = theme.ui.bg_gutter })
set(0, "MiniDiffSignChange", { fg = theme.vcs.changed, bg = theme.ui.bg_gutter })
set(0, "MiniDiffSignDelete", { fg = theme.vcs.removed, bg = theme.ui.bg_gutter })
set(0, "MiniTablineCurrent", { fg = theme.ui.fg_dim, bg = theme.ui.bg_p1, bold = true })
set(0, "MiniTablineFill", { link = "TabLineFill" })
set(0, "MiniTablineHidden", { fg = theme.ui.special, bg = theme.ui.bg_m3 })
set(0, "MiniTablineModifiedCurrent", { fg = theme.ui.bg_p1, bg = theme.ui.fg_dim, bold = true })
set(0, "MiniTablineModifiedHidden", { fg = theme.ui.bg_m3, bg = theme.ui.special })
set(0, "MiniTablineModifiedVisible", { fg = theme.ui.bg_m3, bg = theme.ui.special, bold = true })
set(0, "MiniTablineTabpagesection", { fg = theme.ui.fg, bg = theme.ui.bg_search, bold = true })
set(0, "MiniTablineVisible", { fg = theme.ui.special, bg = theme.ui.bg_m3, bold = true })
set(0, "NeotestAdapterName", { fg = theme.syn.special3 })
set(0, "NeotestDir", { fg = theme.syn.fun })
set(0, "NeotestExpandMarker", { fg = theme.syn.punct, bold = true })
set(0, "NeotestFailed", { fg = theme.diag.error })
set(0, "NeotestFile", { fg = theme.syn.fun })
set(0, "NeotestFocused", { bold = true, underline = true })
set(0, "NeotestIndent", { fg = theme.ui.special, bold = true })
set(0, "NeotestMarked", { fg = theme.diag.warning, italic = true })
set(0, "NeotestNamespace", { fg = theme.syn.fun })
set(0, "NeotestPassed", { fg = theme.diag.ok })
set(0, "NeotestRunning", { fg = theme.vcs.changed })
set(0, "NeotestSkipped", { fg = theme.syn.special1 })
set(0, "NeotestTarget", { fg = theme.syn.special3 })
set(0, "NeotestTest", { fg = theme.ui.float.fg })
set(0, "NeotestUnknown", { fg = theme.syn.deprecated })
set(0, "NeotestWatching", { fg = theme.vcs.changed })
set(0, "NeotestWinSelect", { fg = theme.diag.hint })
set(0, "TreesitterContext", { link = "Folded" })
set(0, "TreesitterContextLineNumber", { fg = theme.ui.special, bg = theme.ui.bg_gutter })
set(0, "healthError", { fg = theme.diag.error })
set(0, "healthSuccess", { fg = theme.diag.ok })
set(0, "healthWarning", { fg = theme.diag.warning })

for i, tcolor in ipairs(theme.term) do
	vim.g["terminal_color_" .. i - 1] = tcolor
end
