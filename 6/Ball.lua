Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
   --math.random returns 2 or 1. this is used to decide the starting direction of the ball
   --and & or used to make a pseudo-ternary operator
   self.dx = math.random(2) == 1 and -100 or 100
   self.dy = math.random (-50, 50)
end

function Ball:update(dt)
    --update the position of the ball based on the current velocity for each axis
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Ball:render()
    --renders the ball with a call to the rectangle() function
    --pretty much the same line of code that you'd find in the paddle class
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end

function Ball:reset()
    --uses the same code found in the init function
    --resets the ball to the center of the screen
   self.x = VIRTUAL_WIDTH / 2 - 2
   self.y = VIRTUAL_HEIGHT / 2 - 2
   --picks a new starting momentum for the ball
   self.dx = math.random(2) == 1 and -100 or 100
   self.dy = math.random (-50, 50)
end