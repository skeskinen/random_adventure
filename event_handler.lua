function event_handler(ev)
    if ev.type == 'function' then
	ev.f()
    end

    if ev.type == 'new_object' then
        local object = Object.new(ev.o)
        g.object_tree.insert(object)
    end
end

