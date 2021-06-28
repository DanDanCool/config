# config
my configuration for terminal + vim + various other things

the pairs script works best with smart indent disabled

# TODO:
- rewrite nerdtree
- rewrite gutentags
- rewrite tagbar
- add keymaps to fzf.lua for more navigation options (tab split, vsplit, etc.)
- fix those errors from complete.lua
- add the 'additional complete' items from the lsp into complete.lua
- add fuzzy matching to complete.lua
- proper credits

# Credits:
Git integration provided by:
https://github.com/itchyny/vim-gitbranch

Vim Devicons:
https://github.com/ryanoasis/vim-devicons

NERDTree Visual Selection:
https://github.com/PhilRunninger/nerdtree-visual-selection

Completion:
https://github.com/nvim-lua/completion-nvim

Treesitter:
https://github.com/nvim-treesitter/nvim-treesitter

# Notes:
Completion: will probably not work with snippets, only gets completion items from lsp. This is a cut down version of the plugin.

Treesitter: this only provides highlighting functionality, everything else was cut. In addition, this does not support the 'is?' predicate

There are probably a dozen license incompabilities... oh well
