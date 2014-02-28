-- test

local classFactory = require("classFontForPixelSize")
local myFontSizeEngine =  classFactory.new( native.systemFont )


print ("here")

local RectangleHeight = 100

display.setDefault( "anchorX", 1 )


local myRoundedRect = display.newRoundedRect( display.contentCenterX, display.contentCenterY, display.contentCenterX/2, RectangleHeight, 12 )
myRoundedRect.strokeWidth = 3
myRoundedRect:setFillColor( 0.5 )
myRoundedRect:setStrokeColor( 1, 0, 0 )

display.setDefault( "anchorX", 0 )


local myText = display.newText( "Hello World!", display.contentCenterX, display.contentCenterY, native.systemFont, myFontSizeEngine:getFontSizebyPix( myRoundedRect.height *.8 ) )
myText:setFillColor( 1, 0, 0 )




