-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1


require("config.lazy")


-- general
vim.keymap.set("i", "jk", "<Esc>", { noremap = true, silent = true })
vim.g.python3_host_prog = '/Users/desafinado/.pyenv/versions/py3nvim/bin/python'
vim.opt.number = true
vim.opt.termguicolors = true
vim.cmd([[filetype plugin indent on]])
vim.api.nvim_set_option_value("clipboard", "unnamedplus", {})
vim.cmd("language en_US")
vim.env.DOTNET_CLI_UI_LANGUAGE = "en"
vim.env.LC_ALL = "en_US.UTF-8"
vim.env.LANG = "en_US.UTF-8"
vim.env.LC_CTYPE = "en_US.UTF-8"

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
    source = true,
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

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lua",
  callback = function(args)
    vim.bo.expandtab = true
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.autoindent = true
    vim.bo.smartindent = true

    local bufnr = args.buf
    local clients = vim.lsp.get_clients({bufnr = bufnr})

    local lspconfig = {
      cmd = { "lua-language-server" },
      filetypes = { "lua" },
      root_dir = vim.fn.getcwd(),
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
            path = vim.split(package.path, ";"),
          },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = vim.api.nvim_get_runtime_file("", true),
            checkThirdParty = false,
          },
          telemetry = { enable = false },
        },
      },
    }

    if #clients == 0 then
      local client_id = vim.lsp.start(lspconfig)
      if client_id then
        vim.lsp.buf_attach_client(bufnr, client_id)
      end
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "cs",
  callback = function()
    vim.bo.expandtab = true
    vim.bo.autoindent = true
    vim.bo.smartindent = true
  end,
})
