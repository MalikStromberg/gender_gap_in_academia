# this function retrieves icons and returns them

i_create_icons <- function(icons) {
  ret <- list()
  if ('article' %in% icons) {
    article <- icon('newspaper')
    article$attribs$class <- 'far fa-newspaper'
    ret$article <- article
  }
  if ('database' %in% icons) {
    database <- icon('database')
    database$attribs$class <- 'fas fa-database'
    ret$database <- database
  }
  if ('hourglass' %in% icons) {
    hourglass <- icon('hourglass-half')
    hourglass$attribs$class <- 'fas fa-hourglass-half'
    ret$hourglass <- hourglass
  }
  if ('author' %in% icons) {
    author <- icon('user')
    author$attribs$class <- 'fas fa-user'
    ret$author <- author
  }
  if ('journal' %in% icons) {
    journal <- icon('book-open')
    journal$attribs$class <- 'fas fa-book-open'
    ret$journal <- journal
  }
  if ('search' %in% icons) {
    search <- icon('search')
    search$attribs$class <- 'fas fa-search'
    ret$search <- search
  }
  return(ret)
}