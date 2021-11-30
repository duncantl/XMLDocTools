library(XML)

z = xmlParse("A.xml")
b = getNodeSet(z, "//B")[[1]]
getNodeLocation(b)
bs = XML:::findXInclude(b, TRUE)

c = getNodeSet(z, "//C")[[1]]
getNodeLocation(c)
# file is empty. Line is 2.

s = getSibling(c, FALSE)
# Is an XMLXIncludeStartNode.
# but the file is not set.
# Also note that if we getSibling(b, FALSE), this is NULL

cs = XML:::findXInclude(c, TRUE)
identical(s, cs)
