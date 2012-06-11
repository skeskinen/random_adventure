local gamepanel
local message_list
local answer_list

local inventorypop

gui = {}

local function toggle_inventory()
    if gui.inventory_frame then
        gui.inventory_frame:Remove()
        gui.inventory_frame:OnClose()
    else
        gui.make_inventory_frame()
    end
end

function gui.init()
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    gamepanel = loveframes.Create("panel")
    gamepanel:SetSize(w, h)
    gamepanel:SetPos(0, 0)
    gamepanel.MousePressed = mousepressed

    loveframes.util.SetActiveSkin("BlueM")

    message_list = loveframes.Create("list")
    message_list:SetPos(10, h - 150)
    message_list:SetSize(w-20, 140)
    message_list:SetDisplayType("vertical")
    message_list:SetPadding(5)
    message_list:SetSpacing(5)
    message_list:SetAutoScroll(true)

    inventory_pop = loveframes.Create("button")
    inventory_pop:SetText("inventory")
    inventory_pop:SetPos(w - inventory_pop:GetWidth(), 0)
    inventory_pop.OnClick = toggle_inventory
end

function gui.add_message(msg)
    local t = loveframes.Create("text")
    t:SetText(msg)
    message_list:AddItem(t)
end

local function answer_done(button)
    local i = button.button_num
    local callback = button.callback
    answer_list:Remove() 
    callback(i)
end

function gui.answer_buttons(choices, callback)
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    answer_list = loveframes.Create("list")
    answer_list:SetPos(50, 200)
    answer_list:SetSize(w-200, 200)
    answer_list:SetDisplayType("vertical")    
    answer_list:SetPadding(5)
    answer_list:SetSpacing(5)

    for i, v in ipairs(choices) do
        local b = loveframes.Create("button")
        b:SetText(v[1])
        b.button_num = v[2]
        b.callback = callback
        b.OnClick = answer_done
        answer_list:AddItem(b)
    end
end

function gui.make_inventory_frame()
    gui.inventory_frame = loveframes.Create("frame")
    local inventory_frame = gui.inventory_frame
    inventory_frame:SetName("Items")
    local size_w, size_h = 200, 200
    inventory_frame:SetSize(size_w, size_h)
    inventory_frame:SetPos(0, 200)

    inventory_frame.OnClose = function() 
        g.inventory.add_callback:remove(gui.inventory_frame)
        g.inventory.remove_callback:remove(gui.inventory_frame)

        gui.inventory_list = nil
        gui.inventory_frame = nil
    end

    gui.inventory_list = loveframes.Create("list", inventory_frame)
    local inventory_list = gui.inventory_list

    inventory_list:SetPos(5, 30)
    inventory_list:SetSize(size_w - 10, size_h - 30 - 10)
    inventory_list:SetDisplayType("vertical")
    inventory_list:SetPadding(5)
    inventory_list:SetSpacing(5)

    local function reload() 
        for _, v in pairs(inventory_list.children) do
            v:Remove()
        end
        inventory_list.children = {}

        for i, count in pairs(g.inventory:get_items()) do
            local item = item_list[i]
            local t = loveframes.Create("text")
            t:SetText(item.name)
            inventory_list:AddItem(t)

            local tt = loveframes.Create("tooltip")
            tt:SetObject(t)
            tt:SetPadding(10)
            tt:SetText(item.description)
        end
    end

    g.inventory.add_callback:add(inventory_frame, reload)
    g.inventory.remove_callback:add(inventory_frame, reload)

    reload()
end
