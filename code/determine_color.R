library("colordistance")

# Load reference images
blue   = loadImage("ref/blue.jpeg")
pink   = loadImage("ref/pink.jpeg")
orange = loadImage("ref/orange.jpeg")
yellow = loadImage("ref/yellow.jpeg")
blank  = loadImage("ref/blank.jpeg")

ref = data.frame(
  files = c("ref/blue.jpeg",
             "ref/pink.jpeg",
             "ref/orange.jpeg",
             "ref/yellow.jpeg",
             "ref/blank.jpeg"),
  names = c("blue","pink","orange","yellow","blank")
)

determine_color <- function(file) {
  require("colordistance")
  
  images = c(file, ref$files)
             
  hlist = suppressWarnings(colordistance::getHistList(images, plotting = FALSE, pausing = FALSE))
  m = getColorDistanceMatrix(hlist, plotting = FALSE)
  ref$names[which.min(m[-1,1])]
}

determine_colors <- function(file) {
  clrs = character(10)
  crop_image(file)
  for (i in 1:10) {
    clrs[i] = determine_color(paste0(tempdir(), "/slot", i, ".jpeg"))
  }
  clrs
}
