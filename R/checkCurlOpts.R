checkCurlOpts =
function(doc = "book.xml")
{
   if(is.character(doc))
     doc = xmlParse(doc)

   opts = getNodeSet(doc, "//rc:opt", c(rc = "http://curl.haxx.se"))
   trueOpts = names(RCurl::getCurlOptionsConstants())
   w = sapply(opts, xmlValue) %in% trueOpts

   if(any(!w)) {
       ans = nodeLocationsDF(opts[!w])
       ans$option =  opts[!w]
       ans
   } else
    TRUE
}
