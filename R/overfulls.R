#XXX Issues with the page numbers for some line numbers in log being earlier than page numbers for earlier log entries.
# ~/Book/book.log 
overfulls =
function(file = "newBook.log", txt = readLines(file))
{
  idx =  grep("Overfull \\\\hbox", txt)

  amt = as.numeric(gsub(".* \\\\hbox \\(([0-9.]+)pt.*\\).*", "\\1", txt[idx] ))
  lineNum = gsub(".*at lines? ([-0-9]+)", "\\1", txt[idx])
  lineNum[  !grepl('^[0-9]', lineNum) ] = NA

  pageNum = sapply(idx, findPageNumber, txt)
  if(all(grepl("^[0-9]+$", pageNum)))
      pageNum = as.integer(pageNum)
  else
      warning("some page numbers are not integers")
  data.frame(lineNum = lineNum, amount = amt, stringsAsFactors = FALSE, page = pageNum, logLineNumber = idx)
  
}

findPageNumber =
    # See version below.
function(at, lines)
{
  ll = lines[1:at]
  i = grep("\\[[0-9]+", ll)
browser()  
  # if i is empty, gives warning about -Inf. Typically? this is before any page numbers have been emitted so we
  # If i is non-empty, then aren't we looking backward and the page number is this + 1L
  if(length(i)) 
      gsub(".*\\[([0-9]+)\\]?.*", "\\1", ll[max(i)])
  else
      0
}


findPageNumber =
    #
    # This version looks forward, not backwards, for the next page as this is the page LaTeX is currently working on.
    #
function(at, lines)
{
  ll = lines[-(1:at)]
  i = grep("\\[[0-9]+", ll)
  # if i is empty, gives warning about -Inf. Typically? this is before any page numbers have been emitted so we
  if(length(i)) 
      gsub(".*\\[([0-9]+)\\]?.*", "\\1", ll[min(i)])
  else
      0
}



findOverfullCode =
function(doc = "newBook.xml", threshold = 66, asNodes = FALSE)
{
  if(is.character(doc))
     doc = xmlParse(doc)
  
  q = paste(sprintf("//%s[not(ancestor::invisible) and not(ancestor::ignore) and not(ancestor::fixme) and not(ancestor::fix) and not(ancestor::answer)]",
                   c("r:code", "r:function", "programlisting")), collapse = " | ")
  z = getNodeSet(doc, q)
  w = sapply(z, function(x) any(nchar(strsplit(xmlValue(x), "\\\n")[[1]]) > threshold))
  if(asNodes)
     z[w]
  else
     getNodePosition(z[w])    
}
