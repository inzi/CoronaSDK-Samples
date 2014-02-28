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

local fontPixelSizeTable = {}
local stringText = "q▄█▀A"

-------------------------------------------------
-- PRIVATE FUNCTIONS

-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------

function classFontForPixelSize.new( oFont )	-- constructor

    local newClassTemplate = {
        font = oFont,
        testString = stringText
    }

    return setmetatable( newClassTemplate, classTemplate_mt )


end

-------------------------------------------------

function classFontForPixelSize:getFontSizebyPix( intPixelHeight )
    local retval = 0

    if fontPixelSizeTable[ intPixelHeight ]~=nil then

        retval = fontPixelSizeTable[intPixelHeight]

    else
        local oTxt = display.newText( self.testString , 0, display.contentHeight*2, self.font, 1)
        while oTxt.height < intPixelHeight do

            oTxt.size = oTxt.size + 1
            if  fontPixelSizeTable[ oTxt.height ]==nil then
                fontPixelSizeTable[ oTxt.height ] = oTxt.size
            end
        end
        retval = oTxt.size -1
        oTxt = nil
        fontPixelSizeTable[ intPixelHeight ] = retval
    end
    return retval
end

-------------------------------------------------

return classFontForPixelSize

