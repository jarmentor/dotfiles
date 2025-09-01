# Ollama Configuration for Neovim Code Completion

This directory contains optimized Ollama configurations for GitHub Copilot-like ghost text completions in Neovim.

## Files

- `qwen-code-optimized.modelfile` - Optimized model configuration for code completion
- `ollama.env` - Environment variables for performance optimization
- `setup.sh` - Setup script for initializing Ollama

## Installation

Run from the root dotfiles directory:
```bash
make ollama-setup
```

## Model Options

The configuration uses `qwen2.5-coder:7b` by default. You can modify the model in `nvim/lua/apiarist/plugins/minuet-ai.lua`:

- `llama3.2:1b` - Fastest, basic quality (200-300ms latency)
- `gemma3:4b` - Fast, good quality (400-500ms latency)
- `qwen2.5-coder:7b` - Best quality (600-800ms latency)
- `deepcoder:14b` - Excellent for complex code (1000-1200ms latency)

## Keybindings

- `<C-j>` - Accept full suggestion
- `<C-l>` - Accept current line only
- `<C-n>` - Next suggestion
- `<C-p>` - Previous suggestion
- `<C-e>` - Dismiss suggestion