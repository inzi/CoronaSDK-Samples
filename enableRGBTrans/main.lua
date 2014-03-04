-------------------------------------------------
--
-- enableRGBTrans
--
--
--[[

	This uses Lua metatables to enable r,g,b,a transitions on display objects in Corona SDK.
	This function is portable; use at your own risk; etc. etc. etc.

	See the caveats.

	I modified this to store color tables today after someone was doing that in the #corona IRC channel and thought it might of use to someone.

    USAGE:         obj = enableRGBTrans( obj )

        local text = display.newText("Watch me, three.", display.contentCenterX, display.contentCenterY + 200 , 0,0, native.systemFont , 48)
        text = enableRGBTrans( text )
        text:defineColorValue( "myBlue", {.2, .2, 1})
        text:setColorFromValue("myBlue")
        mytrans = transition.to(text, {time = 1000, r=math.random(), g=math.random(), b=math.random(), a=math.random(), onComplete = dotrans2} )

        CAVEATES:
        This reserves the values r,g,b,a & _colorValueTable for the object. If you want to use something different, you must edit the metatable




--]]
-------------------------------------------------

------------------------------------------------- START OF MAGIC
function enableRGBTrans(_t)
    -- USAGE:         obj = enableRGBTrans( obj )
    --[[
        local text = display.newText("Watch me, three.", display.contentCenterX, display.contentCenterY + 200 , 0,0, native.systemFont , 48)
        text = enableRGBTrans( text )
        text:defineColorValue( "myBlue", {.2, .2, 1})
        text:setColorFromValue("myBlue")
        mytrans = transition.to(text, {time = 1000, r=math.random(), g=math.random(), b=math.random(), a=math.random(), onComplete = dotrans2} )

        CAVEATS:
        This reserves the values r,g,b,a & _colorValueTable for the object. If you want to use something different, you must edit the metatable
    --]]

    local t= {}
    t._colorValueTable = {}

    local rgbVals = {r="r",g="g",b="b",a="a"}

    --    function targetObject.rgbTransition:initialize()

    local mt = {
        r=1,
        g=1,
        b=1,
        a=1,

        __index = function (t,k)

            if k==rgbVals.r or k==rgbVals.g or k==rgbVals.b or k==rgbVals.a then
                if k==rgbVals.r then
                    return r
                elseif k==rgbVals.g then
                    return g
                elseif k==rgbVals.b then
                    return b
                elseif k==rgbVals.a then
                    return a
                end

            else
                return _t[k]
            end

        end,

        __newindex = function ( t, k, v)

            if k==rgbVals.r or k==rgbVals.g or k==rgbVals.b or k==rgbVals.a then

                if k==rgbVals.r then
                    r=v
                elseif k==rgbVals.g then
                    g=v
                elseif k==rgbVals.b then
                    b=v
                elseif k==rgbVals.a then
                    if v==nil then v=1 end -- Default 1 for alpha
                    a=v
                end
                _t:setFillColor(r,g,b,a)

            else
                _t[k] = v   -- update original object
                --                print ("__index: " .. k)
            end





        end




    }
    function t:defineColorValue(...)
        -- requires Key, and Value ( table: {r,g,b,a} )
        -- example t:defineColorValue("myColor",{1,1,.5,.75} )
        self._colorValueTable[arg[1]] = arg[2]
        return true
    end
    function t:setColorFromValue(...)
        -- requires an existing, assigned color value
        -- example: t:setColorFromValue("myBlue")

        local k = arg[1]
        if self._colorValueTable[k] then
            local r,g,b,a = self.r, self.g, self.b, self.a
            r,g,b,a = unpack( self._colorValueTable[k] )
            self.r, self.g, self.b, self.a = r,g,b,a
            return true
        else
            return false
        end


    end
    function t:importColorTable(...)

        -- requires table in format {name1={r,g,b,a}, name2={r,g,b,a}}

        for k,v in pairs(arg[1]) do
            self:defineColorValue(k, v)
        end

    end
    function t:numberSaveValues()
        local retval = 0
        for _,_ in pairs(self._colorValueTable)do
            retval = retval+1
        end
        return retval
    end

    local retval =  setmetatable(t, mt)

    -- this default the color of the object to 1,1,1,1; required for metatable goodness.
    retval.r = 1
    retval.g = 1
    retval.b = 1
    retval.a = 1
    return retval

end



------------------------------------------------- END OF MAGIC



------------------------------------------------- CREATE TWO TEXT OBJECTS
local text = display.newText("Watch me.", display.contentCenterX, display.contentCenterY - 100, 0,0, native.systemFont , 48)
local text3 = display.newText("Watch me, too.", display.contentCenterX, display.contentCenterY + 200 , 0,0, native.systemFont , 48)

------------------------------------------------- THIS DOESN'T WORK
local mytrans = transition.to(text, {time = 2000, r=1, g=0, b=0} )

------------------------------------------------- BUT THIS WILL

-- abracadabra
text3 = enableRGBTrans( text3 )


------------------------------------------------- RANDOM TRANSITIONS
local function dotrans2(obj)
    local mytrans3
    obj.text = "I'm a random color / alpha."
    local function doit()
        mytrans3 = transition.to(obj, {time = 500, r=math.random(), g=math.random(), b=math.random(), a=math.random(), onComplete = doit} )
    end
    doit()
end

------------------------------------------------- PULSE THE TEXT OBJECT

local function pulse(obj)

    obj.text = "This is me pulsing."

    local pulsein, pulseout, dopulse
    dopulse = true

    function pulsein()

        transition.to( obj ,{time=500, r=1, g=0, b=1, a=1, transition=easing.inExpo, onComplete=pulseout})
    end

    function pulseout()
        if dopulse then
            transition.to( obj ,{time=500, r=0, g=1, b=1, a=.2 , transition=easing.inBounce, onComplete=pulsein})
        else
            dotrans2(obj)
        end

    end
    pulsein()
    timer.performWithDelay(10000, function() dopulse=false end)

end

------------------------------------------------- SHOW RANDOM COLOR FROM COLOR TABLE 5 TIMES (IF ANY VALUES EXIST
local function fromColorTableDemo(obj)

    local colorTable = {}
    local numberSaveValues = obj:numberSaveValues()
    if numberSaveValues>0 then
        local delay, timesToShow=2000, 5
        local function showRandomSaveValue(id)
            local thisid = 0
            for k,v in pairs(obj._colorValueTable ) do
                thisid = thisid+1
                if thisid == id then
                    obj.text = "ColorTableDemo: \"".. k .. "\" " .. timesToShow
                    obj:setColorFromValue(k)
                    break
                end

            end
            timesToShow = timesToShow-1
            if timesToShow==0 then
                pulse(obj)
            end

        end

        timer.performWithDelay(delay, function() showRandomSaveValue( math.random(numberSaveValues) ) end, timesToShow)
    else
        pulse(obj)
    end


end

------------------------------------------------- DEFINE A COLOR VALUE AND START THE DEMO
text3:defineColorValue( "myBlue", {.2, .2, 1})
text3:setColorFromValue("myBlue")
text3.text = "This is \"myBlue\"."

------------------------------------------------- AN EXAMPLE COLOR TABLE (FROM USER Arrpirate in IRC channel)
local myColorTable = {
    black       = {   0,    0,    0},
    white       = {   1,    1,    1},
    darkBlue    = {   0,    0, 0.75},
    blue        = {0.25, 0.25,    1},
    darkGreen   = {   0, 0.75,    0},
    green       = {0.25,    1, 0.25},
    teal        = {   0, 0.75, 0.75},
    aqua        = {0.25,    1,    1},
    darkRed     = {0.75,    0,    0},
    red         = {   1, 0.25, 0.25},
    purple      = {0.75,    0, 0.75},
    pink        = {   1, 0.25,    1},
    darkYellow  = {0.75, 0.75,    0},
    yellow      = {   1,    1, 0.25},
    darkGray    = {0.25, 0.25, 0.25},
    gray        = {0.75, 0.75, 0.75}
}
------------------------------------------------- IMPORT THE TABLE
text3:importColorTable(myColorTable)
------------------------------------------------- BEGIN THE DEMO
timer.performWithDelay(3000, function() fromColorTableDemo(text3)  end)

