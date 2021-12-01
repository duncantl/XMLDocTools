library(XML)

findEmptySections =
    # But that do have a title.
function(doc = xmlParse("book.xml"))
{
    if(is.character(doc))
        doc = xmlParse(doc)
    nodes = getNodeSet(doc, "//section[count(para) = 0  or count(para) = count(para[normalize-space(.) = ''])]/title")
    pos = nodeLocationsDF(nodes)
    pos$title = sapply(nodes, xmlValue)
    pos
}
