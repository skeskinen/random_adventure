Events = {}
Events.__index = Events

function Events.new(o)
    o = o or {}
    setmetatable(o, Events)
    o.next_non_urg_events = {}
    o.cur_non_urg_events = {}
    o.urg_events = {}
    o.event_heap = Event_heap.new()
    return o
end

function Events:run_events()
    while self.event_heap:top() and self.event_heap:top().timer < game_time do
        local ev = self.event_heap:pop()
        if ev.urg then
            event_handler(ev)
        else
            self.next_non_urg_events[#self.next_non_urg_events+1] = ev
        end
    end

    local cur_urg_events = self.urg_events
    self.urg_events = {}
    for i,v in ipairs(cur_urg_events) do
        event_handler(v)
    end
    cur_urg_events = nil

    function have_time()
        return true
    end
    for i=1,#self.next_non_urg_events do
        self.cur_non_urg_events[#self.cur_non_urg_events+1] = self.next_non_urg_events[i]
    end
    self.next_non_urg_events = {}
    if have_time() then
        while have_time() and #self.cur_non_urg_events > 0 do
            event_handler(self.cur_non_urg_events[#self.cur_non_urg_events])
            self.cur_non_urg_events[#self.cur_non_urg_events] = nil
        end
    end
end

function Events:add_event(ev, delay)
    if delay then
        ev.timer = game_time + delay
        return self.event_heap:push(ev)
    else
        if ev.urg then
            self.urg_events[#self.urg_events+1] = ev
        else
            self.next_non_urg_events[#self.next_non_urg_events+1] = ev
        end
    end
end

function Events:interrupt_event(handle)
    self.event_heap:remove(handle)
end

Event_heap = {}
Event_heap.__index = Event_heap

function Event_heap.new(o)
    o = o or {}
    setmetatable(o, Event_heap)
    o.size = 0
    o.heap = {}
    o.values = {}
    o.free_indexes = {}
    return o
end

function Event_heap:value(i)
    return self.values[self.heap[i]].v
end

function Event_heap:heapify(i)
    if i == 1 then
        return
    end
    local j = math.floor(i/2)
    if self:value(i).timer < self:value(j).timer then
        self:swap(i,j)
        self:heapify(j)
    end
end

function Event_heap:push_down(i)
    for p=0,1 do
        local j = i*2+p
        if self.size > j then
            if self:value(i).timer > self:value(j).timer then
                self:swap(i,j)
                self:push_down(j)
            end
        end
    end
end

function Event_heap:push(arg)
    self.size = self.size + 1
    local index = self.size
    if #self.free_indexes > 0 then
        index = self.free_indexes[#self.free_indexes]
        self.free_indexes[#self.free_indexes] = nil
    end
    self.values[index] = {i = self.size, v = arg}
    self.heap[self.size] = index
    self:heapify(self.size)
    return index
end

function Event_heap:top()
    if self.size > 0 then
        return self:value(1)
    end
    return nil
end

function Event_heap:remove(handle)
    if handle and self.size > 0 and self.values[handle] then
        local tmp = self.values[handle].v
        self:swap(self.values[handle].i, self.size)
        self.heap[self.size] = nil
        self.values[handle] = nil
        self.free_indexes[#self.free_indexes+1] = handle
        self.size = self.size - 1
        self:push_down(1)
        return tmp
    end
    return nil
end

function Event_heap:swap(a,b)
    self.values[self.heap[a]].i = b
    self.values[self.heap[b]].i = a
    self.heap[a], self.heap[b] = self.heap[b], self.heap[a]
end

function Event_heap:pop()
    return self:remove(self.heap[1])
end

