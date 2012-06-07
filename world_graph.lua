World_graph = {}
World_graph.__index = World_graph

function World_graph.new(o)
    o = o or {}
    setmetatable(o, World_graph)
    o.nodes = {}
    o.expansions = {}

    o:new_node{pos = vector(0,0), dirs = {Direction.new(Direction.UP), Direction.new(Direction.DOWN)}}
    return o
end

function World_graph:new_node(o)
    if not self.nodes[o.pos.x] then
        self.nodes[o.pos.x] = {}
    end
    if not self.nodes[o.pos.x][o.pos.y] then
        self.nodes[o.pos.x][o.pos.y] = World_node.new(o)
        local node = self.nodes[o.pos.x][o.pos.y]
        self:new_edges(node, unpack(o.dirs))
    else
        local node = self.nodes[o.pos.x][o.pos.y]
        local ok = #node.edges == #o.dirs
        for _,v in ipairs(node.edges) do
            for i,w in ipairs(o.dirs) do
                if v.dir == w then
                    break
                end
                if i == #o.dirs then
                    ok = false
                end
            end
        end
        assert(ok, "tried to merge to incompatible nodes")
    end
    return self.nodes[o.pos.x][o.pos.y]
end

function World_graph:new_edges(node, ...)
    for i,v in ipairs(arg) do
        local new_edge = World_edge.new(node, v)
        node.edges[#node.edges+1] = new_edge
        self.expansions[#self.expansions+1] = new_edge
        new_edge.expansion_index = #self.expansions
    end
end

function World_graph:expand(i, o)
    if type(i) == 'table' then
        if not i.expansion_index then
            assert(false, "Can't expand from given edge")
        end
        i = i.expansion_index
    end
    local edge = self.expansions[i]
    local node = self:new_node(o)
    local other_edge = node:connect(edge)
    if edge.b then
        self.expansions[i] = self.expansions[#self.expansions]
        self.expansions[i].expansion_index = i
        self.expansions[#self.expansions] = nil
        edge.expansion_index = nil
        self.expansions[other_edge.expansion_index] = self.expansions[#self.expansions]
        self.expansions[other_edge.expansion_index].expansion_index = other_edge.expansion_index
        self.expansions[#self.expansions] = nil
    end
    return node
end

World_node = {}
World_node.__index = World_node

function World_node.new(o)
    o = o or {}
    setmetatable(o, World_node)
    
    o.pos = o.pos or vector()
    o.importance = o.importance or 1
    o.edges = {}
    return o
end

function World_node:get_empty_edge(dir)
    for _,v in ipairs(self.edges) do
        if v.dir == dir and not v.b then
            return v
        end
    end
    return nil
end

function World_node:connect(edge)
    if edge.b then
        assert(false, "trying to connect already connected edge")
    end
    if edge.a == self then
        return nil
    end
    for i,v in ipairs(self.edges) do
        if v.dir == edge.dir:opposite() and not v.b then
            local old_edge = self.edges[i]
            self.edges[i] = edge
            edge.b = self
            return old_edge
        end
    end
    assert(false, "Failure in world generation, can't connect edge to node")
end

World_edge = {}
World_edge.__index = World_edge

function World_edge.new(node, dir, o)
    o = o or {}
    setmetatable(o, World_edge)
    o.a = node
    o.dir = Direction.new(dir)
    
    return o
end

