local state = require'completion.state'

local util = {}

function util.checkTriggerCharacter(line_to_cursor)
	for _, ch in ipairs(state.triggerCharacters) do
		local current_char = string.sub(line_to_cursor, #line_to_cursor - #ch + 1, #line_to_cursor)
		if current_char == ch then return true end
	end

	return false
end

return util
