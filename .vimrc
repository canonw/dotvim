" .vimrc
" Author: Ken Wong <ken dot yui dot wong at gmail dot com>
"
" Checklist for VIM.  Confirm these exeucutable are installed.
" 1. git
" 2. build vimproc.vim
"    - Check the value using the command.  It has the exact dll value.
"      :echo g:vimproc#dll_path
"    - Check if the binary is compiled.
"      Note: Windows version has precompiled binary in https://github.com/Shougo/vimproc.vim/downloads
" 3. xmllint
" 4. Setup fonts
"    - Inconsolata.  http://www.fontsquirrel.com/fonts/Inconsolata
"    - ProFont.  http://tobiasjung.name/profont/
"    - Source Code Pro.  http://sourceforge.net/projects/sourcecodepro.adobe/
"
" Give credit where credit is due.
" https://github.com/mizutomo/dotfiles/blob/master/vimrc
" http://amix.dk/vim/vimrc.html
" http://spf13.com/post/perfect-vimrc-vim-config-file
" https://bitbucket.org/sjl/dotfiles/src/tip/vim/vimrc
" http://www.pythonclub.org/vim/gui-font

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
NeoBundle 'tpope/vim-unimpaired' " Easy key binding movement.
NeoBundle 'jakar/vim-AnsiEsc' " ANSI color
" NeoBundle 'vim-scripts/AnsiEsc.vim' " Display ANSI color in log files
NeoBundle 'flazz/vim-colorschemes' " Tons of color schemes
NeoBundle 'vim-scripts/changeColorScheme.vim' " Randomize color scheme
NeoBundle 'vim-scripts/mru.vim.git' " Save file history
NeoBundle 'bling/vim-airline' " Status line
NeoBundle 'tsaleh/vim-matchit'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'godlygeek/tabular'
NeoBundle 't9md/vim-quickhl'
NeoBundle 'vim-scripts/Align'
NeoBundle 'mattn/emmet-vim'
NeoBundle 'vim-scripts/DrawIt'
NeoBundle 'tpope/vim-abolish'
NeoBundle 'tpope/vim-surround'

NeoBundleLazy "vim-scripts/ShowMarks", {
  \ "autoload": {
  \ "commands": ["ShowMarksPlaceMark", "ShowMarksToggle"],
  \ }}
let s:hooks = neobundle#get_hooks("ShowMarks")
function! s:hooks.on_source(bundle)
  let showmarks_text = '>>'
  let showmarks_textupper = '>>'
  let showmarks_textother = '>>'
" ignore ShowMarks on buffer type of
" Help, Non-modifiable, Preview, Quickfix
  let showmarks_ignore_type = 'hmpq'
endfunction

NeoBundle 'vim-scripts/restore_view.vim' " Remember file cursor and folding position

NeoBundle 'SirVer/ultisnips' " Code Snippet

NeoBundle 'tpope/vim-fugitive' " Git

NeoBundleLazy "Shougo/unite.vim", {
  \ "autoload": {
  \ "commands": ["Unite", "UniteWithBufferDir"]
  \ }}
let s:hooks = neobundle#get_hooks("unite.vim")
function! s:hooks.on_source(bundle)
" start unite in insert mode
  let g:unite_enable_start_insert = 1
" use vimfiler to open directory
  call unite#custom_default_action("source/bookmark/directory", "vimfiler")
  call unite#custom_default_action("directory", "vimfiler")
  call unite#custom_default_action("directory_mru", "vimfiler")
  " autocmd MyAutoCmd FileType unite call s:unite_settings()
  " function! s:unite_settings()
  "   imap <buffer> <Esc><Esc> <Plug>(unite_exit)
  "   nmap <buffer> <Esc> <Plug>(unite_exit)
  "   nmap <buffer> <C-n> <Plug>(unite_select_next_line)
  "   nmap <buffer> <C-p> <Plug>(unite_select_previous_line)
  " endfunction
endfunction
NeoBundleLazy 'h1mesuke/unite-outline', {
  \ "autoload": {
  \ "unite_sources": ["outline"],
  \ }}
NeoBundle 'Shougo/neomru.vim' " Prefer integration with unite
NeoBundle 'moznion/unite-git-conflict.vim'

" File Explorer
NeoBundleLazy "Shougo/vimfiler", {
  \ "depends": ["Shougo/unite.vim"],
  \ "autoload": {
  \ "commands": ["VimFilerTab", "VimFiler", "VimFilerExplorer"],
  \ "mappings": ['<Plug>(vimfiler_switch)'],
  \ "explorer": 1,
  \ }} " Use unite bookmark to track specific issues
NeoBundle 'scrooloose/nerdtree' " Bookmark well on directories

" SQL
NeoBundle 'vim-scripts/SQLComplete.vim'
NeoBundle 'vim-scripts/dbext.vim'
NeoBundle 'vim-scripts/SQLUtilities'

" Ruby/Rails
" http://www.vimninjas.com/2012/08/28/vim-for-rubyists-part-1/
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'tpope/vim-rails'
NeoBundle 'ecomba/vim-ruby-refactoring'
NeoBundle 'tpope/vim-cucumber'
NeoBundle 'tpope/vim-haml'
NeoBundle 'groenewege/vim-less'

" NeoBundle 'vim-scripts/DrawIt' 
NeoBundle 'hsitz/VimOrganizer' " For note taking
NeoBundle 'mattn/calendar-vim' " Required by VimOrganizer
NeoBundle 'vim-scripts/utl.vim' " Optional for VimOrganizer
NeoBundle 'chrisbra/NrrwRgn' " Optional for VimOrganizer

filetype plugin indent on " Enable filetype plugins

NeoBundleCheck

" }}}
" General Options {{{

set history=1000 " Sets how many lines of history VIM has to remember (default is 20)

set autoread " Set to auto read when a file is changed from the outside

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ";"
let maplocalleader = "'"
" let g:mapleader = ","

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
    " This tricks does not work at all in Windows
    "silent! set guifont=Inconsolata:h11
    "if &guifont != 'Inconsolata:h11'
    "    set guifont=Consolas:h11
    "endif

    silent! set guifont=Source_Code_Pro:h11:cANSI

    silent! set guifontwide=MingLiU:h11:cANSI
  endif

endif

set encoding=utf8 " Set utf8 as standard encoding and en_US as the standard language

"set fileformats=unix,dos,mac " Use Unix as the standard file type

set autochdir " always switch to the current file directory

" if has("autocmd")
"     " Remove trailing whitespaces and ^M chars
"     autocmd FileType c,cpp,java,php,js,python,twig,xml,yml autocmd BufWritePre <buffer> :call setline(1,map(getline(1,"$"),'substitute(v:val,"\\s\\+$","","")'))
" 
"     " CTRL-X CTRL-O Omni completion
"     autocmd FileType python set omnifunc=pythoncomplete#Complete
"     autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
"     autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
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

" Use grep even in Windows
if has('win32') || has('win64')
  if isdirectory("c:/cygwin64/bin")
    set grepprg=c:\cygwin64\bin\grep.exe\ -nir\ $*
  elseif isdirectory("c:/cygwin/bin")
    set grepprg=c:\cygwin\bin\grep.exe\ -nir\ $*
  endif
endif

" Source setting specific to this machine
if filereadable(expand("~/my.vim"))
  exec "source ~/my.vim"
endif

" }}}
" Quickfix {{{
augroup QFixToggle
"  autocmd!
  autocmd BufWinEnter quickfix setlocal norelativenumber
augroup END
" }}}
" Cursors {{{

" Show cursor only in normal mode
augroup cline
    au!
    au WinLeave,InsertEnter * set nocursorline nocursorcolumn
    au WinEnter,InsertLeave * set cursorline cursorcolumn
augroup END

"?set nostartofline " leave my cursor where it was


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

colorscheme desert

" }}}
" Status Line {{{
" Hidden when vim-airline is active
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
" Line number {{{

set number
set relativenumber " Turn on relative line number

" Toggle line number, relative number or off
function! ToggleNumbers()
  if &relativenumber
    setlocal number
    setlocal norelativenumber
  elseif &number
    setlocal nonumber
    setlocal norelativenumber
  else
    setlocal number
    setlocal relativenumber
  endif
endfunction

function! ToggleFonts()

  if has('win32') || has('win64')
    if &guifont ==? 'Consolas:h11:cANSI'
      set guifont=Source_Code_Pro:h11:cANSI
    elseif &guifont ==? 'Source_Code_Pro:h11:cANSI'
      set guifont=Inconsolata:h11:cANSI
    elseif &guifont ==? 'Inconsolata:h11:cANSI'
      set guifont=ProFontWindows:h11:cANSI
    elseif &guifont ==? 'ProFontWindows:h11:cANSI'
      silent! set guifont=Consolas:h11:cANSI
    elseif &guifont ==? 'Consolas:h11:cANSI'
      set guifont=ProFontWindows:h11:cANSI
    else
      set guifont=Source_Code_Pro:h11:cANSI
    endif
  endif

  echo &guifont

endfunction

" }}}
" Wildmenu completion {{{

set wildmenu " Turn on the WiLd menu
set wildmode=list:longest,full

set wildignore+=.hg,.git,.svn                    " Version control
set wildignore+=*.aux,*.out,*.toc                " LaTeX intermediate files
set wildignore+=*.jpg,*.bmp,*.gif,*.png,*.jpeg,*.tif    " binary images
set wildignore+=*.o,*.obj,*.exe,*.pdb,*.dll,*.manifest " compiled object files
set wildignore+=*.spl                            " compiled spelling word lists
set wildignore+=*.sw?                            " Vim swap files
set wildignore+=*.DS_Store                       " OSX
set wildignore+=*.luac                           " Lua byte code
set wildignore+=migrations                       " Django migrations
set wildignore+=*.pyc                            " Python byte code
set wildignore+=*.orig                           " Merge resolution files

" }}}
" Plugin setting {{{

" mru.vim {{{
" let MRU_Exclude_Files = '^/tmp/.*\|^/var/tmp/.*'  " For Unix
" let MRU_Exclude_Files = '^c:\\temp\\.*'           " For MS-Windows
" }}}

" vim-airline {{{

" Set theme
let g:airline_theme="molokai"

" }}}

" VimFiler {{{

" Replace netrw
let g:vimfiler_as_default_explorer = 1

" }}}

" UltiSnips {{{
" Add my own snippet directory
let g:UltiSnipsSnippetDirectories=["UltiSnips", "mysnippets"]
" }}}

" NERDTree {{{
" Display bookmark in NERD tree
let NERDTreeShowBookmarks = 1
" }}}

" SQLComplete {{{
" }}}

" dbext {{{
" Reference: https://mutelight.org/dbext-the-last-sql-client-youll-ever-need

" Don't ask input parameters
let g:dbext_default_prompt_for_parameters = 1
" Set prefer profile to skip prompting
let g:dbext_default_profile = 'sqlserver_'
" Discard temp files
let g:dbext_default_delete_temp_file = 1
" Specify history file location.  In Windows, it keeps in system path.
let g:dbext_default_history_file = $HOME.'/.dbext_sql_history'
"
" Example configuration
" SQLite
" let g:dbext_default_profile_sqlite_for_rails = 'type=SQLITE:dbname=/path/to/my/sqlite.db'
" Microsoft SQL Server
" let g:dbext_default_profile_sqlserver_mydb = 'type=SQLSRV:host=localhost:dbname=mydb:integratedlogin=1'
" @ask will prompt for password
" let g:dbext_default_profile_sqlserver_mydb = 'type=SQLSRV:host=localhost:dbname=mydb:user=sa:passwd=@ask'

" }}}

" SQLUtilities {{{
" Delimit comma as seperate line
let g:sqlutil_align_comma = 1
" Disable default key map
" let g:sqlutil_load_default_maps = 0
" Set GO as SQL delimiter
let g:sqlutil_cmd_terminator = "\ngo\n"
" }}}

" tComment {{{

" g:tcommentMapLeader1 should be a shortcut that can be used with map, imap, vmap.
" let g:tcommentMapLeader1 = '<c-_>'

" g:tcommentMapLeader2 should be a shortcut that can be used with  map, xmap.
" let g:tcommentMapLeader2 = '<Leader>_'

" See |tcomment-operator|.
" let g:tcommentMapLeaderOp1 = 'gc'

" See |tcomment-operator|.
" let g:tcommentMapLeaderOp2 = 'gC'

" }}}

" restore-view {{{

"let g:loaded_restore_view = 1

set viewoptions=cursor,folds,slash,unix
" let g:skipview_files = ['*\.vim']

" }}}

" Unite {{{
let g:unite_source_history_yank_enable = 1
" }}}

" ShowMarks {{{

" Prevent from loading
" let loaded_showmarks = 1

" }}}

" }}}
" Filetype setting {{{
" VIM {{{

augroup ft_vim
  au!

  au FileType vim setlocal foldmethod=marker ts=2 sts=2 sw=2 expandtab
  au FileType help setlocal textwidth=78
  au BufWinEnter *.txt if &ft == 'help' | wincmd L | endif
  au BufEnter * highlight OverLength ctermbg=darkgrey guibg=#592929
"  au BufEnter * match OverLength /\%78v.*/
augroup END

" }}}

" Ruby {{{

augroup ft_ruby
  au!
  au Filetype ruby setlocal foldmethod=syntax foldlevel=1 shiftwidth=2
  au BufRead,BufNewFile Capfile setlocal filetype=ruby
augroup END

" }}}

" Org {{{
augroup ft_org
  " au! BufRead,BufWrite,BufWritePost,BufNewFile *.org 
  au BufEnter *.org            call org#SetOrgFileType()
augroup END
" }}}

" CSS and Less {{{
augroup ft_css

  au!

  au Filetype less,css setlocal foldmethod=marker
  au Filetype less,css setlocal foldmarker={,}
  "au Filetype less,css setlocal omnifunc=csscomplete#CompleteCSS
  "au Filetype less,css setlocal iskeyword+=-

augroup END
" }}}

" Markdown {{{
augroup ft_markdown
  au!

  au BufNewFile,BufRead *.m*down setlocal filetype=markdown foldlevel=1

  " Use <localleader>1/2/3 to add headings.
  au Filetype markdown nnoremap <buffer> <localleader>1 yypVr=:redraw<cr>
  au Filetype markdown nnoremap <buffer> <localleader>2 yypVr-:redraw<cr>
  au Filetype markdown nnoremap <buffer> <localleader>3 mzI###<space><esc>`zllll
  au Filetype markdown nnoremap <buffer> <localleader>4 mzI####<space><esc>`zlllll

augroup END
" }}}
" }}}
" Helper Functions {{{

" Reference: https://gist.github.com/rkumar/4166881
"autocmd! BufWritePre * :call s:timestamp()
" auto-update "Last update: " if present whenever saving file
" to update timestamp when saving if its in the first 5 lines of a file
function! s:timestamp()
  let pat = '\(Last update\s*:\s*\).*'
  let rep = '\1' . strftime("%Y-%m-%d %H:%M")
  call s:subst(1, 5, pat, rep)
endfunction
" subst taken from timestamp.vim
" subst( start, end, pat, rep): substitute on range start - end.
function! s:subst(start, end, pat, rep)
  let lineno = a:start
  while lineno <= a:end
    let curline = getline(lineno)
    if match(curline, a:pat) != -1
    let newline = substitute( curline, a:pat, a:rep, '' )
      if( newline != curline )
        " Only substitute if we made a change
        "silent! undojoin
        keepjumps call setline(lineno, newline)
      endif
    endif
    let lineno = lineno + 1
  endwhile
endfunction

" Open current file in File Explorer
" Reference: http://vim.wikia.com/wiki/Open_the_directory_for_the_current_file_in_Windows
func! OpenCWD()
  if has("gui_running")
    if has("win32") || has("win64")
      let s:stored_shellslash = &shellslash
      set noshellslash
      !start explorer.exe %:p:h
      let &shellslash = s:stored_shellslash
    elseif has("gui_kde")
      !konqueror %:p:h &
    elseif has("gui_gtk") " TODO: test!
	  if len(expand('%')) == 0
		!nautilus "%:p:h" &
	  else
		!nautilus "%:p" &
	  endif
	  " !nautilus %:p:h &
    elseif has("mac") && has("unix") " TODO: test!
      let s:macpath = expand("%:p:h")
      let s:macpath = substitute(s:macpath," ","\\\\ ","g")
      execute '!open ' .s:macpath
    endif
  endif
endfunc

" }}}
" Key binding {{{

" Next Line Number
nmap <leader>nn :call ToggleNumbers()<CR><CR>

" Next Color Scheme
nmap <leader>nc :call NextColorScheme()<CR>

" Next Font
nmap <leader>nf :call ToggleFonts()<CR>


" Quick file editing
nnoremap <leader>ffv :e $MYVIMRC<cr>
"nnoremap <leader>ev :vsplit $MYVIMRC<cr>
" Access to snippet
nnoremap <leader>fds :e ~/.vim/mysnippets<cr>

" Open files in various mode
" Reference: http://vimcasts.org/episodes/the-edit-command/
cnoremap %% <C-R>=fnameescape(expand('%:p:h')).'/'<cr>
map <leader>fw :e %%
map <leader>fs :sp %%
map <leader>fv :vsp %%
map <leader>ft :tabe %%

" Open file explorer, etc.
map <leader>oe :call OpenCWD()<CR><CR>

" Treat long lines as break lines (useful in wrapped text)
map j gj
map k gk

" Smart way to move between windows
" Need upper case becuase it doesn't behave well in Windows.
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-h> <C-W>h
map <C-l> <C-W>l

" Useful mappings for managing tabs
map <leader>tn :tabnew<cr>
map <leader>to :tabonly<cr>
map <leader>tc :tabclose<cr>
map <leader>tm :tabmove<Space>

" Beauty XML
nmap <leader>x <ESC>:.,+1!xmllint --format --recover - 2>/dev/null<Home><Right>

" Sort properties
au BufNewFile,BufRead *.less,*.css nnoremap <buffer> <localleader>S ?{<CR>jV/\v^\s*\}?$<CR>k:sort<CR>:noh<CR>

" ShowMarks
" default key bingings
" <Leader>mt  - Toggles ShowMarks on and off.
" <Leader>mo  - Turns ShowMarks on, and displays marks.
" <Leader>mh  - Clears a mark.
" <Leader>ma  - Clears all marks.
" <Leader>mm  - Places the next available mark.
nnoremap [showmarks] <Nop>
nmap M [showmarks]
nnoremap [showmarks]m :ShowMarksPlaceMark<CR>
nnoremap [showmarks]t :ShowMarksToggle<CR>

" Unite
nnoremap [unite] <Nop>
nmap U [unite]
nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
nnoremap <silent> [unite]r :<C-u>Unite register<CR>
nnoremap <silent> [unite]m :<C-u>Unite file_mru<CR>
nnoremap <silent> [unite]c :<C-u>Unite bookmark<CR>
nnoremap <silent> [unite]o :<C-u>Unite outline<CR>
nnoremap <silent> [unite]t :<C-u>Unite tab<CR>
nnoremap <silent> [unite]w :<C-u>Unite window<CR>
nnoremap <silent> ugy :<C-u>Unite history/yank<CR>

"VimFiler
nnoremap <Leader>e :VimFilerExplorer<CR>

" }}}

