set number
set mouse=a
syntax enable
set showcmd
set encoding=utf-8
set showmatch
set termguicolors

call plug#begin()
	Plug 'nvim-lualine/lualine.nvim'
	Plug 'nvim-tree/nvim-web-devicons'
	Plug 'dracula/vim', { 'as': 'dracula' }
call plug#end()

colorscheme dracula

highlight Normal guibg=NONE ctermbg=NONE
highlight NormalNC guibg=NONE ctermbg=NONE
highlight EndOfBuffer guibg=NONE ctermbg=NONE

lua << END

require('lualine').setup {
	options = {
		icons_enabled = true,
		theme = 'dracula',
		section_separators = { left = '', right = '' },
		component_separators = { left = '', right = '' }
		},
	sections = {
		lualine_a = {'mode'},
		lualine_b = {'branch', 'diff', 'diagnostics'},
		lualine_c = {'filename'},
		lualine_x = {'fileformat'},
		lualine_y = {'filetype'},
		lualine_z = {'location'}
		}
	}
END
