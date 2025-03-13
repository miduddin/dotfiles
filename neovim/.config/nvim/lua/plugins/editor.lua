return {
	{
		"echasnovski/mini.pairs",
		event = "InsertEnter",
		opts = {},
	},
	{
		"jake-stewart/multicursor.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local mc = require("multicursor-nvim")
			mc.setup()

			local map = vim.keymap.set

			-- Add or skip cursor above/below the main cursor.
			map({ "n", "x" }, "<Up>", function() mc.lineAddCursor(-1) end)
			map({ "n", "x" }, "<Down>", function() mc.lineAddCursor(1) end)
			map({ "n", "x" }, "<Leader><Up>", function() mc.lineSkipCursor(-1) end)
			map({ "n", "x" }, "<Leader><Down>", function() mc.lineSkipCursor(1) end)

			-- Add or skip adding a new cursor by matching word/selection
			map({ "n", "x" }, "<C-x>", function() mc.matchAddCursor(1) end)

			-- Mappings defined in a keymap layer only apply when there are
			-- multiple cursors. This lets you have overlapping mappings.
			mc.addKeymapLayer(function(layerSet)
				-- Select a different cursor as the main one.
				layerSet({ "n", "x" }, "<Left>", mc.prevCursor)
				layerSet({ "n", "x" }, "<Right>", mc.nextCursor)
				layerSet({ "n", "x" }, "n", function() mc.matchAddCursor(1) end)
				layerSet({ "n", "x" }, "s", function() mc.matchSkipCursor(0) end)
				layerSet({ "n", "x" }, "N", function() mc.matchAddCursor(-1) end)
				layerSet({ "n", "x" }, "S", function() mc.matchSkipCursor(-1) end)
				layerSet({ "n", "x" }, "<Leader>a", mc.alignCursors)

				-- Delete the main cursor.
				layerSet({ "n", "x" }, "<Leader>x", mc.deleteCursor)

				-- Enable and clear cursors using escape.
				layerSet("n", "<Esc>", function()
					if not mc.cursorsEnabled() then
						mc.enableCursors()
					else
						mc.clearCursors()
					end
				end)
			end)
		end,
	},
	{
		"kylechui/nvim-surround",
		event = { "BufReadPost", "BufNewFile" },
		opts = {},
	},
}
