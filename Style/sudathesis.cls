%---------------------------------------------------------------------------%
%-                                                                         -%
%-                           Document Class                                -%
%-                                                                         -%
%---------------------------------------------------------------------------%
%- Copyright (C) Xinnan Mao <xnmao@alu.suda.edu.cn>
%- This is free software: you can redistribute it and/or modify it
%- under the terms of the GNU General Public License as published by
%- the Free Software Foundation, either version 3 of the License, or
%- (at your option) any later version.
%---------------------------------------------------------------------------%
%->> Identification
%---------------------------------------------------------------------------%
\NeedsTeXFormat{LaTeX2e}%
\newcommand*\@iflatexlater{\@ifl@t@r\fmtversion}%
\@iflatexlater{2017/01/01}{}{%
    \ClassError{sudathesis}{TeXLive/MikTex >= 2017 is required ...}{}%
}
\ProvidesClass{sudathesis}[2025/03/16 v1.1 LaTeX document class]%
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
\ExplSyntaxOn
\newcommand{\sudalntotab}[2][1pt]{% convert lines into table lines
    \seq_set_split:NnV \l_tmpa_seq {\\} {#2}
    \clist_set_from_seq:NN \l_tmpa_clist \l_tmpa_seq
    \clist_clear:N \l_tmpb_clist
    \clist_map_inline:Nn \l_tmpa_clist
      {%
        \clist_put_right:Nn \l_tmpb_clist 
          { \ulenhance[#1]{\ulextend{##1}} }
      }
    %\clist_show:N\l_tmpb_clist% show the content of comma list
    \clist_use:Nn \l_tmpb_clist { \\ & }
}
\ExplSyntaxOff
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
\setlength{\textwidth}{155mm}% 版心内心尺寸为155x230mm
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
\setlength{\textheight}{230mm}% 版心内心尺寸为155x230mm
\setlength{\voffset}{-1.0in}% set vertical offset
\setlength{\topmargin}{2.0cm}% 页眉距边界2.0厘米
\setlength{\headheight}{0mm}% header height
\setlength{\headsep}{7.06mm}% 20pt折算。含页眉、页码的版心尺寸为155x250mm
\setlength{\footskip}{12.94mm}% 250mm-230mm-20pt折算。含页眉、页码的版心尺寸为155x250mm
%- specifies the amount of space between paragraphs.
\setlength{\parskip}{0ex plus 0.25ex minus 0.25ex}
%- line spacing
\linespread{1.7}% 相当于msword正文小四字号的1.5倍行间距
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
    \setlength{\ULdepth}{0.5em}% set depth
    \expandafter\ulunify\expandafter{#2}% linebreak fix
}
\newcommand{\ulhshift}{-4em}% horizontal shift on underline
\newcommand{\ulextend}[2][350pt]{% extend underline length
    \hbox to #1{\hfill\hspace*{\ulhshift}#2\hfill}}
%---------------------------------------------------------------------------%
%->> Titlepage
%---------------------------------------------------------------------------%
%-
%-> Chinese item commands
%-
\def\suda@value@ch@titlemark{}
\renewcommand{\title}[2][\suda@value@ch@title]{%
    \def\suda@value@ch@title{#2}
    %\def\suda@value@ch@titlemark{\MakeUppercase{#1}}}
    \def\suda@value@ch@titlemark{#1}}
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
\fi
%---------------------------------------------------------------------------%
%->> Structure layout
%---------------------------------------------------------------------------%
%- chapter
\ctexset {
    chapter = {
        format = \linespread{1.7}\zihao{-2}\bfseries\sffamily\centering,
        nameformat = {},
        titleformat = {},
        number = \zhnum{chapter},
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {-10pt},% 折算msword的实际位置。段前24磅
        afterskip = {26pt},% 折算msword的实际位置。段后18磅
        pagestyle = plain,
    }
}
%- section
\ctexset {
    section = {
        format = \linespread{1.7}\zihao{4}\sffamily\raggedright,
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {24pt},% 段前24磅
        afterskip = {12pt},% 折算msword的实际位置。段后6磅
    }
}
%- subsection
\ctexset {
    subsection = {
        format = \linespread{1.7}\zihao{-4}\sffamily\raggedright,
        numberformat = \rmfamily,
        aftername = \quad,
        beforeskip = {12pt},% 段前12磅
        afterskip = {6pt},% 段后6磅
    }
}
%- subsubsection
\ctexset {
    subsubsection = {
        format = \linespread{1.7}\zihao{-4}\sffamily\raggedright,
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
            \zihao{-4}\sffamily #1
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
            \leavevmode \zihao{-4}\sffamily
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
