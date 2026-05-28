-- Clipboard without +clipboard: wl-clipboard when GUI env is available,
-- else Neovim 0.10+ built-in OSC52 (best in tmux / SSH — no plugin needed).
local osc52 = require("vim.ui.clipboard.osc52")

local M = {}

local function env_line(name)
	if not vim.env.TMUX or vim.fn.executable("tmux") ~= 1 then
		return nil
	end
	local out = vim.fn.trim(vim.fn.system({ "tmux", "show-environment", "-g", name }))
	return out:match("^" .. name .. "=(.+)$")
end

local function wayland_socket_ok(name)
	if not name or name == "" then
		return false
	end
	local sock = string.format("/run/user/%d/%s", vim.uv.getuid(), name)
	return vim.fn.filereadable(sock) == 1
end

local function discover_wayland()
	local seen = {}
	local function try(name)
		if name and name ~= "" and not seen[name] then
			seen[name] = true
			if wayland_socket_ok(name) then
				return name
			end
		end
	end

	local from_env = try(os.getenv("WAYLAND_DISPLAY"))
	if from_env then
		return from_env
	end

	local from_tmux = try(env_line("WAYLAND_DISPLAY"))
	if from_tmux then
		return from_tmux
	end

	local uid = vim.uv.getuid()
	for _, path in ipairs(vim.fn.glob(string.format("/run/user/%d/wayland-*", uid), false, true)) do
		local name = vim.fn.fnamemodify(path, ":t")
		local hit = try(name)
		if hit then
			return hit
		end
	end

	return nil
end

local function discover_display()
	local display = os.getenv("DISPLAY") or env_line("DISPLAY")
	if display and display ~= "" then
		return display
	end
	if discover_wayland() then
		return ":0"
	end
	return nil
end

function M.gui_env()
	return discover_display(), discover_wayland()
end

local function run_clip(cmd, input)
	local full = { "timeout", "1" }
	for _, c in ipairs(cmd) do
		table.insert(full, c)
	end
	if input then
		vim.fn.system(full, input)
	else
		vim.fn.system(full)
	end
	return vim.v.shell_error == 0
end

local function copy_wl(text, wayland)
	return run_clip({ "env", "WAYLAND_DISPLAY=" .. wayland, "wl-copy", "--type", "text/plain" }, text)
end

local function copy_xclip(text, display)
	return run_clip({
		"env",
		"DISPLAY=" .. display,
		"xclip",
		"-in",
		"-selection",
		"clipboard",
	}, text)
end

function M.copy_lines(lines)
	local text = table.concat(lines, "\n")
	if text == "" then
		return false, "empty"
	end

	local display, wayland = M.gui_env()

	if wayland and vim.fn.executable("wl-copy") == 1 then
		if copy_wl(text, wayland) then
			return true, "wl-clipboard"
		end
	end

	if display and vim.fn.executable("xclip") == 1 then
		if copy_xclip(text, display) then
			return true, "xclip"
		end
	end

	-- OSC52: terminal copies to system clipboard (works in tmux without WAYLAND_DISPLAY)
	osc52.copy("+")(lines)
	return true, "osc52"
end

function M.paste_lines()
	local display, wayland = M.gui_env()

	if wayland and vim.fn.executable("wl-paste") == 1 then
		local out = vim.fn.system({
			"timeout",
			"1",
			"env",
			"WAYLAND_DISPLAY=" .. wayland,
			"wl-paste",
			"--no-newline",
		})
		if vim.v.shell_error == 0 then
			return vim.split(vim.trim(out), "\n", { plain = true, trimempty = false }), "wl-clipboard"
		end
	end

	if display and vim.fn.executable("xclip") == 1 then
		local out = vim.fn.system({
			"timeout",
			"1",
			"env",
			"DISPLAY=" .. display,
			"xclip",
			"-o",
			"-selection",
			"clipboard",
		})
		if vim.v.shell_error == 0 then
			return vim.split(vim.trim(out), "\n", { plain = true, trimempty = false }), "xclip"
		end
	end

	-- OSC52 paste (terminal must support readback; Kitty/WezTerm/Alacritty often do)
	local lines = osc52.paste("+")()
	if type(lines) == "table" and #lines > 0 then
		return lines, "osc52"
	end

	return vim.split(vim.fn.getreg('"'), "\n", { plain = true }), "register"
end

function M.status()
	local display, wayland = M.gui_env()
	return {
		wayland = wayland,
		display = display,
		wl_copy = vim.fn.executable("wl-copy") == 1,
		osc52 = true,
		tmux = vim.env.TMUX or "",
	}
end

vim.api.nvim_create_user_command("ClipInfo", function()
	local s = M.status()
	vim.notify(
		string.format(
			"clipboard: wayland=%s display=%s wl-copy=%s | copy: wl→xclip→OSC52 (built-in, no plugin)",
			tostring(s.wayland),
			tostring(s.display),
			s.wl_copy and "yes" or "no"
		),
		vim.log.levels.INFO
	)
end, { desc = "Show clipboard backend detection" })

vim.api.nvim_create_user_command("ClipTest", function()
	local ok, via = M.copy_lines({ "nvim-clipboard-test" })
	vim.notify(
		ok and ("Copied via " .. via .. " — paste outside with Ctrl+V") or "Copy failed",
		ok and vim.log.levels.INFO or vim.log.levels.ERROR
	)
end, { desc = "Test copy to system clipboard" })

return M
