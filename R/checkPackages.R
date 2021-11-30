checkPkgNames =
function(doc = "book.xml", xp = c("//omg:pkg", "//r:pkg", "//bioc:pkg"),
         packageList = c(library()$results[, "Package"], available.packages()[,"Package"]),
         known = c("RDCOMClient", "RDCOMServer", "RDCOMEvents", "rcom", "RExcel", 
                   "SWinTypeLibs", "SJava", "RCSS",  "RXQuery", # "iplots", "rjava", "xlsx",
                   "RBrowserPlugin", "RCytoscape", "xlsReadWrite"))
{
   if(is.character(doc))
      doc = xmlParse(doc)

   xp = sprintf("%s[not(@exists = 'false') and not(@url) and not(@deprecated) and not(ancestor::ignore)]", xp)
   
   nodes = getNodeSet(doc, xp)
   pkgNames = sapply(nodes, xmlValue)

   i = !(pkgNames %in% c(packageList, known))

#  if(any(i)) 
#     i = i & !sapply(nodes[i], function(x) any(c("url", "exists") %in% names(xmlAttrs(x))))

   structure(nodes[i], names = pkgNames[i])
}


