
dupIDs =
function(doc = xmlParse("book.xml"))
{
    if(is.character(doc))
        doc = xmlParse(doc)

    nodes = getNodeSet(doc, "//*[@id and not(ancestor::comment) and not(ancestor::ignore)]")

    ids = sapply(nodes, xmlGetAttr, "id")

    isDup = duplicated(ids)
    dup = ids[isDup]

    w = ids %in% dup
    nodes[w]

    
    ans = nodeLocationsDF(nodes[w])
    ans$id = ids[w]
    ans[order(ans$id), ]
}

