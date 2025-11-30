return {
  'lervag/vimtex',
  ft = { 'tex', 'latex', 'bib' },
  init = function()
    -- PDF viewer with SyncTeX support
    vim.g.vimtex_view_method = 'skim'

    -- Compiler settings
    vim.g.vimtex_compiler_method = 'latexmk'
    vim.g.vimtex_compiler_latexmk = {
      options = {
        '-pdf',
        '-shell-escape',
        '-verbose',
        '-file-line-error',
        '-synctex=1',
        '-interaction=nonstopmode',
      },
    }

    -- Don't open quickfix on warnings, only errors
    vim.g.vimtex_quickfix_mode = 0

    -- Disable default mappings, use which-key friendly ones
    vim.g.vimtex_mappings_enabled = 1

    -- TOC settings
    vim.g.vimtex_toc_config = {
      split_pos = 'vert leftabove',
      split_width = 40,
    }

    -- Concealment settings for cleaner display
    vim.g.vimtex_syntax_conceal = {
      accents = 1,
      cites = 1,
      fancy = 1,
      greek = 1,
      math_bounds = 1,
      math_delimiters = 1,
      math_fracs = 1,
      math_super_sub = 1,
      math_symbols = 1,
      sections = 0,
      styles = 1,
    }
  end,
}
