" .vimrc
" Author: Ken Wong <ken.yui.wong@gmail.com
"
"

" Preamble ---------------------------------------------------------------- {{{

" NeoBundle
" Prefer this over pathogen becuase fi 
" Reference: https://github.com/Shougo/neobundle.vim 
" Command line: git submodule add https://github.com/Shougo/neobundle.vim .vim/bundle/neobundle.vim

if has('vim_starting')
  set nocompatible               " Be iMproved

  " Required:
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))
NeoBundleFetch 'Shougo/neobundle.vim'

" My bundles here
NeoBundle 'Shougo/vimproc.vim'  " Recommand by NeoBundle

filetype plugin indent on

NeoBundleCheck

" }}}
