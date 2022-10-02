vim.wo.number = true

local Plug = vim.fn['plug#']
vim.call('plug#begin')
Plug 'vim-airline/vim-airline'
Plug 'folke/tokyonight.nvim'
Plug 'preservim/nerdtree'
vim.call('plug#end')

require('tokyonight').setup({
	style = "night",
	transparent = true,
	styles = {
		floats = "dark",
		sidebars = "dark"
	},
	dim_inactive = true
})

vim.cmd[[colorscheme tokyonight]]

