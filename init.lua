-- recommended installs --
-- - git
-- - c compiler of some kind
-- - tree-sitter cli
-- - lua-language-server
-- - stylua
-- - fd (fast alternative to find, used by projects search)
-- - roslyn-language-server (for c#)
-- - gopls (for go) `go install golang.org/x/tools/gopls@latest`
-- - basedpyright (for python) `uv tool install basedpyright`

-- opts --
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.scrolloff = 10
vim.o.cursorline = true
vim.o.number = true
vim.diagnostic.config({ virtual_text = true })
-- autoread on changes live (when no changes are made to a buffer/file)
vim.o.autoread = true
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, { command = "checktime" })

-- keybinds --
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>")
vim.keymap.set("n", "<leader>q", "<cmd>q!<cr>")
vim.keymap.set("n", "<leader>Q", "<cmd>qa!<cr>")
vim.keymap.set("n", "<C-q>", "<cmd>q!<cr>")
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>")
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>")
vim.keymap.set("n", "<leader>gd", "<cmd>DiffviewFileHistory<cr>")
vim.keymap.set("n", "<leader>gdf", "<cmd>DiffviewFileHistory %<cr>")
vim.keymap.set("v", "<leader>gd", [[<cmd>'<,'>DiffviewFileHistory<cr>]])
vim.keymap.set("v", "<leader>cs", "<cmd>Sidekick cli send<cr>")
vim.keymap.set({ "n", "v" }, "<leader>cp", "<cmd>Sidekick cli prompt<cr>")
vim.keymap.set("n", "<leader>co", "<cmd>Sidekick cli toggle<cr>")
vim.keymap.set("n", "<leader>cr", function()
	-- Relaunch the currently attached Sidekick CLI in the current cwd.
	local State = require("sidekick.cli.state")
	local cli = require("sidekick.cli")
	State.with(function(state)
		if not state then
			return
		end
		local name = state.tool.name
		State.detach(state)
		vim.schedule(function()
			cli.show({ name = name, focus = true })
		end)
	end, { filter = { attached = true } })
end, { desc = "Sidekick: relaunch selected CLI in cwd" })
vim.keymap.set("n", "<Esc>", function()
	if vim.v.hlsearch == 1 then
		vim.cmd("nohlsearch")
	else
		vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
	end
end, { silent = true, desc = "Clear search highlight" })
-- format
vim.keymap.set("n", "<leader>f", function()
	require("conform").format({ async = true, lsp_fallbacke = true })
end)
-- open dashboard
vim.keymap.set("n", "<leader>;", function()
	Snacks.dashboard()
end)
-- searching
vim.keymap.set("n", "<leader>sm", function()
	Snacks.picker.smart()
end)
vim.keymap.set("n", "<leader>sf", function()
	Snacks.picker.files()
end)
vim.keymap.set("n", "<leader>sg", function()
	Snacks.picker.grep()
end)
vim.keymap.set("n", "<leader>sp", function()
	Snacks.picker.projects()
end)
vim.keymap.set("n", "<leader>sh", function()
	Snacks.picker.help()
end)
vim.keymap.set("n", "<leader>sk", function()
	Snacks.picker.keymaps()
end)
vim.keymap.set("n", "<leader>sd", function()
	Snacks.picker.diagnostics()
end)
vim.keymap.set("n", "<leader>sr", function()
	Snacks.picker.lsp_references()
end)
vim.keymap.set("n", "<leader>ss", function()
	Snacks.picker.lsp_workspace_symbols()
end)
vim.keymap.set("n", "<leader>sds", function()
	Snacks.picker.lsp_symbols()
end)
-- panel management
vim.keymap.set("n", "<leader>vs", "<cmd>vs<cr>")
vim.keymap.set("n", "<leader>hs", "<cmd>split<cr>")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-A-h>", "10<C-w><")
vim.keymap.set("n", "<C-A-j>", "5<C-w>-")
vim.keymap.set("n", "<C-A-k>", "5<C-w>+")
vim.keymap.set("n", "<C-A-l>", "10<C-w>>")
-- terminals
vim.keymap.set("n", "<C-\\>", function()
	_G.main_terminal_toggle:toggle()
end)
vim.keymap.set("n", "<leader>\\", function()
	_G.new_terminal()
end)
function _G.set_terminal_keymaps()
	local opts = { buffer = 0 }
	vim.keymap.set("t", "<S-Esc>", [[<C-\><C-n>]], opts) -- pop out of terminal input while staying in term
	-- fallback: raw CSI u sequence for Shift+Esc (sent by Windows Terminal)
	vim.keymap.set("t", "\27[27;2u", [[<C-\><C-n>]], opts)
	-- forward Shift+Enter as a raw LF byte so embedded TUIs (e.g. pi) treat it
	-- as Ctrl+J / newline. Without this nvim sends a bare \r (=Enter/submit).
	-- LF works regardless of whether the inner program negotiated kitty mode.
	vim.keymap.set("t", "<S-CR>", function()
		vim.api.nvim_chan_send(vim.b.terminal_job_id, "\n")
	end, opts)
	-- navigation & management
	vim.keymap.set("t", "<C-h>", [[<cmd>wincmd h<cr>]], opts)
	vim.keymap.set("t", "<C-j>", [[<cmd>wincmd j<cr>]], opts)
	vim.keymap.set("t", "<C-k>", [[<cmd>wincmd k<cr>]], opts)
	vim.keymap.set("t", "<C-l>", [[<cmd>wincmd l<cr>]], opts)
	vim.keymap.set("t", "<C-q>", [[<cmd>q!<cr>]], opts)
	vim.keymap.set("t", "<C-\\>", [[<cmd>lua _G.main_terminal_toggle:toggle()<cr>]])
	-- NOTE: do NOT map any terminal-mode binding starting with <leader> (space).
	-- It causes Neovim to swallow <space> in terminals/lazygit while it waits
	-- timeoutlen for a possible follow-up key, making the cursor appear stuck.
end
vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")

-- lsp keybinds
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local buf = ev.buf
		local map = function(mode, lhs, rhs, desc)
			vim.keymap.set(mode, lhs, rhs, {
				buffer = buf,
				silent = true,
				desc = desc,
			})
		end

		map("n", "gd", vim.lsp.buf.definition, "LSP: go to definition")
	end,
})

-- Lsp --
vim.pack.add({
	{ src = "https://github.com/neovim/nvim-lspconfig" },
})

vim.lsp.config("*", {
	root_markers = { ".git" },
})

-- Lua config
vim.lsp.config("lua_ls", {
	root_dir = function(bufnr, on_dir)
		on_dir(vim.fs.root(bufnr, { ".git" }))
	end,
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
		},
	},
})
vim.lsp.enable({ "lua_ls" })

-- roslyn.nvim (C#) --
vim.pack.add({
	"https://github.com/seblyng/roslyn.nvim",
})
require("roslyn")
vim.lsp.config("roslyn", {
	cmd = {
		"roslyn-language-server",
		"--logLevel=Information",
		"--extensionLogDirectory=C:/Users/Ryan/AppData/Local/nvim-data",
		"--stdio",
	},
})
vim.lsp.enable("roslyn")

-- gopls
vim.lsp.config("gopls", {})
vim.lsp.enable({ "gopls" })

-- basedpyright
vim.lsp.config("basedpyright", {})
vim.lsp.enable({ "basedpyright" })

-- treesitter --
vim.pack.add({
	"https://github.com/neovim-treesitter/nvim-treesitter",
	"https://github.com/neovim-treesitter/treesitter-parser-registry",
})
require("nvim-treesitter").install({ "lua", "rust", "c", "odin", "go", "python" })
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "lua", "rust", "c", "odin", "go", "python" },
	callback = function()
		vim.treesitter.start() -- highlighting
		vim.wo.foldexpr = "v:lua.treesitter.foldexpr()" -- folds
		vim.wo.foldmethod = "expr"
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" -- indentation
	end,
})

-- blink.cmp (completion)--
vim.pack.add({
	{ src = "https://github.com/saghen/blink.cmp", version = "v1.10.2" },
})
require("blink.cmp").setup({
	keymap = { preset = "default" },
	appearance = {
		nerd_font_variant = "mono",
	},
	sources = {
		default = { "lsp", "path", "snippets", "buffer" },
	},
	fuzzy = { implementation = "prefer_rust" },
	completion = {
		documentation = { auto_show = true },
	},
})

-- lsp_signature.nvim (function signature while typing params/arguments) --
vim.pack.add({ "https://github.com/ray-x/lsp_signature.nvim" })
require("lsp_signature").setup({
	zindex = 1000,
})

-- snacks (pickers and more) --
vim.pack.add({
	{ src = "https://github.com/folke/snacks.nvim" },
})
require("snacks").setup({
	picker = {
		enabled = true,
		fuzzy = true,
		sources = {
			projects = {
				patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "package.json", "Makefile", ".plastic" },
				recent = true,
				max_depth = 4,
			},
		},
	},
	dashboard = {
		enabled = true,
		sections = {
			{ section = "header" },
			{ section = "keys", padding = 1 },
			{ icon = " ", title = "Projects", section = "projects", padding = 1, indent = 1 },
			{ icon = "󱦟 ", title = "Recent Files", section = "recent_files", padding = 1, indent = 1 },
		},
		preset = {
			keys = {
				{ key = "p", desc = "Find Project", action = ":lua Snacks.dashboard.pick('projects')" },
				{
					key = "f",
					desc = "Find Recent File",
					action = function()
						Snacks.picker.recent({
							finder = "recent_files",
							format = "file",
							paths = {
								[vim.fn.stdpath("data")] = false,
								[vim.fn.stdpath("cache")] = false,
								[vim.fn.stdpath("state")] = false,
							},
						})
					end,
				},
			},
		},
	},
})

-- color schemes --
vim.pack.add({
	"https://github.com/rebelot/kanagawa.nvim",
	"https://github.com/olimorris/onedarkpro.nvim",
	"https://github.com/AlexvZyl/nordic.nvim",
	"https://github.com/slugbyte/lackluster.nvim",
})

-- color scheme loading --
local function get_saved_colorscheme(default)
	-- load ShaDa so persisted globals are available early
	pcall(vim.cmd.rshada)
	return vim.g.COLORS_NAME or default
end

local function save_colorscheme(name)
	name = name or vim.g.colors_name
	if not name or vim.g.COLORS_NAME == name then
		return
	end
	vim.g.COLORS_NAME = name
	pcall(vim.cmd.wshada)
end

-- apply saved colorscheme on startup
local saved = get_saved_colorscheme("habamax")
pcall(vim.cmd.colorscheme, saved)
vim.keymap.set("n", "<leader>th", function()
	Snacks.picker.colorschemes({
		confirm = function(picker, item)
			-- preserve Snacks' normal behavior
			local source = require("snacks.picker.config.sources").colorschemes
			source.confirm(picker, item)

			-- persist selection
			save_colorscheme(item.text)
		end,
	})
end, { desc = "Pick colorscheme" })

-- lualine (status line) --
vim.pack.add({
	"https://github.com/nvim-lualine/lualine.nvim",
})

-- theming
local function hex(n)
	return n and string.format("#%06x", n) or nil
end
local function get_bg(group)
	local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
	return hex(hl.bg)
end
local function get_fg(group)
	local hl = vim.api.nvim_get_hl(0, { name = group, link = false })
	return hex(hl.fg)
end

local theme = require("lualine.themes.auto")
for _, mode in ipairs({ "normal", "insert", "visual", "replace", "command", "inactive" }) do
	theme[mode] = theme[mode] or {}
	local bg = get_bg("Normal")
	theme[mode].a.fg = theme[mode].a.bg
	for _, section in ipairs({ "a", "b", "c" }) do
		theme[mode][section] = theme[mode][section] or {}
		theme[mode][section].bg = bg
	end
end

function IsRecording()
	local reg = vim.fn.reg_recording()
	if reg == "" then
		return ""
	end -- not recording
	local animated = {
		"○",
		"◉",
	}
	return animated[os.date("%S") % #animated + 1] .. " " .. reg
end

require("lualine").setup({
	options = {
		theme = theme,
		component_separators = "",
		section_separators = { left = "", right = "" },
	},
	sections = {
		lualine_a = { {
			"mode",
			fmt = function(str)
				return string.lower(str):sub(1, 1)
			end,
		} },
		lualine_b = { { "branch", icon = "", color = { fg = get_fg("Special") } }, "diff" },
		lualine_c = { '"⋅"', "filename" },
		lualine_x = {},
		lualine_y = { { "IsRecording()", color = { fg = get_fg("Error") } }, "diagnostics" },
		lualine_z = { "selectioncount", "progress" },
	},
})

-- conform.nvim (formatting) --
vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
})
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		go = { "gofmt" },
	},
})

-- neo-tree (file side bar) --
vim.pack.add({
	{ src = "https://github.com/nvim-neo-tree/neo-tree.nvim", version = vim.version.range("3") },
	-- dependencies
	"https://github.com/nvim-lua/plenary.nvim",
	"https://github.com/MunifTanjim/nui.nvim",
	-- optional, but recommended
	"https://github.com/nvim-tree/nvim-web-devicons",
})
require("neo-tree").setup({})

-- lazygit --
vim.pack.add({
	{ src = "https://github.com/kdheepak/lazygit.nvim" },
})

-- gitsigns.nvim --
vim.pack.add({
	"https://github.com/lewis6991/gitsigns.nvim",
})
require("gitsigns").setup({
	current_line_blame = true,
	current_line_blame_opts = {
		delay = 500,
	},
})

-- diffview.nvim --
vim.pack.add({
	"https://github.com/sindrets/diffview.nvim",
})
require("diffview").setup({
	keymaps = {
		view = {
			{ "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close diffview" } },
			{ "n", "<leader>q", "<Cmd>DiffviewClose<CR>", { desc = "Close diffview" } },
		},
		file_panel = {
			{ "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close diffview" } },
			{ "n", "<leader>q", "<Cmd>DiffviewClose<CR>", { desc = "Close diffview" } },
		},
		file_history_panel = {
			{ "n", "q", "<Cmd>DiffviewClose<CR>", { desc = "Close diffview" } },
			{ "n", "<leader>q", "<Cmd>DiffviewClose<CR>", { desc = "Close diffview" } },
		},
	},
})

-- toggleterm.nvim (terminal) --
vim.pack.add({
	{ src = "https://github.com/akinsho/toggleterm.nvim" },
})
require("toggleterm").setup({})
local Terminal = require("toggleterm.terminal").Terminal
_G.main_terminal_toggle = Terminal:new({ cmd = "nu", hidden = true, direction = "float" })
_G.new_terminal = function()
	Terminal:new({ cmd = "nu", hidden = false, direction = "horizontal" }):toggle()
end

-- satellite.nvim (scrollbar) --
vim.pack.add({
	"https://github.com/lewis6991/satellite.nvim",
})
---@diagnostic disable-next-line: missing-fields
require("satellite").setup({
	-- Must be below any float we want to draw over the bar
	-- (snacks dashboard uses zindex = 10). Default is 40.
	zindex = 5,
})

-- fidget.nvim (notification/status msgs) --
vim.pack.add({ "https://github.com/j-hui/fidget.nvim" })
require("fidget").setup({
	notification = {
		override_vim_notify = true,
	},
})

-- mini.pairs (autopairs) --
vim.pack.add({
	{ src = "https://github.com/nvim-mini/mini.pairs" },
})
require("mini.pairs").setup()

-- smooth scroll --
vim.pack.add({
	{ src = "https://github.com/karb94/neoscroll.nvim" },
})
require("neoscroll").setup({
	easing = "sine",
	duration_multiplier = 0.2,
	hide_cursor = false,
})

-- smear cursor --
vim.pack.add({
	{ src = "https://github.com/sphamba/smear-cursor.nvim" },
})
require("smear_cursor").setup({
	stiffness = 0.8,
	trailing_stiffness = 0.5,
	distance_stop_animating = 0.5,
	legacy_computing_symbols_support = false,
	particles_enabled = true,
	min_distance_emit_particles = 1.0,
})

-- sidekick.nvim (AI, using this for now) --
vim.pack.add({
	{ src = "https://github.com/folke/sidekick.nvim" },
})
require("sidekick").setup({})
