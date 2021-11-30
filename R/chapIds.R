getChapterIds =
function(doc = xmlParse("book.xml"))
{
    if(is.character(doc))
        doc = xmlParse(doc)
    
    chap = getNodeSet(doc, "//chapter")
    ids = sapply(chap, xmlGetAttr, "id")

    titles = sapply(chap, function(x) xpathSApply(x, "./title", xmlValue))
    files = sapply(chap, function(x) getNodeLocation(x)$file[1])

    data.frame(id = ids, title = titles, file = files, stringsAsFactors = FALSE)
}
