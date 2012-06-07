function new_random_road()
--    local expansion_i = math.random(#g.world_graph.expansions)
    local expansion_i
    for i,v in ipairs(g.world_graph.expansions) do
        if v.dir == Direction.new('up') then
            expansion_i = i
        end
    end
    local expansion = g.world_graph.expansions[expansion_i]
    local road = Road.new('basic', Direction.new(Direction.UP), expansion.a.pos)
    apply_road(road, expansion.a) 
end

function apply_road(road, cur_node)
    for _,v in ipairs(road.expansion_points) do
        local edge = cur_node:get_empty_edge(v.dirs[1]:opposite())
        local new_node = g.world_graph:expand(edge, v)
        if v.main then
            cur_node = new_node
        end
    end
end
