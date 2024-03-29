function new_random_road()
    local expansion_i = math.random(#g.world_graph.expansions)
    local expansion = g.world_graph.expansions[expansion_i]
    local road = Road.new('basic', expansion.dir, expansion.a.pos)
    apply_road(road, expansion.a) 
end

function apply_road(road, cur_node)
    for _,v in ipairs(road.expansion_points) do
        local edge = cur_node:get_empty_edge(v.dirs[1]:opposite())
        local new_node
        if v.piece_first then
           new_node = g.world_graph:new_node(v)
        else
            new_node = g.world_graph:expand(edge, v)
        end
        if v.main then
            cur_node = new_node
        end
    end

    for _,v in ipairs(road.objects) do
        v.img = get_image_raw(v.name .. '.png') 
       g.events:add_event{urg = true, type = EV_NEW_OBJECT, o = Object.new(v)} 
    end 
end
