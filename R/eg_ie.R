findEgIe =
    #XX Fix.
function(doc = xmlParse("book.xml"))
{
    if(is.character(doc))
        doc = xmlParse(doc)

    eg = findBadAbbrev(doc, "e.g.")
    ie = findBadAbbrev(doc, "i.e.")    
    
    ans = rbind(eg, ie)
#   if(nrow(ans))
#       ans$word = rep(c("e.g.", "i.e."), c(nrow(eg), nrow(ie)))
    ans
}

findBadAbbrev =
function(doc, word = "e.g.")
{
    w = getNodeSet(doc, sprintf("//text()[not(ancestor::ignore) and not(ancestor::invisible) and contains(., '%s')]", word))
    txt = sapply(w, xmlValue)

    rx = paste0("(^|,[[:space:]]+|\\()", gsub(".", "\\.", word, fixed = TRUE))
#    browser()
    i = !grepl( rx,  txt)
    eg = nodeLocationsDF(w[i])
    eg$text = txt[i]
    eg$word = word
    eg
}
