crop_image <- function(img) {
  require(magick)
  
  crops = c("10x10+49+79",
            "10x10+39+90",
            "10x10+60+89",
            "10x10+28+99",
            "10x10+48+99",
            "10x10+68+100",
            "10x10+17+110",
            "10x10+37+110",
            "10x10+58+110",
            "10x10+78+110")
  
  for (i in 1:length(crops)) {
    image_read(img) |>
      image_crop(crops[i]) |>
      image_write(paste0(tempdir(), "/slot", i, ".jpeg"))
  }
}
