%---------------------------------------------------------------------------%
%->> Identification
%---------------------------------------------------------------------------%
\NeedsTeXFormat{LaTeX2e}%
\newcommand*\@iflatexlater{\@ifl@t@r\fmtversion}%
\@iflatexlater{2017/01/01}{}{%
    \ClassError{sudathesis}{TeXLive/MikTex >= 2017 is required ...}{}%
}
\ProvidesClass{sudathesis}[2020/11/20 v1.0 LaTeX document class]%
%---------------------------------------------------------------------------%
%->> Declare options
%---------------------------------------------------------------------------%
%-
%-> Layout
%-
\DeclareOption{oneside}{%
    \PassOptionsToClass{oneside}{ctexbook}%
}
\DeclareOption{twoside}{%
    \PassOptionsToClass{twoside}{ctexbook}%
}
\newif\ifsuda@print \suda@printfalse
\DeclareOption{print}{%
    \PassOptionsToClass{twoside}{ctexbook}%
    \suda@printtrue%
}
%-
%-> Language
%-
\newif\ifsuda@plain \suda@plainfalse
\DeclareOption{scheme=plain}{% enable plain writing style
    \PassOptionsToClass{scheme=plain}{ctexbook}%
    \suda@plaintrue%
}
%-
%-> Draft version info
%-
\newif\ifsuda@versioninfo \suda@versioninfofalse
\DeclareOption{draftversion}{%
    \suda@versioninfotrue%
}
%-
%-> Handle non-implemented options
%-
\DeclareOption*{%
    \PassOptionsToClass{\CurrentOption}{ctexbook}%
}
%-
%-> Terminates all options processing
%-
\ProcessOptions\relax%
%---------------------------------------------------------------------------%
%->> Load class information
%---------------------------------------------------------------------------%
\LoadClass[UTF8,a4paper,zihao=-4]{ctexbook}%
\@ifclasslater{ctexbook}{2017/01/01}{}{%
    \ClassError{sudathesis}{ctex >= 2017/01/01 is required ...}{}%
}
%---------------------------------------------------------------------------%
%->> Required packages
%---------------------------------------------------------------------------%
\RequirePackage{ifxetex}% LaTeX engine detection
\RequirePackage{etoolbox}% a toolbox of programming facilities
\newcommand{\sudaifstreq}{\expandafter\ifstrequal\expandafter}% expansion control
\newcommand{\sudaifstrbk}{\expandafter\ifblank\expandafter}% expansion control
\RequirePackage{expl3}% LaTeX3 programming environment
%---------------------------------------------------------------------------%
%->> Load class configuration
%---------------------------------------------------------------------------%
\AtEndOfPackage{% class cfg loaded after package to make preamble commands take effect
    \makeatletter
    \InputIfFileExists{Style/sudathesis.cfg}{}{}
    \makeatother
}
%---------------------------------------------------------------------------%
%->> Page layout
%---------------------------------------------------------------------------%
%- use \topmargin insead of \voffset to shift the complete text vertically
%- use \<odd|even>sidemargin insead of \hoffset to shift text horizontally
%- part one -- horizontal widths
%- left side width + textwidth + right side width = paperwidth
%- binding side width + textwidth + nonbinding side width = paperwidth
%- binding side width of [odd, even] page = [left, right] side width
%- left side width of [odd, even] page = 1.0in (fixed) + hoffset + [odd, even]sidemargin
%- assuming A4 paper (210mm x 297mm)
\setlength{\textwidth}{155mm}% set required text width first
\setlength{\hoffset}{-1.0in}% set horizontal offset
\ifsuda@print% if print layout enabled
    \setlength{\oddsidemargin}{30mm}% binding side margin
    \setlength{\evensidemargin}{25mm}% ensure uniform binding side width for printing
\else
    \setlength{\oddsidemargin}{27.5mm}% left side margin
    \setlength{\evensidemargin}{27.5mm}% ensure uniform left side width for EThesis
\fi
\setlength{\marginparwidth}{35pt}% width of margin notes
\setlength{\marginparsep}{10pt}% width of space between body text and margin notes
%- part two -- vertical heights
%- top height + textheight + bottom height = paperheight
%- top height = 1.0in (fixed) + voffset + topmargin + headheight + headsep 
\setlength{\textheight}{230mm}% set required text height first
\setlength{\voffset}{-1.0in}% set vertical offset
\setlength{\topmargin}{23.5mm}% vertical margin above header
\setlength{\headheight}{0mm}% header height
\setlength{\headsep}{17.5pt}% vertical margin between header and body text
\setlength{\footskip}{10.4mm}% vertical margin between footer and body text
%- specifies the amount of space between paragraphs.
\setlength{\parskip}{0.5ex plus 0.25ex minus 0.25ex}
%- line spacing
\linespread{1.6}% line space setting
\raggedbottom% prevent adding vertical white space in strange places
%- default pagestyle is page number at bottom without headers and footers
\pagestyle{plain}
%---------------------------------------------------------------------------%
%->> Style control commands
%---------------------------------------------------------------------------%
%- redefine cleardoublepage to have page style argument
\renewcommand{\cleardoublepage}[1][plain]{%
    \clearpage\if@twoside\ifodd\c@page\else%
    \thispagestyle{#1}%
    \hbox{}\newpage\if@twocolumn\hbox{}\newpage\fi\fi\fi%
}
%- underline
\ifxetex%
    \RequirePackage{ulem}%
\else%
    \RequirePackage{ulem}%
\fi
\newcommand{\ulunify}[1]{\uline{#1}}% unified name
\newcommand{\ulenhance}[2][1pt]{% enhanced underline
    \def\ULthickness{#1}% set thickness
    \setlength{\ULdepth}{0.3em}% set depth
    \expandafter\ulunify\expandafter{#2}% linebreak fix
}
\newcommand{\ulhshift}{-4em}% horizontal shift on underline
\newcommand{\ulextend}[2][350pt]{% extend underline length
    \hbox to #1{\hfill\hspace*{\ulhshift}#2\hfill}}
%---------------------------------------------------------------------------%
%->> Titlepage
%---------------------------------------------------------------------------%
%-
%-> 中文项目命令
%-
\def\suda@value@ch@universitycode{}
\newcommand{\universitycode}[1]{\def\suda@value@ch@universitycode{#1}}
\def\suda@value@ch@sid{}
\newcommand{\sid}[1]{\def\suda@value@ch@sid{#1}}
\def\suda@value@ch@schooltitle{}
\newcommand{\schooltitle}[2][]{\def\suda@value@ch@schooltitle{\sudaifstrbk{#1}{\zihao{-2}\bfseries\sffamily #2}{\includegraphics[#1]{#2}}}}
\def\suda@value@ch@schoollogo{}
\newcommand{\schoollogo}[2][]{\def\suda@value@ch@schoollogo{\sudaifstrbk{#1}{\zihao{-2}\bfseries\sffamily #2}{\includegraphics[#1]{#2}}}}
\def\suda@value@ch@title{}
\def\suda@value@ch@titlemark{}
\renewcommand{\title}[2][\suda@value@ch@title]{%
    \def\suda@value@ch@title{#2}
    %\def\suda@value@ch@titlemark{\MakeUppercase{#1}}}
    \def\suda@value@ch@titlemark{#1}}
\def\suda@value@ch@author{}
\renewcommand{\author}[1]{\def\suda@value@ch@author{#1}}
\def\suda@value@ch@advisor{}
\newcommand{\advisor}[1]{\long\def\suda@value@ch@advisor{#1}}
\def\suda@value@ch@degree{}
\newcommand{\degree}[1]{\def\suda@value@ch@degree{#1}}
\def\suda@value@ch@major{}
\newcommand{\major}[1]{\def\suda@value@ch@major{#1}}
\def\suda@value@ch@field{}
\newcommand{\field}[1]{\def\suda@value@ch@field{#1}}
\def\suda@value@ch@institute{}
\newcommand{\institute}[1]{\long\def\suda@value@ch@institute{#1}}
\def\suda@value@ch@school{}
\newcommand{\school}[1]{\def\suda@value@ch@school{#1}}
\def\suda@value@ch@submitdate{}
\newcommand{\submitdate}[1]{\def\suda@value@ch@submitdate{#1}}
\def\suda@value@ch@date{}
\renewcommand{\date}[1]{\def\suda@value@ch@date{#1}}
%-
%-> English item commands
%-
\def\suda@value@en@title{}
\def\suda@value@en@titlemark{}
\newcommand{\TITLE}[2][\suda@value@en@title]{%
    \def\suda@value@en@title{#2}
    %\def\suda@value@en@titlemark{\MakeUppercase{#1}}}
    \def\suda@value@en@titlemark{#1}}
\def\suda@value@en@degree{}
\newcommand{\DEGREE}[1]{\edef\suda@value@en@degree{\zap@space#1 \@empty}}% expand and remove space
\def\suda@value@en@school{}
\newcommand{\SCHOOL}[1]{\def\suda@value@en@school{#1}}
%-
%-> Detect and adjust items
%-
\AtEndPreamble{%
    \sudaifstreq{\suda@value@en@degree}{Bachelor}{%
        \def\suda@label@ch@thesis{\suda@label@ch@thesis@bac}%
        \def\suda@label@ch@author{\suda@label@ch@author@bac}%
        \def\suda@label@ch@major{\suda@label@ch@major@bac}%
        \def\suda@label@ch@institute{\suda@label@ch@institute@bac}%
    }{%
    \sudaifstreq{\suda@value@en@degree}{Master}{%
        \def\suda@label@ch@thesis{\suda@label@ch@thesis@mas}%
        \def\suda@label@ch@author{\suda@label@ch@author@mas}%
        \def\suda@label@ch@major{\suda@label@ch@major@mas}%
        \def\suda@label@ch@institute{\suda@label@ch@institute@mas}%
    }{%
    \sudaifstreq{\suda@value@en@degree}{Doctor}{%
        \def\suda@label@ch@thesis{\suda@label@ch@thesis@doc}%
        \def\suda@label@ch@author{\suda@label@ch@author@doc}%
        \def\suda@label@ch@major{\suda@label@ch@major@doc}%
        \def\suda@label@ch@institute{\suda@label@ch@institute@doc}%
    }{%
        \ClassWarning{sudathesis}{Invalid value of '\string\DEGREE', please check the spelling}%
    }}}%
}
%-
%-> 封面
%-
\def\maketitle{%
    \cleardoublepage
    \thispagestyle{empty}
    \begin{center}
        \linespread{1.6}
        \zihao{-4}\bfseries% 封面字体

        \hfill{}\begin{tabular}{lc}% 封面右上角创建表格
            \sudaifstrbk{\suda@value@ch@universitycode}{}{\zihao{5}\makebox[4em][s]{\suda@label@ch@universitycode}：&\suda@value@ch@universitycode}\\
            \sudaifstrbk{\suda@value@ch@sid}{}{\zihao{5}\makebox[4em][s]{\suda@label@ch@sid}：&\suda@value@ch@sid}
        \end{tabular}

        \vspace*{\stretch{4}}

        {\suda@value@ch@schooltitle}

        \vspace*{\stretch{2}}

        {\zihao{1}\bfseries\sffamily {\suda@label@ch@thesis}}

        {\zihao{-2}\bfseries\sffamily （\suda@value@ch@degree\suda@label@ch@degree）}

        \vspace*{\stretch{2}}

        {\suda@value@ch@schoollogo}

        \vspace*{\stretch{3}}

        {\zihao{3}\bfseries\sffamily \ulenhance[0.5pt]{\suda@value@ch@title}}

        {\zihao{3}\bfseries \ulenhance[0.5pt]{\suda@value@en@title}}

        \vspace*{\stretch{3}}

        \def\tabcolsep{1pt}
        \def\arraystretch{1.3}
        \begin{tabular}{lc}
            \makebox[6em][s]{\suda@label@ch@author} & \ulenhance[0.5pt]{\ulextend{\suda@value@ch@author}}\\
            \makebox[6em][s]{\suda@label@ch@advisor} & \ulenhance[0.5pt]{\ulextend{\suda@value@ch@advisor}}\\
            \makebox[6em][s]{\suda@label@ch@major} & \ulenhance[0.5pt]{\ulextend{\suda@value@ch@major}}\\
            \makebox[6em][s]{\suda@label@ch@field} & \ulenhance[0.5pt]{\ulextend{\suda@value@ch@field}}\\
            \makebox[6em][s]{\suda@label@ch@institute} & \ulenhance[0.5pt]{\ulextend{\suda@value@ch@institute}}\\
            \makebox[6em][s]{\suda@label@ch@submitdate} & \ulenhance[0.5pt]{\ulextend{\suda@value@ch@submitdate}}\\
        \end{tabular}

        \vspace*{\stretch{4}}

        {\suda@value@ch@date}

        \vspace*{\stretch{4}}
    \end{center}
    \clearpage
    \if@twoside
        \thispagestyle{empty}
        \ifsuda@versioninfo
            \vspace*{\stretch{1}}
            \begin{footnotesize}
                \noindent
                Draft Version (\today)
            \end{footnotesize}
        \fi
        \cleardoublepage[empty]
    \else
        \ifsuda@versioninfo
            \thispagestyle{empty}
            \vspace*{\stretch{1}}
            \begin{footnotesize}
                \noindent
                Draft Version (\today)
            \end{footnotesize}
            \cleardoublepage[empty]
        \fi
    \fi
    \ifsuda@print%
        \hypersetup{% set hyperlinks
            hidelinks,% remove link color and border
        }
    \fi
}
%---------------------------------------------------------------------------%
%->> New environments
%---------------------------------------------------------------------------%
%- define chinese keywords
\newcommand{\keywords}[1]{%
    \vspace{\baselineskip}
    \noindent {\bfseries \suda@label@ch@keywords} #1}
%- define engish keywords
\newcommand{\KEYWORDS}[1]{%
    \vspace{\baselineskip}
    \noindent {\bfseries \suda@label@en@keywords} #1}
%---------------------------------------------------------------------------%
%->> Structure elements
%---------------------------------------------------------------------------%
\ifsuda@plain%
    \def\contentsname{\suda@label@en@tocname}
    \def\listfigurename{\suda@label@en@lsfigname}
    \def\listtablename{\suda@label@en@lstabname}
    \def\bibname{\suda@label@en@bibname}
    \def\refname{\suda@label@en@bibname}
    \def\algname{\suda@label@en@algname}
    \def\bibetal{\suda@label@en@bibetal}
    \def\biband{\suda@label@en@biband}
    \def\axiomname{\suda@label@en@axiomname}
    \def\theoremname{\suda@label@en@theoremname}
    \def\lemmaname{\suda@label@en@lemmaname}
    \def\corollaryname{\suda@label@en@corollaryname}
    \def\assertionname{\suda@label@en@assertionname}
    \def\propositionname{\suda@label@en@propositionname}
    \def\conjecturename{\suda@label@en@conjecturename}
    \def\definitionname{\suda@label@en@definitionname}
    \def\examplename{\suda@label@en@examplename}
    \def\remarkname{\suda@label@en@remarkname}
    \def\proofname{\suda@label@en@proofname}
    \def\@title{\suda@value@en@titlemark}
    \def\@author{\suda@value@en@author}
\else
    \def\contentsname{\suda@label@ch@tocname}
    \def\listfigurename{\suda@label@ch@lsfigname}
    \def\listtablename{\suda@label@ch@lstabname}
    \def\algname{\suda@label@ch@algname}
    \def\bibname{\suda@label@ch@bibname}
    \def\refname{\suda@label@ch@bibname}
    \def\bibetal{\suda@label@ch@bibetal}
    \def\biband{\suda@label@ch@biband}
    \def\axiomname{\suda@label@ch@axiomname}
    \def\theoremname{\suda@label@ch@theoremname}
    \def\lemmaname{\suda@label@ch@lemmaname}
    \def\corollaryname{\suda@label@ch@corollaryname}
    \def\assertionname{\suda@label@ch@assertionname}
    \def\propositionname{\suda@label@ch@propositionname}
    \def\conjecturename{\suda@label@ch@conjecturename}
    \def\definitionname{\suda@label@ch@definitionname}
    \def\examplename{\suda@label@ch@examplename}
    \def\remarkname{\suda@label@ch@remarkname}
    \def\proofname{\suda@label@ch@proofname}
    \def\@title{\suda@value@ch@titlemark}
    \def\@author{\suda@value@ch@author}
\fi
%---------------------------------------------------------------------------%
%->> Structure layout
%---------------------------------------------------------------------------%
%- chapter
\ctexset {
    chapter = {
        format = \linespread{1.0}\zihao{4}\bfseries\sffamily\centering,
        nameformat = {},
        titleformat = {},
        number = \zhnum{chapter},
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {7pt},
        afterskip = {18pt},
        pagestyle = plain,
    }
}
%- section
\ctexset {
    section = {
        format = \linespread{1.0}\zihao{-4}\sffamily\raggedright,
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {24pt},
        afterskip = {6pt},
    }
}
%- subsection
\ctexset {
    subsection = {
        format = \linespread{1.0}\zihao{-4}\sffamily\raggedright,
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {12pt},
        afterskip = {6pt},
    }
}
%- subsubsection
\ctexset {
    subsubsection = {
        format = \linespread{1.0}\zihao{-4}\sffamily\raggedright,
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {12pt},
        afterskip = {6pt},
    }
}
%- appendix
\ctexset {
    appendix = {
        %numbering = true|false,
        %number = \rmfamily\Alph{chapter},
    }
}
%---------------------------------------------------------------------------%
%->> Configure table of contents
%---------------------------------------------------------------------------%
%- the table of contents is specified by defining \l@chapter, \l@section, ...
%- most commands are then defined with the \@dottedtocline:
%- \@dottedtocline{⟨level⟩}{⟨indent⟩}{⟨numwidth⟩}{⟨title⟩}{⟨page⟩}
%- ⟨level⟩    an entry is produced only if ⟨level⟩ <= value of the tocdepth counter
%-            note, \chapter is level 0, \section is level 1, etc
%- ⟨indent⟩   indentation from the outer left margin of the start of the contents line
%- ⟨numwidth⟩ width of a box in which the section number is to go
%- <title>    title
%- <page>     page number

%- parameters for spacing and length in toc
\def\@dotsep{1.5mu}% separation between dots in mu units
\def\@pnumwidth{2em}% width of a box in which the page number is put
\def\@tocrmarg{2em}% right margin for multiple line entries, \@tocrmarg ≥ \@pnumwidth
\def\@chaptervspace{1ex}% vertical space between chapter titles

%- redefine dottedtocline from classes.dtx and latex.ltx
\renewcommand*{\@dottedtocline}[5]{% [<level>,<indent>,<numwidth>,<title>,<page>]
    \ifnum #1>\c@tocdepth \else
        \vskip \z@ \@plus.2\p@
        {\leftskip #2\relax \rightskip \@tocrmarg \parfillskip -\rightskip
        \parindent #2\relax\@afterindenttrue
        \interlinepenalty\@M
        \leavevmode \zihao{-4}\sffamily
        \@tempdima #3\relax
        \advance\leftskip \@tempdima \null\nobreak\hskip -\leftskip
        {#4}\nobreak
        \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}\hfill
        \nobreak
        \hb@xt@\@pnumwidth{\hfil\normalfont \normalcolor #5}%
        \par\penalty\@highpenalty}%
    \fi
}
%- redefine l@part from book.cls to add dotted toc line
\renewcommand*{\l@part}[2]{% [<title>,<page>]
    \ifnum \c@tocdepth >-2\relax
        \addpenalty{-\@highpenalty}%
        \addvspace{2.25em \@plus\p@}%
        \setlength\@tempdima{3em}%
        \begingroup
            \parindent \z@ \rightskip \@pnumwidth
            \parfillskip -\@pnumwidth
            {\leavevmode
            \zihao{4}\sffamily #1
            \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}% add dotted toc line
            \hfil \hb@xt@\@pnumwidth{\hss #2}}\par
            \nobreak
            \global\@nobreaktrue
            \everypar{\global\@nobreakfalse\everypar{}}%
        \endgroup
    \fi
}
%- redefine l@chapter from book.cls to add dotted toc line
\renewcommand*{\l@chapter}[2]{% [<title>,<page>]
    \ifnum \c@tocdepth >\m@ne
        \addpenalty{-\@highpenalty}%
        \vskip \@chaptervspace \@plus\p@
        \setlength\@tempdima{1.5em}%
        \begingroup
            \parindent \z@ \rightskip \@pnumwidth
            \parfillskip -\@pnumwidth
            \leavevmode \zihao{4}\sffamily
            \advance\leftskip\@tempdima
            \hskip -\leftskip
            #1\nobreak
            \leaders\hbox{$\m@th\mkern \@dotsep \cdot\mkern \@dotsep$}% add dotted toc line
            \hfil \nobreak\hb@xt@\@pnumwidth{\hss #2}\par
            \penalty\@highpenalty
        \endgroup
    \fi
}
%- redefine indentation for others
\renewcommand*\l@section{\@dottedtocline{1}{1em}{1.8em}}
\renewcommand*\l@subsection{\@dottedtocline{2}{2em}{2.8em}}
\renewcommand*\l@subsubsection{\@dottedtocline{3}{3em}{3.8em}}
\renewcommand*\l@paragraph{\@dottedtocline{4}{4em}{4.8em}}
\renewcommand*\l@subparagraph{\@dottedtocline{5}{5em}{5.8em}}
\renewcommand*\l@figure{\@dottedtocline{1}{1em}{1.8em}}
\renewcommand*\l@table{\@dottedtocline{1}{1em}{1.8em}}
%---------------------------------------------------------------------------%
\endinput
