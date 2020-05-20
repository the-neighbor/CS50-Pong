Paddle = Class{}

function Paddle:init(x, y, width, height)
    --instantiates a Paddle using the arguments for position and size
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.dy = 0
end

function Paddle:update(dt)
    --updates the y position of the paddle with clamping to prevent going offscreen
    if self.dy < 0 then
        self.y = math.max(self.y + self.dy * dt, 0)
    elseif self.dy > 0 then
        self.y = math.min(self.y + self.dy * dt, VIRTUAL_HEIGHT - 20)
    end
end

function Paddle:render()
    --draws paddle
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end