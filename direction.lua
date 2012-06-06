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

Direction.text = {
    'up', 'up_right', 'right', 'down_right', 'down', 'down_left', 'left', 'up_left'
}

function Direction.new(r)
    o = {}
    setmetatable(o, Direction)
    
    o.r = r or Direction.UP
    return o
end


function Direction:rad()
    return (self.r-1) * math.pi/2
end

function Direction:deg()
    return (self.r-1) * 45
end

function Direction:text()
    return self.text[self.r]
end

