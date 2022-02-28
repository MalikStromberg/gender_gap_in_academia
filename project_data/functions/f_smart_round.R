# this function rounds the percentage values for section IV
# the waffle chart needs the values to sum up to exactly 100

# Source: https://stackoverflow.com/questions/32544646/round-vector-of-numerics-to-integer-while-preserving-their-sum

smart_round <- function(x) {
  y <- floor(x)
  indices <- tail(order(x - y), round(sum(x)) - sum(y))
  y[indices] <- y[indices] + 1
  y
}
