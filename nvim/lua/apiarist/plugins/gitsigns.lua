return {
  {
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },

      on_attach = function(bufnr)
        local gitsigns = require 'gitsigns'

        local function map(mode, l, r, opts)
          opts = opts or {}
          opts.buffer = bufnr
          vim.keymap.set(mode, l, r, opts)
        end

        -- Navigation
        map('n', ']c', function()
          if vim.wo.diff then
            vim.cmd.normal { ']c', bang = true }
          else
            gitsigns.nav_hunk 'next'
          end
        end, { desc = 'Jump to next git [c]hange' })

        map('n', '[c', function()
          if vim.wo.diff then
            vim.cmd.normal { '[c', bang = true }
          else
            gitsigns.nav_hunk 'prev'
          end
        end, { desc = 'Jump to previous git [c]hange' })

        -- Actions

        -- visual mode
        map('v', '<leader>hs', function()
          gitsigns.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'stage git hunk' })

        map('v', '<leader>hr', function()
          gitsigns.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
        end, { desc = 'reset git hunk' })

        map('v', '<leader>hd', function()
          local start_line = vim.fn.line('v')
          local end_line = vim.fn.line('.')
          if start_line > end_line then
            start_line, end_line = end_line, start_line
          end

          -- Get all hunks
          local hunks = gitsigns.get_hunks()
          if not hunks then return end

          -- Find all hunks that intersect with our selection
          local matching_hunks = {}
          for _, hunk in ipairs(hunks) do
            local hunk_start = hunk.added.start
            local hunk_end = hunk.added.start + hunk.added.count - 1

            -- Check if hunk intersects with selection
            if hunk_start <= end_line and hunk_end >= start_line then
              table.insert(matching_hunks, hunk)
            end
          end

          if #matching_hunks == 0 then
            vim.notify("No git changes found in selection", vim.log.levels.INFO)
            return
          end

          -- Create a temporary buffer to show all diffs
          local buf = vim.api.nvim_create_buf(false, true)
          local lines = {}

          -- Add header
          if #matching_hunks == 1 then
            table.insert(lines, string.format("Diff for lines %d-%d:", start_line, end_line))
          else
            table.insert(lines, string.format("Diff for lines %d-%d (%d hunks):", start_line, end_line, #matching_hunks))
          end
          table.insert(lines, string.rep("=", 50))
          table.insert(lines, "")

          -- Show each matching hunk
          for i, hunk in ipairs(matching_hunks) do
            if i > 1 then
              table.insert(lines, "")
              table.insert(lines, string.rep("-", 30))
              table.insert(lines, "")
            end

            -- Add hunk header
            local hunk_info = string.format("@@ -%d,%d +%d,%d @@",
              hunk.removed.start, hunk.removed.count,
              hunk.added.start, hunk.added.count)
            table.insert(lines, hunk_info)

            -- Show removed lines
            if hunk.removed and hunk.removed.lines then
              for _, line in ipairs(hunk.removed.lines) do
                table.insert(lines, "- " .. line)
              end
            end

            -- Show added lines
            if hunk.added and hunk.added.lines then
              for _, line in ipairs(hunk.added.lines) do
                table.insert(lines, "+ " .. line)
              end
            end
          end

          vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
          vim.api.nvim_buf_set_option(buf, 'filetype', 'diff')

          -- Open in a floating window
          local width = math.floor(vim.o.columns * 0.9)
          local height = math.min(#lines + 2, math.floor(vim.o.lines * 0.8))
          local row = math.floor((vim.o.lines - height) / 2)
          local col = math.floor((vim.o.columns - width) / 2)

          local win = vim.api.nvim_open_win(buf, true, {
            relative = 'editor',
            width = width,
            height = height,
            row = row,
            col = col,
            border = 'rounded',
            title = 'Git Diff Preview',
            title_pos = 'center'
          })

          -- Set keymaps to close the window
          vim.keymap.set('n', 'q', '<cmd>close<cr>', { buffer = buf, silent = true })
          vim.keymap.set('n', '<Esc>', '<cmd>close<cr>', { buffer = buf, silent = true })
        end, { desc = 'show git diff for selection' })

        -- normal mode
        map('n', '<leader>hs', gitsigns.stage_hunk, { desc = 'git [s]tage hunk' })
        map('n', '<leader>hr', gitsigns.reset_hunk, { desc = 'git [r]eset hunk' })
        map('n', '<leader>hS', gitsigns.stage_buffer, { desc = 'git [S]tage buffer' })
        map('n', '<leader>hu', gitsigns.undo_stage_hunk, { desc = 'git [u]ndo stage hunk' })
        map('n', '<leader>hR', gitsigns.reset_buffer, { desc = 'git [R]eset buffer' })
        map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git [p]review hunk' })
        map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git [b]lame line' })
        map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git [d]iff against index' })
        map('n', '<leader>hD', function()
          gitsigns.diffthis '@'
        end, { desc = 'git [D]iff against last commit' })

        -- Toggles
        map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = '[T]oggle git show [b]lame line' })
        map('n', '<leader>tD', gitsigns.toggle_deleted, { desc = '[T]oggle git show [D]eleted' })
      end,
    },
  },
}
