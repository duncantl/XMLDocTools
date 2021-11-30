spellCheck = sp = 
function(doc = "Robots/Robots_summary.xml", hyphen = TRUE, speller = getSpeller(createSpellConfig(personal = "/Users/duncan/Projects/CaseStudies/dictionary")))
{
  if(is.character(doc))
      doc = xmlParse(doc)

  nodes = c("r:code", "r:plot", "r:function", "r:output", "r:error", "r:warning", "r:expr", "r:func", "r:var", "r:arg", "r:class", "r:keyword", "r:pkg", "r:el", "r:op", "r:attr", "r:formula", "r:param",
            "omg:pkg",
            "author", 
            "ltx:literal", "math",  "ltx", "latex",
            "programlisting",
            "c:code", "c:var", "c:expr", "c:func", "c:routine", "c:keyword", "c:arg", "c:function", "c:type",
            "sql:code", "sql:var", "sql:op", "sql:column", "sql:keyword", "sql:table",
            "sh:expr", "sh:flag", "sh:exec", "sh:code", "sh:glob", "sh:cmd",
            "x:tag", "x:attr",
            "xp:expr",
            "rx",
            "th", "sup", "entry",
            "quote",
            "invisible", "ignore", "comment()", "dtl", "fix", "check", "comment", 
            "literal", "file", "filename", "dir", "ext", "extension", "ulink", "email")
  q = sprintf("//text()[%s]", paste( sprintf("not(ancestor::%s)", nodes), collapse = " and "))
  txt = getNodeSet(doc, q, c(r = "http://www.r-project.org", sql = "http://www.sql.org", sh = "http://www.shell.org",
                             ltx = "http://www.latex.org", c = "http://www.C.org", omg = "http://www.omegahat.org",
                             x = "http://www.w3.org/XML/1998/namespace", xp = "http://www.w3.org/TR/xpath"))
  ans = sapply(txt, spellCheckNode, hyphen = hyphen, speller = speller)
  w  = sapply(ans, length) == 0

  pos = nodeLocationsDF(txt[w]) # getNodePosition(txt)
  pos$text = sapply(txt[w], xmlValue)
  pos$suggestions = I(ans[w])
  pos
}


spellCheckNode =
function(node, hyphen = TRUE, speller = getSpeller(createSpellConfig(personal = "/Users/duncan/Projects/CaseStudies/dictionary")))
{
   txt = xmlValue(node)

   words = strsplit(txt, '[[:space:],.?:;!/()~"[]+')[[1]]
   if(length(words) == 0)
       return(character())

   words = grep("^([-+$]?[0-9]+[%m]?|[0-9]+(rd|st|th|nd))$", words, invert = TRUE, value = TRUE)
   

   if(length(words) == 0)
       return(character())

   if(!hyphen)
      words = grep("[–-]", words, value = TRUE, invert = TRUE)

   if(length(words) == 0)
       return(character())   
   
   words = gsub("['’]s?$", "", words)
   
   ok = aspell(words, speller = speller)
   words[!ok]
}



if(FALSE) {

a = sp("newBook.xml")
b = a[!grepl("casesBibliography.xml", names(a))]

tmp = grep("^\\$[0-9]+$", grep("^\\$?[0-9]+[sK]$", grep("[-–]", unname(unlist(b)), invert = TRUE, value = TRUE), invert = TRUE, value = TRUE), invert = TRUE, value = TRUE)
tmp = grep("^[0-9]+(G[bB]|Ghz)$", tmp, invert = TRUE, value = TRUE)
exclude = c("S&P", "pseudocode", "base64", "AT&T", "Hmmm", "MD5", "CCs", "Ds", "200+", "IP", "hoc", "ing", "gzip'ed", "i7", "2D", "3D", "ni", "nj",
            "baseball]", "8F", "300+", "et", "al", "flyer", "pos")
setdiff(tmp, exclude)


hy = grep("[-–]", unname(unlist(b)), value = TRUE)
hy.words = unlist(strsplit(hy, "[-–]"))

speller = getSpeller(createSpellConfig(personal = "/Users/duncan/Projects/CaseStudies/dictionary"))
ok = aspell(hy.words, speller = speller)
hy.words = hy.words[!ok]

w = grep("^([0-9]{4}|10+|1024|[0-9]+)$", hy.words, value = TRUE, invert = TRUE)
ex = c("NN", "Kolmogorov", "Smirnov", "th", "Biham", "pre", "nxml", "multi", "docbook", "vivo", "parameterization", "R6127", "R6124", "eval", "DMS", "equi", "$2", "54g", "xsl")
setdiff(w, ex)


#w = grep("-", unname(unlist(b)), value = TRUE, invert = TRUE)
#w
}

