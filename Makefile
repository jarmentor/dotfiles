.PHONY: help install uninstall link unlink status clean ollama-setup ollama-status ollama-models

# Default target
help:
	@echo "Available targets:"
	@echo "  install       - Install all dotfiles (create symlinks)"
	@echo "  uninstall     - Remove all symlinks"
	@echo "  link          - Alias for install"
	@echo "  unlink        - Alias for uninstall"
	@echo "  status        - Show symlink status"
	@echo "  clean         - Remove broken symlinks"
	@echo "  ollama-setup  - Configure Ollama for Neovim code completion"
	@echo "  ollama-status - Check Ollama service and models"
	@echo "  ollama-models - List available Ollama models"
	@echo "  help          - Show this help message"

# Install dotfiles by creating symlinks
install link:
	@echo "Creating symlinks for dotfiles..."
	@ln -sf $(PWD)/.zshrc ~/.zshrc
	@ln -sf $(PWD)/.vimrc ~/.vimrc
	@ln -sf $(PWD)/.tmux.conf ~/.tmux.conf
	@ln -sf $(PWD)/.gitconfig ~/.gitconfig
	@ln -sf $(PWD)/.gitignore ~/.gitignore
	@ln -sf $(PWD)/.editorconfig ~/.editorconfig
	@ln -sf $(PWD)/.stylelintrc ~/.stylelintrc
	@ln -sf $(PWD)/.markdownlint.json ~/.markdownlint.json
	@ln -sf $(PWD)/.taskrc ~/.taskrc
	@ln -sf $(PWD)/phpactor.json ~/.config/phpactor/phpactor.json
	@mkdir -p ~/.config/ghostty
	@ln -sf $(PWD)/ghostty.config ~/.config/ghostty/config
	@rm -rf ~/.config/nvim
	@ln -sf $(PWD)/nvim ~/.config/nvim
	@mkdir -p ~/.config/spotify_player
	@ln -sf $(PWD)/spotify-player/app.toml ~/.config/spotify_player/app.toml
	@mkdir -p ~/.local/bin
	@ln -sf $(PWD)/tmux/tmux-sessionizer.sh ~/.local/bin/tmux-sessionizer
	@ln -sf $(PWD)/tmux/session-fzf.sh ~/.local/bin/session-fzf
	@chmod +x $(PWD)/tmux/tmux-sessionizer.sh
	@chmod +x $(PWD)/tmux/session-fzf.sh
	@chmod +x $(PWD)/tmux/preview-helper.sh
	@echo "Dotfiles installed successfully!"

# Remove symlinks
uninstall unlink:
	@echo "Removing dotfiles symlinks..."
	@rm -f ~/.zshrc
	@rm -f ~/.vimrc
	@rm -f ~/.tmux.conf
	@rm -f ~/.gitconfig
	@rm -f ~/.gitignore
	@rm -f ~/.editorconfig
	@rm -f ~/.stylelintrc
	@rm -f ~/.markdownlint.json
	@rm -f ~/.taskrc
	@rm -f ~/.config/phpactor/phpactor.json
	@rm -f ~/.config/ghostty/config
	@rm -rf ~/.config/nvim
	@rm -f ~/.config/spotify_player/app.toml
	@rm -f ~/.local/bin/tmux-sessionizer
	@rm -f ~/.local/bin/session-fzf
	@echo "Dotfiles uninstalled successfully!"

# Show status of symlinks
status:
	@echo "Checking dotfiles symlink status:"
	@printf "~/.zshrc: "; [ -L ~/.zshrc ] && echo "✓ linked" || echo "✗ not linked"
	@printf "~/.vimrc: "; [ -L ~/.vimrc ] && echo "✓ linked" || echo "✗ not linked"
	@printf "~/.tmux.conf: "; [ -L ~/.tmux.conf ] && echo "✓ linked" || echo "✗ not linked"
	@printf "~/.gitconfig: "; [ -L ~/.gitconfig ] && echo "✓ linked" || echo "✗ not linked"
	@printf "~/.gitignore: "; [ -L ~/.gitignore ] && echo "✓ linked" || echo "✗ not linked"
	@printf "~/.editorconfig: "; [ -L ~/.editorconfig ] && echo "✓ linked" || echo "✗ not linked"
	@printf "~/.stylelintrc: "; [ -L ~/.stylelintrc ] && echo "✓ linked" || echo "✗ not linked"
	@printf "~/.markdownlint.json: "; [ -L ~/.markdownlint.json ] && echo "✓ linked" || echo "✗ not linked"
	@printf "~/.taskrc: "; [ -L ~/.taskrc ] && echo "✓ linked" || echo "✗ not linked"
	@printf "~/.config/phpactor/phpactor.json: "; [ -L ~/.config/phpactor/phpactor.json ] && echo "✓ linked" || echo "✗ not linked"
	@printf "~/.config/ghostty/config: "; [ -L ~/.config/ghostty/config ] && echo "✓ linked" || echo "✗ not linked"
	@printf "~/.config/nvim: "; [ -L ~/.config/nvim ] && echo "✓ linked" || echo "✗ not linked"
	@printf "~/.config/spotify_player/app.toml: "; [ -L ~/.config/spotify_player/app.toml ] && echo "✓ linked" || echo "✗ not linked"
	@printf "~/.local/bin/tmux-sessionizer: "; [ -L ~/.local/bin/tmux-sessionizer ] && echo "✓ linked" || echo "✗ not linked"
	@printf "~/.local/bin/session-fzf: "; [ -L ~/.local/bin/session-fzf ] && echo "✓ linked" || echo "✗ not linked"

# Clean broken symlinks
clean:
	@echo "Cleaning broken symlinks..."
	@find ~ -maxdepth 3 -type l ! -exec test -e {} \; -print 2>/dev/null | grep -E "(\.zshrc|\.vimrc|\.tmux\.conf|\.gitconfig|\.gitignore|\.editorconfig|\.stylelintrc|\.markdownlint\.json|\.taskrc|phpactor\.json|ghostty|nvim)" | xargs rm -f 2>/dev/null || true
	@echo "Broken symlinks cleaned!"

# Ollama setup for Neovim code completion
ollama-setup:
	@echo "Setting up Ollama for Neovim code completion..."
	@# Ensure Ollama is installed
	@which ollama > /dev/null || (echo "Error: Ollama is not installed. Please install from https://ollama.ai" && exit 1)
	@# Create optimized model configuration
	@echo "Creating optimized model for code completion..."
	@ollama create qwen-code-optimized -f $(PWD)/ollama/qwen-code-optimized.modelfile 2>/dev/null || echo "Model already exists or created"
	@# Set environment variables
	@echo "Configuring environment variables..."
	@if ! grep -q "OLLAMA_NUM_PARALLEL" ~/.zshrc 2>/dev/null; then \
		echo "" >> ~/.zshrc; \
		echo "# Ollama optimization for Neovim code completion" >> ~/.zshrc; \
		cat $(PWD)/ollama/ollama.env | sed 's/^/export /' >> ~/.zshrc; \
		echo "Added Ollama environment variables to ~/.zshrc"; \
	else \
		echo "Environment variables already configured"; \
	fi
	@# Ensure MINUET_API_KEY is set in current session
	@export MINUET_API_KEY=OLLAMA_LOCAL
	@# Ensure Ollama service is running
	@if ! pgrep -x "ollama" > /dev/null; then \
		echo "Starting Ollama service..."; \
		ollama serve > /dev/null 2>&1 & \
		sleep 2; \
	fi
	@# Pre-load the model
	@echo "Pre-loading optimized model..."
	@ollama run qwen-code-optimized "test" > /dev/null 2>&1 &
	@echo ""
	@echo "✓ Ollama setup complete!"
	@echo ""
	@echo "Neovim keybindings for ghost text:"
	@echo "  <C-j>  - Accept full suggestion"
	@echo "  <C-l>  - Accept current line only"
	@echo "  <C-n>  - Next suggestion"
	@echo "  <C-p>  - Previous suggestion"
	@echo "  <C-e>  - Dismiss suggestion"
	@echo ""
	@echo "To change models, edit nvim/lua/apiarist/plugins/minuet-ai.lua"

# Check Ollama status
ollama-status:
	@echo "Checking Ollama status..."
	@if pgrep -x "ollama" > /dev/null; then \
		echo "✓ Ollama service is running"; \
	else \
		echo "✗ Ollama service is not running"; \
		echo "  Run 'ollama serve' to start it"; \
	fi
	@echo ""
	@echo "Testing API endpoint..."
	@if curl -s http://localhost:11434/api/tags > /dev/null 2>&1; then \
		echo "✓ API endpoint is accessible"; \
		echo ""; \
		echo "Currently loaded models:"; \
		@ollama ps 2>/dev/null || echo "  No models currently loaded"; \
	else \
		echo "✗ API endpoint is not accessible"; \
	fi

# List available Ollama models
ollama-models:
	@echo "Available Ollama models:"
	@ollama list 2>/dev/null | tail -n +2 | awk '{printf "  %-25s %s\n", $$1, $$3}' || echo "Error: Could not list models"
	@echo ""
	@echo "Recommended for code completion:"
	@echo "  Fast:     llama3.2:1b, gemma3:4b"
	@echo "  Balanced: qwen2.5-coder:7b (recommended)"
	@echo "  Quality:  deepcoder:14b, gpt-oss:20b"