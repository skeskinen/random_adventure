Road = {}
Road.__index = Road

function Road.new(name, dir, pos)
    o = {}
    setmetatable(o, Road)

    local base = Roads[name]

    o.name = base.name
    o.dir = base.dir:clone()
    o.expansion_points = deepcopy(base.expansion_points)
    for _,v in ipairs(o.expansion_points) do
        v.pos = v.pos + pos
    end
    o.objects = deepcopy(base.objects)
    for _,v in ipairs(o.objects) do
        v.pos = v.pos + pos
    end
    o.importance = base.importance
    return o
end

Roads = {}
function roads(o)
    local new_road = {}
    Roads[o.name] = new_road

    new_road.name = o.name
    new_road.dir = Direction.new(o.dir)
    new_road.expansion_points = {}
    parse_expansion_points(new_road.dir, new_road.expansion_points, o.expansion_points)
    new_road.objects = {}
    parse_objects(new_road.objects, o.objects)
    new_road.importance = o.importance
end

function parse_expansion_points(dir, t_target, t_arg)
    t_target[1] = {main = true, pos = vector(0,0), dirs = {dir:opposite(), dir}}
    for _,v in ipairs(t_arg) do
        local new_point = {}
        t_target[#t_target+1] = new_point
        new_point.main = v[1]
        new_point.pos = vector(v[2],v[3])
        new_point.dirs = {}
        for _,w in ipairs(v[4]) do
            new_point.dirs[#new_point.dirs+1] = Direction.new(w)
        end
    end
end

function parse_objects(t_target, t_arg)
    for i,v in ipairs(t_arg) do
        t_target = {}
        t_target.name = 'road_piece_' .. v[1]
        t_target.pos = vector(v[2], v[3])
    end
end

roads{
    name = 'basic',
    dir = 'up',
    expansion_points = {
        {true, 0, -160, {'down','up', 'left', 'right'}}, {false, -32, -160, {'right','left'}}, {false, 32, -160, {'left','right'}}, 
        {true, 0, -192, {'down','up'}}
    },
    objects = {{'straight',-32, -64},{'crossroads', -32, -128}, {'straight', -32, -192}},
    importance = 2
}
