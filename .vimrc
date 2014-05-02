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
"    - Anonymous Pro
"
" Give credit where credit is due.
" https://github.com/tony/vim-config/blob/master/bundles.vim
" https://raw.github.com/hecomi/dotfiles/master/.vimrc
" https://github.com/mizutomo/dotfiles/blob/master/vimrc
" http://amix.dk/vim/vimrc.html
" http://spf13.com/post/perfect-vimrc-vim-config-file
" https://bitbucket.org/sjl/dotfiles/src/tip/vim/vimrc
" http://www.pythonclub.org/vim/gui-font
" http://wyw.dcweb.cn/vim/_vimrc.html
"
" Snippet respository
" https://github.com/Shougo/neosnippet-snippets

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

" Deferred filetytpes loading  {{{
NeoBundleLazy 'tpope/vim-git',                 { 'autoload': { 'filetypes': 'git' }}
NeoBundleLazy 'tpope/vim-markdown',            { 'autoload': { 'filetypes': 'markdown' }}
NeoBundleLazy 'nelstrom/vim-markdown-folding', { 'autoload': { 'filetypes': ['markdown'] }}
NeoBundleLazy 'groenewege/vim-less.git',       { 'autoload': { 'filetypes': 'less' }}
NeoBundleLazy 'othree/html5.vim',              { 'autoload': { 'filetypes': 'html' }}
NeoBundleLazy 'pangloss/vim-javascript',       { 'autoload': { 'filetypes': 'javascript' }}
NeoBundleLazy 'elzr/vim-json',                 { 'autoload': { 'filetypes': ['javascript', 'json'] }}
NeoBundleLazy 'hail2u/vim-css3-syntax',        { 'autoload': { 'filetypes': ['css', 'less'] }}
" }}}


" Super charge VIM setting
" xolox/vim-session - enhance :mksessions - Replaced by Unite {{{
" NeoBundle 'xolox/vim-session'
" " Sessions script location
" let g:session_directory='~/.vim/sessions'
" let g:session_autoload='no'
" }}}
" vim-quickrun {{{
NeoBundleLazy "thinca/vim-quickrun", {
      \ "autoload": {
      \ "commands": ["QuickRun"],
      \ "mappings": [['nxo', '<Plug>(quickrun)']]
      \ }}
let s:hooks = neobundle#get_hooks("vim-quickrun")
function! s:hooks.on_source(bundle)
  let g:quickrun_no_default_key_mappings = 1
  let g:quickrun_config = {
        \ "*": {"runmode": "async:remote:vimproc"},
        \ "_": {"runner": "vimproc", "runner/vimproc/updatetime": 60},
        \ }
  let g:quickrun_config['markdown'] = {
        \ 'type': 'markdown/kramdown',
        \ 'outputter': 'browser',
        \ }
  "let g:quickrun_config['ruby.rspec']  = {'command': 'rspec', 'cmdopt': '-f d'}
  " http://qiita.com/Qureana/items/b057c934733554e05427
  " https://github.com/muryoimpl/dotfiles/blob/master/.vim/vimrc_plugins_quickrun
  " let g:quickrun_config['ruby.rspec'] = {
  "       \ 'command': 'rspec',
  "       \ 'cmdopt': "-l %{line('.')}",
  "       \ 'exec': ['bundle exec %c %o %s %a']
  "       \ }

  let g:quickrun_config['ruby.spec'] = {
        \ 'type' : 'ruby',
        \ 'command' : 'rspec',
        \ 'exec' : 'bundle exec %c %o --color --tty %s'
        \ }
  let g:quickrun_config['ruby'] = {
        \ 'type' : 'ruby',
        \ 'command' : 'ruby',
        \ 'exec' : '%c %o %s'
        \ }

  let g:my_outputter = quickrun#outputter#multi#new()
  let g:my_outputter.config.targets = ["buffer", "quickfix"]

  function! my_outputter.init(session)
    :cclose
    call call(quickrun#outputter#multi#new().init, [a:session], self)
  endfunction

  function! my_outputter.finish(session)
    call call(quickrun#outputter#multi#new().finish, [a:session], self)
    bwipeout quickrun
    :HierUpdate
    :QuickfixStatusEnable
  endfunction

  call quickrun#register_outputter("my_outputter", my_outputter)
  nmap <silent> <leader>r :QuickRun -outputter my_outputter<CR>
  nmap <silent> <leader>m :QuickRun<CR>

endfunction
" NeoBundle 'ujihisa/quicklearn'
NeoBundle 'jceb/vim-hier'
" let g:hier_enabled = 1
" 	let g:hier_highlight_group_qf   = 'SpellBad'
" 	let g:hier_highlight_group_qfw  = 'SpellLocal'
" 	let g:hier_highlight_group_qfi  = 'SpellRare'
"
" 	let g:hier_highlight_group_loc  = 'SpellBad'
" 	let g:hier_highlight_group_locw = 'SpellLocal'
" 	let g:hier_highlight_group_loci = 'SpellRare'

" }}}
augroup RSpec
  au!
  au BufWinEnter,BufNewFile *_spec.rb set filetype=ruby.spec
augroup END

NeoBundle "skwp/vim-rspec.git"
" let g:RspecKeyma,=0
nnoremap <silent> ,rs :RunSpec<CR>
nnoremap <silent> ,rl :RunSpecLine<CR>

" Smart display to get better information
" quickhl - Give ability to highlight multiple words {{{
" NeoBundle 't9md/vim-quickhl'
NeoBundleLazy 't9md/vim-quickhl', {
      \ "depends": ["kana/vim-operator-user"],
      \ "autoload": {
      \ "commands": ["QuickhlCwordToggle"],
      \ 'mappings' : ['<Plug>(quickhl-manual-this)', '<Plug>(quickhl-manual-reset)', 
      \               '<Plug>(quickhl-cword-toggle)', '<Plug>(operator-quickhl-manual-this-motion)' ],
      \ }}
" let s:hooks = neobundle#get_hooks("vim-quickhl")
" function! s:hooks.on_source(bundle)
" let g:quickhl_manual_enable_at_startup=1
" Custom color
" let g:quickhl_manual_colors = [
"       \ "gui=bold ctermfg=16  ctermbg=153 guifg=#ffffff guibg=#0a7383",
"       \ "gui=bold ctermfg=7   ctermbg=1   guibg=#a07040 guifg=#ffffff",
"       \ "gui=bold ctermfg=7   ctermbg=2   guibg=#4070a0 guifg=#ffffff",
"       \ "gui=bold ctermfg=7   ctermbg=3   guibg=#40a070 guifg=#ffffff"
"       \ ]
" Keyword which is always highlighted.
" let g:quickhl_manual_keywords = [
"       \ "finish",
"       \ {"pattern": '\s\+$', "regexp": 1 },
"       \ {"pattern": '\d\{1,3}\.\d\{1,3}\.\d\{1,3}\.\d\{1,3}', "regexp": 1 }
"       \ ]
" endfunction
" }}}
" vim-indent-guides {{{
" NeoBundle 'nathanaelkane/vim-indent-guides'
NeoBundleLazy "nathanaelkane/vim-indent-guides", {
      \ "autoload": {
      \ "commands": ["IndentGuidesToggle"],
      \ }}
" }}}
" indentLine {{{
if has('conceal')
  NeoBundleLazy 'Yggdroot/indentLine', {
        \ "autoload": {
        \ "commands": ["IndentLinesToggle"],
        \ }}
endif
" }}}
" ShowMarks - Display marks {{{
NeoBundleLazy "vim-scripts/ShowMarks", {
      \ "autoload": {
      \ "commands": ["ShowMarksPlaceMark", "ShowMarksToggle", "ShowMarksClearAll", "ShowMarksClearMark"],
      \ }}
let s:hooks = neobundle#get_hooks("ShowMarks")
function! s:hooks.on_source(bundle)
  " ignore ShowMarks on buffer type of
  " Help, Non-modifiable, Preview, Quickfix
  let showmarks_ignore_type = 'hmpq'
endfunction
" }}}
" vim-AnsiEsc - ANSI color {{{
NeoBundleLazy "jakar/vim-AnsiEsc", {
      \ "autoload": {
      \ "commands": ["AnsiEsc"],
      \ }}
" }}}
" vim-airline {{{
NeoBundle 'bling/vim-airline' " Status line display
" Set theme
" let g:airline_theme="molokai"
" }}}


" Smart text format
" NeoBundle 'godlygeek/tabular' " Replace by vim-easy-align
" NeoBundle 'vim-scripts/Align' " Replace by vim-easy-align
" vim-easy-align - align text block {{{
" NeoBundle 'junegunn/vim-easy-align'
NeoBundleLazy 'junegunn/vim-easy-align', {
      \ "autoload": {
      \ "commands": ["EasyAlign"],
      \ 'mappings': ['<Plug>(EasyAlign)', '<Plug>(LiveEasyAlign)'],
      \ }}
let s:hooks = neobundle#get_hooks("vim-easy-align")
function! s:hooks.on_source(bundle)
  " let g:easy_align_delimiters=
endfunction
" }}}
" vim-transpose - Transpose columns to rows {{{
NeoBundleLazy 'salsifis/vim-transpose', {
      \ "autoload": {
      \ "commands": ["Transpose"],
      \ }}
" }}}
" tComment {{{
NeoBundle 'tomtom/tcomment_vim'
" g:tcommentMapLeader1 should be a shortcut that can be used with map, imap, vmap.
" let g:tcommentMapLeader1 = '<c-_>'
" g:tcommentMapLeader2 should be a shortcut that can be used with  map, xmap.
" let g:tcommentMapLeader2 = '<Leader>_'
" See |tcomment-operator|.
" let g:tcommentMapLeaderOp1 = 'gc'
" See |tcomment-operator|.
" let g:tcommentMapLeaderOp2 = 'gC'
" }}}


" Smart text selection
" vim-expand-region - incremental visual selection {{{
" NeoBundle 'terryma/vim-expand-region'
NeoBundleLazy 'terryma/vim-expand-region', {
      \ "depends": ["kana/vim-operator-user"],
      \ "autoload": {
      \ 'mappings' : ['<Plug>(expand_region_expand)', '<Plug>(expand_region_shrink)' ],
      \ }}
" Containing the text objects for search (NOTE: Remove comments in dictionary before sourcing)
" let g:expand_region_text_objects = {
"       \ 'iw'  :0,
"       \ 'iW'  :1,
"       \ 'i"'  :0,
"       \ 'i''' :0,
"       \ 'i]'  :1,<Down> " Support nesting of square brackets
"       \ 'ib'  :1, " Support nesting of parentheses
"       \ 'iB'  :1, " Support nesting of braces
"       \ 'il'  :0, " Not included in Vim by default. See https://github.com/kana/vim-textobj-line
"       \ 'ip'  :0,
"       \ 'ie'  :0  " Not included in Vim by default. See https://github.com/kana/vim-textobj-entire
"       \}
" let g:expand_region_text_objects_ruby = {
"       \ 'im' :0, " 'inner method'. Available through https://github.com/vim-ruby/vim-ruby
"       \ 'am' :0, " 'around method'. Available through https://github.com/vim-ruby/vim-ruby
"       \ }
"call expand_region#custom_text_objects('ruby', {
"      \ 'im' :0,
"      \ 'am' :0,
"      \ })
" }}}


" Smart file editing
" gundo - track undo tree {{{
NeoBundleLazy "sjl/gundo.vim", {
      \ "autoload": {
      \ "commands": ['GundoToggle'],
      \}}
let s:hooks = neobundle#get_hooks("gundo.vim")
function! s:hooks.on_source(bundle)
  "   let g:gundo_width = 60
  "   let g:gundo_preview_height = 40
  "   let g:gundo_right = 1
  "   let g:gundo_preview_bottom = 1
endfunction
" }}}
" junkfile.vim - scratch pad {{{
NeoBundleLazy 'Shougo/junkfile.vim', {
      \ 'autoload' : {
      \  'commands'     : 'JunkfileOpen',
      \  'unite_sources': ['junkfile', 'junkfile/new'],
      \ }}
" }}}


" SQL
" NeoBundle 'vim-scripts/SQLComplete.vim' " Bundle in VIM
" dbext - interfact to database {{{
" Reference: https://mutelight.org/dbext-the-last-sql-client-youll-ever-need
NeoBundle 'vim-scripts/dbext.vim'

" Don't ask input parameters
let g:dbext_default_prompt_for_parameters = 1
" Set prefer profile to skip prompting
let g:dbext_default_profile = 'sqlserver_'
" Discard temp files
let g:dbext_default_delete_temp_file = 1
" Specify history file location.  In Windows, it keeps in system path.
let g:dbext_default_history_file = $HOME.'/.dbext_sql_history'
" DBListColumn (by default) will create a column list with an alias
" n - do not use an alias
" d - use the default (calculated) alias
" a - ask to confirm the alias name
let g:dbext_default_use_tbl_alias='a'
" Result sets returned by the database as columns or rows
let g:dbext_default_DBI_orientation = 'v'
" let g:dbext_default_DBI_orientation=''
" Column delimiter
let g:dbext_default_DBI_column_delimiter = "\t"

" Example configuration
" SQLite
" let g:dbext_default_profile_sqlite_for_rails = 'type=SQLITE:dbname=/path/to/my/sqlite.db'
" Microsoft SQL Server
" let g:dbext_default_profile_sqlserver_mydb = 'type=SQLSRV:host=localhost:dbname=mydb:integratedlogin=1'
" @ask will prompt for password
" let g:dbext_default_profile_sqlserver_mydb = 'type=SQLSRV:host=localhost:dbname=mydb:user=sa:passwd=@ask'

" }}}
" SQLUtilities {{{
NeoBundle 'vim-scripts/SQLUtilities'
" Delimit comma as seperate line
let g:sqlutil_align_comma=1
" Disable default key map
" let g:sqlutil_load_default_maps = 0
" Set GO as SQL delimiter
let g:sqlutil_cmd_terminator = "\ngo\n"
let g:sqlutil_keyword_case = '\U'
" }}}


" Extend Text Object {{{
" https://github.com/kana/vim-textobj-user/wiki
NeoBundle 'kana/vim-textobj-user'
NeoBundle 'Julian/vim-textobj-brace' "aj ij
NeoBundle 'Julian/vim-textobj-variable-segment'
NeoBundle 'jceb/vim-textobj-uri' " iu au
NeoBundle 'kana/vim-textobj-datetime' " ada ida
NeoBundle 'kana/vim-textobj-diff' " adh idh
NeoBundle 'kana/vim-textobj-entire' " ae ie
NeoBundle 'kana/vim-textobj-line' " al il
NeoBundle 'kana/vim-textobj-syntax'
" NeoBundle 'mattn/vim-textobj-url'
NeoBundle 'michaeljsmith/vim-indent-object'
NeoBundle 'osyo-manga/vim-textobj-multiblock'
NeoBundle 'osyo-manga/vim-textobj-multitextobj'
NeoBundle 'rhysd/vim-textobj-word-column'
NeoBundle 'thinca/vim-textobj-between' " af{char} if{char}
NeoBundle 'reedes/vim-textobj-quote'
" NeoBundleLazy 'thinca/vim-textobj-plugins', {
"       \	'depends'  : ['kana/vim-textobj-function'],
"       \	'autoload' : {
"       \		'filetypes' : ['html', 'javascript', 'perl'],
"       \	},
"       \ }
" " nelstrom/vim-textobj-rubyblock
" NeoBundleLazyByFileTypes 'kana/vim-textobj-function'
"       \ 	['c', 'vim']
" }}}

NeoBundle 'flazz/vim-colorschemes' " Tons of color schemes
NeoBundle 'vim-scripts/changeColorScheme.vim' " Randomize color scheme
"NeoBundle 'vim-scripts/mru.vim.git' " Save file history.  Replaced by neomru.vim
NeoBundle 'mattn/emmet-vim'
NeoBundle 'vim-scripts/DrawIt'
" NeoBundle 'roman/golden-ratio'
NeoBundle 'szw/vim-maximizer'
NeoBundle 'terryma/vim-multiple-cursors'
NeoBundle 'tpope/vim-repeat'
NeoBundle 'tpope/vim-dispatch'
NeoBundle 'tpope/vim-abolish'
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-unimpaired' " Easy key binding movement.
NeoBundle 'tpope/vim-speeddating' " Ctrl-A and Ctrl-X on date
NeoBundle 'zhaocai/GoldenView.Vim'
NeoBundle 'vim-voom/VOoM'

" NeoBundle 'vim-scripts/YankRing.vim'
" Default mapping
"     let g:multi_cursor_next_key='<C-s>'
"     let g:multi_cursor_prev_key='<C-d>'
"     let g:multi_cursor_skip_key='<C-f>'
"     let g:multi_cursor_quit_key='<Esc>'
"

" memolist.vim - Jog down thought and idea {{{
NeoBundleLazy "glidenote/memolist.vim", {
      \ "autoload": {
      \ "commands": ["MemoList", "MemoNew", "MemoGrep"],
      \ }}
let s:hooks = neobundle#get_hooks("memolist.vim")
function! s:hooks.on_source(bundle)
  let g:memolist_path = "~/memo"

  " let g:memolist_memo_suffix = "txt"

  " date format (default %Y-%m-%d %H:%M)
  let g:memolist_memo_date = "%Y-%m-%d %H:%M:%S %Z"

  " tags prompt (default 0)
  let g:memolist_prompt_tags = 1

  " categories prompt (default 0)
  let g:memolist_prompt_categories = 1

  " use qfixgrep (default 0)
  let g:memolist_qfixgrep = 1

  " use vimfler (default 0)
  let g:memolist_vimfiler = 1

  " use arbitrary vimfler option (default -split -winwidth=50)
  let g:memolist_vimfiler_option = "-split -winwidth=50 -simple"

  " use unite (default 0)
  let g:memolist_unite = 1

  " use arbitrary unite option (default is empty)
  let g:memolist_unite_option = "-auto-preview -start-insert"

  " use arbitrary unite source (default is 'file')
  let g:memolist_unite_source = "file_rec"

  " use template
  let g:memolist_template_dir_path = "~/.vim/template/memolist"

  " remove filename prefix (default 0)
  " let g:memolist_filename_prefix_none = 1
endfunction
" }}}

" Gist.vim {{{
NeoBundleLazy "mattn/gist-vim", {
      \ "depends": ["mattn/webapi-vim"],
      \ "autoload": {
      \ "commands": ["Gist"],
      \ }}
" NeoBundle 'mattn/webapi-vim'
" NeoBundle 'mattn/gist-vim'
" Detect filetype
let g:gist_detect_filetype = 1
" Open browser after the post
" let g:gist_open_browser_after_post = 0
" Show your private gists with ":Gist -l"
let g:gist_show_privates = 1
" gist to be private by default
let g:gist_post_private = 1
" }}}

" Comment out becuase it may freeze VIM after :w
" easytags.vim - for tagging {{{
" required by easytags
NeoBundle 'xolox/vim-misc'

NeoBundle 'xolox/vim-easytags'
" Prevent from loading
let g:loaded_easytags = 1
" ensure it checks the project specific tags file
" let g:easytags_dynamic_files = 1
" configure easytags to run ctags after saving the buffer
" let g:easytags_events = ['BufWritePost']

" }}}

" tagbar {{{
NeoBundle 'majutsushi/tagbar'
" }}}

" NeoBundle 'SirVer/ultisnips' " Code Snippet
" SnipMate {{{
" NeoBundle 'marcweber/vim-addon-mw-utils'
" NeoBundle 'tomtom/tlib_vim'
" NeoBundle 'garbas/vim-snipmate'
" }}}

" required by Neosnippet for context-type feature
NeoBundle 'Shougo/context_filetype.vim'

" Neosnippet {{{
NeoBundle 'Shougo/neosnippet.vim'

" Custom directory
let g:neosnippet#snippets_directory='$HOME/.vim/neosnippets'
" }}}

" neocomplcache {{{
NeoBundle 'Shougo/neocomplcache.vim'

" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'

" Enable heavy features.
" Use camel case completion.
"let g:neocomplcache_enable_camel_case_completion = 1
" Use underbar completion.
"let g:neocomplcache_enable_underbar_completion = 1

" Define dictionary.
let g:neocomplcache_dictionary_filetype_lists = {
      \ 'default' : '',
      \ 'vimshell' : $HOME.'/.vimshell_hist',
      \ 'scheme' : $HOME.'/.gosh_completions'
      \ }

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'
" }}}

" openbrowser - URL or file browsing {{{
" NeoBundle 'tyru/open-browser.vim'
NeoBundleLazy 'tyru/open-browser.vim', {
      \	'autoload' : {
      \		'commands' : 'OpenBrowser',
      \		'mappings' : ['<Plug>(openbrowser-open)', '<Plug>(openbrowser-smart-search)'],
      \	}}
let s:hooks = neobundle#get_hooks("open-browser.vim")
function! s:hooks.on_source(bundle)
  " let g:openbrowser_fix_hosts
  " let g:openbrowser_fix_paths
  let g:openbrowser_search_engines = {
        \   'google': 'https://www.google.com/search?q={query}'
        \}
endfunction
" }}}

if !has('win32') && !has('win64') " TODO: fix Windows view path
  NeoBundle 'vim-scripts/restore_view.vim' " Remember file cursor and folding position
endif


" Git {{{
NeoBundle 'tpope/vim-fugitive'

NeoBundleLazy 'airblade/vim-gitgutter', {
      \ "depends": ["tpope/vim-fugitive"],
      \ "autoload": {
      \ "commands": ["GitGutterToggle"],
      \ }}
let s:hooks = neobundle#get_hooks("vim-gitgutter")
function! s:hooks.on_source(bundle)
  let g:gitgutter_map_keys = 0
  let g:gitgutter_enabled         = 0
  let g:gitgutter_highlight_lines = 0
  let g:gitgutter_sign_added      = '+'
  let g:gitgutter_sign_modified   = '~'
  let g:gitgutter_sign_removed    = '-'
endfunction

NeoBundleLazy "gregsexton/gitv", {
      \ "depends": ["tpope/vim-fugitive"],
      \ "autoload": {
      \ "commands": ["Gitv"],
      \ }}
" }}}

" NeoBundle "Shougo/unite.vim"
NeoBundleLazy "Shougo/unite.vim", {
      \ "autoload": {
      \ "commands": ["Unite", "UniteWithBufferDir"]
      \ }}
let s:hooks = neobundle#get_hooks("unite.vim")
function! s:hooks.on_source(bundle)
  " start unite in insert mode
  let g:unite_enable_start_insert = 0
  let g:unite_source_history_yank_enable = 1

  " use vimfiler to open directory
  "  call unite#custom_default_action("source/bookmark/directory", "vimfiler")
  call unite#custom_default_action("directory", "vimfiler")
  call unite#custom_default_action("directory_mru", "vimfiler")
  autocmd MyAutoCmd FileType unite call s:unite_settings()
  function! s:unite_settings()
    imap <buffer> <Esc><Esc> <Plug>(unite_exit)
    nmap <buffer> <Esc> <Plug>(unite_exit)
    nmap <buffer> <C-n> <Plug>(unite_select_next_line)
    nmap <buffer> <C-p> <Plug>(unite_select_previous_line)
  endfunction
endfunction
NeoBundleLazy 'h1mesuke/unite-outline', {
      \ "autoload": {
      \ "unite_sources": ["outline"],
      \ }}
NeoBundle 'Shougo/neomru.vim' " Prefer integration with unite
NeoBundle 'moznion/unite-git-conflict.vim'
NeoBundle 'Shougo/unite-session'

" File Explorer
NeoBundleLazy "Shougo/vimfiler", {
      \ "depends": ["Shougo/unite.vim"],
      \ "autoload": {
      \ "commands": ["VimFilerTab", "VimFiler", "VimFilerExplorer"],
      \ "mappings": ['<Plug>(vimfiler_switch)'],
      \ "explorer": 1,
      \ }} " Use unite bookmark to track specific issues
" close vimfiler automatically when there are only vimfiler open
" autocmd MyAutoCmd BufEnter * if (winnr('$') == 1 && &filetype ==# 'vimfiler') | q | endif
let s:hooks = neobundle#get_hooks("vimfiler")
function! s:hooks.on_source(bundle)
  let g:vimfiler_as_default_explorer = 1
  let g:vimfiler_enable_auto_cd = 1
  let g:vimfiler_ignore_pattern = '^\%(.git\|.DS_Store\)$'
  "
  " " vimfiler specific key mappings
  autocmd MyAutoCmd FileType vimfiler call s:vimfiler_settings()
  function! s:vimfiler_settings()
    " " ^^ to go up
    "     nmap <buffer> ^^ <Plug>(vimfiler_switch_to_parent_directory)
    " " use R to refresh
    "     nmap <buffer> R <Plug>(vimfiler_redraw_screen)
    " " overwrite C-l
    "     nmap <buffer> ^^ <Plug>(vimfiler_switch_to_parent_directory)
    nmap <buffer> , <Plug>(vimfiler_toggle_visible_dot_files)
  endfunction
endfunction
NeoBundle 'scrooloose/nerdtree' " Bookmark well on directories

" Ruby/Rails
" http://www.vimninjas.com/2012/08/28/vim-for-rubyists-part-1/
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'tpope/vim-rails'
NeoBundle 'ecomba/vim-ruby-refactoring'
NeoBundle 'tpope/vim-cucumber'
NeoBundle 'tpope/vim-haml'
" NeoBundle 'thoughtbot/vim-rspec'
" " let g:rspec_command = "!rspec --drb {spec}"
" " let g:rspec_command = "dispatch rspec {spec}"
" " RSpec.vim mappings
" map <Leader>t :call RunCurrentSpecFile()<CR>
" map <Leader>s :call RunNearestSpec()<CR>
" map <Leader>l :call RunLastSpec()<CR>
" map <Leader>a :call RunAllSpecs()<CR>


" NeoBundle 'duskhacker/sweet-rspec-vim'
"
" map <Leader>t :SweetVimRspecRunFile<CR>
" map <Leader>f :SweetVimRspecRunFocused<CR> "(SHIFT-CMD-r)
" map <Leader>l :SweetVimRspecRunPrevious<CR> "(OPT-CMD-r)

" NeoBundle 'janx/vim-rubytest'
" let g:rubytest_in_quickfix = 1
" let g:rubytest_cmd_test = "ruby %p"
" let g:rubytest_cmd_testcase = "ruby %p -n '/%c/'"
" let g:rubytest_cmd_spec = "spec -f specdoc %p"
" let g:rubytest_cmd_example = "spec -f specdoc %p -e '%c'"
" let g:rubytest_cmd_feature = "cucumber %p"
" let g:rubytest_cmd_story = "cucumber %p -n '%c'"

NeoBundle 'heavenshell/vim-quickrun-hook-unittest'
" NeoBundle 'mileszs/apidock.vim'
NeoBundle 'lucapette/vim-ruby-doc'
if !has('win32') && !has('win64') " Windows not supported
  NeoBundle 'astashov/vim-ruby-debugger'
endif
" astashov/debugger-xml'

NeoBundle 'hsitz/VimOrganizer' " For note taking
NeoBundle 'mattn/calendar-vim' " Required by VimOrganizer
NeoBundle 'vim-scripts/utl.vim' " Optional for VimOrganizer
NeoBundle 'chrisbra/NrrwRgn' " Optional for VimOrganizer

" TODO list manager
" NeoBundle 'codegram/vim-todo' " Doesn't seems to work
NeoBundle 'mivok/vimtodo'

" NeoBundle "thinca/vim-template"
" autocmd MyAutoCmd User plugin-template-loaded call s:template_keywords()
" function! s:template_keywords()
"   silent! %s/<+DATE+>/\=strftime('%Y-%m-%d')/g
"   silent! %s/<+FILENAME+>/\=expand('%')/g
" endfunction
" autocmd MyAutoCmd User plugin-template-loaded
"   \ if search('<+CURSOR+>')
"   \ | silent! execute 'normal! "_da>'
"   \ | endif

" NeoBundle "scrooloose/syntastic", {
"   \ "build": {
"   \ "mac": ["pip install pyflake", "npm -g install coffeelint"],
"   \ "unix": ["pip install pyflake", "npm -g install coffeelint"],
"   \ }}
" let g:syntastic_mode_map = {
"       \ 'mode': 'active',
"       \ 'passive_filetypes': ['python']
"       \ }

" NeoBundleLazy 'Shougo/vimshell.git', {
"       \ "autoload": {
"       \ "commands": ["VimShell"],
"       \ }}
" nnoremap <silent> <Leader>is :VimShell<CR>
" nnoremap <silent> <Leader>ipy :VimShellInteractive python3<CR>
" vmap <silent> <Leader>ss: VimShellSendString

NeoBundleCheck

" release autogroup in MyAutoCmd
augroup MyAutoCmd
  autocmd!
augroup END

unlet s:hooks

filetype plugin indent on " Enable filetype plugins

" }}}
" General Options {{{

set history=1000 " Sets how many lines of history VIM has to remember (default is 20)

set autoread " Set to auto read when a file is changed from the outside

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ";"
let maplocalleader = "'"

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

" Wrap around words
" Reference: http://vimcasts.org/episodes/soft-wrapping-text/
command! -nargs=* Wrap set wrap linebreak nolist

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


set ttyfast

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
"     autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
"     autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
"     autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
"     autocmd FileType php set omnifunc=phpcomplete#CompletePHP
"     autocmd FileType c set omnifunc=ccomplete#Complete
"     autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
"     autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags

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

" set completeopt=longest,menuone,preview " Completion style
set completeopt=menu,menuone,preview " Completion style

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

let g:xml_syntax_folding=1
" }}}
" Quickfix {{{
augroup QFixToggle
  "  autocmd!
  autocmd BufWinEnter quickfix setlocal norelativenumber
augroup END
" }}}
" QuickRun {{{
" augroup QuickRunUnitTest
"   autocmd!
"   "autocmd BufWinEnter,BufNewFile *test.php setlocal filetype=php.unit
"   " Choose UnitTest or py.test.
"   "autocmd BufWinEnter,BufNewFile test_*.py setlocal filetype=python.unit
"   "autocmd BufWinEnter,BufNewFile test_*.py setlocal filetype=python.pytest
"   "autocmd BufWinEnter,BufNewFile *.t setlocal filetype=perl.unit
"   autocmd BufWinEnter,BufNewFile *_spec.rb setlocal filetype=ruby.rspec
" augroup END
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
set shiftwidth=2
set tabstop=2
set softtabstop=2
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
" Color Scheme and Font {{{

syntax on " Enable syntax highlighting

colorscheme desert

if has("gui_running")

  " Font Switching Binds {
  if has('win32') || has('win64')
    silent! set guifontwide=MingLiU:h11:cANSI
  endif
endif

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

" UltiSnips {{{
" Add my own snippet directory
let g:UltiSnipsSnippetDirectories=["UltiSnips", "mysnippets"]
" }}}

" NERDTree {{{
" Display bookmark in NERD tree
let NERDTreeShowBookmarks = 1
" }}}

" restore-view {{{
" let g:loaded_restore_view = 1

set viewoptions=cursor,folds,slash,unix
" let g:skipview_files = ['*\.vim']

" }}}

" Utl {{{

if has("unix")
  let utl_cfg_hdl_scm_http="silent !firefox -remote 'ping()' && firefox -remote 'openURL( %u )' || firefox '%u#%f' &"

endif

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

" VimFiler {{{
augroup ft_vimfiler
  au!
  au FileType vimfiler setlocal nonumber norelativenumber
augroup END
" }}}

" Ruby {{{

augroup ft_ruby
  au!
  au Filetype ruby setlocal foldmethod=syntax foldlevel=1
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

" SQL {{{
augroup ft_sql
  au!

  " Not working well
  " au BufNewFile,BufRead *.sql* setlocal filetype=syntax foldlevel=1
  " autocmd FileType sql set omnifunc=sqlcomplete#Complete
augroup END
" }}}

" SQL {{{
augroup ft_sql
  au!

  " Not working well
  " au BufNewFile,BufRead *.sql* setlocal filetype=syntax foldlevel=1
  " autocmd FileType sql set omnifunc=sqlcomplete#Complete
augroup END
" }}}

" Markdown {{{
augroup ft_markdown
  au!

  au BufNewFile,BufRead *.m*down setlocal fileformat=unix filetype=markdown foldlevel=1
  au! BufWritePre *.m*down :call s:timestamp()

  " Use <localleader>1/2/3 to add headings.
  au Filetype markdown nnoremap <buffer> <localleader>1 yypVr=:redraw<cr>
  au Filetype markdown nnoremap <buffer> <localleader>2 yypVr-:redraw<cr>
  au Filetype markdown nnoremap <buffer> <localleader>3 mzI###<space><esc>`zllll
  au Filetype markdown nnoremap <buffer> <localleader>4 mzI####<space><esc>`zlllll

augroup END
" }}}

" XML {{{
augroup ft_xml
  au!
  au FileType xml setlocal foldmethod=syntax
  " http://ku1ik.com/2011/09/08/formatting-xml-in-vim-with-indent-command.html
  au FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null
augroup END
" }}}

" todo {{{
augroup ft_todo
  au!
  au BufRead,BufNewFile *.todo,TODO setfiletype todo
augroup END
" }}}

" json {{{
augroup ft_json
  au!
  au FileType json setlocal equalprg=python\ -m\ json.tool
  " au FileType json setlocal ts=2 sts=2 sw=2 expandtab equalprg=python\ -m\ json.tool
augroup END
" }}}

" Disable folder when file opened
au BufRead * normal zR

" }}}
" Helper Functions {{{

function! ToggleFonts()

  " My favorite editor fonts
  if has('win32') || has('win64')
    let s:myfonts = ['Source_Code_Pro:h11:cANSI']
    call add(s:myfonts, 'Inconsolata:h11:cANSI')
    call add(s:myfonts, 'ProFontWindows:h11:cANSI')
    call add(s:myfonts, 'Consolas:h11:cANSI')
  elseif has('unix')
    let s:myfonts = ['Source Code Pro Medium 11']
    call add(s:myfonts, 'Anonymous Pro 11')
    call add(s:myfonts, 'DejaVu Sans Mono 11')
    call add(s:myfonts, 'Ubuntu Mono 11')
    call add(s:myfonts, 'Monospace 11')
  endif

  let s:at = -1
  let s:index = 0
  let s:size = len(s:myfonts)

  if s:size<=0
    return
  endif

  while s:index < s:size
    if &guifont==?s:myfonts[s:index]
      let s:at = s:index
      break
    endif
    let s:index += 1
  endwhile

  if s:index >= s:size
    let s:at = 0
  else
    let s:at += 1
  endif

  " echo s:at
  if s:at >= s:size
    let s:at = 0
  endif

  let &guifont=get(s:myfonts, s:at)

  " echom "guifont " . &guifont . " is set."

endfunction

" Reference: https://gist.github.com/rkumar/4166881
"autocmd! BufWritePre * :call s:timestamp()
" auto-update "Last update: " if present whenever saving file
" to update timestamp when saving if its in the first 5 lines of a file
function! s:timestamp()
  let pat = '\(updated_at:\s*\).*'
  let rep = '\1' . strftime("%Y-%m-%d %H:%M:%S %Z")
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

function! s:GetMyTimeFormat()
  if has("win32") || has("win64")
    return "%Y-%m-%d %H:%M:%S " . s:GetTimeZoneOffset()
  else
    return "%Y-%m-%d %H:%M:%S %Z"
  endif
endfunction

if has("win32") || has("win64")
  " Windows %z does not offer time zone difference
  " https://gist.github.com/mattn/1593343
  let s:reg_path = 'HKLM\System\CurrentControlSet\Control\TimeZoneInformation'

  function! s:GetTimeZoneName()
    let res = system(printf("reg query %s /v StandardName | findstr REG_SZ", s:reg_path))
    return split(substitute(res, '\n', '', 'g'), '\s')[2]
  endfunction

  function! s:GetTimeZoneOffset()
    let res = system(printf("reg query %s /v Bias | findstr REG_DWORD", s:reg_path))
    return -(split(res, '[ \t\n]\+')[2] / 60)
  endfunction
endif

" }}}
" Key binding {{{

" Toggle
nnoremap [toggle] <Nop>
nmap \ [toggle]
nnoremap <silent> [toggle]T :TagbarToggle<CR>
nnoremap <silent> [toggle]c :call NextColorScheme()<CR>:AirlineRefresh<CR>
nnoremap <silent> [toggle]f :call ToggleFonts()<CR>
nnoremap <silent> [toggle]g :GoldenRatioToggle<CR>
if has('conceal')
  " indentLine
  nnoremap <silent> [toggle]i :IndentLinesToggle<CR>
else
  " visual-indent-guides
  nnoremap <silent> [toggle]i :IndentGuidesToggle<CR>
endif
nnoremap <silent> [toggle]l :<C-u>setl list!<CR>:setl list?<CR>
nnoremap <silent> [toggle]m :ShowMarksToggle<CR>
nnoremap <silent> [toggle]n :call ToggleNumbers()<CR>
nnoremap <silent> [toggle]s :<C-u>setl spell!<CR>:setl spell?<CR>
nnoremap <silent> [toggle]t :<C-u>setl expandtab!<CR>:setl expandtab?<CR>
" sjl/gundo.vim
nnoremap <silent> [toggle]u :GundoToggle<CR>
nnoremap <silent> [toggle]w :<C-u>setl wrap!<CR>:setl wrap?<CR>



" Defining prefix as my own mnemonic trigger.
" Idea taken from https://raw.github.com/hecomi/dotfiles/master/.vimrc
nnoremap [prefix] <Nop>
nmap ,   [prefix]
xnoremap [prefix] <nop>
xmap ,   [prefix]


" Open browser using 
nmap [prefix]bo <Plug>(openbrowser-open)
vmap [prefix]bo <Plug>(openbrowser-open)
nmap [prefix]bs <Plug>(openbrowser-smart-search)
vmap [prefix]bs <Plug>(openbrowser-smart-search)

" vim-gitgutter {{{
nnoremap [prefix]gg :GitGutterToggle<CR>
nnoremap [prefix]gn :GitGutterNextHunk<CR>
nnoremap [prefix]gN :GitGutterPrevHunk<CR>
" }}}

" vim-fugitive {{{
nmap [prefix]gb :Gblame<CR>
nmap [prefix]gd :Gdiff<CR>
nmap [prefix]gs :Gstatus<CR>
nmap [prefix]gl :Glog<CR>
nmap [prefix]ga :Gwrite<CR>
nmap [prefix]gc :Gread<CR>
nmap [prefix]gC :Gcommit<CR>
" }}}

" Gitv {{{
nmap [prefix]gv :Gitv<CR>
" }}}

" ShowMarks {{{
nmap [prefix]mm :ShowMarksPlaceMark<CR>
nmap [prefix]mt :ShowMarksToggle<CR>
nmap [prefix]ma :ShowMarksClearAll<CR>
nmap [prefix]mh :ShowMarksClearMark<CR>
" }}}

" Unite Session {{{
nmap [prefix]ss :UniteSessionSave<SPACE>
" }}}

" quickhl
nmap <Space>m <Plug>(quickhl-manual-this)
xmap <Space>m <Plug>(quickhl-manual-this)
nmap <Space>M <Plug>(quickhl-manual-reset)
xmap <Space>M <Plug>(quickhl-manual-reset)
nmap <Space>j <Plug>(quickhl-cword-toggle)
nmap <Space>] <Plug>(quickhl-tag-toggle)
map H <Plug>(operator-quickhl-manual-this-motion)

" vim-easy-align
vmap <Enter>           <Plug>(EasyAlign)
nmap <Leader>a         <Plug>(EasyAlign)
vmap <Leader><Enter>   <Plug>(LiveEasyAlign)
nmap <Leader><Leader>a <Plug>(LiveEasyAlign)

" Quick file editing
nnoremap <leader>ffv :e $MYVIMRC<cr>
"nnoremap <leader>ev :vsplit $MYVIMRC<cr>
" Access to snippet
nnoremap <leader>fds :VimFiler ~/.vim/neosnippets<cr>

" Open files in various mode
" Reference: http://vimcasts.org/episodes/the-edit-command/
cnoremap %% <C-R>=fnameescape(expand('%:p:h')).'/'<cr>
map <leader>fw :e %%
map <leader>fs :sp %%
map <leader>fv :vsp %%
map <leader>ft :tabe %%

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

" Yank file name buffer
nmap cf :let @+ = expand("%")<CR>
nmap cp :let @+ = expand("%:p")<CR>

" Beauty XML
nmap <leader>x <ESC>:.,+1!xmllint --format --recover - 2>/dev/null<Home><Right>

" Sort properties
au BufNewFile,BufRead *.less,*.css nnoremap <buffer> <localleader>S ?{<CR>jV/\v^\s*\}?$<CR>k:sort<CR>:noh<CR>

" Unite
nnoremap [unite] <Nop>
nmap U [unite]
nnoremap <silent> [unite]b :<C-u>Unite buffer<CR>
nnoremap <silent> [unite]f :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> [unite]g :<C-u>Unite grep<CR>
nnoremap <silent> [unite]j :<C-u>Unite jump<CR>
nnoremap <silent> [unite]jf :<C-u>Unite junkfile<CR>
nnoremap <silent> [unite]jfn :<C-u>Unite junkfile/new<CR>
nnoremap <silent> [unite]k :<C-u>Unite bookmark
nnoremap <silent> [unite]l :<C-u>Unite line<CR>
nnoremap <silent> [unite]m :<C-u>Unite file_mru<CR>
nnoremap [unite]ni :Unite neobundle/install<CR>
nnoremap [unite]nl :Unite neobundle/log<CR>
nnoremap [unite]ns :Unite neobundle/search<CR>
nnoremap [unite]nu :Unite neobundle/update<CR>
nnoremap <silent> [unite]o :<C-u>Unite outline<CR>
nnoremap <silent> [unite]r :<C-u>Unite register<CR>
nnoremap <silent> [unite]S :<C-u>Unite session<CR>
nnoremap <silent> [unite]s :<C-u>Unite source<CR>
nnoremap <silent> [unite]t :<C-u>Unite tab<CR>
nnoremap <silent> [unite]w :<C-u>Unite window<CR>
nnoremap <silent> ugy :<C-u>Unite history/yank<CR>

"VimFiler
nnoremap <Leader>e :VimFilerExplorer<CR>

" memolist.vim
map <Leader>mn  :MemoNew<CR>
map <Leader>ml  :MemoList<CR>

" vim-expand-region
map + <Plug>(expand_region_expand)
map _ <Plug>(expand_region_shrink)

" QuickRun
nmap <Leader>r <Plug>(quickrun)

" Neosnippet {{{
imap <C-k>     <Plug>(neosnippet_expand_or_jump)
smap <C-k>     <Plug>(neosnippet_expand_or_jump)
xmap <C-k>     <Plug>(neosnippet_expand_target)
xmap <C-l>     <Plug>(neosnippet_start_unite_snippet_target)
" For snippet_complete marker.
if has('conceal')
  set conceallevel=2 concealcursor=i
endif
" Enable snipMate compatibility feature.
" let g:neosnippet#enable_snipmate_compatibility = 1
" }}}

" neocomplcache - Code completion {{{
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function()
  return neocomplcache#smart_close_popup() . "\<CR>"
  " For no inserting <CR> key.
  "return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplcache#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplcache#close_popup()
inoremap <expr><C-e>  neocomplcache#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplcache#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplcache#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplcache#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplcache#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplcache#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplcache_enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplcache_enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplcache_enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplcache_enable_auto_select = 1
"let g:neocomplcache_disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable heavy omni completion.
" if !exists('g:neocomplcache_omni_patterns')
"   let g:neocomplcache_omni_patterns = {}
" endif
" let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
" let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
" let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
"
" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
" let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
" }}}

" yankround.vim
" nmap p <Plug>(yankround-p)
" nmap P <Plug>(yankround-P)
" nmap gp <Plug>(yankround-gp)
" nmap gP <Plug>(yankround-gP)
" nmap <C-p> <Plug>(yankround-prev)
" nmap <C-n> <Plug>(yankround-next)

" }}}

