" Just gimme vim!
set nocompatible

" Set leader
let mapleader = ","

" Set filetype stuff to on
filetype on
filetype plugin on
filetype indent on
syntax enable

"---------------------------------------------------------------------------
" Vunlde configuration
"---------------------------------------------------------------------------
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'gmarik/vundle'

" GitHub repos
Bundle 'flazz/vim-colorschemes'
Bundle 'torandu/vim-bufexplorer'
Bundle 'msanders/snipmate.vim'
Bundle 'wincent/Command-T'
Bundle 'scrooloose/nerdtree'
Bundle 'tpope/vim-surround'
Bundle 'edsono/vim-matchit'
Bundle 'vim-scripts/taglist.vim'
Bundle 'StanAngeloff/php.vim'

"---------------------------------------------------------------------------
" standard configuration
"---------------------------------------------------------------------------

" Show line numbers
set number

" No wrap by default
set nowrap

" Tabstops are 4 spaces
set tabstop=2
set shiftwidth=2

" set the search scan to wrap lines
set wrapscan

" set the search scan so that it ignores case when the search is all lower
" case but recognizes uppercase if it's specified
set ignorecase
set smartcase

" set the forward slash to be the slash of note.  Backslashes suck
set shellslash

" Make command line two lines high
set ch=2

" set visual bell -- i hate that damned beeping
set vb

" Allow backspacing over indent, eol, and the start of an insert
set backspace=2

" Make sure that unsaved buffers that are to be put in the background are
" allowed to go in there (ie. the "must save first" error doesn't come up)
set hidden

" Set the status line the way i like it
set stl=%f\ %m\ %r\ Line:%l/%L[%p%%]\ Col:%c\ Buf:%n\ [%b][0x%B]

" tell VIM to always put a status line in, even if there is only one window
set laststatus=2

" Don't update the display while executing macros
set lazyredraw

" Show the current command in the lower right corner
set showcmd

" Show the current mode
set showmode

" Hide the mouse pointer while typing
set mousehide

" Set up the gui cursor to look nice
set guicursor=n-v-c:block-Cursor-blinkon0
set guicursor+=ve:ver35-Cursor
set guicursor+=o:hor50-Cursor
set guicursor+=i-ci:ver25-Cursor
set guicursor+=r-cr:hor20-Cursor
set guicursor+=sm:block-Cursor-blinkwait175-blinkoff150-blinkon175

" set the gui options the way I like
set guioptions=ac

" This is the timeout used while waiting for user input on a multi-keyed macro
" or while just sitting and waiting for another key to be pressed measured
" in milliseconds.
"
" i.e. for the ",d" command, there is a "timeoutlen" wait period between the
"      "," key and the "d" key.  If the "d" key isn't pressed before the
"      timeout expires, one of two things happens: The "," command is executed
"      if there is one (which there isn't) or the command aborts.
set timeoutlen=800

" Keep some stuff in the history
set history=100

" These commands open folds
set foldopen=block,insert,jump,mark,percent,quickfix,search,tag,undo

set foldmethod=manual

" When the page starts to scroll, keep the cursor 8 lines from the top and 8
" lines from the bottom
set scrolloff=8

" Make the command-line completion better
set wildmenu

" Set the textwidth to be 120 chars
set textwidth=120

" Turn tabs into spaces
set expandtab

" Add ignorance of whitespace to diff
set diffopt+=iwhite

" Enable search highlighting
set hlsearch

" Incrementally match the search
set incsearch

" cd to the directory containing the file in the buffer
nmap <silent> ,cd :lcd %:h<CR>
nmap <silent> ,md :!mkdir -p %:p:h<CR>

" Turn off that stupid highlight search
nmap <silent> ,n :set invhls<CR>:set hls?<CR>

" set text wrapping toggles
nmap <silent> ,w :set invwrap<CR>:set wrap?<CR>

" Toggle NERDTree 
map <silent> ,p :execute 'NERDTreeToggle ' . getcwd()<CR>

" Make the NERDTree window a little wider
let g:NERDTreeWinSize = 40 

" Toggle taglist
map <silent> ,v :execute 'TlistToggle'<CR>

" SnipMate Reload snippets
nmap ,rr :call ReloadSnippets(&filetype)<CR>

" Flush Command-T
map <silent> ,f :execute 'CommandTFlush'<CR>

" Map CTRL-E to do what ',' used to do
nnoremap <c-e> ,
vnoremap <c-e> ,

" Buffer commands
noremap <silent> ,bd :bd<CR>

" Edit the vimrc file
nmap <silent> ,ev :e $MYVIMRC<CR>
nmap <silent> ,sv :so $MYVIMRC<CR>

" Syntax coloring lines that are too long just slows down the world
set synmaxcol=2048

" Set F3 to toggle paste mode
set pt=<F3> 

" Convert file to HTML from markdown and place generated HTML in buffer
map ,mdc :!m2h.php % \| pbcopy <CR>

"-----------------------------------------------------------------------------
" Set up the window colors and size
"-----------------------------------------------------------------------------
if has("gui_running")
    set guifont=Menlo:h13
    colorscheme jellybeans
    if !exists("g:vimrcloaded")
        winpos 0 0
        if ! &diff
            winsize 130 90
        else
            winsize 227 90
        endif
        let g:vimrcloaded = 1
    endif
endif
:nohls


"---------------------------------------------------------------------------
" PHP mappings
"---------------------------------------------------------------------------

" PHP function reference
function! OpenPhpFunction (keyword)
  let proc_keyword = substitute(a:keyword , '_', '-', 'g')
  try
    exe 'pedit'
  catch /.*/
  endtry
  exe 'wincmd P'
  exe 'enew'
  exe "set buftype=nofile"
  exe "setlocal noswapfile"
  exe 'silent r!lynx -dump -nolist http://us3.php.net/'.proc_keyword
  exe 'norm gg'
"  exe 'call search("____________________________________")'
  exe 'call search("Description")'
  exe 'norm dgg'
  exe 'call search("User Contributed Notes")'
  exe 'norm dGgg'
endfunction
inoremap <D-d> <Esc>h:call OpenPhpFunction('<c-r><c-w>')<CR>:wincmd p<CR>la
nnoremap <D-d> :call OpenPhpFunction('<c-r><c-w>')<CR>:wincmd p<CR>
vnoremap <D-d> :call OpenPhpFunction('<c-r><c-w>')<CR>:wincmd p<CR>

" Close window above
inoremap <D-e> <C-\><C-O><C-w>k<C-\><C-O>:q<CR>
nmap <D-e> <C-w>k:q<CR>

" PHP auto complete
autocmd FileType php set omnifunc=phpcomplete#CompletePHP

" Check PHP syntax
map <D-right> :!php -l %<CR>
map <D-up> :call RunPHP()<CR>

function! RunPHP ()
  let filename = expand("%")
  exe 'enew'
  exe 'set buftype=nofile'
  exe 'setlocal noswapfile'
  exe 'r!/Applications/MAMP/bin/php/php5.3.13/bin/php '.filename
  exe 'norm gg'
endfunction
