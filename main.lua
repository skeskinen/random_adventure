require 'hump.vector'

require 'obj_tree'
require 'object'
require 'events'
require 'event_handler'
require 'world_graph'
require 'direction'
require 'road'
require 'city_generation'
require 'images'
require 'render'
require 'npc'

WORLD_SIZE = 2^20
game_time = 0

function love.load()
    math.randomseed(os.time())
    math.random()

    g = {}
    g.obj_tree = Obj_tree.new{root = 1}
    g.events = Events.new()

    g.world_graph = World_graph.new()
    --g.npc_table = Npc_table.new()

    g.player = new_player()
    g.events:add_event{o = g.player, type = EV_NEW_OBJECT, urg = true}

    for i=1,7 do
        new_random_road()
    end
    
    love.graphics.setBackgroundColor(50,200,50)
    
end

function love.draw()
    render()
end

function love.update(dt)
    game_time = game_time + dt

    g.events:add_event{f = Object.update, o = g.player, urg = true, type = EV_METHOD}
    g.events:run_events()
end

local speed = 400

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    else
        if key == 'up' then
            g.player.vel = g.player.vel + vector(0, -speed)
        elseif key == 'down' then
            g.player.vel = g.player.vel + vector(0, speed)
        elseif key == 'left' then
            g.player.vel = g.player.vel + vector(-speed, 0)
        elseif key == 'right' then
            g.player.vel = g.player.vel + vector(speed, 0)
        end
    end
end

function love.keyreleased(key)
    if key == 'up' then
        g.player.vel = g.player.vel + vector(0, speed)
    elseif key == 'down' then
        g.player.vel = g.player.vel + vector(0, -speed)
    elseif key == 'left' then
        g.player.vel = g.player.vel + vector(speed, 0)
    elseif key == 'right' then
        g.player.vel = g.player.vel + vector(-speed, 0)
    end
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

