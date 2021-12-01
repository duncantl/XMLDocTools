missingTitles =
function(doc = xmlParse("book.xml"))
{
    if(is.character(doc))
        doc = xmlParse(doc)
    getNodeSet(doc, "//section[not(./title)]")
}
