Npc_table = {}
Npc_table.__index = Npc_table

function Npc_table.new(o)
    o = o or {}
    setmetatable(o, Npc_table)

    return o
end

function Npc_table.update(dt)

end

Npc = {}
Npc.__index = Npc

function Npc.new(o)
    o = o or {}

    o.location = o.location or vector(0,0)

end

