remove_return <- function(z) {
  gsub("\\n", "", z)
}

get_title <- function(file) {
  t1 = image_read(file) |>
    image_crop('90x20+10+10') |>
    image_ocr() |>
    remove_return()
  
  t2 = image_read(file) |>
    image_crop('90x20+10+10') |>
    image_negate() |>
    image_ocr() |>
    remove_return
  
  if (nchar(t1) > nchar(t2)) 
    return(t1)
  
  return(t2)
}
