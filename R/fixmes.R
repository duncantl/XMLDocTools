getFixmes =
function(doc = xmlParse('book.xml'), toRemove = FALSE, asNodes = FALSE)
{
    if(is.character(doc))
        doc = xmlParse(doc)

    status = c("ignore", "done", "implement", "code", if(!toRemove) c("latex", "test"))
    status = paste(sprintf("not(@status = '%s')", status), collapse = " and ")
    q = paste(sapply(c("fix", "fixme", "check"),
                     function(x) sprintf("//%s[%s and not(ancestor::ignore) and not(ancestor::duncan[@status='ignore'])]", x[1], status)), collapse = " | ")

    nodes = getNodeSet(doc, q)
    #XXX  data.frame of file and linenum  and probably the text. See nakedWords.R and create a shared function for creating the data.frame from getNodeLocation (not Position)
    if(asNodes)
        structure(nodes, names = sapply(nodes, getNodePosition))
    else {
        ans = nodeLocationsDF(nodes)
        ans$text = sapply(nodes, xmlValue)
        ans
    }
}
