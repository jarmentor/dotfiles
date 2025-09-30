return {
  {
    'kylechui/nvim-surround',
    version = '*',
    event = 'VeryLazy',
    config = function()
      require('nvim-surround').setup {
        keymaps = {
          normal = 'ys',
          normal_cur = 'yss',
          normal_line = 'yS',
          normal_cur_line = 'ySS',
          visual = 'S',
          visual_line = 'gS',
          delete = 'ds',
          change = 'cs',
        },
        surrounds = {
          -- HTML shortcuts (work in all filetypes)
          ['d'] = { add = { '<div>', '</div>' } },
          ['p'] = { add = { '<p>', '</p>' } },
          ['s'] = { add = { '<span>', '</span>' } },
          ['l'] = { add = { '<li>', '</li>' } },
          -- Dynamic tag with prompt (supports attributes!)
          ['t'] = {
            add = function()
              local tag = vim.fn.input 'Tag (with attributes): '
              if tag ~= '' then
                -- Extract just the tag name for closing tag
                local tag_name = tag:match('^(%S+)')
                return { { '<' .. tag .. '>' }, { '</' .. tag_name .. '>' } }
              end
            end,
          },
          -- Emmet-style expansion: supports classes, IDs, and attributes
          -- Examples: div.container, p#blue, a[href="#"], button[type="submit"].btn
          ['e'] = {
            add = function()
              local input = vim.fn.input 'Emmet (e.g., div.container, a[href="#"]): '
              if input == '' then return end

              -- Parse tag name (default to div if not specified)
              local tag = input:match('^([a-zA-Z0-9]+)') or 'div'

              -- Extract classes (everything after . but before # or [)
              local classes = {}
              for class in input:gmatch('%.([a-zA-Z0-9_-]+)') do
                table.insert(classes, class)
              end

              -- Extract id (everything after # but before [)
              local id = input:match('#([a-zA-Z0-9_-]+)')

              -- Extract attributes from [attr="value"] or [attr]
              local custom_attrs = {}
              for attr_block in input:gmatch('%[([^%]]+)%]') do
                -- Handle attr="value" or attr='value' or just attr
                local attr_name, attr_value = attr_block:match('([^=]+)="([^"]*)"')
                if not attr_name then
                  attr_name, attr_value = attr_block:match("([^=]+)='([^']*)'")
                end
                if not attr_name then
                  attr_name = attr_block
                  attr_value = nil
                end

                if attr_name then
                  attr_name = vim.trim(attr_name)
                  if attr_value then
                    table.insert(custom_attrs, attr_name .. '="' .. attr_value .. '"')
                  else
                    table.insert(custom_attrs, attr_name)
                  end
                end
              end

              -- Build opening tag
              local attrs = {}
              if id then
                table.insert(attrs, 'id="' .. id .. '"')
              end
              if #classes > 0 then
                table.insert(attrs, 'class="' .. table.concat(classes, ' ') .. '"')
              end
              -- Add custom attributes
              for _, attr in ipairs(custom_attrs) do
                table.insert(attrs, attr)
              end

              local opening = '<' .. tag
              if #attrs > 0 then
                opening = opening .. ' ' .. table.concat(attrs, ' ')
              end
              opening = opening .. '>'

              local closing = '</' .. tag .. '>'

              return { { opening }, { closing } }
            end,
          },
        },
      }
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    event = 'InsertEnter',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('nvim-ts-autotag').setup {
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false,
        },
      }
    end,
  },
}