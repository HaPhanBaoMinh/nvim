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

-- spellcheck in md
vim.api.nvim_create_autocmd("FileType", {
	group = user_autocmds,
	pattern = "markdown",
	command = "setlocal spell wrap",
})

-- language-local editing defaults for primary stacks
vim.api.nvim_create_autocmd("FileType", {
	group = user_autocmds,
	pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
	callback = function()
		vim.opt_local.shiftwidth = 2
		vim.opt_local.tabstop = 2
		vim.opt_local.softtabstop = 2
		vim.opt_local.expandtab = true
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = user_autocmds,
	pattern = { "go", "gomod", "gowork", "gosum" },
	callback = function()
		vim.opt_local.shiftwidth = 4
		vim.opt_local.tabstop = 4
		vim.opt_local.softtabstop = 4
		vim.opt_local.expandtab = false
	end,
})

-- folding strategy for primary code stacks:
-- prefer Treesitter when parser exists, else fallback to indent folds.
vim.api.nvim_create_autocmd("FileType", {
	group = user_autocmds,
	pattern = { "go", "javascript", "javascriptreact", "typescript", "typescriptreact" },
	callback = function()
		local has_parser = pcall(vim.treesitter.get_parser, 0)
		if has_parser then
			vim.opt_local.foldmethod = "expr"
			vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		else
			vim.opt_local.foldmethod = "indent"
			vim.opt_local.foldexpr = "0"
		end
	end,
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
