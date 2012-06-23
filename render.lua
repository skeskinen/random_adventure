local pixel_effect
local canvas

local run_shader = true

local renderlist = {}
local buckets = 5

function render_obj(obj)
    local idx = obj.draw_pr or 1
    renderlist[idx][1 + #renderlist[idx]] = obj
end

function render_buckets()
    for i = 1, buckets do
        local list = renderlist[i]
        for j = 1,#list do
            local obj = list[j]
            local rot = 0
            if obj.rot then
                rot = obj.rot:rad()
            end
            love.graphics.draw(obj.img, obj.pos.x + obj.w/2, obj.pos.y + obj.h/2, rot, 1, 1, obj.w/2, obj.h/2)
        end
        renderlist[i] = {}
    end
end

function get_camera()
    local screen_size = vector(love.graphics.getWidth(),love.graphics.getHeight())
    return {
          pos = g.player.pos + 0.5*vector(g.player.w, g.player.h) - 0.5*screen_size
        , w = screen_size.x
        , h = screen_size.y
    }
end

function render()
    love.graphics.setColor(255, 255, 255)
    love.graphics.push()
    if pixel_effect then
        love.graphics.setPixelEffect()
        canvas:clear()
        love.graphics.setCanvas(canvas)
    end

    local screen = get_camera()

    love.graphics.translate((-screen.pos):unpack())

    g.obj_tree:query(screen, render_obj)

    render_buckets()

    love.graphics.pop()

    if pixel_effect then
		pixel_effect:send("t", game_time)
        love.graphics.setCanvas()
        love.graphics.setPixelEffect(pixel_effect)
        love.graphics.draw(canvas)
        love.graphics.setPixelEffect()
    end
end


function init_render()
    love.graphics.setBackgroundColor(50,200,50)
    for i=1,buckets do
        renderlist[i] = {}
    end

    if run_shader then
        local f = io.open("effect.gsl")
        if not f then return end
        pixel_effect = love.graphics.newPixelEffect(f:read("*a"))
        f:close()
        print(pixel_effect:getWarnings())
        canvas = love.graphics.newCanvas()
    end
end
