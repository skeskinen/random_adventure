discussion = {}
discussion.list = {}

function discussion.add(n, d)
    local list = discussion.list[n]
    if not list then 
        list = {}
        discussion.list[n] = list 
    end
    
    list[#list+1] = d
end

function discussion.start(obj)
    local d = discussion.list[obj.name]
    if d then
        local disc = d[math.random(#d)]
        pause_player(obj)
        disc(obj)
    end
end

local add = discussion.add

local function end_d(obj)
    resume_player(obj)
end

local function make(d)
    return function(obj)
        gui.add_message(obj.name .. ": " .. d.text)        
        if d.answers then 
            local answers = {}
            for i = 1, #d.answers do
                if not d.answers[i][3] or d.answers[i][3](obj) then
                    answers[#answers+1] = {d.answers[i][1], i}
                end
            end
            local function callback(i)
                d.answers[i][2](obj)
            end
            gui.answer_buttons(answers, callback)
        else
            end_d(obj)
        end
    end
end

local function conditional(bool, disc1, disc2)
    return function(obj)
        if bool(obj) then
            disc1(obj)
        else
            disc2(obj)
        end
    end
end

local function lift(f, disc)
    return function(obj)
        f(obj)
        disc(obj)
    end
end

local function check_shovel(obj)
    return not (not obj.shovel)
end

local bob_s4 = lift(function(obj) obj.shovel = false g.inventory:add_item("shovel") end, make { text = "There you go."})

local bob_s3 = make {
      text = "No, I don't because you took it. *sadface*"
    , answers = {
        {"Right.", end_d}
    }
}

local bob_s2 = make {
       text = "Yes, I do have a shovel."
     , answers = {
           {"Give it to me! Now!", bob_s4}
        ,  {"Ok, cool.", end_d}
     }
}

local bob_s1 = conditional(check_shovel, bob_s2, bob_s3)

local bob3 = make {
      text = "Fuck you too."
}

local bob2 = make {
      text = "Good luck adventuring!"
}

local bobi = lift(function(obj) obj.i = true end, make { text = "Now I'm very angry!" })

local bob1 = make {
      text = "Hello, I'm Bob!"
    , answers = {
        {"Hello.", bob2},
        {"Do you have a shovel?", bob_s1},
        {"One-time insult.", bobi, function(obj) return not obj.i end},
        {"Fuck off!", bob3},
    }
}

add("Bob", bob1)

