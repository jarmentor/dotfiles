return {
  'milanglacier/minuet-ai.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'Saghen/blink.cmp',
  },
  config = function()
    require('minuet').setup {
      provider = 'openai_fim_compatible',

      -- Performance tuning optimized for your hardware
      context_window = 8192,
      context_ratio = 0.75,
      throttle = 800,
      debounce = 400,
      request_timeout = 2.5,
      n_completions = 1,

      -- Ollama configuration using your best model
      provider_options = {
        openai_fim_compatible = {
          api_key = 'TERM',
          name = 'Ollama',
          end_point = 'http://localhost:11434/v1/completions',
          model = 'qwen2.5-coder:7b',
          optional = {
            max_tokens = 128,
            temperature = 0.1,
            top_p = 0.9,
            stop = { '\n\n', 'EOF', '<|fim_end|>' },
          },
        },
      },

      -- Ghost text configuration
      virtualtext = {
        auto_trigger_ft = { 'javascript', 'typescript', 'lua', 'rust', 'go', 'c', 'cpp', 'java', 'tsx', 'jsx', 'vue', 'svelte', 'php' },
        keymap = {
          accept = '<C-j>',
          accept_line = '<C-l>',
          next = '<C-n>',
          prev = '<C-p>',
          dismiss = '<C-e>',
        },
      },
    }
  end,
}
