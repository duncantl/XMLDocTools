if(FALSE) {
x = getXIncludes("book.xml")
names(x)
# [1] "href"     "parse"    "xpointer" "file"


untracked = system("git ls-files --others --exclude-standard", intern = TRUE)
w = gsub("^\\./", "", x$href) %in% untracked
table(w)
x$href[w]

cat(unique(x$href), file = "XMLDependencies", sep = "\\\n")

img = lapply(x$href[tools::file_ext(x$href) == "xml"], getImages)
cat(unlist(img), file = "ImageDependencies", sep = "\\\n")
}


getXIncludes =
function(file, recursive = TRUE, xpointer = "")
{
    doc = xmlParse(file, xinclude = FALSE)
    nodes = getNodeSet(doc, "//xi:include", namespaces= c(xi="http://www.w3.org/2003/XInclude"))
    href = sapply(nodes, xmlGetAttr, "href")
    parse = sapply(nodes, xmlGetAttr, "parse", "")
    xpointer = sapply(nodes, xmlGetAttr, "xpointer", NA)

    if(length(href)) 
        href = getRelativeURL(href, file)
    ans = data.frame(href = href, parse = parse, xpointer = xpointer, file = rep(file, length(href)), stringsAsFactors = FALSE)
    if(recursive && length(href) > 0) {
        isParse = (parse == "text")
        tmp = mapply(getXIncludes, href[!isParse], xpointer[!isParse], MoreArgs = list(recursive = TRUE), SIMPLIFY = FALSE)
        tmp = do.call(rbind, tmp)
        ans = rbind(ans, tmp)
    }
    ans
}


getImages =
function(file, doc = xmlParse(file), relative = TRUE)
{
    ans = xpathSApply(doc, "//graphic[not(ancestor::ignore)]", xmlGetAttr, "fileref")
    if(length(ans) && relative)
        getRelativeURL(ans, docName(doc))
    else
        ans
}

getChapDepends =
function(file)    
{
   c(getXIncludes(file)$href, getImages(file))
}



