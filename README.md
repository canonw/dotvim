This is my VIM setup.  It's design to portable to work in both Windows, Linux and Mac.

Tools to include

- git
- xmllint


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
