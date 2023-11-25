"" General
set number
set noerrorbells vb t_vb=
set ruler
set expandtab
let mapleader = "\<Space>"


"" Mapping
nmap <Leader>q :q<CR>


"" C++
let g:clang_format#detect_style_file = 1
augroup cpp_files_indentation
    autocmd!
    autocmd FileType cpp setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=4
    autocmd FileType c setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=4
    autocmd FileType inl setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=4
    autocmd BufRead,BufNewFile *.in setlocal expandtab shiftwidth=4 softtabstop=4 tabstop=4
augroup END


"" Vim
augroup VimFileType
    autocmd!
    autocmd FileType vim setlocal expandtab shiftwidth=2 softtabstop=2
augroup END


"" Lua
augroup LuaFileType
    autocmd!
    autocmd FileType lua setlocal expandtab shiftwidth=2 softtabstop=2
augroup END


"" Plug
call plug#begin('~/.config/nvim/plugged')
Plug 'sainnhe/sonokai'
Plug 'nvim-tree/nvim-tree.lua'
Plug 'nvim-tree/nvim-web-devicons'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'onsails/lspkind.nvim'
Plug 'nvim-lua/lsp-status.nvim'
Plug 'vim-airline/vim-airline' 
Plug 'vim-airline/vim-airline-themes'
Plug 'majutsushi/tagbar'
Plug 'nvim-lua/plenary.nvim'
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.4' }
Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build' }
Plug 'NeogitOrg/neogit'
Plug 'sindrets/diffview.nvim'
Plug 'ibhagwan/fzf-lua', {'branch': 'main'}
Plug 'nvim-telescope/telescope-file-browser.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'numtostr/BufOnly.nvim', { 'on': 'BufOnly' }
Plug 'L3MON4D3/LuaSnip'
" Leap
Plug 'tpope/vim-repeat'
Plug 'ggandor/leap.nvim'
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
nmap <Leader>n :NvimTreeFindFile<CR>
lua << EOF
-- disable NerdTree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true 

require("nvim-tree").setup({
  filters = {
    custom = {
      "^.git$",
      ".DS_Store"
    }
  }
})
EOF


"" tagbar
let g:tagbar_sort = 0
nmap <Leader>t :TagbarToggle<CR>


"" Colorscheme
colorscheme sonokai


"" Telescope
nnoremap <Leader>lf <cmd>Telescope find_files hidden=true<CR>
lua << EOF
vim.api.nvim_set_keymap("n", "<leader>lc", ":Telescope file_browser path=%:p:h<CR>", {noremap = true, silent = true})
EOF
nnoremap <Leader>f <cmd>Telescope current_buffer_fuzzy_find<CR>
nnoremap <Leader>b  <cmd>Telescope buffers<CR> 
nnoremap <Leader>lg <cmd>Telescope live_grep<CR>
nnoremap <Leader>lh <cmd>Telescope help_tags<CR>

lua << EOF
require('telescope').setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
    }
  }
}
require('telescope').load_extension "fzf"
require("telescope").load_extension "file_browser"
EOF


"" Mason
lua << EOF
require("mason").setup ({
  install_root_dir = vim.fn.stdpath "config" .. "/mason"
})
EOF


"" Neogit
lua << EOF
local neogit = require('neogit')
local utils = require('utils')

neogit.setup {
  integrations = {
    telescope = true,
    diffview = true,
    fzf_lua = true,
  }
}

function focus_or_create_neogit_tab()
  local neogit_buffer = utils.find_buffer_by_name('NeogitStatus')

  if neogit_buffer ~= nil then
    utils.switch_to_window_with_buffer(neogit_buffer)
    require("neogit.status").dispatch_refresh(true)
  else
    vim.cmd('Neogit')
  end
end
vim.api.nvim_set_keymap("n", "<leader>g", ":lua focus_or_create_neogit_tab()<CR>", {noremap = true, silent = true})
EOF


"" Zoom / Restore window
function! s:ZoomToggle() abort
    if exists('t:zoomed') && t:zoomed
        execute t:zoom_winrestcmd
        let t:zoomed = 0
    else
        let t:zoom_winrestcmd = winrestcmd()
        resize
        vertical resize
        let t:zoomed = 1
    endif
endfunction
command! ZoomToggle call s:ZoomToggle()
nnoremap <silent> <leader>a :ZoomToggle<CR>


"" BufOnly
lua << EOF
vim.api.nvim_set_keymap('n', '<leader>x', ':BufOnly<CR>', { noremap = true, silent = true })
EOF


"" Leap
lua << EOF
require('leap').add_default_mappings()
vim.keymap.set('n', '<leader>s', function ()
  local current_window = vim.fn.win_getid()
  require('leap').leap { target_windows = { current_window } }
end)
EOF
