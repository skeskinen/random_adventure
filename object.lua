Object = {}
Object.__index = Object

id_counter = 0

function Object.new(o)
    o = o or {}
    setmetatable(o, Object)
    o.id = id_counter
    o.w = 0
    o.h = 0
    id_counter = id_counter + 1
    return o
end

function Object:update()
    if self.vel then
        local dt = game_time - (self.last_upd or game_time)
        self.last_upd = game_time

        g.obj_tree:remove(self)
        local old_pos = self.pos
        self.pos = self.pos + dt * self.vel
        if self.collision and collision(self.pos) then
            self.pos = old_pos
        end
        g.obj_tree:insert(self)
    end
end


function new_player()
    local o = Object.new{
          pos = vector()
        , vel = vector()
    }
    o.img = get_image_raw("player.png")
    o.w = o.img:getWidth()
    o.h = o.img:getHeight()
    return o
end
