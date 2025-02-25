menubutton = class:new()

function menubutton:init(x, y, text, func)
	self.x = x
	self.y = y
	self.text = text
	self.func = func
	self.value = 0
	self.active = true
	self.hidden = false
	
	self.xmargin = 20
	self.textyplus = -5
	
	self.height = menufont:getHeight()
	self.width = menufont:getWidth( self.text )-3
end

function menubutton:update(dt)
	local x, y = mymousegetPosition()
	y = y - menuoffset
	x = x - menuoffsetx
	if self:gethighlight(x, y) then
		self.value = self.value + ((1-self.value)*4*dt+0.01*dt)
		if self.value > 1 then
			self.value = 1
		end
	else
		self.value = self.value - (self.value*4*dt+0.1*dt)
		if self.value < 0 then
			self.value = 0
		end
	end
end

function menubutton:draw()
	--get foreground color
	local r, g, b = 190/255, 206/255, 248/255
	local tr, tg, tb = unpack(getrainbowcolor(math.mod(rainbowi+.5, 1)))
	
	r = r + (tr-r)*(self.value*.7+.3)
	g = g + (tg-g)*(self.value*.7+.3)
	b = b + (tb-b)*(self.value*.7+.3)
	
	love.graphics.setFont(menufont)
	
	mygraphicssetScissor(self.x-self.width/2-self.xmargin+menuoffsetx, self.y-self.height/2+menuoffset, (self.width+self.xmargin*2)*self.value, self.height)
	love.graphics.setColor(r, g, b, fadecolor)
	love.graphics.rectangle("fill", self.x-self.width/2-self.xmargin, self.y-self.height/2, (self.width+self.xmargin*2)*self.value, self.height)
	love.graphics.setColor(0, 0, 0, fadecolor)
	love.graphics.print(self.text, self.x-self.width/2, self.y-self.height/2+self.textyplus)
	
	mygraphicssetScissor(self.x-self.width/2-self.xmargin+(self.width+self.xmargin*2)*self.value+menuoffsetx, self.y-self.height/2+menuoffset, self.width+self.xmargin*2, self.height)
	love.graphics.setColor(r, g, b, fadecolor)
	love.graphics.print(self.text, self.x-self.width/2, self.y-self.height/2+self.textyplus)
	
	mygraphicssetScissor()
end

function menubutton:mousepressed(x, y, button)
	if self.active and button == lbutton then
		if self:gethighlight(x, y) then
			self:func()
			return true
		end
	end
end

function menubutton:gethighlight(x, y)
	if x >= self.x-self.width/2-self.xmargin-10 and x < self.x+self.width/2+self.xmargin+10 and
	y >= self.y-self.height/2-10 and y < self.y+self.height/2+10 then
		return true
	end
	return false
end
