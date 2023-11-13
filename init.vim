"" General
set number
set noerrorbells vb t_vb=
set ruler
set expandtab
let mapleader = "\<Space>"

"" C++
let g:clang_format#detect_style_file = 1

" Quitting insert mode
inoremap jk <esc> " For insert mode
vnoremap jk <esc> " For visual and select mode


"" Plug
call plug#begin('~/.config/nvim/plugged')
Plug 'sainnhe/sonokai' " Colorscheme based on monokai
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'vim-airline/vim-airline' 
Plug 'vim-airline/vim-airline-themes'
Plug 'majutsushi/tagbar'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.4' }
Plug 'williamboman/mason.nvim'
call plug#end()


"" LSP
runtime! lsp.vim


"" airline
let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.branch = ' '    " alternatives:        $
let g:airline_symbols.colnr = ':'      " alternatives: \u33c7 (㏇)  ℅:
let g:airline_symbols.readonly = ' '  " alternatives: 
let g:airline_symbols.linenr = ' '     " alternatives ' :'
let g:airline_symbols.maxlinenr = ''   " alternatives: '☰ '
let g:airline_symbols.dirty = ''       " I don't care
let g:airline_theme = 'sonokai'
" Section Y contains  (fileencoding, fileformat, 'bom', 'eol') and we don't need it
let g:airline_section_y = ''
" Show lsp errors and wranings in airline
let g:airline_section_warning = airline#section#create(['%{LspStatus()}'])
let g:airline_section_error = ''
let g:airline_skip_empty_sections = 1
" Tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#tab_nr_type = 1  " show tab number instead of # of splits
let g:airline#extensions#tabline#show_splits = 1  " Note: disable if screen is small
let g:airline#extensions#tabline#alt_sep = 0  " tab1 > tab 2 > <active> (disabled)
let g:airline#extensions#tabline#show_tab_type = 1  " left is tabs, right is buffers, d'uh
let g:airline#extensions#tabline#tabs_label = ' '
let g:airline#extensions#tabline#buffers_label = '$'
let g:airline#extensions#tabline#buffer_idx_mode = 1
nmap <leader>1 <Plug>AirlineSelectTab1
nmap <leader>2 <Plug>AirlineSelectTab2
nmap <leader>3 <Plug>AirlineSelectTab3
nmap <leader>4 <Plug>AirlineSelectTab4
nmap <leader>5 <Plug>AirlineSelectTab5
nmap <leader>6 <Plug>AirlineSelectTab6
nmap <leader>7 <Plug>AirlineSelectTab7
nmap <leader>8 <Plug>AirlineSelectTab8
nmap <leader>9 <Plug>AirlineSelectTab9
nmap <leader>0 <Plug>AirlineSelectTab0
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline#extensions#tabline#left_sep = ""
let g:airline#extensions#tabline#right_sep = ""
let g:airline#extensions#tabline#left_alt_sep = ''
let g:airline#extensions#tabline#right_alt_sep = ''
let g:airline#extensions#tabline#show_close_button = 0
function! TabnrFormat(tab_nr, buflist)
  let spc=g:airline_symbols.space
  let tab_nr_type = get(g:, 'airline#extensions#tabline#tab_nr_type', 0)
  if tab_nr_type == 0 " nr of splits
    return spc. len(tabpagebuflist(a:buflist[0]))
  elseif tab_nr_type == 1 " tab number
    return spc. a:tab_nr. spc. get(g:, 'airline#extensions#tabline#left_alt_sep', '')
  else " tab_nr_type == 2 splits and tab number
    return spc. a:tab_nr. spc. len(tabpagebuflist(a:buflist[0]))
  endif
endfunction
let g:airline#extensions#tabline#tabnr_formatter = 'TabnrFormat'
" Tagbar (disabled)
let g:airline#extensions#tagbar#enabled = 0
let g:airline#extensions#tagbar#flags = 'f'
" Branch
let g:airline#extensions#branch#enabled = 1


"" nvim-tree
nmap <Leader>n :NvimTreeToggle<CR>
lua << EOF
-- disable NerdTree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true 

require("nvim-tree").setup()
EOF


"" tagbar
let g:tagbar_sort = 0
nmap <Leader>t :TagbarToggle<CR>


"" Colorscheme
colorscheme sonokai


"" Telescope
nnoremap <Leader>f <cmd>Telescope find_files<CR>
nnoremap <Leader>b  <cmd>Telescope buffers<CR> 
nnoremap <Leader>lg <cmd>Telescope live_grep<CR>
nnoremap <Leader>lh <cmd>Telescope help_tags<CR>
