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
set ttymouse=xterm2
set undolevels=1000
set ttyfast
set history=1000
set hidden
set ruler

if has("colorcolumn")
	set colorcolumn=80
endif

set laststatus=2
"set statusline=%F%m%r%h%w\ [TYPE=%Y\ %{&ff}]\ [%l/%L\ (%p%%)]
"set statusline+=\ %#warningmsg#
"set statusline+=\ %{SyntasticStatuslineFlag()}
"set statusline+=\ %*
"set rulerformat=%40(%{hostname}\ %{strftime('%a\ %b\ %e\ %H:%M\ ')}\ %5l,%-6(%c%V%)\ %P%)

"let g:Powerline_symbols = 'fancy'

let g:syntastic_auto_jump=0
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=1
let g:syntastic_mode_map = { 'mode': 'active',
                           \ 'active_filetypes': [],
                           \ 'passive_filetypes': ['scala'] }

set title
auto BufEnter * let &titlestring = hostname .": ". expand("%:t") ." (". expand("%:p:h") .")"

" clear search term for peace and quiet
map <silent> <C-N> :let @/=""<CR>

map T :exec ":NERDTree"<CR>
let NERDTreeIgnore = ['\.pyc$','\.log$']

nnoremap <C-e> 3<C-e>
nnoremap <C-y> 3<C-y>

let php_oldStyle = 0
let php_asp_tags = 0
let php_folding = 0
let php_parent_error_open = 1


syntax enable
set smartindent
set autoindent
set cindent
set tabstop=4 "tab char
set expandtab "expand tabs
set shiftwidth=4 "indent width for autoindent
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
nmap <F8> :TagbarToggle<CR>

"autoindent entire file
nmap <F11> 1G=G
imap <F11> <ESC>1G=Ga

nnoremap \ :set hlsearch!<CR>

"nnoremap <CR> :noh<CR><CR>
set list
set listchars=tab:>·,trail:·,extends:#,nbsp:.
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

highlight ExtraWhitespace ctermbg=yellow ctermfg=black
match ExtraWhitespace /\s\+$/

autocmd Filetype gitcommit setlocal spell textwidth=72

let g:user_emmet_settings = {
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

let g:tagbar_type_scala = {
    \ 'ctagstype' : 'Scala',
    \ 'kinds' : [
        \ 'p:packages:1',
        \ 'V:values',
        \ 'v:variables',
        \ 'T:types',
        \ 't:traits',
        \ 'o:objects',
        \ 'a:aclasses',
        \ 'c:classes',
        \ 'r:cclasses',
        \ 'm:methods'
    \ ]
\ }

