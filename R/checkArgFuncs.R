
# Check XML elements <r:arg func="f"/>
# actually correspond to parameter names in definition of f.

checkArgFuncs =
function(doc = "book.xml")
{
  if(is.character(doc))
     doc = xmlParse(doc)

  args = getNodeSet(doc, "//r:arg[@func]")
  ok = sapply(args, checkArgFunc) 
  args[ is.na(ok) | !ok ]
}

checkArgFunc =
function(arg, checkDots = TRUE)
{
  funcName = xmlGetAttr(arg, "func")
  if(!exists(funcName, mode = "function"))
    return(NA)
  
  fun = get(funcName, mode = "function")
  paramNames = names(formals(fun))
  argName = xmlValue(arg)
  argName %in% paramNames || (checkDots && "..." %in% paramNames)
}
