-- Regression check for the recurring aerial.nvim <-> no-neck-pain.nvim fight.
-- Run: nvim --headless -c 'luafile nvim/tests/aerial-nnp.lua' -c 'qa!'
--
-- Drives the real <C-y> mapping rather than AerialOpen/AerialClose, because the
-- direct commands pass even when the mapping is broken -- which is how the
-- `AerialToggle!` bang hid a layout collapse across several fix attempts.

vim.cmd('edit ' .. vim.fn.stdpath('config') .. '/init.lua')
vim.o.columns, vim.o.lines = 200, 50

local main_win = vim.api.nvim_get_current_win()

--- Width of the editing window, a printable summary, whether focus is still on
--- it, and whether aerial is up. Floats (fidget, smear-cursor, ...) aren't part
--- of the layout, so they're skipped.
local function layout()
  local parts, main, has_aerial = {}, nil, false
  for _, id in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
    if vim.api.nvim_win_get_config(id).relative == '' then
      local width = vim.api.nvim_win_get_width(id)
      local ft = vim.bo[vim.api.nvim_win_get_buf(id)].filetype
      if id == main_win then
        main, ft = width, 'MAIN'
      elseif ft == 'aerial' then
        has_aerial = true
      end
      parts[#parts + 1] = ft .. ':' .. width
    end
  end
  table.sort(parts)
  return main, table.concat(parts, ' | '), vim.api.nvim_get_current_win() == main_win, has_aerial
end

local function show(tag)
  local main, summary, focused, has_aerial = layout()
  print(string.format('%-16s -> %-46s focus=%s', tag, summary, focused and 'MAIN' or vim.bo.filetype))
  return main, focused, has_aerial
end

-- <C-y> is a lazy.nvim load stub until aerial is pulled in; grab the real
-- callback afterwards, otherwise the first toggle silently does nothing.
require('lazy').load({ plugins = { 'aerial.nvim' } })
local toggle = assert(vim.fn.maparg('<C-y>', 'n', false, true).callback,
  '<C-y> is not mapped to a Lua callback -- did the aerial keys spec change?')

vim.cmd('NoNeckPain')
vim.wait(400)
assert(_G.NoNeckPain.state and _G.NoNeckPain.state.enabled, 'no-neck-pain failed to enable')
local centered = show('nnp on')

-- Loop: the broken version degraded a bit further on each cycle.
for i = 1, 3 do
  toggle()
  vim.wait(600)
  local open, focused, has_aerial = show('cycle ' .. i .. ' open')
  assert(has_aerial, 'aerial did not open')
  assert(focused, 'focus was left in the outline')
  -- Aerial takes over the right padding, so the text widens a little -- but it
  -- must still be padded, not stretched across the whole terminal.
  assert(open < vim.o.columns - 20, 'centering was lost while aerial was open')

  -- When no-neck-pain loses track of aerial, its re-init scrambles the widths.
  vim.cmd('doautocmd VimResized')
  vim.wait(600)
  local resized = show('cycle ' .. i .. ' resize')
  assert(math.abs(resized - open) <= 2,
    string.format('resize disturbed the layout: MAIN %d -> %d', open, resized))

  toggle()
  vim.wait(800)
  local restored, back = show('cycle ' .. i .. ' closed')
  assert(vim.api.nvim_win_is_valid(main_win), 'main window was destroyed rebuilding the layout')
  assert(_G.NoNeckPain.state.enabled, 'no-neck-pain turned itself off when aerial closed')
  assert(back, 'focus was left in the outline after closing')
  assert(restored == centered,
    string.format('centering not restored: %d, expected %d', restored, centered))
end

print('PASS')
