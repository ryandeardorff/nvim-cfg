-- recommended installs --
-- - git
-- - c compiler of some kind
-- - tree-sitter cli
-- - lua-language-server
-- - stylua
-- - fd (fast alternative to find, used by projects search)

-- opts --
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.shiftwidth = 4
vim.o.tabstop = 4
vim.o.scrolloff = 10
vim.o.cursorline = true
vim.diagnostic.config({ virtual_text = true })

-- keybinds --
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>")
vim.keymap.set("n", "<leader>q", "<cmd>q!<cr>")
vim.keymap.set("n", "<C-q>", "<cmd>q!<cr>")
vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>")
vim.keymap.set("n", "<leader>gg", "<cmd>LazyGit<cr>")
-- format
vim.keymap.set("n", "<leader>f", function()
	require("conform").format({ async = true, lsp_fallbacke = true })
end)
-- open dashboard
vim.keymap.set("n", "<leader>;", function()
	Snacks.dashboard()
end)
-- searching
vim.keymap.set("n", "<leader>sf", function()
	Snacks.picker.files()
end)
vim.keymap.set("n", "<leader>sg", function()
	Snacks.picker.grep()
end)
vim.keymap.set("n", "<leader>sp", function()
	Snacks.picker.projects()
end)
-- panel management
vim.keymap.set("n", "<leader>vs", "<cmd>vs<cr>")
vim.keymap.set("n", "<leader>hs", "<cmd>split<cr>")
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")
-- terminals
vim.keymap.set("n", "<C-\\>", function()
	_G.main_terminal_toggle:toggle()
end)
vim.keymap.set("n", "<leader>\\", function()
	_G.new_terminal()
end)
function _G.set_terminal_keymaps()
	local opts = { buffer = 0 }
	vim.keymap.set("t", "<esc><esc>", [[<C-\><C-n>]], opts) -- pop out of terminal input while staying in term
	-- navigation & management
	vim.keymap.set("t", "<C-h>", [[<cmd>wincmd h<cr>]], opts)
	vim.keymap.set("t", "<C-j>", [[<cmd>wincmd j<cr>]], opts)
	vim.keymap.set("t", "<C-k>", [[<cmd>wincmd k<cr>]], opts)
	vim.keymap.set("t", "<C-l>", [[<cmd>wincmd l<cr>]], opts)
	vim.keymap.set("t", "<C-q>", [[<cmd>q!<cr>]], opts)
	vim.keymap.set("t", "<C-\\>", [[<cmd>lua _G.main_terminal_toggle:toggle()<cr>]])
	vim.keymap.set("t", "<leader>\\", [[<cmd>lua _G.new_terminal()<cr>]])
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

-- treesitter --
vim.pack.add({
	{ src = "https://github.com/neovim-treesitter/nvim-treesitter" },
})
require("nvim-treesitter").install({ "lua", "rust", "c", "odin" })
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "lua", "rust", "c", "odin" },
	callback = function()
		vim.treesitter.start() -- highlighting
		vim.wo.foldexpr = "v:lua.treesitter.foldexpr()" -- folds
		vim.wo.foldmethod = "expr"
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()" -- indentation
	end,
})

-- blink.cmp --
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

-- snacks (pickers and more) --
vim.pack.add({
	{ src = "https://github.com/folke/snacks.nvim" },
})
require("snacks").setup({
	picker = { enabled = true },
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

-- conform.nvim (formatting) --
vim.pack.add({
	{ src = "https://github.com/stevearc/conform.nvim" },
})
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
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
	hide_cursor =false,
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
