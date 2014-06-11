This is my VIM setup.  It's design to portable to work in both Windows, Linux and Mac.

# Command to execute 

~~~
git clone https://github.com/canonw/dotvim.git
git pull && git submodule init && git submodule update && git submodule status
~~~

# Tools to include

- git
- xmllint


# Other setup

I prefer to include symbolic link

Here's bash command in Linux

~~~
# Goto local repository root
ln -Ffs .vim $HOME/.vim
ln -fs .vimrc $HOME/.vimrc
ln -fs .gvimrc $HOME/.gvimrc
~~~

Here's Windows command

~~~
@REM Goto root repository
mklink /H %HOME%\.vimrc .vimrc
mklink /H %HOME%\.gvimrc .gvimrc
mklink /J %HOME%\.vim .vim
~~~

## Install these tools

[Downloads · Shougo/vimproc.vim](https://github.com/Shougo/vimproc.vim/downloads){:target='_blank')

Install the binary to .vim\bundle\vimproc.vim\autoload

