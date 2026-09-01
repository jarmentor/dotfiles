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

      -- JSON/YAML schema support
      'b0o/schemastore.nvim',
    },
    config = function()
      -- Float borders now come from vim.o.winborder = 'rounded' (options.lua)

      -- Better diagnostic configuration
      vim.diagnostic.config({
        virtual_text = false,
        float = {
          source = 'always',
          border = 'rounded',
        },
        severity_sort = true,
        update_in_insert = false,
      })

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

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

          -- Hover documentation (buffer-local so keywordprg K survives elsewhere)
          map('K', vim.lsp.buf.hover, 'Hover Documentation')
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
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

          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
            map('<leader>th', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
            end, '[T]oggle Inlay [H]ints')
          end
        end,
      })

      local capabilities = require('blink.cmp').get_lsp_capabilities()
      -- Without this nvim-ufo silently falls back to indent folding
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      -- Merged over nvim-lspconfig's lsp/ defaults. root_markers, not root_dir:
      -- lspconfig.util's functions are the old framework's signature.
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
          filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
          root_markers = { 'compile_commands.json', 'compile_flags.txt', '.git' },
        },

        emmet_language_server = {
          -- No php: phpactor owns that filetype alone
          filetypes = { 'html', 'astro', 'css', 'javascript', 'typescript', 'vue', 'svelte', 'javascriptreact', 'typescriptreact' },
          root_markers = { '.git' },
        },

        graphql = {
          filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'graphql' },
        },

        -- TypeScript/JavaScript language server (diagnostics, completion, go-to-def)
        ts_ls = {},

        phpactor = {
          -- Tiered so the site root beats a nested plugin/theme composer.json.
          -- Never functions.php: every theme has one, stranding the index there.
          root_markers = { { '.phpactor.json', 'wp-config.php' }, { 'composer.json', '.git' } },
        },

        -- Defaults include php/scss, which makes it index vendored scss in WP repos
        tailwindcss = {
          filetypes = { 'astro', 'html', 'css', 'javascript', 'typescript', 'javascriptreact', 'typescriptreact', 'svelte', 'vue' },
          root_markers = {
            'tailwind.config.js',
            'tailwind.config.cjs',
            'tailwind.config.mjs',
            'tailwind.config.ts',
          },
        },

        lua_ls = {
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

        -- Defaults include php/lua/sh/c, i.e. spellchecking your source code
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

        texlab = {
          settings = {
            texlab = {
              build = {
                executable = 'latexmk',
                args = { '-pdf', '-interaction=nonstopmode', '-synctex=1', '%f' },
                onSave = true,
              },
              forwardSearch = {
                executable = 'skim',
                args = { '--synctex-forward', '%l:1:%f', '%p' },
              },
              chktex = {
                onOpenAndSave = true,
                onEdit = false,
              },
              diagnosticsDelay = 300,
              latexFormatter = 'latexindent',
              latexindent = {
                modifyLineBreaks = false,
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
              schemas = require('schemastore').yaml.schemas(),
              format = {
                enable = true,
                singleQuote = true,
              },
              validate = true,
            },
          },
        },

        jsonls = {
          settings = {
            json = {
              schemas = require('schemastore').json.schemas(),
              validate = { enable = true },
            },
          },
        },

        bashls = {},

        sqlls = {},
      }

      vim.lsp.config('*', { capabilities = capabilities })
      for name, cfg in pairs(servers) do
        vim.lsp.config(name, cfg)
      end

      -- Ensure the servers and tools above are installed
      --  To check the current status of installed tools and/or manually install
      --  other tools, you can run
      --    :Mason
      --
      --  You can press `g?` for help in this menu.
      require('mason').setup()

      -- You can add other tools here that you want Mason to install
      -- for you, so that they are available from within Neovim.
      -- tailwindcss excluded: its Mason package name differs, listed below
      local ensure_installed = {}
      for name in pairs(servers) do
        if name ~= 'tailwindcss' then
          table.insert(ensure_installed, name)
        end
      end
      vim.list_extend(ensure_installed, {
        'stylua', -- Used to format Lua code
        'tailwindcss-language-server',
        'latexindent', -- LaTeX formatter
      })
      require('mason-tool-installer').setup { ensure_installed = ensure_installed }

      -- v2 silently ignores `handlers` and `automatic_installation`
      require('mason-lspconfig').setup {
        ensure_installed = {},
        -- Everything Mason installs auto-starts; these three double up on a
        -- filetype already covered (oxfmt is wanted as a formatter, not an LSP)
        automatic_enable = {
          exclude = { 'phpantom_lsp', 'markdown_oxide', 'oxfmt' },
        },
      }
    end,
  },
}
