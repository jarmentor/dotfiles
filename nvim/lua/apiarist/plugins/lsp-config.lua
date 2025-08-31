return {
  {
    -- `lazydev` configures Lua LSP for your Neovim config, runtime and plugins
    -- used for completion, annotations and signatures of Neovim apis
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true },
  {
    -- Main LSP Configuration
    'neovim/nvim-lspconfig',
    dependencies = {
      -- Automatically install LSPs and related tools to stdpath for Neovim
      { 'williamboman/mason.nvim', config = true }, -- NOTE: Must be loaded before dependants
      'williamboman/mason-lspconfig.nvim',
      'WhoIsSethDaniel/mason-tool-installer.nvim',

      -- Useful status updates for LSP.
      -- NOTE: `opts = {}` is the same as calling `require('fidget').setup({})`
      { 'j-hui/fidget.nvim', opts = {} },

      -- Allows extra capabilities provided by blink.cmp
      'saghen/blink.cmp',
    },
    config = function()
      -- Override LSP floating window defaults
      local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
      function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
        opts = opts or {}
        opts.border = 'rounded'
        opts.pad_top = 1
        opts.pad_bottom = 1
        return orig_util_open_floating_preview(contents, syntax, opts, ...)
      end

      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', require('snacks').picker.lsp_definitions, '[G]oto [D]efinition')

          -- Find references for the word under your cursor.
          map('gr', require('snacks').picker.lsp_references, '[G]oto [R]eferences')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', require('snacks').picker.lsp_implementations, '[G]oto [I]mplementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>D', require('snacks').picker.lsp_type_definitions, 'Type [D]efinition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>ds', require('snacks').picker.lsp_symbols, '[D]ocument [S]ymbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<leader>ws', require('snacks').picker.lsp_symbols, '[W]orkspace [S]ymbols')

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
              end,
            })
          end

          if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend('force', capabilities, require('blink.cmp').get_lsp_capabilities())

      local servers = {
        cssls = {
          settings = {
            css = {
              validate = true,
              lint = {
                unknownAtRules = 'ignore',
              },
            },
            scss = {
              validate = true,
            },
            less = {
              validate = true,
            },
          },
        },

        clangd = {
          cmd = { 'clangd', '--background-index', '--clang-tidy', '--header-insertion=never' },
          capabilities = capabilities,
          filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
          root_dir = require('lspconfig').util.root_pattern('.git', 'compile_commands.json', 'compile_flags.txt'),
        },

        emmet_language_server = {
          filetypes = { 'html', 'astro', 'css', 'javascript', 'typescript', 'php', 'vue', 'javascriptreact', 'typescriptreact' },
          root_dir = require('lspconfig').util.find_git_ancestor,
          single_file_support = true,
        },

        graphql = {
          filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'graphql' },
        },

        phpactor = {
          capabilities = capabilities,
          root_dir = require('lspconfig').util.root_pattern('composer.json', 'wp-config.php', 'functions.php', '.git'),
        },

        lua_ls = {
          -- cmd = {...},
          -- filetypes = { ...},
          -- capabilities = {},
          settings = {
            Lua = {
              completion = {
                callSnippet = 'Replace',
              },
              diagnostics = { disable = { 'missing-fields' } },
            },
          },
        },

        stylelint_lsp = {
          filetypes = {
            'css',
            'scss',
            'less',
            'html',
            'astro',
          },
          settings = {
            stylelintplus = {
              autoFixOnFormat = true,
              autoFixOnSave = true,
              validateOnType = true,
              validateOnSave = true,
            },
          },
        },

        harper_ls = {
          filetypes = { 'markdown', 'text' },
          settings = {
            ['harper-ls'] = {
              diagnostics = {
                severity = 'hint', -- Use hint level to avoid overwhelming interface
              },
            },
          },
        },

        yamlls = {
          filetypes = { 'yaml', 'yml' },
          settings = {
            yaml = {
              schemaStore = {
                enable = false,
                url = '',
              },
              schemas = {
                ['http://json.schemastore.org/github-workflow'] = '.github/workflows/*',
                ['https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json'] = '*docker-compose*.{yml,yaml}',
                ['http://json.schemastore.org/prettierrc'] = '.prettierrc.{yml,yaml}',
                ['http://json.schemastore.org/github-action'] = '.github/action.{yml,yaml}',
              },
              format = {
                enable = true,
                singleQuote = true,
              },
              yaml = {
                validate = true,
              },
            },
          },
        },
      }

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
      require('mason').setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      local ensure_installed = vim.tbl_keys(servers or {})
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'tailwindcss-language-server',
        'sqlls',
        'bashls',
        'jsonls',
        'markdown_oxide',
        'harper_ls', -- Fast grammar checking
        'phpactor',
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      require('mason-lspconfig').setup {
        automatic_installation = true,
        ensure_installed = {},
        handlers = {
          function(server_name)
            local server = servers[server_name] or {}
            -- This handles overriding only values explicitly passed
            -- by the server configuration above. Useful when disabling
            -- certain features of an LSP (for example, turning off formatting for tsserver)
            server.capabilities = vim.tbl_deep_extend('force', {}, capabilities, server.capabilities or {})
            -- Special setup for Tailwind CSS LSP to include .astro files
            if server_name == 'tailwindcss-language-server' then
              require('lspconfig')[server_name].setup {
                filetypes = { 'astro', 'html', 'css', 'javascript', 'typescript' },
              }
            else
              require('lspconfig')[server_name].setup(server)
            end
          end,
        },
      }
    end,
  },
}
