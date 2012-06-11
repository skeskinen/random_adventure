Road = {}
Road.__index = Road

function Road.new(name, dir, pos)
    local o = {}
    setmetatable(o, Road)

    local base = road_bases[name]

    o.name = base.name
    o.dir = dir:clone()
    o.expansion_points = deepcopy(base.expansion_points)
    for _,v in ipairs(o.expansion_points) do
        v.pos:rotate_inplace(dir:rad())
        v.pos = round_vector(v.pos)
        v.pos = v.pos + pos
        for i,w in ipairs(v.dirs) do
            v.dirs[i] = w + dir
        end
    end
    o.objects = deepcopy(base.objects)
    for _,v in ipairs(o.objects) do
        v.pos:rotate_inplace(dir:rad())
        v.pos = round_vector(v.pos)
        v.pos = v.pos + pos
        v.pos = v.pos - vector(v.w/2, v.h/2)
        v.rot = v.rot + dir
    end
    
    return o
end

road_bases = {}
function road_base(o)
    local new_r = {}
    road_bases[o.name] = new_r
    new_r.dir = Direction.new(o.dir)
    new_r.expansion_points = {}
    new_r.objects = {}

    for _,v in ipairs(o.pieces) do
        local piece = road_pieces[v[1]]
        local dir = Direction.new(v[2])
        for i,w in ipairs(piece.expansion_points) do
            local point = deepcopy(w)
            if i == 1 then
                point.piece_first = true
            end
            new_r.expansion_points[#new_r.expansion_points+1] = point
            point.pos:rotate_inplace((dir-piece.dir):rad())
            local pos = round_vector(point.pos) + vector(v[3],v[4])
            point.pos = pos
            for i,z in ipairs(point.dirs) do
                point.dirs[i] = Direction.new(z+(dir-piece.dir))
            end
        end
        for _,w in ipairs(piece.objects) do
            local object = deepcopy(w)
            new_r.objects[#new_r.objects+1] = object
            print(piece.name, dir-piece.dir)
            object.pos:rotate_inplace((dir-piece.dir):rad())
            local pos = round_vector(object.pos) + vector(v[3],v[4])
            object.pos = pos
            object.rot = dir-piece.dir
        end
    end
end

road_pieces = {}
function road_piece(o)
    local new_rp = {}
    road_pieces[o.name] = new_rp

    new_rp.name = o.name
    new_rp.dir = Direction.new(o.dir)
    new_rp.expansion_points = {}
    parse_expansion_points(new_rp.dir, new_rp.expansion_points, o.expansion_points)
    new_rp.objects = {}
    parse_objects(new_rp.objects, o.objects)
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

road_piece{
    name = 'crossroads',
    dir = DIR_UP,
    expansion_points = {
        {true, 0, -32, {DIR_DOWN,DIR_UP, DIR_LEFT, DIR_RIGHT}}, 
        {false, -32, -32, {DIR_RIGHT,DIR_LEFT}}, 
        {false, 32, -32, {DIR_LEFT,DIR_RIGHT}}, 
        {true, 0, -64, {DIR_DOWN,DIR_UP}}
    },
    objects = {{'crossroads', 0, -32, 64, 64}}
}

road_piece{
    name = 'straight',
    dir = DIR_UP,
    expansion_points = {
        {true, 0, -64, {DIR_DOWN,DIR_UP}}
    },
    objects = {{'straight', 0, -32, 64, 64}}
}

road_piece{
    name = 'turn',
    dir = DIR_UP,
    expansion_points = {
        {true, 0, -32, {DIR_DOWN,DIR_RIGHT}},
        {true, 32, -32, {DIR_LEFT, DIR_RIGHT}}
    },
    objects = {{'turn', 0, -32, 64, 64}}
}

road_piece{
    name = 'straight_to_diagonal',
    dir = DIR_UP,
    expansion_points = {
        {true, 0, -32, {DIR_DOWN,DIR_UP_RIGHT}},
        {true, 32, -64, {DIR_DOWN_LEFT, DIR_UP_RIGHT}}
    },
    objects = {{'straight_to_diagonal', 0, -64, 128,128}}
}

road_piece{
    name = 'diagonal',
    dir = DIR_UP_RIGHT,
    expansion_points = {
        {true, 64, -64, {DIR_DOWN_LEFT, DIR_UP_RIGHT}}
    },
    objects = {{'diagonal',32,-32,128,128}}
}

road_piece{
    name = 'diagonal_to_straight',
    dir = DIR_UP_RIGHT,
    expansion_points = {
        {true, 32, -32, {DIR_DOWN_LEFT, DIR_RIGHT}},
        {true, 64, -32, {DIR_LEFT, DIR_RIGHT}}
    },
    objects = {{'diagonal_to_straight',32,-32,128,128}}
}

road_base{
    name = 'basic',
    dir = DIR_UP,
    pieces = {
        {'turn', DIR_UP,0,0},
        {'straight_to_diagonal', DIR_RIGHT, 32,-32},
        {'diagonal', DIR_DOWN_RIGHT, 96, 0},
        {'diagonal_to_straight', DIR_DOWN_RIGHT, 160, 64},
        {'straight', DIR_DOWN, 192, 128},
        {'crossroads', DIR_DOWN, 192, 192}
    }
}


