"######################
"#		Vundle		  #
"######################

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'SirVer/ultisnips'
Plugin 'honza/vim-snippets'
Plugin 'Shougo/neocomplete.vim'
Plugin 'scrooloose/syntastic'
Plugin 'rust-lang/rust.vim'
Plugin 'cespare/vim-toml'
Plugin 'pangloss/vim-javascript'
Plugin 'francoiscabrol/ranger.vim'
Plugin 'ervandew/supertab'
Plugin 'Raimondi/delimitMate'
call vundle#end()

"######################
"#		Plugins		  #
"######################

"supertab
"let g:SuperTabDefaultCompletionType = "<C-j>"


"UltiSnips
let g:UltiSnipsSnippetDirectories=["UltiSnips", "vim-snippets"]
let g:UltiSnipsExpandTrigger="<s-tab>"
let g:UltiSnipsJumpForwardTrigger="<c-n>"
let g:UltiSnipsJumpBackwardTrigger="<c-m>"
let g:UltiSnipsEditSplit="vertical"

"ctrlP
let g:ctrlp_use_caching=1
let g:ctrlp_working_path_mode = 'ca'
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.class,

"nerdTree
let NERDTreeShowHidden=1

" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
	exec 'autocmd filetype nerdtree highlight ' . a:extension .' ctermbg='.a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
	exec 'autocmd filetype nerdtree syn match ' . a:extension .' #^\s\+.*'.a:extension .'$#'
endfunction

call NERDTreeHighlightFile('jade', 'green', 'none', 'green', '#151515')
call NERDTreeHighlightFile('ini', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('md', 'blue', 'none', '#3366FF', '#151515')
call NERDTreeHighlightFile('yml', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('config', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('conf', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('json', 'darkyellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('html', 'yellow', 'none', 'yellow', '#151515')
call NERDTreeHighlightFile('styl', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('css', 'cyan', 'none', 'cyan', '#151515')
call NERDTreeHighlightFile('coffee', 'Red', 'none', 'red', '#151515')
call NERDTreeHighlightFile('js', 'Red', 'none', '#ffa500', '#151515')
call NERDTreeHighlightFile('php', 'Magenta', 'none', '#ff00ff', '#151515')
call NERDTreeHighlightFile('java', 'Magenta', 'none', '#ff00ff', '#151515')

autocmd StdinReadPre * let s:std_in=1

"neocomplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
"
"syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"syntastic
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1
let g:syntastic_enable_balloons = 1

"ranger
let g:ranger_open_new_tab = 1
let g:ranger_map_keys = 0

"statusline
set rtp+=/usr/lib/python2.7/site-packages/powerline/bindings/vim/
set laststatus=2

"######################
"#		 personal	  #
"######################

"general
set nocompatible
filetype on
filetype plugin indent on

"colors
colorscheme angr
syntax on
set number
set cursorcolumn
set cursorline
hi LineNr ctermfg=lightgrey ctermbg=black
hi CursorLine term=bold ctermbg=black cterm=bold guibg=Grey40

"hilight tabs
let blacklist = ['html', 'css', 'json', 'yaml']
autocmd BufReadPost * if index(blacklist, &ft) < 0 | set tabstop=4 softtabstop=4 shiftwidth=4
autocmd BufReadPost * if index(blacklist, &ft) < 0 | set list listchars=tab:❘.,trail:·,extends:»,precedes:«,nbsp:×
autocmd BufReadPost * if index(blacklist, &ft) < 0 | set noexpandtab | retab! 4
autocmd BufReadPre * if index(blacklist, &ft) < 0 | set expandtab | retab! 4
autocmd BufWritePost * if index(blacklist, &ft) < 0 | set noexpandtab | retab! 4


autocmd Filetype html setlocal expandtab softtabstop=2 shiftwidth=2 tabstop=2
autocmd Filetype html retab

autocmd Filetype css setlocal expandtab softtabstop=2 shiftwidth=2 tabstop=2
autocmd Filetype css retab

autocmd Filetype json setlocal expandtab softtabstop=2 shiftwidth=2 tabstop=2
autocmd Filetype json retab

autocmd Filetype yaml setlocal expandtab softtabstop=2 shiftwidth=2 tabstop=2
autocmd Filetype yaml retab

"markdown
au BufRead,BufNewFile *.md set filetype=markdown

"splitting
set splitbelow
set splitright

"python
au BufRead,BufNewFile *.py set colorcolumn=79
au BufRead,BufNewFile *.py set textwidth=79
"highlight ColorColumn

"html
au BufRead,BufNewFile *.html set colorcolumn=79


"keymappings

inoremap jk <ESC>
map <S-m> :NERDTreeToggle<CR>
map <S-c> :SyntasticToggleMode<CR>
map <S-C-j> :lnext<CR>
map <S-C-k> :lprevious<CR>
map <S-x> :lclose<CR>
map <S-f> :Ranger<CR>
inoremap <expr><C-g> neocomplete#undo_completion()
inoremap <expr><C-l> neocomplete#complete_common_string()

"save file as root
cmap w!! w !sudo tee % >/dev/null

"disable arrow keys
inoremap <Up> <Nop>
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>
noremap <Up> <Nop>
noremap <Down> <Nop>
noremap <Left> <Nop>
noremap <Right> <Nop>
vnoremap <Up> <Nop>
vnoremap <Down> <Nop>
vnoremap <Left> <Nop>
vnoremap <Right> <Nop>

"split navigation
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
"Swap top/bottom or left/right split
noremap Ctrl+W R
"Break out current window into a new tabview
noremap Ctrl+W T
"Close every window in the current tabview but the current one
noremap Ctrl+W o
"Normalize all split sizes, which is very handy when resizing terminal
noremap ctrl + w =
