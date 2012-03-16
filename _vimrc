set nocompatible              " Don't be compatible with vi

" ========
" Pathogen
" ========
" Load pathogen with docs for all plugins
filetype off
" call pathogen#runtime_append_all_bundles()
" call pathogen#helptags()
call pathogen#infect()
call pathogen#helptags()

" ==============
" Basic Settings
" ==============
syntax on                                  " syntax highlighing
filetype on                                " try to detect filetypes
filetype plugin indent on                  " enable loading indent file for filetype
set gdefault                               " And be global by default
set number                                 " Display line numbers
set numberwidth=1                          " using only 1 column (and 1 space) while possible
set background=dark                        " We are using dark background in vim
set title                                  " show title in console title bar
set wildmenu                               " Menu completion in command mode on <Tab>
set wildmode=full                          " <Tab> cycles between all matching choices.
set wildignore+=*.o,*.obj,.git,*.pyc       " Ignore these files when completing
set autochdir                              " change working directory automatically
set hidden                                 " Enable hidden buffers
set noerrorbells                           " don't bell or blink
set completeopt=menuone,longest,preview    " Insert completion
set pumheight=6                            " Keep a small completion window
set grepprg=ack-grep                       " replace the default grep program with ack
 if has("gui_running")                     " show a line at column 79
    set colorcolumn=79
endif


" Remember cursor position
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif


""" Moving Around/Editing
set cursorline              " have a line indicate the cursor location
set ruler                   " show the cursor position all the time
set guioptions-=T           " Don't show window toolbar
set nostartofline           " Avoid moving cursor to BOL when jumping around
set virtualedit=block       " Let cursor move past the last char in <C-v> mode
set scrolloff=3             " Keep 3 context lines above and below the cursor
set backspace=2             " Allow backspacing over autoindent, EOL, and BOL
set showmatch               " Briefly jump to a paren once it's balanced
set nowrap                  " don't wrap text
set linebreak               " don't wrap textin the middle of a word
set autoindent              " always set autoindenting on
set smartindent             " use smart indent if there is no indent file
set tabstop=4               " <tab> inserts 4 spaces 
set shiftwidth=4            " but an indent level is 2 spaces wide.
set softtabstop=4           " <BS> over an autoindent deletes both spaces.
set expandtab               " Use spaces, not tabs, for autoindent/tab key.
set shiftround              " rounds indent to a multiple of shiftwidth
set matchpairs+=<:>         " show matching <> (html mainly) as well
set foldmethod=indent       " allow us to fold on indents
set foldlevel=99            " don't fold by default

" The PC is fast enough, do syntax highlight syncing from start
autocmd BufEnter * :syntax sync fromstart

" backup to ~/.tmp 
set backup 
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp 
set backupskip=/tmp/*,/private/tmp/* 
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp 
set writebackup

" don't outdent hashes
inoremap # #

"""" Reading/Writing
set noautowrite             " Never write a file unless I request it.
set noautowriteall          " NEVER.
set noautoread              " Don't automatically re-read changed files.
set modelines=0             " disable modelines 
set ffs=unix,dos,mac        " Try recognizing dos, unix, and mac line endings.
set enc=utf-8               " utf-8 default encoding

"""" Messages, Info, Status
set ls=2                    " allways show status line
set vb t_vb=                " Disable all bells.  I hate ringing/flashing.
set confirm                 " Y-N-C prompt if closing with unsaved changes.
set showcmd                 " Show incomplete normal mode commands as I type.
set report=0                " : commands always print changed line count.
set shortmess+=a            " Use [+]/[RO]/[w] for modified/readonly/written.
set laststatus=2            " Always show statusline, even if only 1 window.
set statusline=[%l,%v\ %P%M]\ %f\ %r%h%w\ (%{&ff})\ %{fugitive#statusline()}

""" Searching and Patterns
set ignorecase              " Default to using case insensitive searches,
set smartcase               " unless uppercase letters are used in the regex.
set smarttab                " Handle tabs more intelligently 
set hlsearch                " Highlight searches by default.
set incsearch               " Incrementally search while typing a /regex

"""" Display
" displays tabs with :set list & displays when a line runs off-screen
" set listchars=tab:>-,eol:$,trail:-,precedes:<,extends:>
set listchars=tab:›-,trail:·,eol:¬,precedes:<,extends:> " mark trailing white space
set list

if has("gui_running")
    "colorscheme solarized
    colorscheme molokai
    "set guifont=Menlo:h12
    "let g:solarized_visibility =  "medium"
    " Tagbar
    autocmd VimEnter * nested TagbarOpen
else
    colorscheme molokai
endif
set t_Co=256

" syntastic
"
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_enable_signs=1
let g:syntastic_auto_loc_list=1
let g:syntastic_quiet_warnings=1

" superTab

let g:SuperTabDefaultCompletionType = "context"

" NerdTree
let NERDTreeIgnore=['\~$', '\.pyc$', '\.pyo$', '\.class$', 'pip-log\.txt$', '\.o$']
let NERDTreeSortOrder=['^__\.py$', '\/$', '*', '\.swp$',  '\.bak$', '\~$']
let NERDTreeChDirMode=2 " CWD is changed whenever the tree root is changed


"python-mode
let g:pymode_syntax = 1 " Enable pymode's custom syntax highlighting

" =========================
" FileType specific changes
" =========================

" HTML
autocmd FileType html,xhtml,xml,css setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
fun! s:SelectHTML()
  let n = 1
  while n < 50 && n < line("$")
    " check for django
    if getline(n) =~ '{%\s*\(extends\|load\|block\|if\|for\|include\|trans\)\>'
      set ft=htmldjango
      return
    endif
    let n = n + 1
  endwhile
  " go with html
  set ft=html
endfun
autocmd BufNewFile,BufRead *.html,*.htm  call s:SelectHTML()

" Python
au FileType python set omnifunc=pythoncomplete#Complete
au FileType python setlocal expandtab shiftwidth=4 tabstop=8 softtabstop=4 smartindent cinwords=if,elif,else,for,while,try,except,finally,def,class,with
au BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

" Add the virtualenv's site-packages to vim path

py << EOF
import os.path
import sys
import vim
if 'VIRTUALENV' in os.environ:
    project_base_dir = os.environ['VIRTUAL_ENV']
    sys.path.insert(0, project_base_dir)
    activate_this = os.path.join(project_base_dir, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF

" Load up virtualenv's vimrc if it exists
if filereadable($VIRTUAL_ENV . '/.vimrc')
    source $VIRTUAL_ENV/.vimrc
endif

" ============
" Key Bindings
" ============

" change the leader to be a comma vs slash
let mapleader=","

" ,v brings up my .vimrc
" ,V reloads it -- making all changes active (have to save first)
map <leader>v :sp ~/.vimrc<CR><C-W>_
map <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" open/close the quickfix window
nmap <leader>c :copen<CR>
nmap <leader>cc :cclose<CR>

" Open NerdTree
map <leader>n :NERDTreeToggle<CR>

" Run command-t file search
map <leader>f :CommandT<CR>

" Load the Gundo window
map <leader>g :GundoToggle<CR>

" Paste from clipboard
map <leader>p "+gP

" Quit window on <leader>q
nnoremap <leader>q :q<CR>
"
" hide matches on <leader>space
nnoremap <leader><space> :nohlsearch<cr>

" Remove trailing whitespace on <leader>S
nnoremap <leader>S :%s/\s\+$//<cr>:let @/=''<CR>

" Set working directory
nnoremap <leader>. :lcd %:p:h<CR>

