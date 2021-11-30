checkTitles = 
function(doc = xmlParse('book.xml'), group = FALSE)
{
    if(is.character(doc))
        doc = xmlParse(doc)
    
    ti = getNodeSet(doc, "//title[not(ancestor::ignore) and not(ancestor::invisible) and not(ancestor::bibliography)]")
    tiValues = XML:::trim(xmlSApply(ti, xmlValue))
    w = duplicated(tiValues)
    ans = structure(ti[w], names = sapply(ti[w], getNodePosition))
    if(group) {
        split(ans, sapply(ans, function(x) xmlName(xmlParent(x))))
    } else
        ans
}

checkTitles2 = 
function(doc = xmlParse('book.xml'), group = FALSE)
{
    if(is.character(doc))
        doc = xmlParse(doc)
    
    ti = getNodeSet(doc, "//title[not(ancestor::ignore) and not(ancestor::invisible) and not(ancestor::bibliography)]")
    tiValues = XML:::trim(xmlSApply(ti, xmlValue))
    z = split(ti, tiValues)
    z = z[sapply(z, length) > 1 ]
}
