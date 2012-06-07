Road = {}
Road.__index = Road

function Road.new(name, dir, pos)
    local o = {}
    setmetatable(o, Road)

    local base = Roads[name]

    o.name = base.name
    o.dir = dir:clone()
    o.expansion_points = deepcopy(base.expansion_points)
    for _,v in ipairs(o.expansion_points) do
        v.pos:rotate_inplace(dir:rad())
        v.pos = v.pos + pos
        for i,w in ipairs(v.dirs) do
            v.dirs[i] = w + dir
        end
        v.pos.x = round(v.pos.x)
        v.pos.y = round(v.pos.y)
    end
    o.objects = deepcopy(base.objects)
    for _,v in ipairs(o.objects) do
        v.pos:rotate_inplace(dir:rad())
        v.pos = v.pos + pos
        v.pos.x = round(v.pos.x)
        v.pos.y = round(v.pos.y)
        v.pos = v.pos - vector(v.w/2, v.h/2)
        v.rot = dir:clone()
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
        t_target[i] = {}
        t_target[i].name = 'road_piece_' .. v[1]
        t_target[i].pos = vector(v[2], v[3])
        t_target[i].w = v[4]
        t_target[i].h = v[5]
    end
end

roads{
    name = 'basic',
    dir = DIR_UP,
    expansion_points = {
        {true, 0, -96, {DIR_DOWN,DIR_UP, DIR_LEFT, DIR_RIGHT}}, {false, -32, -96, {DIR_RIGHT,DIR_LEFT}}, {false, 32, -96, {DIR_LEFT,DIR_RIGHT}}, 
        {true, 0, -192, {DIR_DOWN,DIR_UP}}
    },
    objects = {{'straight',0, -32, 64, 64},{'crossroad', 0, -96, 64, 64}, {'straight', 0, -160, 64, 64}},
    importance = 2
}
