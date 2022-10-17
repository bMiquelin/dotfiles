local o = vim.o

o.number = true
o.mouse = "a"
o.tabstop = 2
o.ignorecase = true
o.title = true
o.hidden = true
o.ignorecase = true
o.smartcase = true
o.signcolumn = "yes"
o.cursorline = true
o.clipboard = "unnamedplus"

local Plug = vim.fn['plug#']
vim.call('plug#begin')
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
Plug 'folke/tokyonight.nvim'
Plug 'preservim/nerdtree'
vim.call('plug#end')

require('tokyonight').setup({
	style = "night",
	transparent = true,
	styles = {
		floats = "dark",
		sidebars = "dark"
	}
})

require('lualine').setup({
	icons_enabled = true,
	theme = 'auto'
})

vim.cmd[[colorscheme tokyonight]]

