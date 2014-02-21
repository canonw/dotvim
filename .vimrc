" .vimrc
" Author: Ken Wong <ken.yui.wong@gmail.com
"
" Checklist for VIM
" 1. git
" 2. build vimproc.vim
"
" Reference vimrc
" https://bitbucket.org/sjl/dotfiles/src/tip/vim/vimrc

" Preamble ---------------------------------------------------------------- {{{

" NeoBundle
" Prefer this over pathogen becuase fi 
" Reference: https://github.com/Shougo/neobundle.vim 
" Command line: git submodule add https://github.com/Shougo/neobundle.vim .vim/bundle/neobundle.vim

if has('vim_starting')
  set nocompatible " This option has the effect of making Vim either more Vi-compatible, or make Vim behave in a more useful way.

  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

" My bundles here
NeoBundle 'Shougo/vimproc.vim', {
      \ 'build' : {
      \     'windows' : 'make -f make_mingw32.mak',
      \     'cygwin' : 'make -f make_cygwin.mak',
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ } " Recommand by NeoBundle
NeoBundle 'flazz/vim-colorschemes' " Tons of color schemes
NeoBundle 'vim-scripts/changeColorScheme.vim' " Randomize color scheme

filetype plugin indent on " Enable filetype plugins

NeoBundleCheck

" }}}
" General Options {{{

set history=1000 " Sets how many lines of history VIM has to remember (default is 20)

set autoread " Set to auto read when a file is changed from the outside

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","

" Share windows clipboard
" Reference: http://vimcasts.org/episodes/accessing-the-system-clipboard-from-vim/
if has("clipboard")
    set clipboard+=unnamed,unnamedplus
endif

" Set 10 lines to the cursor - when moving vertically using j/k
set scrolloff=10

" Shortens messages
set shortmess=aOstT

if has('cmdline_info')
    "Always show current position
    set ruler
    set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%)

    " Show the command being typed
    set showcmd
endif

" Height of the command bar
"?set cmdheight=2

set hidden " A buffer becomes hidden when it is abandoned

" Configure backspace so it acts as it should act
set backspace=eol,start,indent
set whichwrap+=<,>,h,l

" Ignore case when searching
set ignorecase

" When searching try to be smart about cases      
set smartcase

" Highlight search results
set hlsearch

" Makes search act like search in modern browsers
set incsearch

" Don't redraw while executing macros (good performance config)
set lazyredraw

" For regular expressions turn magic on
"^"set magic

" Show matching brackets when text indicator is over them
set showmatch
" How many tenths of a second to blink when matching brackets
set matchtime=2

" No annoying sound on errors
set noerrorbells
set novisualbell
set t_vb=
set tm=500

" Highlight the current column
set cursorcolumn

" Highlight current line
set cursorline

" leave my cursor where it was
"?set nostartofline

" Turn on relative line number
set relativenumber
" We are good up to 99999 lines
"set numberwidth=5

" Tell us when anything is changed via :...
set report=0

" Set extra options when running in GUI mode
if has("gui_running")

    set guioptions=ceTm
    "              ||||
    "              |||+-- Menu bar is present
    "              ||+-- Include Toolbar
    "              |+-- Use simple dialogs rather than pop-ups
    "              +-- Use console dialogs not popup dialogs for simple choice

    set t_Co=256

    set guitablabel=%M\ %t

    " Hide the mouse cursor when typing
    set mousehide

    set columns=120

    " set lines=50

    " Font Switching Binds {
    if has('unix')
        if (match(system("cat /etc/issue"), "Ubuntu") != -1)
                set guifont=Ubuntu\ Mono\ 11
            else
                set guifont=Monospace\ 11
        endif
    endif
    if has('win32') || has('win64')
        " Graceful degration http://stackoverflow.com/a/12856063

        " Font URL http://www.tobias-jung.de/seekingprofont/
        "?silent! set guifont=ProFontWindows:h11
        "?if &guifont != 'ProFontWindows:h11'

        "? Not work
        " Font URL http://www.levien.com/type/myfonts/inconsolata.html
        "silent! set guifont=Inconsolata:h11
        "if &guifont != 'Inconsolata:h11'
            set guifont=Consolas:h11
        "endif

        set guifontwide=MingLiU:h11
        "?map <F10> <ESC>:set guifont=MingLiU:h10<CR>
    endif

endif

set encoding=utf8 " Set utf8 as standard encoding and en_US as the standard language

"set fileformats=unix,dos,mac " Use Unix as the standard file type

" always switch to the current file directory
set autochdir

" if has("autocmd")
"     " Remove trailing whitespaces and ^M chars
"     autocmd FileType c,cpp,java,php,js,python,twig,xml,yml autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))
" 
"     " CTRL-X CTRL-O Omni completion
"     autocmd FileType python set omnifunc=pythoncomplete#Complete
"     autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
"     autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
"     autocmd FileType css set omnifunc=csscomplete#CompleteCSS
"     autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
"     autocmd FileType php set omnifunc=phpcomplete#CompletePHP
"     autocmd FileType c set omnifunc=ccomplete#Complete
"     "?autocmd FileType sql set omnifunc=sqlcomplete#Complete
" 
"   " Reset file type
"   " Reference: http://stackoverflow.com/questions/8413781/automatically-set-multiple-file-types-in-filetype-if-a-file-has-multiple-exten
"     " autocmd BufNewFile,BufRead web.config setlocal filetype=xml
" endif


" " Reference: http://vimcasts.org/episodes/whitespace-preferences-and-filetypes/
" " Update specific file type setting.
" if has("autocmd")
"   " Enable file type detection
"   "?filetype on
" 
"   " Syntax of these languages is fussy over tabs Vs spaces
"   "?autocmd FileType make setlocal ts=8 sts=8 sw=8 noexpandtab
"   "?autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
" 
"   " Customisations based on house-style (arbitrary)
"   autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
"   autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab
"   autocmd FileType javascript setlocal ts=4 sts=4 sw=4 noexpandtab
" 
" endif


" Linebreak on 500 characters
"?set lbr
"?set tw=500


" Reference: http://vimcasts.org/episodes/show-invisibles/
" Reference: http://vim.wikia.com/wiki/Highlight_unwanted_spaces 
"
" Display unprintable characters
set list listchars=tab:».,trail:·,extends:>,precedes:<
" Disable showing eol.  The character is annoying on screen.
" set list listchars=tab:»·,trail:·,extends:>,precedes:<,eol:¶

" Invisible character colors
highlight NonText ctermfg=LightBlue guifg=LightBlue
highlight SpecialKey ctermfg=LightGreen guifg=LightGreen

" Shortcut to rapidly toggle 'set list'
" nmap <leader>l :set list!<CR>

set completeopt=longest,menuone,preview " Completion style

" }}}
" Indent, Tab, Spacing and Wrap {{{

set autoindent " Copy indent from current line when starting a new line.

set smartindent " Do smart autoindenting when starting a new line.

set nowrap " No wrap line

set expandtab " Use spaces instead of tabs
"set noexpandtab

set smarttab " Be smart when using tabs ;)

" Tab setting
" Reference: http://vimcasts.org/episodes/tabs-and-spaces/
" If space is prefer over tab, tabstop == softtabstop
" Set tabstop == softtabstop
set shiftwidth=4
set tabstop=4
set softtabstop=4
" }}}
" Backup {{{

set backup " Backup of the original file
set writebackup " Make a backup before overwriting a file
set noswapfile " No swapfile

set undodir=~/.vim/tmp/undo// " List of directory names for undo files
set backupdir=~/.vim/tmp/backup// " List of directories for the backup file
set directory=~/.vim/tmp/swap// " List of directory names for the swap file

" Create backup folders if not exists
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

" }}}
" Color Scheme {{{

syntax on " Enable syntax highlighting

" colorscheme desert

" }}}
" Status Line {{{
if has('statusline')
    " Always show the status line
    set laststatus=2 " always show the status line

    " Format the status line
    set statusline=
    set statusline +=%3*%n%*                "buffer number
    set statusline +=%3*%r%*                "readonly flag in square brackets
    set statusline +=%3*%h%*                "help flag in square brackets
    set statusline +=%3*%w%*                "preview window flag in square brackets
    set statusline +=%4*\[%{&ff}%*\]        "file format
    set statusline +=%4*%y%*                "file type
    set statusline+=%4*\[%{(&fenc!=''?&fenc:&enc)}      "encoding
    set statusline+=%4*%{(&bomb?\",BOM\":\"\")}\]       "encoding2
    set statusline +=%2*%<%F%*              "full path
    set statusline +=%1*%m%*                "modified flag in square brackets
    set statusline +=%1*%=                  "seperate between right- and left-aligned
    set statusline +=%1*%c%V%*              "column number and virtual column number
    set statusline +=%2*,                   "seperataor
    set statusline +=%1*%04l%*              "current line
    set statusline +=%2*/%04L%*             "total lines
    set statusline +=%2*(%03p%%)%*          "percent through file
    set statusline +=%1*\ %{v:register}%*   "last register
    set statusline +=%4*\ 0x%04B\ %*        "character under cursor

    hi User1 guifg=#ffff73 guibg=#222222 " gui=bold
    hi User2 guifg=#67e667 guibg=#222222
    hi User3 guifg=#ff7373 guibg=#222222
    hi User4 guifg=#ad66d5 guibg=#222222

endif

" }}}
" Wildmenu completion {{{

set wildmenu " Turn on the WiLd menu
set wildmode=list:longest,full

set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg,*.tif    " binary images
set wildignore+=*.o,*.obj,*.exe,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX
set wildignore+=*.luac                           " Lua byte code
set wildignore+=migrations                       " Django migrations
set wildignore+=*.pyc                            " Python byte code
set wildignore+=*.orig                           " Merge resolution files

" }}}

