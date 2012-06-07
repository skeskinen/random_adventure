
function render_obj(obj)
    love.graphics.draw(obj.img, obj.pos.x, obj.pos.y)
end

function render()
    local screen_size = vector(love.graphics.getWidth(),love.graphics.getHeight())
    local screen = {
          pos = g.player.pos + 0.5*vector(g.player.w, g.player.h) - 0.5*screen_size
        , w = screen_size.x
        , h = screen_size.y
    }

    love.graphics.translate((-screen.pos):unpack())

    g.obj_tree:query(screen, render_obj)
end
