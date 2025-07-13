.PHONY: help install uninstall link unlink status clean

# Default target
help:
	@echo "Available targets:"
	@echo "  install   - Install all dotfiles (create symlinks)"
	@echo "  uninstall - Remove all symlinks"
	@echo "  link      - Alias for install"
	@echo "  unlink    - Alias for uninstall"
	@echo "  status    - Show symlink status"
	@echo "  clean     - Remove broken symlinks"
	@echo "  help      - Show this help message"

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
	@ln -sf $(PWD)/.taskrc ~/.taskrc
	@ln -sf $(PWD)/phpactor.json ~/.config/phpactor/phpactor.json
	@mkdir -p ~/.config/ghostty
	@ln -sf $(PWD)/ghostty.config ~/.config/ghostty/config
	@rm -rf ~/.config/nvim
	@ln -sf $(PWD)/nvim ~/.config/nvim
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
	@rm -f ~/.taskrc
	@rm -f ~/.config/phpactor/phpactor.json
	@rm -f ~/.config/ghostty/config
	@rm -rf ~/.config/nvim
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
	@printf "~/.taskrc: "; [ -L ~/.taskrc ] && echo "✓ linked" || echo "✗ not linked"
	@printf "~/.config/phpactor/phpactor.json: "; [ -L ~/.config/phpactor/phpactor.json ] && echo "✓ linked" || echo "✗ not linked"
	@printf "~/.config/ghostty/config: "; [ -L ~/.config/ghostty/config ] && echo "✓ linked" || echo "✗ not linked"
	@printf "~/.config/nvim: "; [ -L ~/.config/nvim ] && echo "✓ linked" || echo "✗ not linked"

# Clean broken symlinks
clean:
	@echo "Cleaning broken symlinks..."
	@find ~ -maxdepth 3 -type l ! -exec test -e {} \; -print 2>/dev/null | grep -E "(\.zshrc|\.vimrc|\.tmux\.conf|\.gitconfig|\.gitignore|\.editorconfig|\.stylelintrc|\.taskrc|phpactor\.json|ghostty|nvim)" | xargs rm -f 2>/dev/null || true
	@echo "Broken symlinks cleaned!"