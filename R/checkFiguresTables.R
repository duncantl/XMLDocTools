checkTableFigureTitlesCaptions =
function(doc = "book.xml", xp = c("table", "figure"), # , "functionSummaryTable"
         packageList = library()$results[, "Package"])
{
   if(is.character(doc))
      doc = xmlParse(doc)

   xp = sprintf("//%s[not(ancestor::ignore) and ((not(title) or normalize-space(title) = '') or (not(calloutlist) and (not(caption) or normalize-space(caption) = '')))]", xp)
   nodes = getNodeSet(doc, xp)
   ans = nodeLocationsDF(nodes)
   ans$type = sapply(nodes, xmlName)
   ans
}
