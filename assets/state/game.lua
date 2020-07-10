
local game = {}


function game:load()

    -- initialize ball
    bubbles = {}
    addBubble(10)

    -- create button
    b_reset = Button:new('Clear', 690, 500)
    b_reset.click = function() bubbles = {} end
    -- create slider
    s_speed = Slider:new('Speed', 650, 50, 200, 0, 4)
    s_speed:send(1)
    -- create checkbox
    o_fill = Checkbox:new('fill', 650, 250)
    -- create dropdown
    d_color = Dropdown:new(650, 150, {'blue', 'green', 'red'})

end


function game:update(dt)

    -- move
    for i,b in ipairs(bubbles) do 
        b.x = b.x + dt * b.u * s_speed.val
        b.y = b.y + dt * b.v * s_speed.val
    end
    
    -- wall collision
    for i,b in ipairs(bubbles) do 
        if b.x - b.r < 0 and b.u < 0 then b.u = -b.u end
        if b.x + b.r > 600 and b.u > 0 then b.u = -b.u end
        if b.y - b.r < 0 and b.v < 0 then b.v = - b.v end
        if b.y + b.r > 600 and b.v > 0 then b.v = -b.v end
    end

    -- bubble collision
    for i = 1,#bubbles do 
        for j = (i+1),#bubbles do
            collision(bubbles[i], bubbles[j])
        end
    end

    debug.log['bubbles'] = #bubbles
    
end


function game:draw()

    -- draw ball
    love.graphics.setColor(COL[d_color.val])
    for i,b in ipairs(bubbles) do 
        love.graphics.circle('line', b.x, b.y, b.r)
    end
    if o_fill.val then 
        for i,b in ipairs(bubbles) do 
            love.graphics.circle('fill', b.x, b.y, b.r)
        end
    end

    -- draw gui pannel
    love.graphics.setColor(COL[10])
    love.graphics.rectangle('fill', 600, 0, 300, 600)

end


function game:mousepressed(x, y, key)
    
    -- add bubble
    if fmath.pointInRect(x, y, {x=0, y=0, w=600, h=600}) then
        local theta = 2*math.pi*math.random()
        local speed = 300 * math.random()
        local b = {}
        b.x = x
        b.y = y
        b.u = speed * math.sin(theta)
        b.v = speed * math.cos(theta)
        b.r = 40
        table.insert(bubbles, b)
    end
    
    
end


-- add bubble
function addBubble(n)
    for i = 1,n do
        local theta = 2*math.pi*math.random()
        local speed = 300 * math.random()
        local b = {}
        b.x = 600 * math.random()
        b.y = 600 * math.random()
        b.u = speed * math.sin(theta)
        b.v = speed * math.cos(theta)
        b.r = 40
        table.insert(bubbles, b)
    end
end


-- bubble collision
function collision(b1, b2)

    local x = b1.x - b2.x
    local y = b1.y - b2.y
    local r = math.sqrt(x*x + y*y)
    
    if r  > b1.r + b2.r then
        return
    end

    local nx = x / r
    local ny = y / r
    local per1 = b1.u * nx + b1.v * ny
    local per2 = b2.u * nx + b2.v * ny

    if per1 > 0 and per2 < 0 then
        return
    end

    local tan1 = b1.u * ny - b1.v * nx
    local tan2 = b2.u * ny - b2.v * nx
    b1.u = per2 * nx + tan1 * ny
    b1.v = per2 * ny - tan1 * nx
    b2.u = per1 * nx + tan2 * ny
    b2.v = per1 * ny - tan2 * nx

end


return game