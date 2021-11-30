readBib =
function(file = "book.bib")
{
  txt = readLines(file)
#  start = grep("^@", txt)  
#  end = grep("^}", txt)
  i = cumsum(grepl("^@", txt))
  els = split(txt,  i)
  if(!i[1] )
    els = els[-1]
  els
}

# Defined in nakedWords
#NSDefs = c(r = "http://www.r-project.org", omg = "http://www.omegahat.org")

checkXMLBib =
function(doc = "bibliography.xml",
         emptyNodeNames = c("r", "xml", "html", "xmlrpc", "c", "xquery",
                            "xpath", "xslt", "xsl", "json", "kml", "dom", "sax", "svg", "js"))
{
  if(is.character(doc))
     doc = xmlParse(doc)

  nodes = getNodeSet(doc, "//*  | //r:* | //omg:*", namespaces = NSDefs)
  empty = sapply(nodes, function(x) xmlSize(x) == 0 && !(xmlName(x) %in% emptyNodeNames)
                                          && length(xmlAttrs(x)) == 0)
  list(empty = nodes[empty])
}
