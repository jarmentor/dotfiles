return {
  {
    'saghen/blink.cmp',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = 'rafamadriz/friendly-snippets',
    version = 'v0.*',
    opts = {
      keymap = {
        preset = 'default',
        ['<CR>'] = { 'accept', 'fallback' },
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        ['<C-n>'] = { 'select_next', 'fallback' },
        ['<C-p>'] = { 'select_prev', 'fallback' },
        ['<C-y>'] = { 'accept', 'fallback' },
        ['<C-e>'] = { 'cancel', 'fallback' },
      },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
      },
      completion = {
        ghost_text = {
          enabled = true,
        },
      },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' },
        per_filetype = {
          markdown = { 'lsp', 'path', 'snippets', 'buffer' },
        },
      },
      cmdline = {
        keymap = {
          preset = 'default',
          ['<Tab>'] = { 'select_next', 'fallback' },
          ['<S-Tab>'] = { 'select_prev', 'fallback' },
          ['<C-n>'] = { 'select_next', 'fallback' },
          ['<C-p>'] = { 'select_prev', 'fallback' },
          ['<CR>'] = { 'accept', 'fallback' },
          ['<Right>'] = { 'accept', 'fallback' },
          ['<C-y>'] = { 'accept', 'fallback' },
          ['<C-e>'] = { 'cancel', 'fallback' },
        },
        completion = {
          menu = { auto_show = true },
          ghost_text = { enabled = true },
          list = { selection = { preselect = false, auto_insert = false } },
        },
      },
      signature = { 
        enabled = true,
        window = {
          border = 'rounded',
          winblend = 0,
          winhighlight = 'Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder'
        }
      }
    }
  }
}
