function overlap(a, b)
    return a.pos.x < b.pos.x + b.w and b.pos.x < a.pos.x + a.w and a.pos.y < b.pos.y + b.h and b.pos.y < a.pos.y + a.h
end

function deepcopy(object)
    local lookup_table = {}
    local function _copy(object)
        if type(object) ~= "table" then
            return object
        elseif lookup_table[object] then
            return lookup_table[object]
        end
        local new_table = {}
        lookup_table[object] = new_table
        for index, value in pairs(object) do
            new_table[_copy(index)] = _copy(value)
        end
        return setmetatable(new_table, getmetatable(object))
    end
    return _copy(object)
end

function round(num)
    return math.floor(num+0.5)
end

function round_vector(v)
    return vector(round(v.x), round(v.y))
end

