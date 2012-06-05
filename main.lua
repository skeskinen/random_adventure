require 'hump.vector'

require 'obj_tree'
require 'object'

WORLD_SIZE = 2^20

function love.load()
    math.randomseed(os.time())
    g = {}
    g.obj_tree = Obj_tree.new{root = 1}
    for i=1,40 do
        g.obj_tree:insert(Object.new{pos=vector(0,0),w=40,h=40})
    end
    for i=1,30 do
        g.obj_tree:remove{id = i, pos=vector(0,0),w=40,h=40}
    end
end

function love.draw()

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

function move_object(o, v)
    g.obj_tree:remove(o)
    local old_pos = o.pos
    o.pos = v
    if o.collision then
        if collision(o) then
            o.pos = old_pos
        end
    end
    g.obj_tree:insert(o)
end

