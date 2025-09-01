#!/bin/bash

# Ollama performance optimization settings for Neovim integration
echo "Setting up Ollama for optimal Neovim code completion..."

# Export environment variables for optimal performance
export OLLAMA_NUM_PARALLEL=2
export OLLAMA_MAX_LOADED_MODELS=1
export OLLAMA_KEEP_ALIVE=24h
export OLLAMA_HOST=127.0.0.1:11434

# Add to shell rc file if not already present
SHELL_RC="$HOME/.zshrc"
if [ -f "$HOME/.bashrc" ] && [ ! -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.bashrc"
fi

if ! grep -q "OLLAMA_NUM_PARALLEL" "$SHELL_RC" 2>/dev/null; then
    echo "" >> "$SHELL_RC"
    echo "# Ollama optimization for Neovim code completion" >> "$SHELL_RC"
    echo "export OLLAMA_NUM_PARALLEL=2" >> "$SHELL_RC"
    echo "export OLLAMA_MAX_LOADED_MODELS=1" >> "$SHELL_RC"
    echo "export OLLAMA_KEEP_ALIVE=24h" >> "$SHELL_RC"
    echo "export OLLAMA_HOST=127.0.0.1:11434" >> "$SHELL_RC"
    echo "Added Ollama environment variables to $SHELL_RC"
fi

# Ensure Ollama is running
if ! pgrep -x "ollama" > /dev/null; then
    echo "Starting Ollama service..."
    ollama serve &
    sleep 2
fi

# Pre-load the optimized model
echo "Pre-loading optimized model..."
ollama run qwen-code-optimized "test" > /dev/null 2>&1 &

echo "Ollama setup complete!"
echo ""
echo "Neovim keybindings for ghost text:"
echo "  <C-j>  - Accept full suggestion"
echo "  <C-l>  - Accept current line only"
echo "  <C-n>  - Next suggestion"
echo "  <C-p>  - Previous suggestion"
echo "  <C-e>  - Dismiss suggestion"
echo ""
echo "To use a faster model for better performance, update minuet-ai.lua:"
echo "  model = 'llama3.2:1b'  (fastest, basic quality)"
echo "  model = 'gemma3:4b'    (fast, good quality)"
echo "  model = 'qwen2.5-coder:7b' (current, best quality)"