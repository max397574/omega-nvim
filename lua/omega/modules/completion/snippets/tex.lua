local ls = require("luasnip")
local parse = ls.parser.parse_snippet
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local d = ls.dynamic_node
local sn = ls.snippet_node
local c = ls.choice_node
local r = ls.restore_node
local ai = require("luasnip.nodes.absolute_indexer")
local fmt = require("luasnip.extras.fmt").fmt

local tex_arrow = [[\$\implies\$]]

local tex_paragraph = [[
\paragraph{$1}]]

local tex_math_envs = [[
\definecolor{NiceGreen}{RGB}{79,219,0}

\newenvironment{satz}[1]{
\mdfsetup{
    leftmargin = {-1em},
    rightmargin = {-1em},
    roundcorner = 0pt,
    middlelinewidth = 1pt,
    linecolor = blue,
    innertopmargin = 0.5cm,
    frametitle= Satz: #1,
    outerlinewidth=0.5pt,
    innertopmargin = 10pt
}
\begin{mdframed}
}
{\end{mdframed}}

\newenvironment{bemerkungen}{
\mdfsetup{
    leftmargin = {-1em},
    rightmargin = {-1em},
    roundcorner = 0pt,
    middlelinewidth = 1pt,
    linecolor = NiceGreen,
    innertopmargin = 0.5cm,
    topline=false,
    rightline=false,
    bottomline=false,
    frametitle= Bemerkungen:,
    outerlinewidth=0.5pt,
    innertopmargin = 10pt
}
\begin{mdframed}
% \textbf{\color{black}Bemerkungen:}\\
}
{\end{mdframed}}

\newenvironment{definition}[1]{
\mdfsetup{
    leftmargin = {-1em},
    rightmargin = {-1em},
    roundcorner = 5pt,
    middlelinewidth = 1.2pt,
    linecolor = orange,
    innertopmargin = 0.5cm,
    frametitle= Definition: #1,
    outerlinewidth=1.5pt,
    innertopmargin = 10pt
}
\begin{mdframed}
}
{\end{mdframed}}

\newenvironment{merke}[1]{
\mdfsetup{
    leftmargin = {-1em},
    rightmargin = {-1em},
    roundcorner = 5pt,
    middlelinewidth = 1.2pt,
    linecolor = NiceGreen,
    innertopmargin = 0.5cm,
    frametitle= Merke!: #1,
    outerlinewidth=1.5pt,
    innertopmargin = 10pt
}
\begin{mdframed}
}
{\end{mdframed}}
]]

local tex_template = [=[
\documentclass[a4paper,12pt]{article}
\usepackage[a4paper, top=3.7cm, left=3cm, total={15.5cm,23cm}]{geometry}
\usepackage{fancyhdr}
\usepackage{import}
\usepackage{pdfpages}
\usepackage{transparent}
\usepackage{xcolor}
\usepackage{hyperref}
\usepackage{pdfpages}
\hypersetup{pdfborder = {0 0 0}}

\usepackage{textcomp}
\usepackage[german]{babel}
\usepackage{amsmath, amssymb}
\usepackage{ragged2e}
\usepackage{subcaption}
\usepackage[framemethod=tikz]{mdframed}
\usepackage{graphicx}
\graphicspath{ {./images/} }
\usepackage{tikz}
\usepackage{wrapfig}
\usepackage{enumitem}

\title{$1}
\author{$2}

\DeclareUrlCommand{\url}{%
    \def\UrlFont{\color{blue}\normalfont}%      Adding a little color 
    \def\UrlLeft##1\UrlRight{\underline{##1}}%  Underlining the url
}

\DeclareCaptionFormat{custom}
{%
    \textit{#1#2#3}
}
\captionsetup{format=custom,font={stretch=1}}

% \parskip=0.1cm

\begin{document}
% \maketitle
\linespread{1.5}

% \begin{titlepage}
%     \includepdf{titelblatt}
% \end{titlepage}

\pagenumbering{Roman}
\tableofcontents
\newpage

\pagestyle{fancy}
\fancyhf{}
\renewcommand{\footrulewidth}{0.4pt}
\fancyhead[RO]{$3Paper \hfill\nouppercase{\leftmark}}
\fancyfoot[LE,RO]{$4Author \hfill\thepage}

\newpage
\pagenumbering{arabic}

$0

\end{document}
% vim:spelllang=de
]=]
-- local tex_template = [[
-- \documentclass[a4paper,12pt]{article}
-- \usepackage[a4paper, margin=1in, total={20cm,27cm}]{geometry}
-- \usepackage{import}
-- \usepackage{pdfpages}
-- \usepackage{transparent}
-- \usepackage{xcolor}
-- \usepackage[labelfont=bf]{caption}
--
-- \usepackage{textcomp}
-- \usepackage[german]{babel}
-- \usepackage{amsmath, amssymb}
-- \usepackage{graphicx}
-- \usepackage{tikz}
-- \usetikzlibrary{shapes,positioning}
-- \usepackage{wrapfig}
--
-- \title{$1}
-- \author{$2}
--
-- \begin{document}
-- \maketitle
-- \tableofcontents
--
-- $0
-- \addcontentsline{toc}{section}{Unnumbered Section}
-- \end{document}
-- % vim:spelllang=de
-- ]]

local tex_section = [[
\section{$1}]]

local tex_italic = [[
\textit{$1}]]

local tex_subsection = [[
\subsection{$1}]]

local tex_subsubsection = [[
\subsubsection{$1}]]

local tex_table = [[
\begin{center}
  \begin{tabular}{ c c c }
    cell1 & cell2 & cell3 \\\\
    \\hline
    cell4 & cell5 & cell6 \\\\
    \\hline
    cell7 & cell8 & cell9
  \end{tabular}
\end{center}]]

local tex_enumerate = [[
\begin{enumerate}
  \item $0
\end{enumerate}]]

local tex_description = [[
\begin{description}
  \item $0
\end{description}]]

local tex_item = [[
\item ]]

local tex_bold = [[
\textbf{$1}]]

local tex_itemize = [[
\begin{itemize}
	\item $0
\end{itemize}]]

local tex_begin = [[
\\begin{$1}
	$0
\\end{$1}]]

local rec_ls
rec_ls = function()
    return sn(nil, {
        c(1, {
            -- important!! Having the sn(...) as the first choice will cause infinite recursion.
            t({ "" }),
            -- The same dynamicNode as in the snippet (also note: self reference).
            sn(nil, { t({ "", "\t\\item " }), i(1), d(2, rec_ls, {}) }),
        }),
    })
end

local function column_count_from_string(descr)
    -- this won't work for all cases, but it's simple to improve
    -- (feel free to do so! :D )
    return #(descr:gsub("[^clm]", ""))
end

-- function for the dynamicNode.
local tab = function(args, snip)
    local cols = column_count_from_string(args[1][1])
    -- snip.rows will not be set by default, so handle that case.
    -- it's also the value set by the functions called from dynamic_node_external_update().
    if not snip.rows then
        snip.rows = 1
    end
    local nodes = {}
    -- keep track of which insert-index we're at.
    local ins_indx = 1
    for j = 1, snip.rows do
        -- use restoreNode to not lose content when updating.
        table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1)))
        ins_indx = ins_indx + 1
        for k = 2, cols do
            table.insert(nodes, t(" & "))
            table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1)))
            ins_indx = ins_indx + 1
        end
        table.insert(nodes, t({ "\\\\", "" }))
    end
    -- fix last node.
    nodes[#nodes] = t("")
    return sn(nil, nodes)
end

ls.add_snippets("tex", {
    s(
        "table",
        fmt(
            [[
                \begin{{tabular}}{{{}}}
                {}
                \end{{tabular}}
            ]],
            {
                i(1, "c"),
                d(2, tab, { 1 }, {
                    user_args = {
                        -- Pass the functions used to manually update the dynamicNode as user args.
                        -- The n-th of these functions will be called by dynamic_node_external_update(n).
                        function(snip)
                            snip.rows = snip.rows + 1
                        end,
                        -- don't drop below one.
                        function(snip)
                            snip.rows = math.max(snip.rows - 1, 1)
                        end,
                    },
                }),
            }
        )
    ),

    s("hl", {
        t("\\hline"),
    }),
    s("ls", {
        t({ "\\begin{itemize}", "\t\\item " }),
        i(1),
        d(2, rec_ls, {}),
        t({ "", "\\end{itemize}" }),
        i(0),
    }),
    s("//", {
        t([[\textit{]]),
        i(1),
        t([[}]]),
        i(0),
    }),
    parse({ trig = "beg" }, tex_begin),
    parse({ trig = "item" }, tex_itemize),
    -- parse({ trig = "table" }, tex_table),
    parse({ trig = "bd" }, tex_bold),
    parse({ trig = "it" }, tex_item),
    parse({ trig = "sec" }, tex_section),
    parse({ trig = "italic" }, tex_italic),
    parse({ trig = "math_envs" }, tex_math_envs),
    parse({ trig = "enum" }, tex_enumerate),
    parse({ trig = "desc" }, tex_description),
    parse({ trig = "ssec" }, tex_subsection),
    parse({ trig = "sssec" }, tex_subsubsection),
    parse({ trig = "para" }, tex_paragraph),
    parse({ trig = "->" }, tex_arrow),
    parse({ trig = "template" }, tex_template),
    s("ls", {
        t({ "\\begin{itemize}", "\t\\item " }),
        i(1),
        d(2, rec_ls, {}),
        t({ "", "\\end{itemize}" }),
        i(0),
    }),
})
