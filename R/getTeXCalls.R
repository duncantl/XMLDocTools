getTeXCalls = getLineAcronyms =
    #
    #  Find calls
    #
    #   getTeXCalls(ll = "This \\gls{ast} is a glossary acronym", str = "gls")
    #   getTeXCalls(ll = "This \\gls{ast} is a glossary acronym", str = "gls")
    #   getTeXCalls(ll = c("This is \\LaTeX", "This is no \\LaTeXext"), str = "LaTeX", noArgs = TRUE)
    #
    # Now using \gls   rather than acronym.
function(tex = "book.tex", str = "acronym", ll  = readLines(tex), noArgs = FALSE)
{
    rx = if(noArgs)
           sprintf("\\\\%s({})?\\b", str)
         else
            sprintf("\\\\%s\\{([^}]+)}?", str)
    m = gregexpr(rx, ll, perl = TRUE) 
    regmatches(ll, m)[sapply(m, function(x) x[1]) > 0]
}

if(FALSE) {
    ll = readLines("book.tex")
    getLineAcronyms(ll = ll)
    getLineAcronyms(ll = ll, str = "gls")    


#Older version that was not vectorized.    
acr = grep("\\\\acronym\\{", ll, value = TRUE)
words = sapply(acr, getLineAcronyms)

words = gsub("\\\\acronym\\{(.*)}", "\\1", unlist(words))
words = gsub("[-) ,'\\\\.}/:;]$", "", words)
words = gsub("^\\\\[a-zA-Z]+\\{", "", words)

w = unique(words)
}
