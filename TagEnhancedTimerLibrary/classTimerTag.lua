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


local t = {}

-- keep a private access to original table
local _t = t

-- create proxy
t = timer
t._timers = {}
_t._funcs = {

    performWithDelay = t.performWithDelay,
    cancel = t.cancel,
    resume = t.resume,
    pause = t.pause,
    _insert = t._insert,
    enterFrame = t.enterFrame
}


t.performWithDelay = function(...)


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

    returnObject = _t._funcs.performWithDelay(arg[1], arg[2], iterations)

    returnObject._tag = tag

    table.insert( t._timers, returnObject )

    return returnObject
end

t.cancel = function(...)

    if type( arg[1] ) == "string" then

        --        for _,v in pairs(timer._runlist) do
        for _,v in pairs(  t._timers ) do

            if v._tag == arg[1] then

                _t._funcs.cancel( v )
            elseif arg[1]=="*" then
                _t._funcs.cancel( v )
            end

        end
    else
        _t._funcs.cancel( arg[1] )
    end
end
t.resume = function(...)

    if type( arg[1] ) == "string" then

        --        for _,v in pairs(timer._runlist) do
        for _,v in pairs(  t._timers ) do

            if v._tag == arg[1] then

                _t._funcs.resume( v )
            elseif arg[1]=="*" then
                _t._funcs.resume( v )
            end


        end
    else

        _t._funcs.resume( arg[1] )

    end
end
t.pause = function(...)

    if type( arg[1] ) == "string" then

        --        for _,v in pairs(timer._runlist) do
        for _,v in pairs(  t._timers ) do

            if v._tag == arg[1] then
                --                spit ("found " .. v._tag)
                _t._funcs.pause( v )
            elseif arg[1]=="*" then
                _t._funcs.pause( v )
            end


        end
    else
        _t._funcs.pause( arg[1] )
    end
end

-- create metatable
local mt = {
    __index = function (t,k)
        return _t[k]   -- access the original table
    end,

    __newindex = function (t,k,v)
        _t[k] = v   -- update original table
    end

}
t = setmetatable(t, mt)

return t