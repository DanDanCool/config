local highlight = require'treesitter.highlight'

-- Registers all query predicates
require"treesitter.query_predicates"

local treesitter = {}

function treesitter.setup()
	highlight.setup()
end

return treesitter
