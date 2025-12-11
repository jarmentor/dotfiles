return { -- Useful plugin to show you pending keybinds.
  'folke/which-key.nvim',
  event = 'VimEnter', -- Sets the loading event to 'VimEnter'
  config = function() -- This is the function that runs, AFTER loading
    require('which-key').setup()

    -- Document existing key chains
    require('which-key').add {
      { '<leader>b', group = '[B]uffer' },
      { '<leader>c', group = '[C]ode' },
      { '<leader>d', group = '[D]ocument' },
      { '<leader>g', group = '[G]it' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } },
      { '<leader>l', group = '[L]SP' },
      { '<leader>o', group = '[O]bsidian' },
      { '<leader>r', group = '[R]ename' },
      { '<leader>s', group = '[S]earch' },
      { '<leader>S', group = '[S]ession' },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>w', group = '[W]indow', mode = { 'n', 'v' } },
      { '<leader>x', group = 'Diagnostics/Trouble' },
      { '<leader>y', group = '[Y]ank' },
    }
  end,
}
