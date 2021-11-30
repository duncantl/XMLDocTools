\name{getXIncludes}
\alias{getXIncludes}
\title{Compute all of the active XIncludes of an XML document}
\description{
  This finds all the xi:include nodes in the XML document
  that are not inside <ignore> nodes, and
  gets their href, parse and xpointer attributes.
  If \code{recursive} is \code{TRUE},
  the function processes each node in the same manner.
}
\usage{
getXIncludes(file, recursive = TRUE, xpointer = "")
}
\arguments{
  \item{file}{the name of the XML file, or a parsed document}
  \item{recursive}{a logical value}
  \item{xpointer}{the xpointer attribute for this \code{file} which is
    used to subset the resulting XML document to the target node.
    This is typically passed only in recursive calls.
  }
}
\value{
A data.frame with a row for each xi:include node found
\item{href}{the value of the \code{href} attribute, i.e., the name of
  the file/URL to be XInclude'd}
\item{parse}{the value of the \code{parse} attribute, either \code{""}
  or \code{"text"}}
\item{xpointer}{the value of the \code{xpointer} attribute specifying
  the restriction to the nodes of interest}

}
\references{
  XInclude \url{https://www.w3.org/TR/xinclude/}
}
\author{
Duncan Temple Lang
}
\seealso{\code{\link[XML]{xmlParse}}}
\examples{
f = system.file("", "A.xml", package = "XMLDocTools")
a = getXIncludes(f)

# More specific example with use of xpointer.
f = system.file("", "X.xml", package = "XMLDocTools")
b = getXIncludes(f)
# A.xml is not in the result as the xi:include href="A.xml" is not part
# of the resulting nodes in the xpointer restriction.
}
\keyword{IO}
\concept{XML}
