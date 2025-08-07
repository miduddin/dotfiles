require("mini.pairs").setup({})

local mc = require("multicursor-nvim")
mc.setup()

Map("<C-x>", function() mc.matchAddCursor(1) end, { "n", "x" })
Map("<Down>", function() mc.lineAddCursor(1) end, { "n", "x" })
Map("<Up>", function() mc.lineAddCursor(-1) end, { "n", "x" })

mc.addKeymapLayer(function(layerSet)
	layerSet({ "n", "x" }, "<Left>", mc.prevCursor)
	layerSet({ "n", "x" }, "<Right>", mc.nextCursor)
	layerSet({ "n", "x" }, "n", function() mc.matchAddCursor(1) end)
	layerSet({ "n", "x" }, "q", function() mc.matchSkipCursor(0) end)
	layerSet({ "n", "x" }, "N", function() mc.matchAddCursor(-1) end)
	layerSet({ "n", "x" }, "Q", function() mc.matchSkipCursor(-1) end)
	layerSet({ "n", "x" }, "<Leader>a", mc.alignCursors)
	layerSet({ "n", "x" }, "<Leader>x", mc.deleteCursor)
	layerSet("n", "<Esc>", function()
		if not mc.cursorsEnabled() then
			mc.enableCursors()
		else
			mc.clearCursors()
		end
	end)
end)

require("nvim-surround").setup({})
