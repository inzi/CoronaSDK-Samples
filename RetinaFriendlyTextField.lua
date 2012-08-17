local function myRetinaTextField(x1,y1,w1,h1,foListener)
    -- Some default values
    x1 = x1 or 1
    y1 = y1 or 1
    w1 = w1 or display.contentWidth*.75
    h1 = h1 or 32
   
-- -----------------------------------------------
-- this creates a nativeTextBox that works with 
-- Retina displays in CoronaSDK
-- If you use Corona's scaling (setting size in build.settings)
-- then you don't need this.
-- If you was pixel level control and chose to do things
-- by specifying screen coordinates, then you'll need this.
-- At least, until Corona fixes the bug.
-- -----------------------------------------------
   

    -- Assume the best
	local isRetina = false 
    local iDivider=1 
	
	-- Plan for the worst
    -- Note, but horizontal and vertical resolutions are in this table.
	-- the w is because you can't say 650=1 in lua
	local retinaResolutions = {w640="1",w2048="1",w960="1",w1536="1"}
    local plat = system.getInfo("platformName")
    if string.find(plat ,"iPhone")~=nil then --There's not retina bug on Android.
        -- We are on an IOS device - now determine if this is a Retina display
        if retinaResolutions["w"..display.contentWidth]~=nil then
            -- Yup, we're on a Retina device.
			-- Technically, the bug is native text boxes are twice as big and double
			-- parameters you give them.
			-- so if you tell it to be at position X, it goes to X*2.
			-- So we set a divider. It's not pixel perfect, but it's close enough!
			iDivider=2           
        end
    end
    
	-- It's either 1 or 2
    x1=x1/iDivider
    y1=y1/iDivider
    w1=w1/iDivider
    h1=h1/iDivider
    
-- ----------------------------------
-- Let's create our text field
-- note that the keyboard handling is not done here
-- I only override the "buggy" settings
-- and provide a transition capability.
-- (The bug manifests in tranisions, too).
-- ----------------------------------
    
    local tf3 = native.newTextField( 
    x1,y1,w1,h1,
    foListener
    )

-- ----------------------------------
-- These are the functions.
-- They should be self explanatory
-- ----------------------------------
	
    tf3.funcs={} -- I create a holding table for the functions
    function tf3.funcs.setX(a1) -- Set X. Use instead of MyTextField.x = 5, do MyTextField.funcs.setX(5) instead.
        tf3.x = a1/iDivider
    end
    
    function tf3.funcs.setY(a1) -- Set Y
        tf3.y = a1/iDivider
    end
    
    function tf3.funcs.setW(a1) -- Set Width
        tf3.width = a1/iDivider
    end
    
    function tf3.funcs.setH(a1) -- Set Height
        tf3.height = a1/iDivider
    end
    
    function tf3.funcs.setXY(a1,a2) -- set X AND Y, like so: MyTextField.funcs.setXY(display.contentCenterX, display.ContentCenterY)
        tf3.funcs.setX(a1)
        tf3.funcs.setY(a2)
    end
    
    function tf3.funcs.setWH(a1,a2) -- set Width AND height, like so: MyTextField.funcs.setWY(100,32)
        tf3.funcs.setW(a1)
        tf3.funcs.setH(a2)
    end
    
    function tf3.funcs.setXYWH(a1,a2,b1,b2) -- Set them all, like so: MyTextField.funcs.setXYWH(display.contentCenterX, display.ContentCenterY,100,32)
        tf3.funcs.setXY(a1,a2)
        tf3.funcs.setWH(b1,b2)
        
    end
    
	-- Transition Functions
	-- Call these instead of transition.to(MyTextField) and pass the transition options table as normal
	-- because if you use transition.to, the bug will manifest.
	-- This only provides for transitionTo and transitionFrom
	-- Note that nativeTextFields have unique behavior. See Corona Documentation.
	
    function tf3.funcs.transitionTo(a1) 
       
        local newTransParams = {}
        for i,v in pairs(a1) do
           if (i=="x" or i=="y" or i=="width" or i=="height") then
                newTransParams[i]=v/iDivider
           else 
                newTransParams[i]=v
           end
        end
        local myTrans = transition.to(tf3,newTransParams)
        
        return myTrans
    end
    
    function tf3.funcs.transitionFrom(a1)
        local newTransParams
        for i,v in pairs(a1) do
           if (i=="x" or i=="y" or i=="width" or i=="height") then
                newTransParams[i]=v/iDivider
           else 
                newTransParams[i]=v
           end
        end
        local myTrans = transition.from(tf3,newTransParams)
        
        return myTrans
    end
    
    return tf3
    
end

local function InputHandler( event )
    if event.phase == "began" then
        -- user begins editing textField
        print( event.text )
    elseif event.phase == "ended" then
        -- textField/Box loses focus
    elseif event.phase == "ended" or event.phase == "submitted" then
        -- do something with defaulField's text
    elseif event.phase == "editing" then
        print( event.newCharacters )
        print( event.oldText )
        print( event.startPosition )
        print( event.text )
    end
end
 
-- Usage Examples
-- Example 1
MyTextField = myRetinaTextField(50,50,250,32,InputHandler)
MyTextField.funcs.setXY(50,display.contentCenterY)

-- Example 2
MyOtherTextField = myRetinaTextField(50,50,250,32)
MyOtherTextField.userInput = InputHandler
MyOtherTextField:addEventListener( "userInput", MyOtherTextField )
MyOtherTextField.funcs.transitionTo({time=3000,x=1,y=1})
    

-- Example 3
local function TransitionHandlerFunction( obj )
        print( "Transition 2 completed on object: " .. tostring( obj ) )
end

numericField = myRetinaTextField( 50, 150, 220, 36 )
numericField.inputType = "number"
numericField:addEventListener( "userInput", handlerFunction )
numericField.funcs.transitionTo({time=500,delay=10000,x=display.contentCenterX,y=display.contentCenterY, onComplete=TransitionHandlerFunction})

