local dap = require("dap")
local dapui = require("dapui")

dapui.setup()

vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { silent = true, desc = "DAP toggle breakpoint" })
vim.keymap.set("n", "<leader>dB", function()
	dap.set_breakpoint(vim.fn.input("Condition: "))
end, { silent = true, desc = "DAP conditional breakpoint" })
vim.keymap.set("n", "<leader>dc", dap.continue, { silent = true, desc = "DAP continue" })
vim.keymap.set("n", "<leader>di", dap.step_into, { silent = true, desc = "DAP step into" })
vim.keymap.set("n", "<leader>do", dap.step_over, { silent = true, desc = "DAP step over" })
vim.keymap.set("n", "<leader>dO", dap.step_out, { silent = true, desc = "DAP step out" })
vim.keymap.set("n", "<leader>dr", dap.repl.open, { silent = true, desc = "DAP REPL" })
vim.keymap.set("n", "<leader>du", dapui.toggle, { silent = true, desc = "DAP UI toggle" })

dap.listeners.before.attach.dapui_config = function()
	dapui.open()
end
dap.listeners.before.launch.dapui_config = function()
	dapui.open()
end
dap.listeners.before.event_terminated.dapui_config = function()
	dapui.close()
end
dap.listeners.before.event_exited.dapui_config = function()
	dapui.close()
end

require("mason-nvim-dap").setup({
	ensure_installed = { "python", "cppdbg", "lua" },
	automatic_setup = true,
})
