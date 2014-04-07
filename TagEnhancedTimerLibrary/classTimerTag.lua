-------------------------------------------------
--
-- classTimerTag.lua
--
-- Extends the timer object to use tags
--
-- adds a fourth, optional tag parameter to creating timers.
--
--
-- How to use
-- timer =  require ("classTimerTag")
--
--
-- local mytimer = timer.performWithDelay(5000 , function(event) print ("fired " .. event.tag .." - " .. system.getTimer()) end, 1, "timerTag")
-- local mytimer = timer.performWithDelay(5000 , function(event) print ("fired " .. event.tag .." - " .. system.getTimer()) end, "timerTag")
-- local mytimer = timer.performWithDelay(5000 , function(event) print ("fired " .. event.tag .." - " .. system.getTimer()) end, 1)
-- local mytimer = timer.performWithDelay(5000 , function(event) print ("fired " .. event.tag .." - " .. system.getTimer()) end)

-- timer.cancel(mytimer)
-- timer.cancel("default")

-- timer.pause("timerTag")
-- timer.resume("timerTag")
-- timer.cancel("timerTag")


-------------------------------------------------


local function _SpawnEnhancedTimer( timerObj )-- constructor

    local retVal = {}

    local _t = {

        performWithDelay = timerObj.performWithDelay,
        cancel = timerObj.cancel,
        pause = timerObj.pause,
        resume = timerObj.resume,

    }

    retVal = setmetatable( timerObj ,  {})

    retVal.performWithDelay = function(...)

        local returnObject

        local tag = arg[4]
        local iterations = nil
        if tag == nil then tag = "default" end
        if arg[3] ~= nil then
            if type( arg[3] ) == "string" then
                tag = arg[3]
            else
                iterations = arg[3]
            end
        end

        -- Set a default tag; handy for cleaning up scenes. If you don't use
        -- tags, then you call timer.cancel("default") and it will cancel ALL running timers


        returnObject =  _t["performWithDelay"](arg[1], function(e) e.tag=tag; arg[2](e) end, iterations)

        returnObject._tag = tag

        return returnObject

    end

    retVal.cancel = function(...)

        if type( arg[1] ) == "string" then

            for _,v in pairs(timer._runlist) do

                if v._tag == arg[1] then

                    _t["cancel"]( v )

                end

            end
        else
            _t["cancel"]( arg[1] )
        end
    end
    retVal.resume = function(...)

        if type( arg[1] ) == "string" then

            for _,v in pairs(timer._runlist) do

                if v._tag == arg[1] then

                    _t["resume"]( v )

                end


            end
        else

            _t["resume"]( arg[1] )

        end
    end
    retVal.pause = function(...)

        if type( arg[1] ) == "string" then

            for _,v in pairs(timer._runlist) do

                if v._tag == arg[1] then
                    _t["pause"]( v )
                end


            end
        else
            _t["pause"]( arg[1] )
        end
    end

    return retVal

end


return _SpawnEnhancedTimer( timer )