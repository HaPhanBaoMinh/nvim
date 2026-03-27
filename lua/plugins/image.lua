-- https://github.com/3rd/image.nvim
-- Cần: ImageMagick (`sudo apt install imagemagick`). Terminal: Kitty (khuyên dùng) hoặc cài ueberzugpp (lệnh `ueberzug` trong PATH).

local function pick_backend()
	if vim.env.TERM == "xterm-kitty" or vim.env.KITTY_WINDOW_ID then
		return "kitty"
	end
	if vim.fn.executable("ueberzug") == 1 then
		return "ueberzug"
	end
	return nil
end

local backend = pick_backend()
if not backend then
	vim.schedule(function()
		vim.notify_once(
			"[image.nvim] Bật khi dùng Kitty hoặc cài ueberzugpp (PATH có lệnh `ueberzug`) + ImageMagick.",
			vim.log.levels.INFO
		)
	end)
	return
end

local ok, err = pcall(function()
	require("image").setup({
		backend = backend,
		processor = "magick_cli",
		integrations = {
			markdown = {
				enabled = true,
				clear_in_insert_mode = false,
				download_remote_images = true,
				only_render_image_at_cursor = false,
				only_render_image_at_cursor_mode = "popup",
				floating_windows = false,
				filetypes = { "markdown", "vimwiki", "quarto" },
			},
		},
		max_height_window_percentage = 50,
		kitty_method = "normal",
	})
end)

if not ok then
	vim.schedule(function()
		vim.notify("[image.nvim] " .. tostring(err), vim.log.levels.WARN)
	end)
end
