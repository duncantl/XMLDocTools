getQuestions =
function(doc = "book.xml", els = "q")
{
  if(is.character(doc))
     doc = xmlParse(doc)
  if(!is(els, "AsIs"))
      els = paste(sprintf("//%s[not(ancestor::ignore)]", els), collapse = " | ")

  q = getNodeSet(doc, els)
  if(length(q) == 0)
    return(list())

  #XXX return getNodeLocation and DF
  names(q) = sapply(q, getNodePosition)
  q
}
