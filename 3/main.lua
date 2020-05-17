WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

push = require 'push'

function love.load()
   --[[
      1. set the default scaling filter to nearest neighbor
      2. load our ttf to create a font object
      3. use push library to set up our virtual raster and window
   --]]
   love.graphics.setDefaultFilter('nearest', 'nearest')
   smallFont = love.graphics.newFont('font.ttf', 8)
   largeFont = love.graphics.newFont('font.ttf', 32)
   --initialize variables to track the score of each player
   player1Score = 0
   player2Score = 0
   --initialize variables to track where each paddle is on screen.
   --only y value changes for each paddle
   player1Y = 30
   player2Y = VIRTUAL_HEIGHT - 40
   --set up virtual resolution and window using push library call
   push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
      fullscreen = false,
      vsync = true,
      resizable = false
   })
end

function love.keypressed(key)
   --called every time a key is pressed, passing in that key as a parameter
   if key == 'escape' then
      --if the escape key was pressed, then quit the program using love.event.quit()
      love.event.quit()
   end
end

function love.update(dt)
   --called every frame. dt is "delta", the change in time since the last call/frame

   --controls to move the paddle for player 1
   if love.keyboard.isDown('w') then
      player1Y = player1Y - PADDLE_SPEED * dt
   elseif love.keyboard.isDown('s') then
      player1Y = player1Y +  PADDLE_SPEED * dt
   end

   --controls to move the paddle for player 2
   if love.keyboard.isDown('up') then
      player2Y = player2Y - PADDLE_SPEED * dt
   elseif love.keyboard.isDown('down') then
      player2Y = player2Y +  PADDLE_SPEED * dt
   end
end

function love.draw()
   --[[
      1. clear screen with love.graphics.clear()
      2. draw the text we need with love.graphics.printf()
      3. draw the paddles with love.graphics.rectangle()
      --]]
   --start rendering with virtual resolution
   push:apply('start')
   --clear the raster/framebuffer with a single color
   love.graphics.clear(40/255,45/255,52/255,255/255)
   --draw ball
   love.graphics.rectangle('fill', VIRTUAL_WIDTH/2 - 2 , VIRTUAL_HEIGHT/2 - 2, 5, 5)
   --draw paddles
   love.graphics.rectangle('fill', 5, player1Y, 5, 20)
   love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)
   --draw text
   love.graphics.setFont(smallFont)
   love.graphics.printf("Hello Pong!", 0, 20, VIRTUAL_WIDTH, 'center')

   love.graphics.setFont(largeFont)
   love.graphics.print(player1Score, VIRTUAL_WIDTH/2 - 50, VIRTUAL_HEIGHT / 3)
   love.graphics.print(player2Score, VIRTUAL_WIDTH/2 + 30, VIRTUAL_HEIGHT / 3)
   --end call to virtual resolution library
   push:apply('end')
end