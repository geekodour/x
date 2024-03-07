" leader
map <Space> <Leader>

" operation settings
set timeoutlen=500 " used for whichkey plugin
set hidden " switch between buffers without having to save first
set autoread " re-read file if external changes detected
set noswapfile

" natural languages
set spelllang=en
set spellsuggest=best,9
nnoremap <leader>ss :set spell!<CR>

" navigation settings
set mouse=a
set cursorline " find the current line quickly
set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
set foldlevel=1 " when file is initially open, fold level set to 1

" layout settings
set number
set relativenumber
set termguicolors
set lazyredraw " only redraw when necessary
set signcolumn=number " show signs in the number column

" indentation settings
set autoindent " indent according to previous lines
set tabstop=2 " 2 whitespace character equals \t
set softtabstop=2 " 2 whitespace character equals tab/backspace keypress
set shiftwidth=2 " indents by 2 whitespace characters
set expandtab " insert space instead of tab

" runtime settings
set showmatch

" search settings
set nohlsearch
set incsearch
set ignorecase
set smartcase

" configuration file
nnoremap <leader>ce :tabnew ~/.config/nvim/init.vim<CR>
nnoremap <leader>cr :source ~/.config/nvim/init.vim<CR>

" new buffers
nnoremap <leader>nt :tabnew<CR>
nnoremap <leader>nn :new<CR>
nnoremap <leader>nv :vnew<CR>

" misc
inoremap jj <esc>
nnoremap <leader>mm :MinimapToggle<CR>

" clipboard
nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>p "+p

" tabs
nnoremap <silent> <C-k> :BufferNext<CR>
nnoremap <silent> <C-j> :BufferPrevious<CR>
nnoremap <silent> <C-x> :BufferClose<CR>

" plugins
" see: https://github.com/junegunn/vim-plug
call plug#begin()
  " themes
  Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
  Plug 'rebelot/kanagawa.nvim'
  " deps
  Plug 'nvim-lua/plenary.nvim' 
  Plug 'nvim-lua/popup.nvim'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'vim-airline/vim-airline-themes'
  " currently using this for syntax highlighting only
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  " fuzzy finder for a lot of things
  Plug 'nvim-telescope/telescope.nvim'
  " minimap, uses external cli tool
  Plug 'wfxr/minimap.vim' 
  " emacs like pop up for possible key binding suggestions
  Plug 'folke/which-key.nvim' 
  " running async commands
  Plug 'skywind3000/asyncrun.vim'
  " smart commenting, there's some key conflict going on with this that i am
  " not able to figure out
  Plug 'numToStr/Comment.nvim'
  " is a better %, but i have not properly used it yet
  Plug 'andymass/vim-matchup'
  " neat plugin that lets me test out/run specific section of the buffer
  Plug 'michaelb/sniprun', {'do': 'bash install.sh'}
  " debugging helper, haven't made use of yet
  Plug 'puremourning/vimspector'
  " another debugging/info helper, haven't made use of yet
  Plug 'folke/trouble.nvim' 
  " minimal start screen that i like
  Plug 'mhinz/vim-startify'
  " statusline
  Plug 'vim-airline/vim-airline'
  " only autocompletion plugin i think i need
  Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
  " coq support for snippets
  Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
  " i use it to keep track of random key bindings, also comes
  " with a predefined cheatsheet, uses telescope. pretty neat
  Plug 'sudormrfbin/cheatsheet.nvim'
  " show all urls in the file, i work with files that have a lot of urls in
  " them. think useful for me
  Plug 'axieax/urlview.nvim'
  " better nvim tabs
  Plug 'romgrk/barbar.nvim'
  " abbreviations for things that'll often repeat. eg. my address etc.
  Plug 'Pocco81/AbbrevMan.nvim'
  " this is for aligning text
  Plug 'junegunn/vim-easy-align'
  " i am yet not sure how this helps but think i'll need it
  Plug 'machakann/vim-sandwich'
  " show the state of the change in the side
  Plug 'airblade/vim-gitgutter'
  " git plugin for vim, i might not need this as i am going to use magin and
  " git cli exclusively for git changes.
  Plug 'tpope/vim-fugitive'
call plug#end()
" plugins i want to test later
" = https://github.com/nanotee/nvim-lua-guide
" = https://github.com/mhinz/vim-galore
" - https://github.com/pwntester/octo.nvim
" - https://github.com/chentau/marks.nvim
" - https://github.com/ThePrimeagen/harpoon
" - https://github.com/akinsho/bufferline.nvim (does not seem to play well w airline)
" - https://github.com/ekickx/clipboard-image.nvim
" - https://github.com/numToStr/Navigator.nvim
" - https://github.com/aserowy/tmux.nvim
" - https://github.com/rcarriga/nvim-notify
" - https://github.com/nvim-treesitter/playground
" - https://github.com/wakatime/vim-wakatime

" theme
"colorscheme tokyonight
colorscheme kanagawa
let g:airline_powerline_fonts = 1

" treesitter
lua << EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
  additional_vim_regex_highlighting = false,
}
EOF

" telescope
nnoremap <leader>ff <cmd>Telescope find_files<cr>
nnoremap <leader>fg <cmd>Telescope live_grep<cr>
nnoremap <leader>fb <cmd>Telescope buffers<cr>
nnoremap <leader>fh <cmd>Telescope help_tags<cr>

" minimap
let g:minimap_width = 10
let g:minimap_auto_start_win_enter = 1

" smart comments
lua << EOF
require('Comment').setup()
EOF

" whichkey
lua << EOF
require("which-key").setup()
EOF
