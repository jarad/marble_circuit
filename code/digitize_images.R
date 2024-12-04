library("tidyverse")
library("magick")
library("jpeg")

source("crop_image.R")


title = "90x20+10+10"
numbers = "100x10+5+120"

# # Reference images
# image_read(paste0(tempdir(),"/slot1.jpeg")) %>% image_write("ref/blue.jpeg")
# image_read(paste0(tempdir(),"/slot2.jpeg")) %>% image_write("ref/pink.jpeg")
# image_read(paste0(tempdir(),"/slot3.jpeg")) %>% image_write("ref/blank.jpeg")
# image_read(paste0(tempdir(),"/slot7.jpeg")) %>% image_write("ref/orange.jpeg")
# image_read(paste0(tempdir(),"/slot8.jpeg")) %>% image_write("ref/yellow.jpeg")





digitize_image <- function(file) {
  crop_image(file)
  
  n = get_numbers(file)
  clrs = determine_colors(file)
  
  data.frame(title = get_title(file),
             n1 = n[1],
             n2 = n[2],
             n3 = n[3],
             n4 = n[4],
             n5 = n[5],
             slot1 = clrs[1],
             slot2 = clrs[2],
             slot3 = clrs[3],
             slot4 = clrs[4],
             slot5 = clrs[5],
             slot6 = clrs[6],
             slot7 = clrs[7],
             slot8 = clrs[8],
             slot9 = clrs[9],
             slot10 = clrs[10],
             file = file)
}

d = readRDS("progress.RDS")
files = list.files(path = ".", pattern = ".jpeg")

if (file.exists("progress.RDS")) {
  d = readRDS("progress.RDS")
  files = setdiff(files, d$file)
}

for (file in files) {
  new = digitize_image(file)
  
  if (exists("d")) {
    d = rbind(d, new)
  } else {
    d = new
  }
  
  saveRDS(d, "progress.RDS")
}
