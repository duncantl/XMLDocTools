checkIndex =
function(idx = "book.idx")
{
  ll = readLines(idx)
  els = sub("^\\\\indexentry\\{([^|]+)\\|.*", "\\1", ll)

  tmp = strsplit(els, "@")
  key = sapply(tmp, `[`, 1)
  txt = sapply(tmp, function(x) paste(x[-1], collapse = "@"))

  vals = split(txt, key)
  w = sapply(vals, function(x) length(unique(x)) > 1)
  vals[w]
#  te = table(e)
#  sapply(te, length) == 1
}


readLatexDefs =
function(src = "bookMacros.tex")
{
  txt = readLines(src)
  txt = grep("^[[:space:]]*%", txt, value = TRUE, invert = TRUE)
  defs = grep("\\\\def\\\\[a-zA-Z]+#1\\{", txt, value = TRUE)

  tmp = gsub("\\\\def\\\\([a-zA-Z]+)#1\\{(.*)\\}",  "\\1xxx\\2", defs)
  tmp1 = strsplit(tmp, "xxx")
  structure(sapply(tmp1, `[`, 2), names = sapply(tmp1, `[`, 1))
}
  
