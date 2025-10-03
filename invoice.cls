\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{invoice}

\LoadClass{extarticle}

\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage[a4paper, margin=1in]{geometry}
\usepackage[
  round-mode=places,
  round-precision=2,
  detect-all,
  group-minimum-digits=4,
  group-separator={,},
]{siunitx}
\usepackage[hidelinks]{hyperref}
\usepackage[default]{lato}
\usepackage{microtype}
\usepackage{booktabs}
\usepackage{setspace, fp, ifthen}

\pagestyle{empty}
\setlength{\parindent}{0pt}
\setstretch{1.25}

\newcommand{\titletext}{INVOICE}
\newcommand{\descriptiontext}{DESCRIPTION}
\newcommand{\quantitytext}{QTY.}
\newcommand{\pricetext}{PRICE}
\newcommand{\amounttext}{AMOUNT}
\newcommand{\subtotaltext}{BEFORE TAX}
\newcommand{\totaltext}{TOTAL}
\newcommand{\vattext}{VAT}
\newcommand{\taxtext}{TAX}
\newcommand{\contacttext}{Contact}
\newcommand{\banktext}{Payment}
\newcommand{\outputamount}[1]{\currencysymbol\num{#1}}

\AtBeginDocument{%
  \ifthenelse{\equal{\languagename}{spanish}}{%
    \renewcommand{\titletext}{FACTURA}
    \renewcommand{\descriptiontext}{DESCRIPCIÓN}
    \renewcommand{\quantitytext}{CANT.}
    \renewcommand{\pricetext}{PRECIO}
    \renewcommand{\amounttext}{IMPORTE}
    \renewcommand{\subtotaltext}{BASE IMPONIBLE}
    \renewcommand{\totaltext}{TOTAL}
    \renewcommand{\vattext}{IVA}
    \renewcommand{\taxtext}{IRPF}
    \renewcommand{\contacttext}{Contacto}
    \renewcommand{\banktext}{Pago}
    \renewcommand{\outputamount}[1]{\num{#1}\currencysymbol}
    \sisetup{
      output-decimal-marker={,},
      group-separator={.},
    }
  }{}
}

\newcommand{\vatrate}[1]{\renewcommand{\vatrate}{#1}}
\newcommand{\taxrate}[1]{\renewcommand{\taxrate}{#1}}

\newcommand{\currency}[2]{
  \newcommand{\currencycode}{#1}
  \newcommand{\currencysymbol}{#2}
}

\newcommand{\receiver}[3]{%
  \begin{minipage}[t]{0.56\textwidth}
    \flushright
    \textbf{#1}\\
    #2\\
    #3
  \end{minipage}\hfill%
}

\gdef\gitemsubtotal{0}
\gdef\gsubtotal{0}
\gdef\gvat{0}
\gdef\gtax{0}
\gdef\gtotal{0}

\newcommand{\updateTotals}[2]{%
  \FPeval{\itemsubtotal}{#1 * #2}%
  \global\let\gitemsubtotal\itemsubtotal%
  %
  \FPeval{\subtotal}{\gsubtotal + \itemsubtotal}%
  \global\let\gsubtotal\subtotal%
  %
  \ifdefempty{\vatrate}{}{%
    \FPeval{\vat}{\subtotal * (\vatrate / 100)}%
    \global\let\gvat\vat%
  }%
  %
  \ifdefempty{\taxrate}{}{%
    \FPeval{\tax}{\subtotal * (\taxrate / 100)}%
    \global\let\gtax\tax%
  }%
  %
  \FPeval{\total}{\subtotal + \vat - \tax}%
  \global\let\gtotal\total%
}

\newcommand{\makeheader}[1]{%
  {\Huge\titletext}\\[1em]
  {\large #1}\\[4em]
}

\newcommand{\invoice}[3]{%
  {\Huge \##1}\smallskip

  \begin{minipage}[t]{0.38\textwidth}
    \textbf{#2}\\
    #3
  \end{minipage}\hfill%
}

\newenvironment{invoicetable}{
  \vfill
  \setstretch{1.75}
  \setlength{\tabcolsep}{8pt}
  \centering
  \begin{tabular}{lrrr}
    \toprule
    \textbf{\descriptiontext} & \textbf{\quantitytext} & \textbf{\pricetext} & \textbf{\amounttext}\\
    \midrule
}{
    \bottomrule\\
    & \multicolumn{2}{r}{\subtotaltext} & \outputamount{\gsubtotal}\\
    \ifdefempty{\taxrate}{}{& & \taxtext{} (\taxrate\%) & \outputamount{\gtax}\\}
    \ifdefempty{\vatrate}{}{& & \vattext{} (\vatrate\%) & \outputamount{\gvat}\\}
    \\[-1em]
    & & \textbf{TOTAL (\currencycode)} & \textbf{\outputamount{\gtotal}}\\
  \end{tabular}
  \vfill
}

\newcommand{\invoiceitem}[3]{%
  \updateTotals{#2}{#3}%
  #1 & #2 & \outputamount{#3} & \outputamount{\gitemsubtotal}\\
}

\newcommand{\conditions}[1]{%
  \textsl{#1}\\[2em]
}

\newcommand{\emitter}[3]{%
  \begin{minipage}[t]{0.333\textwidth}
    \textbf{#1}\\
    #2\\
    #3
  \end{minipage}%
}

\newcommand{\contact}[1]{%
  \begin{minipage}[t]{0.333\textwidth}
    \textbf{\contacttext}\\
    #1
  \end{minipage}%
}

\newcommand{\bank}[1]{%
  \begin{minipage}[t]{0.333\textwidth}
    \textbf{\banktext}\\
    #1
  \end{minipage}%
}
