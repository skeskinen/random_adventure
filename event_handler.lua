EV_FUNC = 1
EV_METHOD = 2
EV_NEW_OBJECT = 3

local handlers = {}

handlers[EV_FUNC] = function(ev) ev.f() end
handlers[EV_METHOD] = function(ev) ev.f(ev.o) end
handlers[EV_NEW_OBJECT] = function(ev) g.obj_tree:insert(ev.o) end

function event_handler(ev)
    assert(handlers[ev.type] ~= nil, "Handler type: " .. tostring(ev.type))
    handlers[ev.type](ev)
end
