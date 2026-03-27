-- autocmds (grouped so :source and reload stay predictable)

local alpha_on_empty = vim.api.nvim_create_augroup("alpha_on_empty", { clear = true })
local relativenumber_focus = vim.api.nvim_create_augroup("relativenumber_focus", { clear = true })
local user_autocmds = vim.api.nvim_create_augroup("user_autocmds", { clear = true })

-- close nvim-tree if it's last buffer open
vim.api.nvim_create_autocmd("BufEnter", {
	group = user_autocmds,
	pattern = "*",
	callback = function()
		if #vim.api.nvim_list_bufs() == 1 and vim.bo.filetype == "NvimTree" then
			vim.cmd.quit()
		end
	end,
})

-- linting when file is written to (nvim-lint loads in deferred batch)
vim.api.nvim_create_autocmd("BufWritePost", {
	group = user_autocmds,
	callback = function()
		local ok, lint = pcall(require, "lint")
		if ok then
			lint.try_lint()
		end
	end,
})

-- spellcheck in md
vim.api.nvim_create_autocmd("FileType", {
	group = user_autocmds,
	pattern = "markdown",
	command = "setlocal spell wrap",
})

-- disable automatic comment on newline
vim.api.nvim_create_autocmd("FileType", {
	group = user_autocmds,
	pattern = "*",
	callback = function()
		vim.opt_local.formatoptions:remove({ "c", "r", "o" })
	end,
})

-- highlight text on yank
vim.api.nvim_create_autocmd("TextYankPost", {
	group = user_autocmds,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ timeout = 300 })
	end,
})

-- restore cursor pos on file open
vim.api.nvim_create_autocmd("BufReadPost", {
	group = user_autocmds,
	pattern = "*",
	callback = function()
		local line = vim.fn.line("'\"")
		if line > 1 and line <= vim.fn.line("$") then
			vim.cmd('normal! g\'"')
		end
	end,
})

vim.api.nvim_create_autocmd("VimEnter", {
	group = user_autocmds,
	callback = function()
		local startuptime = vim.fn.reltimefloat(vim.fn.reltime(vim.g.start_time))
		vim.g.startup_time_ms = string.format("%.2f ms", startuptime * 1000)
	end,
})

vim.api.nvim_create_autocmd("User", {
	pattern = "BDeletePre *",
	group = alpha_on_empty,
	callback = function()
		local bufnr = vim.api.nvim_get_current_buf()
		local name = vim.api.nvim_buf_get_name(bufnr)
		if name == "" then
			vim.cmd([[Alpha | bd#]])
		end
	end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "FocusGained", "InsertLeave", "CmdlineLeave", "WinEnter" }, {
	pattern = "*",
	group = relativenumber_focus,
	callback = function()
		if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
			vim.opt.relativenumber = true
		end
	end,
})

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost", "InsertEnter", "CmdlineEnter", "WinLeave" }, {
	pattern = "*",
	group = relativenumber_focus,
	callback = function()
		if vim.o.nu then
			vim.opt.relativenumber = false
			-- https://github.com/rockyzhang24/dotfiles/commit/03dd14b5d43f812661b88c4660c03d714132abcf
			-- https://github.com/neovim/neovim/issues/32068
			if not vim.tbl_contains({ "@", "-" }, vim.v.event.cmdtype) then
				vim.cmd.redraw()
			end
		end
	end,
})
