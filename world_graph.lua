World_graph = {}
World_graph.__index = World_graph

function World_graph.new(o)
    o = o or {}
    setmetatable(o, World_graph)
    o.places = {}
    o.expansions = {}

    o.places['center'] = World_node.new(o)
    o.places['center'].set_edges(Direction.UP, Direction.RIGHT, Direction.DOWN, Direction.LEFT)
    return o
end

function World_graph.new_edges(node, ...)
    for i,v in ipairs(arg) do
        local new_edge = World_edge.new(node, v)
        node.edges[#node.edges+1] = new_edge
        self.expansions[#self.expansions+1] = new_edge
    end
end

World_node = {}
World_node.__index = World_node

function World_node.new(graph, o)
    o = o or {}
    setmetatable(o, World_node)
    
    o.graph = graph
    o.x = o.x or 0
    o.y = o.y or 0
    o.edges = o.edges or {}
    return o
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

