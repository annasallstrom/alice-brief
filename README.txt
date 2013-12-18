To compile this document, run:

xelatex alice-brief.tex

If you do not have the necessary fonts installed, follow the instructions in the
file alice-brief.tex (change the \iftrue to \iffalse).

You will need to direct LaTeX to use the library files found in the texmf/
subdirectory. On my computer, which is running OS X and TeXLive 2013, I did this
by creating a symlink to ~/Library/texmf.


