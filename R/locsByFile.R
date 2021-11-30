nodeLocationsDF =
function(nodes)
{
  tmp = getNodeLocation(nodes)
  data.frame(file = sapply(tmp, function(x) x[[1]][1]), line = sapply(tmp, `[[`, 2))
}

locationsByFile =
function(nodes, dashLoc = nodeLocationsDF(nodes))
{
  split(dashLoc$line, dashLoc$file)
}
