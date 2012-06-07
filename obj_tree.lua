Obj_tree = {}
Obj_tree.__index = Obj_tree

local BUCKET_SIZE = 30
local MIN_SIZE = 256

local CHILD_COORDINATES = {{0,0}, {0.5, 0}, {0,0.5}, {0.5, 0.5}}

function Obj_tree.new(o)
    o = o or {}
    if o.root then
        o.s = WORLD_SIZE o.h = WORLD_SIZE o.w = WORLD_SIZE o.pos = vector(-o.s/2,-o.s/2)
    end
    setmetatable(o, Obj_tree)
    o.bucket = {}
    o.bucket_s = 0
    return o
end

function Obj_tree:query(o, f)
    if overlap(self, o) then
        if self.children then
            for i=1,4 do
                if self.children[i]:query(o, f) then
                    return true
                end
            end
        else
            for _,v in pairs(self.bucket) do
                if overlap(o, v) and f(v) then
                    return true
                end
            end
        end
    end
end

function Obj_tree:insert(o)
    if overlap(self, o) then
        self.bucket_s = self.bucket_s + 1
        if self.children then
            for i=1,4 do
                self.children[i]:insert(o) 
            end
        else
            self.bucket[o.id] = o
            self:check_size()
        end
    end
end

function Obj_tree:remove(o)
    if overlap(self, o) then
        self.bucket_s = self.bucket_s - 1
        if self.children then
            local require_check = false
            for i=1,4 do
                require_check = self.children[i]:remove(o) or require_check
            end
            if require_check then
                self:check_size()
                return true
            end
        else
            self.bucket[o.id] = nil
            return true
        end
    end
    return false
end

function Obj_tree:divide()
    if not self.children and self.s > MIN_SIZE then
        self.children = {}
        for i=1,4 do
            self.children[i] = Obj_tree.new{s = self.s/2, w = self.s/2, h = self.s/2,  
                pos = self.pos + self.s * vector(CHILD_COORDINATES[i][1], CHILD_COORDINATES[i][2])}
        end
        self.bucket_s = 0
        for _,v in pairs(self.bucket) do
            self:insert(v)
        end
        self.bucket = nil
    end
end

function Obj_tree:combine()
    self.bucket = {} 
    for c=1,4 do
        for i,v in pairs(self.children[c].bucket) do
            self.bucket[i] = v
        end
    end
    self.children = nil
end

function Obj_tree:check_size()
    if self.bucket_s > BUCKET_SIZE then
        self:divide()
    elseif self.children and self.bucket_s < BUCKET_SIZE/2 then
        self:combine()
    end
end

