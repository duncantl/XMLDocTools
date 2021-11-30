library(XML)
library(RCurl)

if(FALSE) {
b = xmlParse("book.xml")

sapply(sapply(getNodeSet(b, "//ulink[not(@url)]"), xmlValue), url.exists)

u = unlist(getNodeSet(b, "//ulink/@url"))
w = sapply(u, url.exists)
}

checkURLs =
function(doc = "book.xml")
{
  if(is.character(doc))
      doc = xmlParse(doc)

  nodes = getNodeSet(doc, "//ulink[@url and not(ancestor::ignore) and not(ancestor::invisible)]")
  u = sapply(nodes, xmlGetAttr, "url")
  ex = sapply(u, url.exists)
  structure(nodes[!ex], names = u[!ex])
}

checkBibURLs =
function(doc = "casesBibliography.xml")
{
  if(is.character(doc))
      doc = xmlParse(doc)

  nodes = checkURLs(doc)

  ids = sapply(nodes, function(x)
                          getNodeSet(x, ".//ancestor::biblioentry/@id"))
  has = sapply(ids, function(id) length(getNodeSet(doc, sprintf("//*[@linkend = '%s']", i))))
  nodes[has]
}
