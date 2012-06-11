require 'hump.vector'

require 'misc' 
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
require 'gui'

require 'loveframes/init'

WORLD_SIZE = 2^20
game_time = 0

disable_moving = false

function love.load()
    math.randomseed(os.time())
    math.random()

    g = {}
    g.obj_tree = Obj_tree.new{root = 1}
    g.events = Events.new()

    g.world_graph = World_graph.new()
    g.npc_table = Npc_table.new()

    g.player = new_player()
    g.events:add_event{o = g.player, type = EV_NEW_OBJECT, urg = true}


    for i=1,2 do
        new_random_road()
    end
    
    love.graphics.setBackgroundColor(50,200,50)

    npc = Npc.new()
    
    init_render()
    gui.init()

    gui.add_message("Hello, welcome to super cool random adventure!")

    for i,v in ipairs(g.world_graph.expansions) do
        print(i, v.a.pos)
    end
end

function love.draw()
    render()
    loveframes.draw()
end

function love.update(dt)
    game_time = game_time + dt
    check_keys()

    g.events:add_event{f = Object.update, o = g.player, urg = true, type = EV_METHOD}
    g.events:run_events()
    loveframes.update(dt)
end

local speed = 400

function love.keypressed(key, unicode)
    if key == 'escape' then
        love.event.quit()
    end
    loveframes.keypressed(key, unicode)
end

function love.keyreleased(key)
    loveframes.keyreleased(key)
end

function check_keys()
    if disable_moving then return end

    local vel = vector()
    if love.keyboard.isDown("up") then
        vel = vel + vector(0, -1)
    end
    if love.keyboard.isDown("down") then
        vel = vel + vector(0, 1)
    end
    if love.keyboard.isDown("left") then
        vel = vel + vector(-1, 0)
    end
    if love.keyboard.isDown("right") then
        vel = vel + vector(1, 0)
    end

    g.player.vel = vel
    if vel.x ~= 0 or vel.y ~= 0 then
        g.player.vel:normalize_inplace()
        g.player.vel = speed * g.player.vel
    end
end

-- after gui has taken its mouse clicks
function mousepressed(x, y, mouse)
    if disable_moving then return end
    if mouse == "l" then
        local camera = get_camera()
        local m = {pos = vector(x, y) + camera.pos, w = 1, h = 1}
        local choose
        g.obj_tree:query(m, function(obj) if obj.selectable then choose = obj return true end end)
        if choose then
            click(choose)
        end
    end
end

function click(obj)
    gui.add_message("Hello, I'm Bob!") 
    g.player.vel = vector()
    obj.parent:interrupt()
    gui.answer_buttons{"Hello!", "Fuck off!"}
    disable_moving = true
    interrupted_obj = obj.parent
end

function get_answer(i)
    disable_moving = false
    interrupted_obj:continue()
    interrupted_obj = nil

    if i == 1 then
        gui.add_message("Good luck adventuring!")
    else 
        gui.add_message("Fuck you too.")
    end
end

function love.mousepressed(x, y, mouse)
    loveframes.mousepressed(x, y, mouse)
end

function love.mousereleased(x, y, mouse)
    loveframes.mousereleased(x, y, mouse)
end
