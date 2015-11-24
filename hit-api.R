works_with_R("3.2.2", httr="0.6.1", RJSONIO="1.3.0")

getContent <- function(u){
  request <- GET(u)
  stop_for_status(request)
  content(request, "text")
}

gist.content <- getContent("https://api.github.com/users/tdhock/gists")
gists <- fromJSON(gist.content)

gist.data.list <- list()
file.vec <- c("animint.js", "index.html")
for(gist.i in seq_along(gists)){
  g <- gists[[gist.i]]
  cont <- getContent(g$url)
  dest.file <- tempfile()
  write(cont, dest.file)
  bytes <- file.size(dest.file)
  kilobytes <- bytes/1024
  present.vec <- file.vec %in% names(g$files)
  names(present.vec) <- file.vec
  gist.data.list[[gist.i]] <-
    data.frame(id=g$id,
               files=length(g$files),
               animint.js=present.vec[["animint.js"]],
               index.html=present.vec[["index.html"]],
               bytes,
               kilobytes)
}
gist.data <- do.call(rbind, gist.data.list)
animint.gists <- subset(gist.data, animint.js)
  
