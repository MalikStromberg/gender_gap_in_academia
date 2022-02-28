# this function creates robust numeric values out of factor coded variables

create_numerics <- function(x) {
  ifelse(is.factor(x), return(as.numeric(levels(x))[x]), return(x))
}