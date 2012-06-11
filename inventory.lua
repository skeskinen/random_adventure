require 'callback'

Inventory = {}
Inventory.__index = Inventory

function Inventory.new()
    local o = {}
    o.items = {}
    o.add_callback = Callback.new()
    o.remove_callback = Callback.new()

    setmetatable(o, Inventory)
    return o
end

function Inventory:add_item(i, count)
    assert(item_list[i], "adding bad item type \"" .. i .. "\"")
    count = count or 1
    self.items[i] = self:get_item(i) + count
    self.add_callback:call(i, count)
end

function Inventory:get_item(i)
    return self.items[i] or 0
end

function Inventory:get_items()
    return self.items
end

function Inventory:remove_item(i, count)
    assert(item_list[i], "removing bad item type \"" .. i .. "\"")
    count = count or 1
    if self:get_item(i) < count then return false end
    if self:get_item(i) == count then 
        self.items[i] = nil
    else
        self.items[i] = self.items[i] - count
    end

    self.remove_callback:call(i, count)

    return true
end

item_list = {}

local function add_item(props)
    assert(item_list[props.id] == nil, "overlapping item ids: " .. props.id)
    item_list[props.id] = props
end

add_item{id = "shovel", name = "shovel", description = "A not-so-badly rusted shovel perfect for shoveling!"}
add_item{id = "compass" , name = "compass", description = "A nice compass for navigating."}


local function inflect(n, count)
    if count > 1 then
        if string.sub(n, string.len(n)) == "s" then
            return n .. "es"
        else
            return n .. "s"
        end
    end
    return n
end

function Inventory.new_main()
    local o = Inventory.new()
    o.add_callback:add(o, function(i, count)
            local n = inflect(item_list[i].name, count)
            if count == 1 then count = "a" end
            gui.add_message("Got " .. count .. " " .. n .. ".")
        end)

    o.remove_callback:add(o, function(i, count)
            local n = inflect(item_list[i].name, count)
            if count == 1 then count = "a" end
            gui.add_message("Lost " .. count .. " " .. n .. ".")
        end)
    return o
end
