dbtable =
function(x, ...)
{
   x = as.data.frame(lapply(x, format, ...), stringsAsFactors = FALSE)
   txt = sapply(1:nrow(x), function(i) mkRow(x[i,], ...))
   b = paste(txt, collapse = "\n")
   h = mkRow(names(x))
   sprintf("<table>\n<title></title>\n<tgroup cols='%s'>\n<thead>\n%s\n</thead>\n<tbody>\n%s\n</tbody>\n</tgroup>\n</table>", ncol(x), h, b)
}

mkRow =
function(x, collapse = "\n", ...)
{
  ans = sprintf("<row>\n%s\n</row>",  paste(sapply(x,
                                               function(x, ...)
                                                   sprintf("<entry>%s</entry>", format(x, ...)), ...), collapse = "\n   "))
  if(length(collapse))
      paste(ans, collapse = collapse)
  else
      ans
}
