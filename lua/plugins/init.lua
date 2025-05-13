return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    lazy = false,
    config = function()
      vim.cmd([[colorscheme catppuccin-mocha]])
    end,
  },
  {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = 'nvim-tree/nvim-web-devicons',
    opts = function(_, opts)
      if (vim.g.colors_name or ""):find("catppuccin") then
        opts.highlights = require("catppuccin.groups.integrations.bufferline").get()
      end
    end,
    lazy = false,
    config = function()
      local function close_buffer_and_focus_neighbor()
        local current_buf = vim.api.nvim_get_current_buf()
        local bufferline = require("bufferline.state")
        local visible_buffers = bufferline.components

        local current_index = nil
        for i, comp in ipairs(visible_buffers) do
          if comp.id == current_buf then
            current_index = i
            break
          end
        end

        local function is_valid(buf)
          return vim.api.nvim_buf_is_valid(buf)
            and vim.bo[buf].buflisted
            and vim.bo[buf].filetype ~= "NvimTree"
        end

        local target_buf = nil

        if current_index then
          -- Try left
          for i = current_index - 1, 1, -1 do
            local buf = visible_buffers[i].id
            if is_valid(buf) then
              target_buf = buf
              break
            end
          end
          -- If no valid left buffer, try right
          if not target_buf then
            for i = current_index + 1, #visible_buffers do
              local buf = visible_buffers[i].id
              if is_valid(buf) then
                target_buf = buf
                break
              end
            end
          end
        end

        local function close_and_switch()
          vim.cmd("bd! " .. current_buf)
          if target_buf then
            vim.api.nvim_set_current_buf(target_buf)
          end
        end

        if vim.bo[current_buf].modified then
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(current_buf), ":t")
          vim.ui.input({ prompt = "Save changes to '" .. filename .. "' before closing? (y/n)" }, function(answer)
            if answer == "y" then
              vim.api.nvim_buf_call(current_buf, function()
                vim.cmd("write")
              end)
              close_and_switch()
            elseif answer == "n" then
              close_and_switch()
            else
              -- Do nothing (cancel)
            end
          end)
        else
          close_and_switch()
        end
      end

      local function delete_buffers_to_right()
        local current_buf = vim.api.nvim_get_current_buf()
        local bufferline = require("bufferline.state")
        local visible_buffers = bufferline.components

        local current_index = nil
        for i, comp in ipairs(visible_buffers) do
          if comp.id == current_buf then
            current_index = i
            break
          end
        end

        if not current_index then return end

        for i = #visible_buffers, current_index + 1, -1 do
          local buf = visible_buffers[i].id
          if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted and vim.bo[buf].filetype ~= "NvimTree" then
            if vim.bo[buf].modified then
              local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
              vim.ui.input({ prompt = "Save changes to '" .. filename .. "' before closing? (y/n)" }, function(answer)
                if answer == "y" then
                  vim.api.nvim_buf_call(buf, function()
                    vim.cmd("write")
                  end)
                end
                vim.cmd("bd! " .. buf)
              end)
            else
              vim.cmd("bd " .. buf)
            end
          end
        end
      end

      require("bufferline").setup()
      for i = 1, 9 do
        vim.keymap.set('n', '<leader>' .. i, '<Cmd>BufferLineGoToBuffer ' .. i .. '<CR>')
      end
      vim.keymap.set('n', '<leader>d', close_buffer_and_focus_neighbor, { silent = true })
      vim.keymap.set("n", "<leader>bd", delete_buffers_to_right)
    end,
  },
  {
    'mrcjkb/rustaceanvim',
    version = '^6',
    lazy = false,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")

      configs.setup({
        ensure_installed = { "lua", "vim", "vimdoc", "rust", "toml", "c_sharp" },
        sync_install = false,
        highlight = { enable = true },
        indent = { enable = true },
        enable = true,
      })
    end,
    lazy = false,
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '*',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-nvim-lsp-signature-help',
      'ryo33/nvim-cmp-rust',

      'L3MON4D3/LuaSnip',
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        mapping = {
          ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          -- Add tab support
          ['<S-Tab>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ['<Tab>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.close(),
          ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true,
          })
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'nvim_lua',               keyword_length = 2 },
          { name = 'buffer',                 keyword_length = 2 },
          { name = 'path' },
          { name = 'luasnip' },
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        formatting = {
          fields = { 'menu', 'abbr', 'kind' },
          format = function(entry, item)
            local menu_icon = {
              nvim_lsp = 'λ',
              vsnip = '⋗',
              buffer = 'Ω',
              path = '[]',
            }
            item.menu = menu_icon[entry.source.name]
            return item
          end,
        },
      })

      local compare = require "cmp.config.compare"
      cmp.setup.filetype({ "rust" }, {
        sorting = {
          priority_weight = 2,
          comparators = {
            -- deprioritize `.box`, `.mut`, etc.
            require("cmp-rust").deprioritize_postfix,
            -- deprioritize `Borrow::borrow` and `BorrowMut::borrow_mut`
            require("cmp-rust").deprioritize_borrow,
            -- deprioritize `Deref::deref` and `DerefMut::deref_mut`
            require("cmp-rust").deprioritize_deref,
            -- deprioritize `Into::into`, `Clone::clone`, etc.
            require("cmp-rust").deprioritize_common_traits,
            compare.offset,
            compare.exact,
            compare.score,
            compare.recently_used,
            compare.locality,
            compare.sort_text,
            compare.length,
            compare.order,
          },
        },
      })
    end,
    lazy = false,
  },
  {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      local function my_on_attach(bufnr)
        local api = require "nvim-tree.api"

        local function opts(desc)
          return {
            desc = "nvim-tree: " .. desc,
            buffer = bufnr,
            noremap = true,
            silent = true,
            nowait = true
          }
        end

        -- Default mappings
        api.config.mappings.default_on_attach(bufnr)

        -- Custom mappings
        vim.keymap.set("n", "?", api.tree.toggle_help, opts("Help"))
      end

      local function open_nvim_tree_at_git_root()
        -- Try to find the Git root
        local git_root = vim.fn.systemlist("git rev-parse --show-toplevel")[1]
        if vim.v.shell_error == 0 and git_root and git_root ~= "" then
          vim.cmd("cd " .. git_root)
        end

        -- Toggle tree
        require("nvim-tree.api").tree.open({ find_file = true, focus = true })
      end


      vim.keymap.set(
        "n",
        "<leader>t",
        open_nvim_tree_at_git_root
      )

      vim.keymap.set(
        "n",
        "<leader>T",
        require("nvim-tree.api").tree.close
      )

      require("nvim-tree").setup {
        on_attach = my_on_attach,
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = true
        },
        view = {
          width = 40,
        },
      }
    end,
    lazy = false,
  },
  {
    'stevearc/aerial.nvim',
    opts = {
      layout = {
        min_width = 40,
      }
    },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
    keys = {
      { "<leader>e", "<cmd>AerialOpen<cr>" },
      { "<leader>E", "<cmd>AerialClose<cr>" },
    },
    lazy = false,
  },
  {
    "voldikss/vim-floaterm",
    lazy = false,
    keys = {
      { "<leader>ft", ":FloatermNew --name=myfloat --height=1.0 --width=1.0 --autoclose=2 <CR> " },
      { "<leader>;",  ":FloatermToggle myfloat<CR>" },
      { "<Esc>",      "<C-\\><C-n>:q<CR>",                                                       mode = "t" },
    },
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    lazy = false,
    config = function()
      require('lualine').setup()
    end
  },
  {
    'williamboman/mason.nvim',
    config = function()
      require("mason").setup({
        registries = {
            "github:mason-org/mason-registry",
            "github:Crashdummyy/mason-registry",
        },
      })

      local mason_registry = require('mason-registry')

      local packages = {
        "lua-language-server",
        "roslyn",
        "ruby-lsp",
      }

      for _, pkg in ipairs(packages) do
        if not mason_registry.is_installed(pkg) then
          vim.cmd("MasonInstall " .. pkg)
        end
      end
    end,
    lazy = false,
  },
  {
    "editorconfig/editorconfig-vim",
    lazy = false,
  },
  {
    "seblyng/roslyn.nvim",
    ft = "cs",
    config = {
        cmd = {
            "dotnet",
            "<target>/Microsoft.CodeAnalysis.LanguageServer.dll",
            "--logLevel=Information",
            "--extensionLogDirectory=" .. vim.fs.dirname(vim.lsp.get_log_path()),
            "--stdio",
        },
    },
  },
  {
    {
      "lukas-reineke/indent-blankline.nvim",
      main = "ibl",
      lazy = false,
      config = function()
        require("ibl").setup()
      end,
    },
    {
      {
        "lewis6991/gitsigns.nvim",
        main = "gitsigns",
        lazy = false,
        config = function()
          require('gitsigns').setup({
            on_attach = function(bufnr)
              local gitsigns = require('gitsigns')

              local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
              end

              -- Navigation
              map('n', ']c', function()
                if vim.wo.diff then
                  vim.cmd.normal({']c', bang = true})
                else
                  gitsigns.nav_hunk('next')
                end
              end)

              map('n', '[c', function()
                if vim.wo.diff then
                  vim.cmd.normal({'[c', bang = true})
                else
                  gitsigns.nav_hunk('prev')
                end
              end)
            end
          })
        end,
      }
    },
  }
}
