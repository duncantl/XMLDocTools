# Need to consider:
# xsl:value-of  select  @str
# xsl:if @test
# xsl:choose, xsl:when, xsl:otherwise
# 

getUnusedNS =
    #
    #
function(x, is.xsl = isXSL(x))
{
    if(is(x, "character"))
        x  = xmlParse(x, xinclude = FALSE)

    prefix = getNSPrefixes(x)

    if(is.xsl)
       prefix = unlist(c(prefix, getXSLNSPrefixes(x)))

    prefix = gsub(":", "", prefix)
    
    # Now look at the namespace definitions in the document
    nsDefs = xmlNamespaces(xmlRoot(x))
    ids = sapply(nsDefs, `[[`, "id")

    # So we don't 'seem' to need 
    setdiff(ids,  prefix)
}

# xpathSApply(x, "//*", xmlNamespace)
# [1] "s"    "doc"  "omg"  "bioc" "svg"  "js"   "str"  "ltx"  "c"   

getNSPrefixes =
    # Get the namespace prefix from all nodes in the document. This includes
    # those within the templates that create the new content.    
function(doc)
{
    tmp = xpathSApply(doc, "//*", xmlName, TRUE)
    w = grepl(":", tmp)    
    m = gregexpr("^[a-zA-Z0-9]+:", tmp[w])
    unlist(regmatches(tmp[w], m))
}


getXSLNSPrefixes =
function(x)
{
    # Now look at the match attribute in the xsl:template nodes and examine
    # their content.    
    tmpl = getNodeSet(x, "//xsl:template[@match]")
    m = sapply(tmpl, xmlGetAttr, "match")
    els = strsplit(m, "|", fixed = TRUE)


    # Next look in the select attributes of the xsl:value-of nodes.
    sel = xpathSApply(x, "//xsl:value-of", xmlGetAttr, "select")
    m = gregexpr("^[a-zA-Z0-9]+:", sel)
    tmp = regmatches(sel, m)
    els = trimws(c(els, unlist(tmp)))

    # Now that we have all of these, clean these up to extract the namespace prefix.
    m = gregexpr("^([a-zA-Z0-9]+):", els)
    prefix = unlist(regmatches(els, m))
    gsub(":$", "", prefix)
}


isXSL =
function(x)
{
    ns = xmlNamespace(xmlRoot(x))
    length(ns) > 0 && ns == "http://www.w3.org/1999/XSL/Transform"
}
