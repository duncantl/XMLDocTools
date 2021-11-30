getRClasses =
function(doc = "book.xml", xpath = "//r:class")
{
   if(is.character(doc))
     doc = xmlParse(doc)

   k = getNodeSet(doc, xpath, NSDefs)
   table(sapply(k, xmlValue))
}

getPkgs =
function(doc = "book.xml")
   getRClasses(doc, "//r:pkg|//omg:pkg")


getRFuncs =
function(doc = "book.xml")
   getRClasses(doc, "//r:func")


