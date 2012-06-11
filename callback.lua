Callback = {}
Callback.__index = Callback

function Callback.new()
    local o = { callbacks = {}} 
    return setmetatable(o, Callback)
end

function Callback:add(o, f)
    self.callbacks[o] = f    
end

function Callback:remove(o)
    self.callbacks[o] = nil
end

function Callback:call(...)
    for o, f in pairs(self.callbacks) do
        f(...)
    end
end
