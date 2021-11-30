

# Analyze the XSL to see which templates lead to simple markup of a word to identify thewords.

# Connects to findNaked in nakedWords.R as the words argument.

getXSLNakedWords =
function(doc)
{
    if(is.character(doc))
        doc = xmlParse(doc)

    templs = getNodeSet(doc, "//xsl:template[@match]")

    match = sapply(templs, xmlGetAttr, "match")
}
