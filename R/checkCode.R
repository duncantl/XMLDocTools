library(XML)

checkDocCode =
function(doc = "book.xml", xp = c("r:code", "r:function", "r:expr", "r:plot", "r:init", "r:test"), verbose = TRUE)
{
   if(is.character(doc))
      doc = xmlParse(doc)

   # Could use
   #    code = xmlSource(doc, eval = FALSE, parse = FALSE)   
   xp = sprintf("//%s[not(ancestor::ignore) and (not(@parse) or @parse = 'false')]", xp) # and not(@eval='false')
   browser()
   xp = paste(xp, collapse = " | ")
   nodes = getNodeSet(doc, xp, NSDefs)

   
   ans = nodes[!sapply(nodes, codeNodeParses)]
   df = nodeLocationsDF(ans)
   df$code = sapply(ans, XML:::getRCode)
   df
#   structure(ans, names = sapply(ans, getNodePosition))
}

codeNodeParses =
function(node, verbose = FALSE)
{
    # Or
    #  x = XML:::evalNode(node, eval = FALSE)
    #  inherits(x, 'try-error')
    
  code = XML:::getRCode(node)
  if(verbose)
    message(code)
  tryCatch({parse(text = code); TRUE}, error = function(e) FALSE)
}
         
