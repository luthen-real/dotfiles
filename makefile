# CURRDIR = directory of makefile

default:
	@echo $(CURDIR)

prereq: 
	@mkdir -p $(HOME)/.config

gui: prereq
	@ln -fs  $(CURDIR)/config/alacritty $(HOME)/.config
	@ln -fs  $(CURDIR)/config/sway $(HOME)/.config/sway

cli: prereq # bash, tmux, zsh, scripts
	@ln -fs  $(CURDIR)/config/zshrc $(HOME)/.zshrc
	@ln -fs  $(CURDIR)/config/zsh/funcs $(HOME)/.funcs
	@ln -fs  $(CURDIR)/config/zsh/aliases $(HOME)/.aliases
	@ln -fs  $(CURDIR)/config/warprc $(HOME)/.warprc
	@ln -fs  $(CURDIR)/config/aliases $(HOME)/.aliases
	@ln -fs  $(CURDIR)/config/bashrc $(HOME)/.bashrc
	@ln -fs  $(CURDIR)/config/tmux.conf $(HOME)/.tmux.conf
	@ln -fs  $(CURDIR)/config/bin $(HOME)/.local
	@ln -fs  $(CURDIR)/config/nvim $(HOME)/.config/nvim

clean:
	@echo "Removing all symlinks..."
	@rm $(HOME)/.zshrc
	@rm $(HOME)/.warprc
	@rm $(HOME)/.aliases
	@rm $(HOME)/.bashrc
	@rm $(HOME)/.tmux.conf
	@rm $(HOME)/.local/bin
	@rm $(HOME)/.config/nvim


install-gui:
	$(CURDIR)/install-packages.sh gui

install-cli:
	$(CURDIR)/install-packages.sh cli

install: install-gui install-cli
