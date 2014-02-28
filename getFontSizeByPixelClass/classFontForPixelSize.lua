-------------------------------------------------
--
-- classFontForPixelSize.lua
--
--
--[[
    Usage

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






--]]
-------------------------------------------------

local classFontForPixelSize = {}
local classTemplate_mt = { __index = classFontForPixelSize }	-- metatable




-------------------------------------------------
-- PRIVATE FUNCTIONS

-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------

function classFontForPixelSize.new( oFont )	-- constructor

    local newClassTemplate = {
        font = oFont,
        testString = "q▄█▀A",
        fontPixelSizeTable = {}
    }
    
    return setmetatable( newClassTemplate, classTemplate_mt )


end

-------------------------------------------------

function classFontForPixelSize:getFontSizebyPix( intPixelHeight )
    local retval = 0

    if self.fontPixelSizeTable[ intPixelHeight ]~=nil then

        retval = self.fontPixelSizeTable[intPixelHeight]

    else
        local oTxt = display.newText( self.testString , 0, display.contentHeight*2, self.font, 1)
        while oTxt.height < intPixelHeight do

            oTxt.size = oTxt.size + 1
            if self.fontPixelSizeTable[ oTxt.height ]==nil then
                self.fontPixelSizeTable[ oTxt.height ] = oTxt.size
            end
        end
        retval = oTxt.size -1
        oTxt:removeSelf()
        oTxt = nil
        self.fontPixelSizeTable[ intPixelHeight ] = retval
    end
    return retval
end

-------------------------------------------------

return classFontForPixelSize

