local alpha = require('alpha')
local dashboard = require("alpha.themes.dashboard")

local fallback_header = {
	[[  _   _                 _           ]],
	[[ | \ | | _____   ___ __| | ___ _ __ ]],
	[[ |  \| |/ _ \ \ / / '__| |/ _ \ '__|]],
	[[ | |\  |  __/\ V /| |  | |  __/ |   ]],
	[[ |_| \_|\___| \_/ |_|  |_|\___|_|   ]],
}

local function apply_ascii_header()
	local ascii_dir = vim.fn.stdpath("config") .. "/ascii"
	local picked = ascii_dir .. "/makima.lua"
	local ok, data = pcall(dofile, picked)
	if not ok or type(data) ~= "table" then
		dashboard.section.header.val = fallback_header
		return
	end

	-- Format A: return { "line1", "line2", ... }
	if #data > 0 then
		dashboard.section.header.val = data
		return
	end

	-- Format B (from some img2art/alpha generators): return { header = { val = {...}, opts = {...} } }
	local hdr = data.header
	if type(hdr) == "table" and type(hdr.val) == "table" and #hdr.val > 0 then
		dashboard.section.header.val = hdr.val
		if type(hdr.opts) == "table" then
			dashboard.section.header.opts = vim.tbl_deep_extend("force", dashboard.section.header.opts or {}, hdr.opts)
		end
		return
	end

	dashboard.section.header.val = fallback_header
end

apply_ascii_header()

dashboard.section.buttons.val = {
	dashboard.button("e", "  New file", ":ene <BAR> startinsert <CR>"),
	dashboard.button("f", "󰍉  Find file", ":lua require('fzf-lua').files() <CR>"),
	dashboard.button("t", "  Browse cwd", ":NvimTreeOpen<CR>"),
	dashboard.button("r", "  Browse src", ":e ~/.local/src/<CR>"),
	dashboard.button("s", "󰯂  Browse scripts", ":e ~/scripts/<CR>"),
	dashboard.button("c", "  Config", ":e ~/.config/nvim/<CR>"),
	dashboard.button("m", "  Mappings", ":e ~/.config/nvim/lua/core/keymaps.lua<CR>"),
	dashboard.button("p", "  Plugins", ":PlugInstall<CR>"),
	dashboard.button("q", "󰅙  Quit", ":q!<CR>"),
}

dashboard.section.footer.val = function()
  return vim.g.startup_time_ms or "[[  ]]"
end

dashboard.section.buttons.opts.hl = "Keyword"
dashboard.opts.opts.noautocmd = true
alpha.setup(dashboard.opts)
