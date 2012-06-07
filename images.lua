local images = {}

function get_image_raw(name)
	if not images[name] then
		local img = love.graphics.newImage("images/" .. name)
		img:setFilter("nearest", "nearest")
		images[name] = img
	end
	return images[name]
end

function get_image(name)
	return {get_image_raw(name), name}
end
