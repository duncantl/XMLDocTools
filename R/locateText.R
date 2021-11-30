locateText =
function(str, doc = xmlParse("book.xml"))
{
  str = sprintf("contains(., '%s')", str)
  q = sprintf("//para[%s]", paste(str, collapse = "and"))
  nodes = getNodeSet(doc, q)
  structure(sapply(nodes, xmlValue), names = getNodePosition(nodes))
}

  
