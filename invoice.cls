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

\newcommand{\vatrate}[1]{\renewcommand{\vatrate}{#1}}
\newcommand{\taxrate}[1]{\renewcommand{\taxrate}{#1}}
\newcommand{\currency}[1]{\renewcommand{\currency}{#1}}
% \newcommand{\description}[1]{\renewcommand{\description}{#1}}
\newcommand{\emitter}[3]{%
  \renewcommand{\emitter}{%
    \textbf{#1}\\
    #2\\
    #3
  }
}
\newcommand{\receiver}[3]{%
  \renewcommand{\receiver}{%
    \textbf{#1}\\
    #2\\
    #3
  }
}
\newcommand{\contact}[1]{\renewcommand{\contact}{#1}}
\newcommand{\bank}[1]{\renewcommand{\bank}{#1}}

\newcommand{\headertext}{INVOICE}
\newcommand{\descriptiontext}{DESCRIPTION}
\newcommand{\quantitytext}{QTY}
\newcommand{\pricetext}{PRICE}
\newcommand{\amounttext}{AMOUNT}
\newcommand{\subtotaltext}{TAX BASE}
\newcommand{\totaltext}{TOTAL}
\newcommand{\vattext}{VAT}
\newcommand{\taxtext}{TAX}

\AtBeginDocument{%
  \ifthenelse{\equal{\languagename}{spanish}}{%
    \renewcommand{\headertext}{FACTURA}
    \renewcommand{\descriptiontext}{DESCRIPCIÓN}
    \renewcommand{\quantitytext}{CANT.}
    \renewcommand{\pricetext}{PRECIO}
    \renewcommand{\amounttext}{IMPORTE}
    \renewcommand{\subtotaltext}{BASE IMPONIBLE}
    \renewcommand{\totaltext}{TOTAL}
    \renewcommand{\vattext}{IVA}
    \renewcommand{\taxtext}{IRPF}
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


\newcommand{\header}[1]{%
	{\Huge\headertext}\\[1em]
  {\large #1}\\[1em]
  \vfill
}

\newcommand{\invoicenumber}[1]{%
		{\Huge \#1}\smallskip
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
		& \multicolumn{2}{r}{BASE IMPONIBLE} & \subtotal\currency\\
		\ifdefempty{\taxrate}{}{& & IRPF (\taxrate\%) & \tax\currency\\}
		\ifdefempty{\vatrate}{}{& & IVA (\vatrate\%) & \vat\currency\\[2em]}
		& & \textbf{TOTAL} & \textbf{\total\currency}\\
	\end{tabular}

  \vfill\vfill
}

\newcommand{\invoiceitem}[3]{%
  \updateTotals{#2}{#3}%
  #1 & #2 &	#3\currency & \itemsubtotal\currency\\
}

\newcommand{\conditions}[1]{%
  \textsl{#1}\\[2em]
}
