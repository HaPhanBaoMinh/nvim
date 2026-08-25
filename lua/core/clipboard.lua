-- Clipboard provider: prefer XWayland/xclip on GNOME, then
-- wl-clipboard, then Neovim's built-in OSC52 for remote terminals.
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

local function discover_xauthority()
	local configured = os.getenv("XAUTHORITY") or env_line("XAUTHORITY")
	if configured and configured ~= "" and vim.fn.filereadable(configured) == 1 then
		return configured
	end

	-- GNOME creates this file for XWayland. Shells opened without DISPLAY often
	-- also lose XAUTHORITY, so recover it from the user runtime directory.
	local runtime_dir = os.getenv("XDG_RUNTIME_DIR") or string.format("/run/user/%d", vim.uv.getuid())
	local candidates = vim.fn.glob(runtime_dir .. "/.mutter-Xwaylandauth.*", false, true)
	table.sort(candidates, function(a, b)
		local a_stat = vim.uv.fs_stat(a)
		local b_stat = vim.uv.fs_stat(b)
		return (a_stat and a_stat.mtime.sec or 0) > (b_stat and b_stat.mtime.sec or 0)
	end)
	for _, path in ipairs(candidates) do
		if vim.fn.filereadable(path) == 1 then
			return path
		end
	end

	local home_auth = vim.fn.expand("~/.Xauthority")
	if vim.fn.filereadable(home_auth) == 1 then
		return home_auth
	end
	return nil
end

function M.gui_env()
	return discover_display(), discover_wayland(), discover_xauthority()
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

local function xclip_cmd(display, xauthority, args)
	local cmd = { "env", "DISPLAY=" .. display }
	if xauthority then
		table.insert(cmd, "XAUTHORITY=" .. xauthority)
	end
	table.insert(cmd, "xclip")
	vim.list_extend(cmd, args)
	return cmd
end

local function copy_xclip(text, display, xauthority)
	return run_clip(xclip_cmd(display, xauthority, {
		"-in",
		"-selection",
		"clipboard",
		"-target",
		"UTF8_STRING",
	}), text)
end

function M.copy_lines(lines)
	local text = table.concat(lines, "\n")
	if text == "" then
		return false, "empty"
	end

	local display, wayland, xauthority = M.gui_env()

	-- Mutter's Wayland clipboard can stop answering while XWayland still works.
	-- Prefer xclip here and specify UTF8_STRING so reads do not request STRING.
	if display and vim.fn.executable("xclip") == 1 then
		if copy_xclip(text, display, xauthority) then
			return true, "xclip"
		end
	end

	if wayland and vim.fn.executable("wl-copy") == 1 then
		if copy_wl(text, wayland) then
			return true, "wl-clipboard"
		end
	end

	-- OSC52: terminal copies to system clipboard (works in tmux without WAYLAND_DISPLAY)
	osc52.copy("+")(lines)
	return true, "osc52"
end

function M.paste_lines()
	local display, wayland, xauthority = M.gui_env()

	if display and vim.fn.executable("xclip") == 1 then
		local cmd = { "timeout", "1" }
		vim.list_extend(cmd, xclip_cmd(display, xauthority, {
			"-out",
			"-selection",
			"clipboard",
			"-target",
			"UTF8_STRING",
		}))
		local out = vim.fn.system(cmd)
		if vim.v.shell_error == 0 then
			return vim.split(out, "\n", { plain = true, trimempty = false }), "v"
		end
	end

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
			return vim.split(out, "\n", { plain = true, trimempty = false }), "v"
		end
	end

	-- OSC52 paste (terminal must support readback; Kitty/WezTerm/Alacritty often do)
	local lines = osc52.paste("+")()
	if type(lines) == "table" and #lines > 0 then
		return lines, "v"
	end

	return vim.fn.getreg('"', 1, true), vim.fn.getregtype('"')
end

function M.status()
	local display, wayland, xauthority = M.gui_env()
	return {
		wayland = wayland,
		display = display,
		xauthority = xauthority,
		wl_copy = vim.fn.executable("wl-copy") == 1,
		xclip = vim.fn.executable("xclip") == 1,
		osc52 = true,
		tmux = vim.env.TMUX or "",
	}
end

vim.api.nvim_create_user_command("ClipInfo", function()
	local s = M.status()
	vim.notify(
		string.format(
			"clipboard: display=%s xauth=%s xclip=%s wayland=%s wl-copy=%s | copy: xclip→wl→OSC52",
			tostring(s.display),
			tostring(s.xauthority),
			s.xclip and "yes" or "no",
			tostring(s.wayland),
			s.wl_copy and "yes" or "no"
		),
		vim.log.levels.INFO
	)
end, { desc = "Show clipboard backend detection", force = true })

vim.api.nvim_create_user_command("ClipTest", function()
	local ok, via = M.copy_lines({ "nvim-clipboard-test" })
	vim.notify(
		ok and ("Copied via " .. via .. " — paste outside with Ctrl+V") or "Copy failed",
		ok and vim.log.levels.INFO or vim.log.levels.ERROR
	)
end, { desc = "Test copy to system clipboard", force = true })

return M
