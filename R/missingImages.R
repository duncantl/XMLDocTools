getWarnings =
function(file = "newBook.log", txt = readLines(file), asIndex = FALSE)
{
  warnings = grep("LaTeX Warning", txt)
  if(asIndex)
     warnings
  else
     txt[warnings]
}


missingImages =
function(file = "newBook.log", txt = readLines(file))
{
  msg = getWarnings(, txt, asIndex = TRUE)
  idx = grep("File `.+' not found", txt[msg])
  ll = txt[msg][idx]
  gsub(".* File `([^']+)'.*", "\\1", ll)
}

missingXRefs =
function(file = "newBook.log", txt = readLines(file))
{

  msg = getWarnings(, txt, asIndex = TRUE)
  idx = grep("Reference `.+'", txt[msg])
  ll = txt[msg][idx]
  gsub(".* Reference `([^']+)'.*", "\\1", ll)
}



missingCaptions =
function(doc = "newBook.xml", asNodes = TRUE, nodeName = "caption")
{
  if(is.character(doc))
     doc = xmlParse(doc)

  q = sprintf("//%s[not(ancestor::ignore) and not(%s) and (not(ancestor::table[.//caption]) and not(ancestor::figure[.//caption]))]", c("figure", "table"), nodeName)
  nodes = getNodeSet(doc, q)
  if(asNodes)
     nodes
  else
     getNodePosition(nodes)
}

missingTitle =
function(doc = "newBook.xml", asNodes = TRUE)
{
  missingCaptions(doc, asNodes, "title")
}
