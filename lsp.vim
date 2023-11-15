lua << EOF

-- GENERAL


-- CMP
local cmp = require'cmp'
cmp.setup {
  sources = {
    { name = 'nvim_lsp' }
  }
}



-- LSP Status
local lsp_status = require "lsp-status"
lsp_status.config({
  show_filename = false,
  current_function = false,
  indicator_separator = ' ',
  status_symbol = '',
  indicator_errors = ' ',
  indicator_warnings = ' ',
  indicator_info = ' ',
  indicator_hint = ' ',
  indicator_ok = ' '
})
lsp_status.register_progress()


-- LSP CONFIG
local lsp = require "lspconfig"

local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  -- Enable omni completion
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', 'gY', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>ci', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>', opts)
  buf_set_keymap('n', '<space>co', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', opts)
  buf_set_keymap('n', '<space>h', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<space>j', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  -- Diagnostics
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float({"line"})<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  if (client.name == 'clangd') then
  else
    buf_set_keymap('n', '<space>c', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
  end

  lsp_status.on_attach(client)
end

local capabilities = require('cmp_nvim_lsp').default_capabilities()

lsp.clangd.setup({
  handlers = lsp_status.extensions.clangd.setup(),
  init_options = {
    clangdFileStatus = true
  },
  capabilities = capabilities,
  on_attach = on_attach
})


EOF

"" Statusline
function! LspStatus() abort
  if luaeval('#vim.lsp.buf_get_clients() > 0')
    return luaeval("require('lsp-status').status()")
  endif

  return ''
endfunction
