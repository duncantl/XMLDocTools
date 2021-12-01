# Find the xref linkend="value" which do not have a corresponding id="value"
#

badXRefs = 
function(doc = xmlParse("book.xml"))
{
    if(is.character(doc))
        doc = xmlParse(doc)

    le.nodes = getNodeSet(doc, "//xref[not(ancestor::ignore) and not (ancestor::comment)]")
    le = sapply(le.nodes, xmlGetAttr, "linkend")
    id = xpathSApply(doc, "//*[@id and not(ancestor::ignore) and not(ancestor::comment)]", xmlGetAttr, "id")
    w = le == "" | !(le %in% id )

    ans = nodeLocationsDF(le.nodes[w])
    ans$targetID = le[w]
    ans
}

if(FALSE) {
table(m)
# Currently 26 missing, 13 unique.

# Or from the output of running make book.pdf
miss = trimws(gsub(".* id: ", "", grep("^XRef", readLines("/tmp/x"), value = TRUE)))
}
