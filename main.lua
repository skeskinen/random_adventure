require 'hump.vector'

require 'obj_tree'
require 'object'
require 'events'
require 'event_handler'
require 'world_graph'
require 'direction'
require 'road'
require 'city_generation'

WORLD_SIZE = 2^20
game_time = 0

function love.load()
    math.randomseed(os.time())
    math.random()

    g = {}
    g.obj_tree = Obj_tree.new{root = 1}
    g.events = Events.new()
    g.world_graph = World_graph.new()
    for i=1,40 do
        g.obj_tree:insert(Object.new{pos=vector(0,0),w=40,h=40})
    end
    for i=1,30 do
        g.obj_tree:remove{id = i, pos=vector(0,0),w=40,h=40}
    end
   
    for i=1,5 do
        new_random_road()
    end
    --[[
    for i,v in ipairs(g.world_graph.expansions) do
        print(i, v.dir:text(), v.a.pos)
    end
    --]]
    
end

function love.draw()

end

function love.update(dt)
    game_time = game_time + dt
    g.events:run_events()
end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    end
end

function love.keyreleased(key)

end

function love.mousepressed(x, y, mouse)

end

function overlap(a, b)
    return a.pos.x < b.pos.x + b.w and b.pos.x < a.pos.x + a.w and a.pos.y < b.pos.y + b.h and b.pos.y < a.pos.y + a.h
end

function deepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

function round(num)
    return math.floor(num+0.5)
end

