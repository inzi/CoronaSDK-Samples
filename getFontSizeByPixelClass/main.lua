local classFactory = require("classFontForPixelSize")
local myFontSizeEngineStandard =  classFactory.new( native.systemFont )
local myFontSizeEngineBold =  classFactory.new( native.systemFontBold )


-- Change this rectangle height to see the font size change.
local RectangleHeight1 = 100
local RectangleHeight2 = 60

display.setDefault( "anchorX", 1 )


local myRoundedRect1 = display.newRoundedRect( display.contentCenterX, display.contentCenterY/2*1, display.contentCenterX/2, RectangleHeight1, 12 )
myRoundedRect1.strokeWidth = 3
myRoundedRect1:setFillColor( 0.5 )
myRoundedRect1:setStrokeColor( 1, 0, 0 )

local myRoundedRect2 = display.newRoundedRect( display.contentCenterX, display.contentCenterY/2*2, display.contentCenterX/2, RectangleHeight2, 12 )
myRoundedRect2.strokeWidth = 3
myRoundedRect2:setFillColor( 0.5 )
myRoundedRect2:setStrokeColor( 1, 0, 0 )



display.setDefault( "anchorX", 0 )

local myText1 = display.newText( "Hello World!", display.contentCenterX, display.contentCenterY/2*1, native.systemFont, myFontSizeEngineStandard:getFontSizebyPix( myRoundedRect1.height *.8 ) )
myText1:setFillColor( 1, 0, 0 )

local myText2 = display.newText( "Hello World!", display.contentCenterX, display.contentCenterY/2*2, native.systemFont, myFontSizeEngineBold:getFontSizebyPix( myRoundedRect2.height *.8 ) )
myText2:setFillColor( 1, 0, 0 )


