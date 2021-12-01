if(FALSE) {
bibPkgs = xpathSApply(doc, "//bibliography//r:pkg | //bibliography//omg:pkg ", xmlValue)  
allPkgs = xpathSApply(doc, "//r:pkg | //omg:pkg ", xmlValue)  
pkgNames = setdiff(allPkgs, bibPkgs)
bib = structure(lapply(pkgNames, makePkgBiblioEntry), names = pkgNames)
bib[!sapply(bib, is.null)]

bibDoc = xmlParse("bibliography.xml")
bib = structure(lapply(pkgNames, makePkgBiblioEntry, parent = xmlRoot(bibDoc)),
                names = pkgNames)

saveXML(bibDoc, "bibliography.xml")

left = names(bib)[sapply(bib, is.null)]
left = left[-c(1, 2, 5, 15, 17)]

#ap =available.packages()
}

makePkgBiblioEntry =
function(pkg, desc = packageDescription(pkg),
         parent = NULL, id = sprintf("bib:%s", pkg),
         isOmegahat = grepl("Temple Lang", desc$Author))
{

  if(is.na(desc)) 
     return(NULL)


  be = newXMLNode("biblioentry", attrs = c(id = id, auto = "true"), parent = parent,
                   namespaceDefinitions = NSDefs[c("r", "omg")])
  newXMLNode("title",
             newXMLNode(sprintf("%s:pkg", if(isOmegahat) "omg" else "r"),
                         pkg),
             ": ", desc$Title,
               parent = be)
  makeAuthors(desc$Author, parent = be)
  newXMLNode("r:pkgVersion", desc$Version, parent = be)
  u = if(isOmegahat)
        sprintf("www.omegahat.org/%s", pkg)    
      else
        sprintf("cran.r-project.org/package=%s", pkg)
  
  newXMLNode("ulink", attrs = c(url = u), parent = be)

  be
}

makeAuthors =
function(author, parent = NULL)
{
  author = gsub(",? *with contributions by.*", "", author)
  els = XML:::trim(strsplit(author, ",|and")[[1]])

  ans = parent
  if(length(els) > 1)
    ans = parent = newXMLNode("authorgroup", parent = parent)
    
  tmp = lapply(els, makeAuthor, parent = parent) 

  if(length(els) == 1)
    tmp[[1]]
  else
    ans
}

makeAuthor =
function(author, parent = NULL)
{
   m = regexec("^([^ ]+) (.*)", author)
   els = regmatches(author, m)[[1]]
   if(length(els) == 0)
     els = c("", "", author)
   
   newXMLNode("author",
        newXMLNode("firstname", els[[2]]),
        newXMLNode("surname", els[[3]]), parent = parent)
}


makeRTemplate =
function(pkg, parent = NULL)
{
txt = '<biblioentry id="bib:" xmlns:r="http://www.r-project.org">
    <title><r:pkg></r:pkg>: </title>
    <authorgroup>
      <author>
        <firstname></firstname>
        <surname></surname>
      </author>
    </authorgroup>
    <r:pkgVersion></r:pkgVersion>
    <ulink url="cran.r-project.org/package="/>
  </biblioentry>'

  node = xmlRoot(xmlParse(I(txt)))

  xmlAttrs(node) = c(id = sprintf("bib:%s", pkg))
  t = node[["title"]][["pkg"]]
  xmlValue(t) = pkg

  u = node[["ulink"]]
  xmlAttrs(u) = c(url = sprintf("cran.r-project.org/package=%s", pkg))
  
  node
}
