Events = {}
Events.__index = Events

function Events.new(o)
    o = o or {}
    setmetatable(o, Events)
    o.non_urg_events = {}
    o.event_heap = Event_heap.new()
    return o
end

function Events:run_events()
    while self.event_heap:top() and self.event_heap:top().timer < game_time do
	local ev = self.event_heap:pop()
	if ev.urg then
	    event_handler(ev)
	else
	    self.non_urg_events[#self.non_urg_events+1] = ev
	end
    end

    function have_time()
	return true
    end
    while have_time() and #self.non_urg_events > 0 do
	event_handler(self.non_urg_events[#self.non_urg_events])
	self.non_urg_events[#self.non_urg_events] = nil
    end
end

function Events:add_event(ev, delay)
    if delay then
	ev.timer = game_time + delay
	self.event_heap:push(ev)
    else
	if ev.urg then
	    event_handler(ev)
	else
	    self.non_urg_events[#self.non_urg_events+1] = ev
	end
    end
end

Event_heap = {}
Event_heap.__index = Event_heap

function Event_heap.new(o)
    o = o or {}
    setmetatable(o, Event_heap)
    o.size = 0
    o.t = {}
    return o
end

function Event_heap:heapify(i)
    if i == 1 then
	return
    end
    local j = math.floor(i/2)
    if self.t[i].timer < self.t[j].timer then
	self.t[i], self.t[j] = self.t[j], self.t[i]
	self:heapify(j)
    end
end

function Event_heap:push_down(i)
    for p=0,1 do
	local j = i*2+p
	if self.size > j then
	    if self.t[i].timer > self.t[j].timer then
		self.t[i], self.t[j] = self.t[j], self.t[i]
		self:push_down(j)
	    end
	end
    end
end

function Event_heap:push(arg)
    self.size = self.size + 1
    self.t[self.size] = arg
    self:heapify(self.size)
end

function Event_heap:top()
    if self.size > 0 then
	return self.t[1]
    end
    return nil
end

function Event_heap:pop()
    if self.size > 0 then
	local tmp = self.t[1]
	self.t[1] = self.t[self.size]
	self.size = self.size - 1
	self:push_down(1)
	return tmp
    end
    return nil
end

