

-- circular slider
local SliderC = class('Slider', Gui)


function SliderC:initialize(text, x, y)
	Gui.initialize(self, 'sliderC')
    self.text = text
	self.x = x
    self.y = y
	self.r = 50
	self.x1 = 0
	self.y1 = 0
	self.val = {self.x1, self.y1}
    self.bbox = {x = self.x+100-self.r, y = self.y+40, w = 2*self.r, h = 2*self.r}
    self.font = FONT.medium
    self.isSelected = false
end


function SliderC:draw()

	-- outer circle
	love.graphics.setColor(COL[8])
	love.graphics.circle('line', self.x+100, self.y+self.r+40, self.r)
	love.graphics.circle('fill', self.x+100, self.y+self.r+40, self.r)

	-- inner circle
	if self.isSelected or self.mouseOver then
		love.graphics.setColor(COL[10])
		love.graphics.circle('fill', self.x+100+self.x1, self.y+self.r+40+self.y1, 10+2)
		love.graphics.setColor(COL[8])
		love.graphics.circle('line', self.x+100+self.x1, self.y+self.r+40+self.y1, 10+2)
	else
		love.graphics.setColor(COL[10])
		love.graphics.circle('fill', self.x+100+self.x1, self.y+self.r+40+self.y1, 10)
		love.graphics.setColor(COL[8])
		love.graphics.circle('line', self.x+100+self.x1, self.y+self.r+40+self.y1, 10)
	end

	-- text
	love.graphics.setColor(COL[1])
	love.graphics.print(self.text, self.x, self.y)

end


function SliderC:update(dt)

	local mx, my = love.mouse.getPosition()

	if self.isSelected then
		self.x1 = mx - (self.x + 100)
		self.y1 = my - (self.y + self.r + 40)
		local r = math.sqrt(self.x1*self.x1 + self.y1*self.y1)
		if r > self.r then
			self.x1 = self.x1 * self.r / r
			self.y1 = self.y1 * self.r / r
		end
	end

	self.val = {self.x1/self.r, self.y1/self.r}
	debug.log['val'] = fmath.bool2int(self.isSelected)

end


function SliderC:mousepressed(x, y, key)
	if self.mouseOver then
		self.isSelected = true
		self:setLock()
	end
end


function SliderC:mousereleased(x, y, key)
	self.isSelected = false
	self:unsetLock()
end


function SliderC:send(val)
	self.val = val
	self.x1 = val[1]
	self.y1 = val[2]
end


return SliderC