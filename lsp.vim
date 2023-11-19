lua << EOF

-- GENERAL


-- CMP
local lspkind = require('lspkind')
local cmp = require'cmp'

WIDE_HEIGHT = 60

cmp.setup({
  snippet = {
    expand = function(args)
--      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = {
      border = { "╭", "─", "╮", "│", "╯", "─", "╰", "│" },
      max_height = math.floor(WIDE_HEIGHT * (WIDE_HEIGHT / vim.o.lines)),
      max_width = math.floor((WIDE_HEIGHT * 2) * (vim.o.columns / (WIDE_HEIGHT * 2 * 16 / 9))),
    }
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), 
  }),
  formatting = {
    format = lspkind.cmp_format({ mode = 'symbol' })
  },
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    --{ name = 'luasnip' }, -- For luasnip users.
  }, {
    { name = 'buffer' },
  })
})



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
  buf_set_keymap('n', 'gd', ':Telescope lsp_definitions<CR>', opts)
  buf_set_keymap('n', 'gy', ':Telescope lsp_type_definitions<CR>', opts)
  buf_set_keymap('n', 'gi', ':Telescope lsp_implementations<CR>', opts)
  buf_set_keymap('n', 'gr', ':Telescope lsp_references<CR>', opts)
  buf_set_keymap('n', 'gt', ':Telescope lsp_document_symbols<CR>', opts)
  buf_set_keymap('n', '<space>ci', '<cmd>lua vim.lsp.buf.incoming_calls()<CR>', opts)
  buf_set_keymap('n', '<space>co', '<cmd>lua vim.lsp.buf.outgoing_calls()<CR>', opts)
  buf_set_keymap('n', '<space>h', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', '<space>j', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)

  -- Diagnostics
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float({"line"})<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)

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
