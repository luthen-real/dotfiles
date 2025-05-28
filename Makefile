default:
	@echo Current dir is $(CURDIR) # dir of makefile

dotfiles:
	stow --verbose --dotfiles --target=$(HOME) stow

clean:
	stow -D --verbose --dotfiles --target=$(HOME) stow
