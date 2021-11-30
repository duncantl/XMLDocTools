emptyXMLAttr =
    # see if any stray <xml:attr></xml:attr> nodes were inserted
    # as the Rdocbook.el key bindings make this easy to insert.
    #????  Make this return a data.frame of positions. Or we can let the caller get these.
function(doc = xmlParse("book.xml"))
{
    if(is.character(doc))
        doc = xmlParse(doc)
    
    getNodeSet(doc, "//xml:attr[string(.) = '']", c("xml" = "http://www.w3.org/XML/1998/namespace"))
}
