
checkFunctionNames =
  #
  #  
  #
function(doc = "book.xml", xp = c("//r:func[not(ancestor::ignore) and not(ancestor::invisible) and not(@exists = 'false')]"),
         packageList = library()$results[, "Package"],
         knownFunctions = character(),
         loadPackages = TRUE,
         localFunctions = TRUE,
         group = TRUE, ...)
{
   if(is.character(doc))
      doc = xmlParse(doc)

   nodes = getNodeSet(doc, xp)
   names(nodes) = sapply(nodes, xmlValue)

   if(is.logical(loadPackages) && loadPackages) 
      loadPackages = unique(xpathSApply(doc, "//r:pkg[not(@exists = 'false')] | //omg:pkg[not(@exists = 'false')]", xmlValue))

   if(length(loadPackages))
     lapply(unique(loadPackages), function(pkg) try(library(pkg, character.only = TRUE)))

   if(is.logical(localFunctions) && localFunctions)
      knownFunctions = c(knownFunctions, getDocFunctionDefs(doc))
   else
      knownFunctions = c(knownFunctions, getDocFunctionDefNames(doc))     

   w = names(nodes) %in% knownFunctions
   nodes = nodes[!w]
   
   i = mapply(checkFunctionExists, names(nodes), nodes, MoreArgs = list(...) )

   if(group)
      split(nodes[!i], names(nodes[!i]))
    else
      nodes[!i]
}


checkFunctionExists =
function(name, node = NULL,
          pkg = xpathSApply(node, ".//ancestor-or-self::*[@r:pkg]",
                             function(x) strsplit(xmlGetAttr(x, "pkg", character()), ",")[[1]],
                            namespaces = c(r = "http://www.r-project.org")),
           verbose = TRUE)
{
  if(length(pkg) == 0 && exists(name, mode = "function"))
    return(TRUE)

  if(grepl("::", name)) {
     tmp = strsplit(name, "::+")[[1]]
     return(exists(tmp[2], envir = asNamespace(tmp[1])))
  }
  
  if(!is.null(node) && length(pkg) == 0) {
     tmp = getNodeSet(node, ".//preceding-sibling::r:pkg | .//preceding-sibling::omg:pkg | .//ancestor-or-self::*[@r:pkg]",
                                        c("omg" = "http://www.omegahat.org", r = "http://cran.r-project.org"))
     if(length(tmp))
       pkg = sapply(tmp, function(x) if(xmlName(x) == "chapter") strsplit(xmlGetAttr(x, "pkg"), ",")[[1]] else xmlValue(x))
  }

  any(sapply(pkg, function(x) {
                if(verbose)
                  cat("loading", x, "\n")
                library(x, character.only = TRUE)
                exists(name, mode = "function") || exists(name, mode = "function", envir = asNamespace(x))
              }))

}

getDocFunctionDefNames =
function(doc = "book.xml")
{
   if(is.character(doc))
      doc = xmlParse(doc)

  defs = unlist(getNodeSet(doc, "//r:code/@r:define"))

  unique(c(defs,  unlist(xpathApply(doc, "//r:function[@id or @name and not(ancestor::ignore)]",
                      function(x)
                          xmlGetAttr(x, "name", xmlGetAttr(x, "id"))))))
}
  

getDocFunctionDefs =
function(doc = "book.xml")
{
   if(is.character(doc))
      doc = xmlParse(doc)

  defs = unlist(xpathSApply(doc, "//r:code/@r:define | //r:function/@r:define", strsplit, ","))
  unique(c(defs, unlist( xpathSApply(doc, "//r:function[not(@eval = 'false') and not(ancestor::ignore)]", getDocFunctionDef) )))
}

getDocFunctionDef =
function(node)
{
   id = xmlGetAttr(node, "id", xmlGetAttr(node, "name", NA))
   if(is.na(id)) {
       txt = xmlValue(node)
       if(txt == "")
         return("")
       expr = parse(text = txt)
       if(is.expression(expr))
         expr = expr[[1]]
       if(is.call(expr) && as.character(expr[[1]]) %in% c("<-", "="))
         id = as.character(expr[[2]])
       else
         id = ""
#       e =  new.env()
#       vals = eval(expr, envir = e)       
#       id = names(vals)
   }
   id
}
