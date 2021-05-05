title = "90x20+10+10"
slot1 = "10x10+17+110"
slot2 = "10x10+28+99"
slot3 = "10x10+39+90"
slot4 = "10x10+48+99"
slot5 = "10x10+37+110"
slot6 = "10x10+68+100"
slot7 = "10x10+60+89"
slot8 = "10x10+58+110"
slot9 = "10x10+49+79"
slot10 = "10x10+78+110"
numbers = "100x10+5+120"

library("tesseract")
eng <- tesseract("eng")
text <- tesseract::ocr("cropped.jpg", engine = eng)
cat(text)

numbers <- tesseract(options = list(tessedit_char_whitelist = "0123456789"))
cat(ocr("cropped.jpg", engine = numbers))
