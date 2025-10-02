% -*- TeX-master: "./main.tex" -*-

\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{invoice}

\LoadClass{extarticle}

\usepackage[utf8]{inputenc}
\usepackage[T1]{fontenc}
\usepackage[a4paper, margin=1in]{geometry}
\usepackage[hidelinks]{hyperref}
\usepackage[default]{lato}
\usepackage{microtype}
\usepackage{booktabs}
\usepackage{setspace, fp, ifthen}

\pagestyle{empty}
\setlength{\parindent}{0pt}
\setstretch{1.2}
\renewcommand{\arraystretch}{1.75}

\newcommand{\titletext}{INVOICE}
\newcommand{\descriptiontext}{DESCRIPTION}
\newcommand{\quantitytext}{QTY}
\newcommand{\pricetext}{PRICE}
\newcommand{\amounttext}{AMOUNT}
\newcommand{\subtotaltext}{TAX BASE}
\newcommand{\totaltext}{TOTAL}
\newcommand{\vattext}{VAT}
\newcommand{\taxtext}{TAX}
\newcommand{\contacttext}{Contact}
\newcommand{\banktext}{Bank Details}

\newcommand{\vatrate}[1]{\renewcommand{\vatrate}{#1}}
\newcommand{\taxrate}[1]{\renewcommand{\taxrate}{#1}}
\newcommand{\currency}[2]{
  \newcommand{\currencyCode}{#1}
  \newcommand{\currencySymbol}{#1}
}
\newcommand{\emitter}[3]{%
  \setstretch{1.2}
  \begin{minipage}[t]{0.33\textwidth}
    \textbf{#1}\\
    #2\\
    #3
  \end{minipage}\hfill%
}

\newcommand{\receiver}[3]{%
  \begin{minipage}[t]{0.56\textwidth}
    \flushright
    \textbf{#1}\\
    #2\\
    #3
  \end{minipage}\hfill%
}
\newcommand{\contact}[1]{%
  \begin{minipage}[t]{0.33\textwidth}
    \textbf{\contacttext}\\
    #1
  \end{minipage}\hfill%
}
\newcommand{\bank}[1]{%
  \begin{minipage}[t]{0.33\textwidth}
    \textbf{\banktext}\\
    #1
  \end{minipage}%
}

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
  }{}
}

\gdef\itemsubtotal{0}
\gdef\subtotal{0}
\gdef\vat{0}
\gdef\tax{0}
\gdef\total{0}

\newcommand{\updateTotals}[2]{%
	\FPeval{\itemsubtotal}{round(#1 * #2, 2)}%
	\global\let\itemsubtotal\itemsubtotal%
  %
	\FPeval{\subtotal}{round(\subtotal + \itemsubtotal, 2)}%
	\global\let\subtotal\subtotal%
  %
	\ifdefempty{\vatrate}{}{%
		\FPeval{\vat}{round(\subtotal * (\vatrate / 100), 2)}%
		\global\let\vat\vat%
	}%
  %
	\ifdefempty{\taxrate}{}{%
		\FPeval{\tax}{round(\subtotal * (\tax / 100), 2)}%
		\global\let\tax\tax%
  }%
  %
	\FPeval{\total}{round(\subtotal + \tax - \vat, 2)}%
	\global\let\total\total%
}


\newcommand{\makeheader}[1]{%
	{\Huge\titletext}\\[1em]
  {\large #1}\\[1em]
  \vfill
}

\newcommand{\invoice}[3]{%
	{\Huge \#1}\smallskip

  \begin{minipage}[t]{0.38\textwidth}
    \textbf{#2}\\
    #3
  \end{minipage}\hfill%
}

\newenvironment{invoicetable}[4]{
  \vfill\vfill
  \setstretch{1}
  \centering
  \begin{tabular}{lrrr}
    \toprule
    \textbf{\descriptiontext} & \textbf{\quantitytext} & \textbf{\pricetext} & \textbf{\amounttext}\\
    \midrule
}{
    \bottomrule\\
		& \multicolumn{2}{r}{BASE IMPONIBLE} & \subtotal\currencySymbol\\
		\ifdefempty{\taxrate}{}{& & IRPF (\taxrate\%) & \tax\currencySymbol\\}
		\ifdefempty{\vatrate}{}{& & IVA (\vatrate\%) & \vat\currencySymbol\\[2em]}
		& & \textbf{TOTAL (\currencyCode)} & \textbf{\total\currencySymbol}\\
	\end{tabular}

  \vfill\vfill
}

\newcommand{\invoiceitem}[3]{%
  \updateTotals{#2}{#3}%
  #1 & #2 &	#3\currencySymbol & \itemsubtotal\currencySymbol\\
}

\newcommand{\conditions}[1]{%
  \textsl{#1}\\[2em]
}
