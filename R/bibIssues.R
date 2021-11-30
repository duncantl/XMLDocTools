missingBibs =
function(file = "newBook.log", txt = readLines(file))
{
  idx = grep("Package natbib Warning: Citation", txt)
  bib = gsub("Package natbib Warning: Citation `([^']+)'.*", "\\1", txt[idx])
  pageNum = sapply(idx, findPageNumber, txt)
  data.frame(id = bib, page = pageNum, index = idx, stringsAsFactors = FALSE)  
}


findMissing =
function(doc = "newBook.xml", bib = "newBook.bib")
{
  if(is.character(doc))
     doc = xmlParse(doc)
 
  inText = names(table(grep("^bib:", unlist(getNodeSet(doc, "//biblioref/@linkend")), value = TRUE)))
  defs = getBibDefs(bib)
  setdiff(inText, defs)
}

getBibDefs =
function(bibFile)
{
  bib = readLines(bibFile)
  bib = grep("^%", bib, invert = TRUE, value = TRUE)
  defs = grep("@[a-zA-Z]+\\{[^ ]+", bib, value = TRUE)
  gsub("[[:space:]]*@[a-zA-Z]+\\{([^ ]+),", "\\1", defs)
}
