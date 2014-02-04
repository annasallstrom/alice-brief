%
% This is scotus.cls, by Charles Duan.
%
% Copyright 2013 Charles Duan. This program is free software: you can
% redistribute it and/or modify it under the terms of the GNU General Public
% License as published by the Free Software Foundation, either version 3 of the
% License, or (at your option) any later version.
%
% This program is distributed in the hope that it will be useful, but WITHOUT
% ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
% FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License along with
% this program.  If not, see <http://www.gnu.org/licenses/>.
%
% Document class for Supreme Court briefs.
%
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{scotus}[2013/10/09 v0.1 Supreme Court Brief]
\newcommand\@ptsize{}
\newif\if@restonecol
\newif\if@titlepage
\@titlepagefalse
\DeclareOption{letterpaper}{%
  \setlength\paperwidth{8in}%
  \setlength\paperheight{11in}%
}
\DeclareOption{booklet}{%
  \setlength\paperwidth{6.125in}%
  \setlength\paperheight{9.25in}%
}
\DeclareOption{12pt}{\renewcommand\@ptsize{2}}
\DeclareOption{twoside}{\@twosidetrue  \@mparswitchtrue}
\DeclareOption{draft}{\setlength\overfullrule{5pt}}
\DeclareOption{final}{\setlength\overfullrule{0pt}}
\DeclareOption{onecolumn}{\@twocolumnfalse}
\DeclareOption{leqno}{\input{leqno.clo}}
\DeclareOption{fleqn}{\input{fleqn.clo}}
\ExecuteOptions{booklet,12pt,twoside,onecolumn,final}
\ProcessOptions
\input{size1\@ptsize.clo}
\usepackage{geometry}
\geometry{%
  includehead,
  textheight=7.125in,
  textwidth=4.125in,
  headsep=\baselineskip,
  headheight=\baselineskip,
  hmarginratio=1:1,
  vmarginratio=1:1
}
\setlength\lineskip{2\p@}
\setlength\normallineskip{2\p@}
\setlength\lineskiplimit{2\p@}
\setlength\normallineskiplimit{2\p@}
\renewcommand\baselinestretch{}
\setlength\parskip{%
  0.5\baselineskip \@plus 0.5\baselineskip \@minus 0.1\baselineskip
}
\@lowpenalty   51
\@medpenalty  151
\@highpenalty 301
\setcounter{topnumber}{2}
\renewcommand\topfraction{.7}
\setcounter{bottomnumber}{1}
\renewcommand\bottomfraction{.3}
\setcounter{totalnumber}{3}
\renewcommand\textfraction{.2}
\renewcommand\floatpagefraction{.5}
\setcounter{dbltopnumber}{2}
\renewcommand\dbltopfraction{.7}
\renewcommand\dblfloatpagefraction{.5}
\def\ps@scotus{\let\@mkboth\@gobbletwo
     \let\@oddfoot\@empty\def\@oddhead{\reset@font\hfil\thepage
     \hfil}\let\@evenhead\@oddhead\let\@evenfoot\@oddfoot}
\def\separator{%
  \vskip .5\baselineskip
  \hbox to \textwidth{%
    \hfil
    \leaders\hrule height 4pt depth -3pt\hskip .3\textwidth\relax
    \hfil
  }%
  \vskip .5\baselineskip
}
\def\titlefont#1{#1}
\newcommand\maketitle{%
  \begin{titlepage}%
    \small
    \parskip\z@
    \begin{centering}%
      \hbox{}
      \vskip-3\baselineskip
      No.~\@docket\strut
      \vskip .5\baselineskip
      \hrule
      \vskip 2pt
      \hrule
      \vskip .5\baselineskip
      \textsc{In the}\par
      {\Large \titlefont{Supreme Court of the United States}\par}%
      \separator
      \@drawcasecaption
      \separator
      \textsc{\@posture}%
      \separator
      \textbf{\MakeUppercase{\@title}}
      \separator
    \end{centering}\par
    \hb@xt@\textwidth{%
      \hfil
      \parindent\z@
      \hsize.45\textwidth
      \everypar{\hangindent=1em\relax}%
      \def\\{\@testopt\@parwithskip\z@}%
      \def\@parwithskip[##1]{\par\vskip##1\relax}
      \rightskip=0pt plus \hsize
      \def\and{\egroup\hfil\vtop\bgroup}%
      \vtop\bgroup\@counsel\egroup
    }%
  \vfill\null
  \hrule
  \vskip 2pt
  \hrule
  \end{titlepage}%
  \setcounter{footnote}{0}%
  \global\let\thanks\relax
  \global\let\maketitle\relax
  \global\let\@thanks\@empty
  \global\let\@docket\@empty
  \global\let\@casecaption\@empty
  \global\let\@title\@empty
  \global\let\title\relax
  \global\let\author\relax
  \global\let\date\relax
  \global\let\and\relax
}
\def\counselofrecord{\leavevmode\hbox{\quad\emph{Counsel of Record}}\par}
\def\whois#1{\par\vskip 6pt\leavevmode\emph{#1}\par}
\def\docket#1{\gdef\@docket{#1}}
\def\casecaption#1{\gdef\@casecaption{#1}}
\def\@drawcasecaption{{%
    \def\The##1{%
        \leavevmode\hb@xt@\textwidth{\hfil\emph{##1}}%
    }%
    \def\\{\par}
    \parskip=.5\baselineskip
    \@casecaption
}}
\def\posture#1{\gdef\@posture{#1}}
\def\counsel#1{\gdef\@counsel{#1}}
\newcommand*{\stopbreaks}{%
    \interlinepenalty\@M
    \def\par{\@@par\nobreak}%
    \let\\\par
    \let\vspace\@nobreakvspace
}
\def\signature{%
    \par\begingroup
        \parindent\z@
        \parskip\z@
        \raggedright
        \leftskip=.33\textwidth
        \everypar{\hangindent=1em\relax}%
        \def\\{\@testopt\@parwithskip\z@}%
        \def\@parwithskip[##1]{\par\vskip##1\relax}
        \def\and{\\[.5\baselineskip]}%
        \vskip2\baselineskip minus 1\baselineskip
        \stopbreaks
        \emph{Respectfully submitted,}\par\vskip.5\baselineskip
        \@counsel\par
    \endgroup
}
\setcounter{secnumdepth}{3}
\newcounter {part}
\newcounter {section}[part]
\newcounter {subsection}[section]
\newcounter {subsubsection}[subsection]
\newcounter {paragraph}[subsubsection]
\newcounter {subparagraph}[paragraph]
\newcounter {appendix}
\renewcommand \thepart {}
\renewcommand \thesection {\@Roman\c@section}
\renewcommand\thesubsection   {\@Alph\c@subsection}
\renewcommand\thesubsubsection{\@arabic\c@subsubsection}
\renewcommand\theparagraph    {\@alph\c@paragraph}
\renewcommand\thesubparagraph {\@roman\c@subparagraph}
\renewcommand\theappendix{\@Alph\c@appendix}
\def\appendix#1{%
    \clearpage
    \refstepcounter{appendix}%
    \ifnum \c@secnumdepth >\m@ne
      \vskip\baselineskip
      \begin{centering}
          \leavevmode
          \refstepcounter{part}%
          \addcontentsline{toc}{part}{%
            \MakeUppercase{\appendixname\ \theappendix}: #1%
          }\nobreak
          \bfseries\MakeUppercase{\appendixname\ \theappendix}\par
          #1\par
      \end{centering}
      \nobreak
      \@afterheading
    \else
      \@spart{#1}
    \fi
}
\newcommand\part{%
   \secdef\@part\@spart}

\def\@part[#1]#2{%
    \ifnum \c@secnumdepth >\m@ne
      \vskip\baselineskip
      \begin{centering}
          \leavevmode
          \refstepcounter{part}%
          \addcontentsline{toc}{part}{\MakeUppercase{#1}}\nobreak
          \bfseries\MakeUppercase{#1}\par
      \end{centering}
      \nobreak
      \@afterheading
    \else
      \@spart{#2}
    \fi
}
\def\@spart#1{%
    \vskip\baselineskip
    \begin{centering}
        \bfseries\MakeUppercase{#1}\par
    \end{centering}
    \nobreak
    \@afterheading
}
\def\@seccntformat#1{\csname the#1\endcsname.\quad}
\def\numberline#1{\hb@xt@\@tempdima{#1.\hfil}}
\newcommand\section{\@startsection {section}{1}{\z@}%
                                   {\baselineskip}%
                                   {1pt}%
                                   {\normalfont\bfseries}}
\newcommand\subsection{\@startsection{subsection}{2}{\z@}%
                                     {\baselineskip}%
                                     {1pt}%
                                     {\normalfont\bfseries}}
\newcommand\subsubsection{\@startsection{subsubsection}{3}{\z@}%
                                     {\baselineskip}%
                                     {1pt}%
                                     {\normalfont\bfseries}}
\newcommand\paragraph{\@startsection{paragraph}{4}{\z@}%
                                    {0.5\baselineskip}%
                                    {-1em}%
                                    {\normalfont\bfseries}}
\newcommand\subparagraph{\@startsection{subparagraph}{5}{\parindent}%
                                       {0.5\baselineskip}%
                                       {-1em}%
                                       {\normalfont\normalsize\bfseries}}
\if@twocolumn
  \setlength\leftmargini  {2em}
\else
  \setlength\leftmargini  {2.5em}
\fi
\leftmargin  \leftmargini
\setlength\leftmarginii  {2.2em}
\setlength\leftmarginiii {1.87em}
\setlength\leftmarginiv  {1.7em}
\if@twocolumn
  \setlength\leftmarginv  {.5em}
  \setlength\leftmarginvi {.5em}
\else
  \setlength\leftmarginv  {1em}
  \setlength\leftmarginvi {1em}
\fi
\setlength  \labelsep  {.5em}
\setlength  \labelwidth{\leftmargini}
\addtolength\labelwidth{-\labelsep}
\@beginparpenalty -\@lowpenalty
\@endparpenalty   -\@lowpenalty
\@itempenalty     -\@lowpenalty
\renewcommand\theenumi{\@arabic\c@enumi}
\renewcommand\theenumii{\@alph\c@enumii}
\renewcommand\theenumiii{\@roman\c@enumiii}
\renewcommand\theenumiv{\@Alph\c@enumiv}
\newcommand\labelenumi{\theenumi.}
\newcommand\labelenumii{(\theenumii)}
\newcommand\labelenumiii{\theenumiii.}
\newcommand\labelenumiv{\theenumiv.}
\renewcommand\p@enumii{\theenumi}
\renewcommand\p@enumiii{\theenumi(\theenumii)}
\renewcommand\p@enumiv{\p@enumiii\theenumiii}
\newcommand\labelitemi{\textbullet}
\newcommand\labelitemii{\normalfont\bfseries \textendash}
\newcommand\labelitemiii{\textasteriskcentered}
\newcommand\labelitemiv{\textperiodcentered}
\newenvironment{description}
               {\list{}{\labelwidth\z@ \itemindent-\leftmargin
                        \let\makelabel\descriptionlabel}}
               {\endlist}
\newcommand*\descriptionlabel[1]{\hspace\labelsep
                                \normalfont\bfseries #1}
\newenvironment{verse}
               {\let\\\@centercr
                \list{}{\itemsep      \z@
                        \itemindent   -1.5em%
                        \listparindent\itemindent
                        \rightmargin  \leftmargin
                        \advance\leftmargin 1.5em}%
                \item\relax}
               {\endlist}
\newenvironment{quotation}
               {\list{}{\listparindent 1.5em%
                        \itemindent    \listparindent
                        \rightmargin   \leftmargin
                        \parsep        \z@ \@plus\p@}%
                \item\relax}
               {\endlist}
\newenvironment{quote}
               {\list{}{\rightmargin\leftmargin}%
                \item\relax}
               {\endlist}
\newenvironment{titlepage}
    {%
      \newpage
      \thispagestyle{empty}%
      \setcounter{page}\@ne
    }%
    {\newpage}
\setlength\arraycolsep{5\p@}
\setlength\tabcolsep{6\p@}
\setlength\arrayrulewidth{.4\p@}
\setlength\doublerulesep{2\p@}
\setlength\tabbingsep{\labelsep}
\skip\@mpfootins = \skip\footins
\setlength\fboxsep{3\p@}
\setlength\fboxrule{.4\p@}
\renewcommand \theequation {\@arabic\c@equation}
\newcounter{figure}
\renewcommand \thefigure {\@arabic\c@figure}
\def\fps@figure{tbp}
\def\ftype@figure{1}
\def\ext@figure{lof}
\def\fnum@figure{\figurename\nobreakspace\thefigure}
\newenvironment{figure}
               {\@float{figure}}
               {\end@float}
\newenvironment{figure*}
               {\@dblfloat{figure}}
               {\end@dblfloat}
\newcounter{table}
\renewcommand\thetable{\@arabic\c@table}
\def\fps@table{tbp}
\def\ftype@table{2}
\def\ext@table{lot}
\def\fnum@table{\tablename\nobreakspace\thetable}
\newenvironment{table}
               {\@float{table}}
               {\end@float}
\newenvironment{table*}
               {\@dblfloat{table}}
               {\end@dblfloat}
\newlength\abovecaptionskip
\newlength\belowcaptionskip
\setlength\abovecaptionskip{10\p@}
\setlength\belowcaptionskip{0\p@}
\long\def\@makecaption#1#2{%
  \vskip\abovecaptionskip
  \sbox\@tempboxa{#1: #2}%
  \ifdim \wd\@tempboxa >\hsize
    #1: #2\par
  \else
    \global \@minipagefalse
    \hb@xt@\hsize{\hfil\box\@tempboxa\hfil}%
  \fi
  \vskip\belowcaptionskip}
\DeclareOldFontCommand{\rm}{\normalfont\rmfamily}{\mathrm}
\DeclareOldFontCommand{\sf}{\normalfont\sffamily}{\mathsf}
\DeclareOldFontCommand{\tt}{\normalfont\ttfamily}{\mathtt}
\DeclareOldFontCommand{\bf}{\normalfont\bfseries}{\mathbf}
\DeclareOldFontCommand{\it}{\normalfont\itshape}{\mathit}
\DeclareOldFontCommand{\sl}{\normalfont\slshape}{\@nomath\sl}
\DeclareOldFontCommand{\sc}{\normalfont\scshape}{\@nomath\sc}
\DeclareRobustCommand*\cal{\@fontswitch\relax\mathcal}
\DeclareRobustCommand*\mit{\@fontswitch\relax\mathnormal}
\newcommand\@pnumwidth{1.55em}
\newcommand\@tocrmarg{2.55em}
\newcommand\@dotsep{4.5}
\setcounter{tocdepth}{3}
\def\@dottedtocline#1#2#3#4#5{%
  \ifnum #1>\c@tocdepth \else
    {\leftskip #2\relax \rightskip \@tocrmarg \parfillskip -\rightskip
     \parskip=.5\parskip\@plus 3pt
     \parindent #2\relax\@afterindenttrue
     \interlinepenalty\@M
     \leavevmode
     \@tempdima #3\relax
     \advance\leftskip \@tempdima \null\nobreak\hskip -\leftskip
     {#4}\nobreak
     \leaders\hbox{$\m@th
        \mkern \@dotsep mu\hbox{.}\mkern \@dotsep
        mu$}\hskip 2em plus 1fill\relax
     \nobreak
     \hbox{\hfil\normalfont \normalcolor #5}%
     \par}%
  \fi}
\newcommand\tableofcontents{%
    \part*{\contentsname
        \@mkboth{%
           \MakeUppercase\contentsname}{\MakeUppercase\contentsname}}%
    \@starttoc{toc}%
    \clearpage
    }
\newcommand*\l@part{\@dottedtocline{1}{0em}{0em}}
\newcommand*\l@section{\@dottedtocline{1}{0em}{2em}}
\newcommand*\l@subsection{\@dottedtocline{2}{2em}{2em}}
\newcommand*\l@subsubsection{\@dottedtocline{3}{4em}{2em}}
\newcommand*\l@paragraph{\@dottedtocline{4}{6em}{2em}}
\newcommand*\l@subparagraph{\@dottedtocline{5}{8em}{2em}}
\newcommand\listoffigures{%
    \section*{\listfigurename}%
      \@mkboth{\MakeUppercase\listfigurename}%
              {\MakeUppercase\listfigurename}%
    \@starttoc{lof}%
    }
\newcommand*\l@figure{\@dottedtocline{1}{1.5em}{2.3em}}
\newcommand\listoftables{%
    \section*{\listtablename}%
      \@mkboth{%
          \MakeUppercase\listtablename}%
         {\MakeUppercase\listtablename}%
    \@starttoc{lot}%
    }
\let\l@table\l@figure
\newdimen\bibindent
\setlength\bibindent{1.5em}
\newenvironment{thebibliography}[1]
     {\section*{\refname}%
      \@mkboth{\MakeUppercase\refname}{\MakeUppercase\refname}%
      \list{\@biblabel{\@arabic\c@enumiv}}%
           {\settowidth\labelwidth{\@biblabel{#1}}%
            \leftmargin\labelwidth
            \advance\leftmargin\labelsep
            \@openbib@code
            \usecounter{enumiv}%
            \let\p@enumiv\@empty
            \renewcommand\theenumiv{\@arabic\c@enumiv}}%
      \sloppy
      \clubpenalty4000
      \@clubpenalty \clubpenalty
      \widowpenalty4000%
      \sfcode`\.\@m}
     {\def\@noitemerr
       {\@latex@warning{Empty `thebibliography' environment}}%
      \endlist}
\newcommand\newblock{\hskip .11em\@plus.33em\@minus.07em}
\let\@openbib@code\@empty
\newenvironment{theindex}
               {\if@twocolumn
                  \@restonecolfalse
                \else
                  \@restonecoltrue
                \fi
                \twocolumn[\section*{\indexname}]%
                \@mkboth{\MakeUppercase\indexname}%
                        {\MakeUppercase\indexname}%
                \thispagestyle{plain}\parindent\z@
                \parskip\z@ \@plus .3\p@\relax
                \columnseprule \z@
                \columnsep 35\p@
                \let\item\@idxitem}
               {\if@restonecol\onecolumn\else\clearpage\fi}
\newcommand\@idxitem{\par\hangindent 40\p@}
\newcommand\subitem{\@idxitem \hspace*{20\p@}}
\newcommand\subsubitem{\@idxitem \hspace*{30\p@}}
\newcommand\indexspace{\par \vskip 10\p@ \@plus5\p@ \@minus3\p@\relax}
\renewcommand\footnoterule{%
  \kern-3\p@
  \hrule\@width.4\columnwidth
  \kern2.6\p@}
\newcommand\@makefntext[1]{%
    \parindent 1em%
    \noindent
    \hb@xt@1.8em{\hss\@makefnmark}#1}
\newcommand\contentsname{Table of Contents}
\newcommand\listfigurename{List of Figures}
\newcommand\listtablename{List of Tables}
\newcommand\refname{References}
\newcommand\indexname{Index}
\newcommand\figurename{Figure}
\newcommand\tablename{Table}
\newcommand\partname{Part}
\newcommand\appendixname{Appendix}
\newcommand\abstractname{Abstract}
\def\today{\ifcase\month\or
  January\or February\or March\or April\or May\or June\or
  July\or August\or September\or October\or November\or December\fi
  \space\number\day, \number\year}
\setlength\columnsep{10\p@}
\setlength\columnseprule{0\p@}
\pagestyle{scotus}
\pagenumbering{arabic}
\def\romanpagenumbers{%
    \c@page=\@ne
    \pagenumbering{roman}%
    \gdef\thepage{(\@roman\c@page)}%
}
\def\arabicpagenumbers{%
    \c@page=\@ne
    \pagenumbering{arabic}%
}
\def\appendixpagenumbers{%
    \c@page=\@ne
    \pagenumbering{arabic}%
    \gdef\thepage{\@arabic\c@page a}%
}
\flushbottom
\onecolumn
\sloppy
\endinput
%%
%% End of file `article.cls'.

