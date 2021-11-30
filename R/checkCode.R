library(XML)

checkDocCode =
function(doc = "book.xml", xp = c("r:code", "r:function"), verbose = TRUE)
{
   if(is.character(doc))
      doc = xmlParse(doc)

   xp = sprintf("//%s[not(ancestor::ignore) ]", xp) # and not(@eval='false')
   nodes = getNodeSet(doc, xp)
   ans = nodes[!sapply(nodes, codeNodeParses)]
   structure(ans, names = sapply(ans, getNodePosition))
}

codeNodeParses =
function(node, verbose = TRUE)
{
  code = XML:::getRCode(node)
  if(verbose)
    message(code)
  tryCatch({parse(text = code); TRUE}, error = function(e) FALSE)
}
         
