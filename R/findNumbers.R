library(XML)

findNumbers =
function(doc = xmlParse("newBook.xml"))
{
    if(is.character(doc))
        doc = xmlParse(doc)

    nodeNames = c("invisible", "ignore", "r:code", "r:plot", "r:expr", "programlisting")
    query = sprintf("//text()[%s]",  paste(sprintf("not(ancestor::%s)", nodeNames), collapse = " and "))
    tt = getNodeSet(doc, query, NSDefs)

    txt = sapply(tt, xmlValue)

if(FALSE) {    
    rx = "(^|[[:space:]])(one|two|three|four|five|six|seven|eight|nine|ten)([[:space:],.;:]|$)"
    i = grep(rx, txt)

# Find the ones for the number being a position, i.e. first, second, etc.
    rx1 = "first|second|third|fourth|fifth|sixth|seventh|eighth|ninth|tenth"
    j = grep(rx1, txt)
}

    rxX = "(^|[[:space:]])(1st|2nd|3rd|4th|5th|6th|7th|8th|9th|10th)"
    k = grep(rxX, txt)
    #getMatch(txt[k])
    pos = nodeLocationsDF(tt[k])  # getNodePosition(tt[k])
    pos$text = txt[k]
#    names(txt[j]) = getMatch(txt[j], rx1)
#    browser()
    pos
    #XXXX finish off.
    # Was a script, now a function.
}


getMatch =
    #XXXX  Is this regmatches ???
function(text, regex)
{
   pos = gregexpr(regex, text)
   unname(mapply(function(txt, pos) {
            paste(substring(txt, pos, pos + attr(pos, "match.length")), collapse = ", ")
          }, text, pos))
}

