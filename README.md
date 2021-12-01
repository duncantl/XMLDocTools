#  Tools for Analyzing XML, XSL and LaTeX content 

This is a collection of all the top-level R files from the 3 (or 4) books I have written or am in
the processing of writing.  We use an XML/XSL that maps to (La)TeX approach. This is very powerful, but also has some
issues.  XSL can be finicky and LaTeX can be very finicky and cryptic.

The XML structure allows us to query the content to find different types of elements of interest.
(The alternative is regular expressions which are not reliable.)


Having created the LaTeX, we sometimes want to 
+ examine the resulting content before we run it through latex
+ explore the output from the LaTeX log file to explore
  + errors
     + runaway arguments
	 + errors
	 + missing citations and cross-refs
  + overfull and underfull lines



We start with some variables we use throughout.
These are the XML, bibliography, TeX  and TeX log file:
```r
xmlFile = "~/Book/book.xml"
xbibFile = "~/Book/Bibliography.xml"
texFile = "~/Book/book.tex"
logFile = "~/Book/book.log"
```

# Generating XML Content

## A Table in Docbook
To create content to put into an XML document, 
we can provide an R list or data.frame to create a Docbook table with
```
dbtable(obj)
```
You can put the output into the XML file.


## Creating an XML Bibliography Entry

`makePkgBiblioEntry()` creates a bibliography entry for an R package,
integrating the information from the package's DESCRIPTION/`.packageDescription()`.


# Analyzing the XML Documents

## Identifying Dependencies


```r
xmlFile = "book.xml"
xdeps = getXIncludes(xmlFile)
```

```
imgs = lapply(xdeps$href[xdeps$parse == ""], getImages)
names(imgs) = xdeps$href[xdeps$parse == ""]
```

```r
deps = unname(c(xdeps$href, unlist(imgs)))
```

If all the files are under the top-level common directory, we can remove that prefix
```r
prefix = dirname(path.expand(xmlFile))
sub(prefix, "", deps)   # not absolutely guaranteed
substring(deps, nchar(prefix) + 2) 
```
We skip 2 characters as the first is the / after the common directory name.
 

If the top-level document is not in the top-level directory, we can use `getCommonPrefix()`
from the [`Rlibstree`](https://github.com/omegahat/Rlibstree) package on github.
```r
prefix = Rlibstree::getCommonPrefix(deps)
substring(deps, nchar(prefix) + 1) 
```
We add 1 this time as getCommonPrefix identifies the / as part of the prefix.


## Missing Section Titles

```r
ti = missingTitles(xmlFile)
length(ti) # hopefully none.
nodeLocationsDF(ti)
```

## Table and Figure Titles and Captions

```r
checkTableFigureTitlesCaptions(xmlFile)
```
This returns a data.frame with the locations and the element names
of those tables or figures that are missing a caption or title or both.


## Finding duplicate @id attributes

```r
dupIDs(xmlFile)
```
The result is a data.frame with file and line number information and the id value.

## Finding instances of e.g. and i.e. that need a preceding ,
```
w = findEgIe(xmlFile)
```


## Finding erroneous xml:attr nodes

```r
emptyXMLAttr(xmlFile)
```

## Find - which should be en-dash or em-dash

```
dash = findDash(xmlFile)
```
This returns a data.frame of node locations (file and line number.)

## Finding 1st, 2nd, 3rd, ... in text

```r
findNumbers(xmlFile)
```


## Get all Packages, Classes or Function Names

```r
doc = xmlParse(xmlFile)
pkgs = getPkgs(doc)
fns = getRFuncs(doc)
k = getRClasses(doc)
```

We can then check whether these exist in different ways.

For packages, we can compare with known names 
```r
unknown = checkPkgNames(doc)
```

For functions and classes, we need to know which packages to look in.
These may be in the text of the XML documents, and we can also analyze the R code in the XML documents for calls to 
`library()` and `require()` to see which packages are loaded.
Functions may also be defined in the XML document.

See `checkFunctionNames`, `checkFunctionExists()`, `getDocFunctionDefNames`,  `getDocFunctionDefs`
for functions to check these aspects.


## Checking the Chapter and Section Titles

We can check the titles, also for empty and duplicate titles, in the document with 
```r
checkTitles(xmlFile)  # all titles with locations
checkTitles2(xmlFile) # just duplicated titles as XML nodes
```

## Check URLs
In the XML document and in the bibliography.

```r
checkURLs(xmlFile)
checkBibURLs(xbibFile)
```


## Finding the &lt;fix&gt;/&lt;fixme&gt; Nodes

```r
getFixmes(xmlFile)
```


## Words/phrases Needing XML Markup

We should find words or phrases that should have a markup, e.g., R versus &lt;r/&gt; 
so that they 1) are formatted correctly, and 2) more importantly, are added to the index
appropriately.
We can do this with 
```r
w = findNaked(xmlFile)
```

This returns a data.frame with columns
+ names  identifying the word/phrase
+ file & lineNum identifying where this occurred so one can readily edit it.


## Contractions (e.g., let's, we'll, doesn't)

It is good to eliminate these. So let's find them with
```r
k = findContractions(xmlFile)
```
This returns a data.frame with the word and the name of the file  and the line number within the file.


## Find Empty Sections

Sometimes we create a section and give it a title but don't delay adding  any content.
`findEmptySections` finds these sections:
```
esecs = findEmptySections(xmlFile)
```
returning a data.frame of locations and the title.



## Spell-checking XML Content

We spell-check in Emacs. However, our current modifications to nxml-mode don't skip the code nodes,
e.g., r:code, r:function, c:code, r:output, etc.
Also, doing this in Emacs means interactive spell-checking.
We can do this 
```r
z = spellCheck(xmlFile)
```

This isn't quick for a large document, e.g., 1 minute for 650 page document, but rapid for smaller,
individual files.

The result is a data.frame with
+ file  the name of the file
+ line the line number
+ text the text in which the potential spelling error was found
+ suggestions  a list of character vectors of suggested corrections



## Missing Titles, Captions

Find missing titles and captions in the XML documents:
```r
missingCaptions(xmlFile)
missingTitle(xmlFile)
```

For table and figure captions
```r
checkTitlesCaptions(xmlFile)
```

## Find Questions in the XML

```r
q  = getQuestions(xmlFile)
```


## Check r:code/r:function/r:expr nodes that don't parse correctly

```r
k = checkDocCode(xmlFile)
```
Again, we get a data.frame with the locations of the problematic nodes and 
the code.

## Missing or incorrect xref linkend attbitues

```r
badXRefs(xmlFile)
```

## Get &lt;fix&gt;/&lt;fixme&gt; nodes

```r
fix = getFixmes
```
A data.frame of locations and the text of the fixme.


## Check RCurl options
This checks the text (not the code) for markup identifying RCurl options
and then checks they are valid options (and not misspelled)
```r
rcopts = checkCurlOpts(xmlFile)
if(is.data.frame(rcopts))
  rcopts
```
Returns either TRUE or a data.frame of locations for the problematics RCurl "options".

# LaTeX

## Missing Warnings, Xrefs, Images

We can get the warnings, missing cross-references and missing images from the LaTeX document with 
```r
getWarnings(logFile)
missingXRefs(logFile)
missingImages(logFile)
```


## Finding Overfull lines/boxes

```r
ov = overfulls("~/Book/book.log")
```
This gives a data.frame with each row being 
a warning about an Overfull box and the columns identify
+ the line number in the TeX file
+ the amount the box is overfull
+ the page number in the PDF
+ the line number in the log file.


Missing values for the line number correspond to early in the document generation,
often with the message "while \output is active" rather than "detected at line".


The function `getWideNodes()` works on the XML and finds 
r:code, r:function, r:output and programlisting nodes (by default) that 
contain long lines of text. 

## Finding all Calls to a LaTeX macro

```
getTeXCalls(texFile, str = "gls")
getTeXCalls(texFile, str = "LaTeX", noArgs = TRUE)
```

# XML/XSL Namespaces

Sometimes we have a lot of namespace definitions in an XML/XSL file
that were copied but are not actually needed.
One can comment each one out and run the document through `xmllint` to see if there is an error.
If not, the namespace was not needed for that file.

This approach works for XML files, but doesn't catch the use of namespaces in XSL when they arise
in attributes such as `match`, `select`, `test`, etc.

So  the `getUnusedNS()` function is possibly a better way to find these
for XML and/or XSL files.


## Finding a Template

```r
library(Sxslt)
sty = xsltParseStyleSheet("http://www.omegahat.org/XDynDocs/XSL/OmegahatXSL/latex/krantz.xsl")
```
```
library(XML)
tem = getTemplate(sty, newXMLNode("acronym"))
```
The result is a list that gives the match attribute, the node,
the priority and the mode.


