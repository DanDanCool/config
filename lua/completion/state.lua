------------------------------------------------------------------------
--                    plugin variables and states                     --
------------------------------------------------------------------------

-- Global variables table, accessed in scripts as manager.variable_name
state = {
	insertLeave         = false,  -- flag for InsertLeave, prevent every completion if true
	textHover           = false,  -- handle auto hover
	textSignature		= false,  -- handle signatures
	selected            = -1,     -- handle selected items in v:complete-items for auto hover
	changedTick         = 0,      -- handle changeTick
	triggerCompletion	= false,  -- flag for manual confirmation of completion
	matches				= {},
	triggerCharacters	= {}
}

function state.getTriggerCharacters()
	for _, value in pairs(vim.lsp.buf_get_clients(0)) do
		if value.resolved_capabilities.signature_help == false or
			value.server_capabilities.signatureHelpProvider == nil then
			return
		end

		state.triggerCharacters = value.server_capabilities.signatureHelpProvider.triggerCharacters
	end
end

function state.reset()
	state.insertLeave		= false
	state.textHover			= false
	state.textSignature		= false
	state.selected			= -1
	state.triggerCompletion	= false
	state.forceCompletion	= false
	state.matches			= {}
end

return state
