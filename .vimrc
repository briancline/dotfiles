runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#infect()
call pathogen#runtime_append_all_bundles()

let hostname = substitute(system('hostname -s'), '\n', '', '')

nore ; :
nore , ;

"set backup
set nobackup
set backupdir=~/.vim/backup
set directory=~/.vim/tmp

map <space> <c-W>w
map <space>n <c-W>w
map <space><space> <c-W>w<c-W>_
map <space>= <c-W>=
if bufwinnr(1)
	map = <c-W>+
	map + <c-W>+
	map - <c-W>-
endif


set mouse=a
set undolevels=1000
set ttyfast
set history=1000
set hidden
set ruler
set cin si ai

set laststatus=2
"set statusline=%F%m%r%h%w\ [TYPE=%Y\ %{&ff}]\ [%l/%L\ (%p%%)]
"set statusline+=\ %#warningmsg#
"set statusline+=\ %{SyntasticStatuslineFlag()}
"set statusline+=\ %*
"set rulerformat=%40(%{hostname}\ %{strftime('%a\ %b\ %e\ %H:%M\ ')}\ %5l,%-6(%c%V%)\ %P%)

"let g:Powerline_symbols = 'fancy'

let g:syntastic_auto_jump=1
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=1

set title
auto BufEnter * let &titlestring = hostname .": ". expand("%:t") ." (". expand("%:p:h") .")"

" clear search term for peace and quiet
map <silent> <C-N> :let @/=""<CR>
map T :exec ":NERDTree"<CR>

nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

let php_oldStyle = 0
let php_asp_tags = 0
let php_folding = 0
let php_parent_error_open = 1


syntax enable
set smartindent
set tabstop=3 "tab char
set noexpandtab "don't expand tabs
set shiftwidth=3 "indent width for autoindent
filetype on
filetype indent on
filetype plugin on

set incsearch "search as you type
set ignorecase "dear search: don't be a dick
set smartcase "hooray AI!

set t_Co=256
set background=dark
"colorscheme desert256
"colorscheme peachpuff
"colorscheme ir_black
"colorscheme molokai
"colorscheme Tomorrow-Night-Bright
colorscheme Tomorrow-Night
"colorscheme wombat256mod

"Enable indent folding
"set foldenable
"set foldmethod=syntax
"set foldnestmax=2

set scrolloff=5 "Have 3 lines of offset (or buffer) when scrolling
set sidescrolloff=5

set number
set numberwidth=5 "Set line numbering to take up 5 spaces
set cursorline "Highlight current line

"Turn on spell checking with English dictionary
set nospell
set spelllang=en
set spellsuggest=9 "show only 9 suggestions for misspelled words


"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"autoindent entire file
nmap <F11> 1G=G
imap <F11> <ESC>1G=Ga

"toggle a fold
nnoremap <space> za
nnoremap \ :set hlsearch!<CR>

"nnoremap <CR> :noh<CR><CR>
set listchars=tab:>-,trail:·,eol:$
nmap <silent> <leader>s :set nolist!<CR>



set viminfo='10,\"100,:100,%,n~/.viminfo
function! ResCur()
	if line("'\"") <= line("$")
		normal! g`"
		return 1
	endif
endfunction

augroup resCur
	autocmd!
	autocmd BufWinEnter * call ResCur()
augroup END



let g:user_zen_settings = {
\	'php' : {
\		'extends' : 'html',
\		'filters' : 'c',
\	},
\	'xml' : {
\		'extends' : 'html',
\	},
\	'haml' : {
\		'extends' : 'html',
\	},
\}