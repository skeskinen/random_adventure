Direction = {}
Direction.__index = Direction

Direction.UP = 1
Direction.UP_RIGHT = 2
Direction.RIGHT = 3
Direction.DOWN_RIGHT = 4
Direction.DOWN = 5
Direction.DOWN_LEFT = 6
Direction.LEFT = 7
Direction.UP_LEFT = 8

Direction.TEXT = {
    'up', 'up_right', 'right', 'down_right', 'down', 'down_left', 'left', 'up_left'
}

Direction.vectors = {
    vector(0,-1), 
    vector(1,-1):normalized(), 
    vector(1,0), 
    vector(1,1):normalized(), 
    vector(0,1),
    vector(-1,1):normalized(),
    vector(-1,0),
    vector(-1,-1):normalized()
}

function Direction.new(dir)
    local o = {}
    setmetatable(o, Direction)
    if type(dir) == 'string' then
        for i,v in ipairs(Direction.TEXT) do
            if dir == v then
                dir = i
                break
            end
        end
        assert(type(dir) ~= 'string') 
    end
    if type(dir) == 'table' then
        o.r = dir.r
    else
        o.r = dir%8
        if o.r == 0 then 
            o.r = 8
        end
    end
    return o
end


function Direction:rad()
    return (self.r-1) * math.pi/4
end

function Direction:deg()
    return (self.r-1) * 45
end

function Direction:text()
    return self.TEXT[self.r]
end

function Direction:__tostring()
    return self:text()
end

function Direction:opposite()
    return Direction.new(self.r+4)
end

function Direction:vector()
    return Derection.vectors[self.r].clone()
end

function Direction:rotate(rot)
    self.r = self.r + rot
    self.r = self.r%8
    if self.r == 0 then
        self.r = 8
    end
end

function Direction.__add(a,b)
    return Direction.new(a.r+b.r-1)
end

function Direction:clone()
    return Direction.new(self.r)
end

function Direction.__eq(a,b)
    return a.r == b.r
end
