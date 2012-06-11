local gamepanel
local messagelist
local answerlist

gui = {}

function gui.init()
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()
    gamepanel = loveframes.Create("panel")
    gamepanel:SetSize(w, h)
    gamepanel:SetPos(0, 0)
    gamepanel.MousePressed = mousepressed

    loveframes.util.SetActiveSkin("BlueM")

    messagelist = loveframes.Create("list")
    messagelist:SetPos(10, h - 150)
    messagelist:SetSize(w-20, 140)
    messagelist:SetDisplayType("vertical")
    messagelist:SetPadding(5)
    messagelist:SetSpacing(5)
    messagelist:SetAutoScroll(true)
end

function gui.add_message(msg)
    local t = loveframes.Create("text")
    t:SetText(msg)
    messagelist:AddItem(t)
end

local function answer_done(button)
    local i = button.button_num
    get_answer(i)
    answerlist:Remove() 
end

function gui.answer_buttons(choices)
    local w = love.graphics.getWidth()
    local h = love.graphics.getHeight()

    answerlist = loveframes.Create("list")
    answerlist:SetPos(50, 200)
    answerlist:SetSize(w-200, 100)
    answerlist:SetDisplayType("vertical")    
    answerlist:SetPadding(5)
    answerlist:SetSpacing(5)

    for i, v in ipairs(choices) do
        local b = loveframes.Create("button")
        b:SetText(v)
        b.button_num = i
        b.OnClick = answer_done
        answerlist:AddItem(b)
    end
end

function gui.answer_done()

end
