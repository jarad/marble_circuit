library("tidyverse")
library("jpeg")
library("raster")

# from https://stackoverflow.com/questions/9543343/plot-a-jpg-image-using-base-graphics-in-r
plot_jpeg = function(path, add=FALSE, xsub = NULL, ysub = NULL)
{
  require('jpeg')
  jpg = readJPEG(path, native=T) # read the file
  jpg = rasterFromCells(jpg, c(xsub,ysub))
  
  res = dim(jpg)[2:1] # get the resolution, [x, y]

  if (!add) # initialize an empty plot area if add==FALSE
    plot(1,1,
         xlim=c(1,res[1]),
         ylim=c(1,res[2]),
         asp=1,type='n',xaxs='i',yaxs='i',xaxt='n',yaxt='n',xlab='',ylab='',bty='n')
  rasterImage(jpg,1,1,res[1],res[2])
}

ask_challenge <- function() {
  return(askYesNo("Is this a challenge?"))
}

ask_number <- function() {
  number <- NA
  while(is.na(number)) {
    number <- as.numeric(readline("What number? [1-64]: "))
  }
  return(number)
}

ask_color <- function(slot) {
  color <- "x"
  while(!(color %in% c("e","b","p","o","b","y"))) {
    color <- readline(paste("What color is in slot",slot,"? [e,b,p,o,b,y]: "))
  }
  return(color)
}

ask_colors <- function() {
  colors = character(10)
  for (i in 1:10) {
    colors[i] <- ask_color(i)
  }
  return(paste0(colors, collapse = ""))
}

ask_slot_numbers <- function() {
  numbers <- character(5)
  for (i in 1:5) {
    number <- NA
    while(is.na(number)) {
      number <- as.numeric(readline(paste("What number is in slot",i,"? [0-8]: ")))
    }
    numbers[i] <- number
  }
  return(paste0(numbers, collapse = ""))
}

##########################
  
if (file.exists("tmp_data.rds")) {
  d = readRDS("tmp_data.rds")
} else {
  d = data.frame(file = character(),
                 challenge = character(),
                 number = integer(),
                 colors = character(),
                 slots = character())
}

files = list.files("data/images/low_quality/",
                   full.names = TRUE)[1:3]

files <- setdiff(files, d$file)



for (foo in files) {
  plot_jpeg(foo)
  
  d = rbind(d, 
        data.frame(file = foo,
                   challenge = ask_challenge(),
                   number = ask_number(),
                   colors = ask_colors(),
                   slots = ask_slot_numbers()))
  
  write_rds(d, file = "tmp_data.rds")
}


