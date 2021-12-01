library(XML)
findDash =
function(doc = xmlParse("book.xml"))
{
    if(is.character(doc))
        doc = xmlParse(doc)
    
    tt = getNodeSet(doc, "//text()[contains(., '-') and not(ancestor::ignore) and not(ancestor::comment) and not(ancestor::invisible) and not(ancestor::r:code) and not(ancestor::programlisting) and not(ancestor::proglisting) and not(ancestor::r:output) and not(ancestor::r:function) and not(ancestor::flag) and not(ancestor::literal) and not(ancestor::sh:flag) and not(ancestor::sh:code) and not(ancestor::xml:expr) and not(ancestor::deb) and not(ancestor::duncan) and not(ancestor::r:code) and not(ancestor::js:code) and not(ancestor::xml:code) and not(ancestor::xp:code)]", NSDefs)

    txt = sapply(tt, xmlValue)
    i = grepl("([[:space:]]-[^0-9]?|-[[:space:]])", txt)
    nodeLocationsDF(tt[i])
}


