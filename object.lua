Object = {}
Object.__index = Object

id_counter = 0

function Object.new(o)
    o = o or {}
    setmetatable(o, Object)
    o.id = id_counter
    id_counter = id_counter + 1
    return o
end

function Object:update(dt)
    if self.speed then

    end
end
