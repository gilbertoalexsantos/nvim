-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


require("config.lazy")


-- general
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })
vim.g.python3_host_prog = '/Users/desafinado/.pyenv/versions/py3nvim/bin/python'
vim.opt.number = true
vim.opt.termguicolors = true


-- keys
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>fs', builtin.current_buffer_fuzzy_find)
vim.keymap.set('n', '<leader>ff', builtin.find_files)
vim.keymap.set('n', '<leader>fg', builtin.live_grep)
vim.keymap.set('n', '<leader>fb', builtin.buffers)
vim.keymap.set('n', '<leader>fh', builtin.help_tags)
vim.keymap.set('n', '<leader>s', ':w<CR>', { silent = true })
vim.keymap.set('n', '<leader>fh', builtin.help_tags)


-- lsp
local builtin = require('telescope.builtin')
vim.keymap.set("n", "ga", vim.lsp.buf.code_action)
vim.keymap.set("n", "gr", vim.lsp.buf.rename)
vim.keymap.set('n', 'gR', builtin.lsp_references)
vim.keymap.set('n', 'gi', builtin.lsp_implementations)
vim.keymap.set('n', 'gd', builtin.lsp_definitions)
vim.keymap.set('n', 'gD', builtin.lsp_type_definitions)
vim.keymap.set('n', 'ge', function()
  builtin.diagnostics({ bufnr = 0 })
end)
vim.keymap.set('n', 'gE', builtin.diagnostics)
vim.keymap.set('n', 'gt', builtin.treesitter)

vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = true,
  underline = true,
  severity_sort = false,
  float = {
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})

vim.g.rustaceanvim = {
  server = {
    on_attach = function(_, bufnr)
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

      vim.keymap.set(
        "n",
        "ga",
        function()
          vim.cmd.RustLsp('codeAction')
        end,
        { silent = true, buffer = bufnr }
      )

      vim.keymap.set(
        "n",
        "gk",
        function()
          vim.cmd.RustLsp({ 'hover', 'actions' })
        end,
        { silent = true, buffer = bufnr }
      )

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.rs",
        callback = function()
          vim.lsp.buf.format({ async = false })
        end,
      })
    end,
  },
}
