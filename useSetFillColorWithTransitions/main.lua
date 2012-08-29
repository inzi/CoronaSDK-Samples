


-- draw rows of lines to show alpha

local steps = display.contentHeight/20
local y
for x =1,steps do
        y = display.contentHeight/20 * x
        display.newLine(0,y,display.contentWidth,y)
end

local myRect = display.newRect(20,20,150,150)

local rgbTransitionObject = {}

        function rgbTransitionObject:initialize(targetObject)
                local mt = {}
                mt.__index = function(self, key)
                        if self._props[key] ~= nil then
                                return self._props[key]
                        end
                end
                mt.__newindex = function(self, key, value)
                        if self._props[key] ~= nil then
                                self._props[key] = value
                                -- paint target:
                                --spit ("paiting via newindex " .. self._props.obj.serverIP)
                                self._props.obj:setFillColor(self._props.r, self._props.g, self._props.b, self._props.a)
                        else
                                rawset(self, key, value)
                        end
                end
                print ("init")
                self._props = { r = 255, g=255, b=255, a=255, obj = targetObject }
                setmetatable(self, mt)

                function self:setFillColor(red, green,blue, alpha)
                        local params = {red, blue, green, alpha}
                        local numParams = #params
                        --spit ("numParams: " .. numParams)
                        local r,g,b,a = self._props.r,self._props.g, self._props.b, self._props.a
                        --spit ("setFillColor: " .. self._props.r..", " .. self._props.g..", " .. self._props.b..", " .. self._props.a)
                     if numParams==1 then -- grey
                             r=params[1]
                             g=params[1]
                             b=params[1]
                     elseif numParams==2 then --grey and alpha
                             r=params[1]
                             g=params[1]
                             b=params[1]
                             a=params[2]
                     elseif numParams==3 then --rgb
                             r=params[1]
                             g=params[2]
                             b=params[3]
                     elseif numParams==4 then --rgb and alpha
                             r=params[1]
                             g=params[2]
                             b=params[3]
                             a=params[4]
                     end
                     self._props.r=r
                     self._props.g=g
                     self._props.b=b
                     self._props.a=a
                     --spit ("setFillColor: " .. self._props.r..", " .. self._props.g..", " .. self._props.b..", " .. self._props.a)
                    -- spit ("paiting via setFillColor " .. self._props.obj.serverIP)
                     self._props.obj:setFillColor(self._props.r, self._props.g, self._props.b, self._props.a)
                end
        end

rgbTransitionObject:initialize(myRect)


local function bluecycle()
        local cyclespeed = 1000
        transition.to(rgbTransitionObject,{time=cyclespeed, b=2})
        transition.to(rgbTransitionObject,{time=cyclespeed, delay=cyclespeed, b=255, onComplete=bluecycle})
end
local function redcycle()
        local cyclespeed = 7000
        transition.to(rgbTransitionObject,{time=cyclespeed, r=2})
        transition.to(rgbTransitionObject,{time=cyclespeed, delay=cyclespeed, r=255, onComplete=redcycle})
end
local function greencycle()
        local cyclespeed = 5000
        transition.to(rgbTransitionObject,{time=cyclespeed, g=2})
        transition.to(rgbTransitionObject,{time=cyclespeed, delay=cyclespeed, g=255, onComplete=greencycle})
end
local function alphacycle()
        local cyclespeed = 500
        transition.to(rgbTransitionObject,{time=cyclespeed, a=100})
        transition.to(rgbTransitionObject,{time=cyclespeed, delay=cyclespeed,a=255, onComplete=alphacycle})
end

bluecycle()
redcycle()
greencycle()
alphacycle()



