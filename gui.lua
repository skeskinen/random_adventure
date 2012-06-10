local panel
local messagelist

function init_gui()
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
--    panel = loveframes.Create("panel")
--    panel:SetSize(w-20, 140)
--    panel:SetPos(10, h - 150)

    loveframes.util.SetActiveSkin("BlueM")

    messagelist = loveframes.Create("list", panel)
    messagelist:SetPos(10, h - 150)
    messagelist:SetSize(w-20, 140)
    messagelist:SetDisplayType("vertical")
    messagelist:SetPadding(5)
    messagelist:SetSpacing(5)
    messagelist:SetAutoScroll(true)
end

function add_message(msg)
    local t = loveframes.Create("text")
    t:SetText(msg)
    messagelist:AddItem(t)
end
