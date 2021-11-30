# function to find the r:code, etc. nodes that have lines that are
# more than a particular length. We use this when formatting the content for latex.

getWideNodes =
function(doc = "book.xml", xp = c("r:code", "r:function", "r:output", "programlisting"),
          width = 55)
{
  if(is.character(doc))
     doc = xmlParse(doc)
  
  xp = sprintf("//%s[not(ancestor::ignore)]", xp)
  nn = getNodeSet(doc, xp)
  els = lapply(nn, function(x) strsplit(xmlValue(x), "\n")[[1]])
  i = sapply(els, function(x) any(nchar(x) > width) )
  invisible(nn[i])
}

getNodeWidth =
function(node)
{
  nchar(strsplit(xmlValue(node), "\n")[[1]])
}
