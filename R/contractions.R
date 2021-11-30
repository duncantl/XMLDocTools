
findContractions =
function(doc = xmlParse("book.xml"), contractions = c("t", "ll", "d"), #, "s")
             ancestors = c("ignore", "invisible", "comment", "deb", "duncan", "r:code", "programlisting", "proglisting", "r:output", "r:function", "flag",
                            "literal", "sh:flag", "sh:code", "xml:expr", "js:code", "xml:code", "xp:code", "fixme", "dquote"))
{
    if(is.character(doc))
        doc = xmlParse(doc)

     xp = sprintf("//text()[(%s) and %s]",
                   paste(sprintf("contains(., \"'%s\")", contractions), collapse = " or "),
                   paste(sprintf("not(ancestor::%s)", ancestors), collapse = " and "))

     tt = getNodeSet(doc, xp, namespaces = NSDefs)

    z = nodeLocationsDF(tt) # locationsByFile(tt)
    z$text = sapply(tt, xmlValue)
    z
}

# RCurl/readfunction.xml#55  Let's
