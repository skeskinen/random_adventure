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
    setmetatable(o, Npc)

    o.travel_speed = 200
    o.location = o.location or vector(0,0)
    o.wakeup = g.events:add_event({f = Npc.wakeup, o = o, type = EV_METHOD, urg = false})

    o.object = new_player()
    o.object.pos = -0.5*vector(o.object.w, o.object.h)
    o.object.parent = o
    o.object.selectable = true

    g.events:add_event{urg = true, type = EV_NEW_OBJECT, o = o.object}
    g.events:add_event{type = EV_METHOD, o = o, f = Npc.object_update, urg = false}

    return o
end

function Npc:choose_target()
    local t = g.world_graph:random_adjacent(self.location, self.last)
    if t then
        return t
    else
        return g.world_graph:random_adjacent(self.location)
    end
end

function Npc:wakeup()
    if self.target then
        self.last = self.location
        self.location = self.target
        self.object.pos = self.target - 0.5*vector(self.object.w,self.object.h)
        self.target = nil
    end

    self.target = self:choose_target()

    local distance = self.location:dist(self.target)
    local travel_time = distance / self.travel_speed
    self.object.vel = (self.target - self.location):normalized() * self.travel_speed
    self.travel_end = game_time + travel_time
    self.wakeup_handle = g.events:add_event({f = Npc.wakeup, o = self, type = EV_METHOD, urg = false}, travel_time)
end

function Npc:interrupt()
    if self.wakeup_handle then
        local _, t = g.events:interrupt_event(self.wakeup_handle)
            
        self.interrupt = {}
        self.interrupt.time_left = t - game_time
        self.interrupt.vel = self.object.vel
        self.object.vel = vector()
        self.wakeup_handle = nil
    end
end

function Npc:continue()
    if self.interrupt then
        self.wakeup_handle = g.events:add_event({f = Npc.wakeup, o = self, type = EV_METHOD, urg = false}, self.interrupt.time_left)
        self.object.vel = self.interrupt.vel
        self.interrupt = nil
    end
end

function Npc:object_update()
    if self.object then
        self.object:update()
        g.events:add_event{type = EV_METHOD, o = self, f = Npc.object_update, urg = false}
    end
end

