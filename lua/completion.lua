local state		= require'completion.state'
local complete	= require'completion.complete'
local hover		= require'completion.hover'
local signature	= require'completion.signature'
local util		= require'completion.util'

local completion = {}

function completion.insertEnter()
	local timer = vim.loop.new_timer()
	state.reset()

	timer:start(100, 80, vim.schedule_wrap(function()
		local changedTick = vim.api.nvim_buf_get_changedtick(0)

		-- complete if changes are made
		if changedTick ~= state.changedTick then
			state.changedTick = changedTick

			if state.triggerCompletion then
				complete.autoComplete()
			end

			hover.autoHover()
			signature.autoSignature()
		end

		-- closing timer if leaving insert mode
		if state.insertLeave == true then
			timer:stop()
			timer:close()
		end
	end))
end

function completion.insertLeave()
	state.insertLeave = true
end

function completion.triggerCompletion()
	state.triggerCompletion = true
	complete.autoComplete()
end

function completion.completeDone()
	state.triggerCompletion = false
	state.matches = {}
end

function completion.setup()
	state.getTriggerCharacters()

	vim.api.nvim_command("augroup CompletionCommand")
	vim.api.nvim_command("autocmd! * <buffer>")
	vim.api.nvim_command("autocmd InsertEnter <buffer> lua require'completion'.insertEnter()")
	vim.api.nvim_command("autocmd InsertLeave <buffer> lua require'completion'.insertLeave()")
	vim.api.nvim_command("autocmd CompleteDone <buffer> lua require'completion'.completeDone()")
	vim.api.nvim_command("augroup end")
end

return completion
