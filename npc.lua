Npc_table = {}
Npc_table.__index = Npc_table

function Npc_table.new(o)
    o = o or {}
    setmetatable(o, Npc_table)

    return o
end

Npc = {}
Npc.__index = Npc

function Npc.new(o)
    o = o or {}

    o.travel_speed = 400
    o.location = o.location or vector(0,0)
    g.events:add_event({f = Npc.wakeup, o = o, type = EV_METHOD, urg = false})
    o.object = new_player()
    o.object.pos = -0.5*vector(o.object.w, o.object.h)
    g.events:add_event{urg = true, type = EV_NEW_OBJECT, o = o.object}
    g.events:add_event{type = EV_METHOD, o = o, f = Npc.object_update, urg = false}
end

function Npc:wakeup()
    if self.target then
        self.location = self.target
        self.object.pos = self.target - 0.5*vector(self.object.w,self.object.h)
        self.target = nil
    end
    self.target = g.world_graph:random_adjecent(self.location)
    self.travel_start = game_time
    local distance = self.location:dist(self.target)
    local travel_time = distance / self.travel_speed
    self.object.vel = (self.target - self.location):normalized() * self.travel_speed
    self.travel_end = game_time + travel_time
    g.events:add_event({f = Npc.wakeup, o = self, type = EV_METHOD, urg = false}, travel_time)
end

function Npc:object_update()
    if self.object then
        self.object:update()
        g.events:add_event{type = EV_METHOD, o = self, f = Npc.object_update, urg = false}
    end
end

