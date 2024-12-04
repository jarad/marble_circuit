get_numbers <- function(file) {
  print(image_read(file))
  
  n = rep(0,5)
  
  while(sum(n, na.rm = TRUE) != 8) {
    for (i in 1:5) {
      n[i] = as.numeric(readline(paste0("Number ",i,": ")))
    }
  }
  return(n)
}

