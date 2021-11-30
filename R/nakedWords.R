NSDefs = c(r = "http://www.r-project.org",
           omg = "http://www.omegahat.org",
           http ="http://www.w3.org/Protocols",
           sh = "http://www.shell.org",
           x = "http://www.w3.org/XML/1998/namespace",
           s3 = "http://www.r-project.org",
           js = "http://www.ecma-international.org/publications/standards/Ecma-262.htm",
           c = "http://www.C.org",
           bioc = "http://www.bioconductor.org",
           db = "http://docbook.org/ns/docbook",
           make = "http://www.make.org",
           env = "http://www.shell-environments.org",
           xp = "http://www.w3.org/TR/xpath",
           curl = "http://curl.haxx.se",
           json = "http://www.json.org",
           xi = "http://www.w3.org/2003/XInclude" ,
           ltx = "http://www.latex.org",
           html = "http://www.w3.org/TR/html401",
           soap = "http://schemas.xmlsoap.org/soap/envelope/",
           sch = "http://www.w3.org/2001/XMLSchema"
    )


# Todo:
# Analyze the XSL to see which templates lead to simple markup of a word to identify thewords.
#     See xslNakedWords
# Develop a test document to ensure few false positives and negatives, e.g.,  R.  and  ,R. and not oR.
# check for lower-case.
#     + use R XML-UDF for this.
# √ Add shell commands such as  cp, rm, bash, curl, wget, ...

findNaked =
    # This finds certain words that should be in markup but that are in the XML text
    # as literal values. Hence the won't be formatted correctly and worse, they won't appear in the index
    # for these uses.
    #
    # ??? Check C++ is working correctly, i.e. with the \+..
    
function(doc = xmlParse("book.xml"), words = c("XML", "R", "XInclude", "XPointer", "XLink", "XSL",
                                               "WADL", "WSDL", "KML", "RSS", "DSL", "C", "C\\+\\+",
                                                "SSL", "REST", "HTML", "XHTML", "OAuth", "Java", "Perl",
                                                "Ruby", "Python", "MATLAB", "DTD", "DOM", "SAX", "JavaScript", "DCOM",
                                                "HTTP", "CSV", "S3", "S4", "SGML", "ZIP", "zip", "libxml", "libxml2", "libcurl","url", "URL",
                                                "cp", "rm", "mkdir", "curl", "wget", "gdb", "lldb", "Firefox", "chrome", "sqlite3"
                                              ), 
          ancestors = c("ignore", "r:code", "r:function", "r:class", "code", "programlisting", "proglisting", "duncan", "deb", "r:output", "r:pkg",
                         "omg:pkg", "xml:code", "sh:code", "fixme", "http:headerLine", "ulink", "literal", "r:arg"))
{

    if(is.character(doc))
        doc = xmlParse(doc)
    
    qancestors = paste(sprintf("not(ancestor::%s)", ancestors), collapse  = " and ")
    q = paste(sprintf("contains(., '%s')", words), collapse = " or ")

    xpath = sprintf("//text()[ %s and (%s)]", qancestors, q)
    x = getNodeSet(doc, xpath, namespaces = NSDefs)

    txt = sapply(x, xmlValue)
    #XXX catch false positives such as C.xml
    i = grep(sprintf("(^| )(%s)($|[[[:space:]],-]|\\. )", paste(words, collapse = "|")), txt, ignore.case = TRUE)
    rx = sprintf(".*(%s).*", paste(words, collapse = "|"))
    m = gsub(rx, "\\1", sapply(x[i], xmlValue))

    #  pos = sapply(x[i], getNodePosition)
    pos = nodeLocationsDF(x[i])
    pos$words = m
    pos[ , c(3, 1, 2)]
  #data.frame(words = m, file = sapply(pos, function(x) if(length(x$file)) x$file else NA), lineNum = sapply(pos, `[[`, "line"))
}





