WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

Class = require 'class' --import Class library
push = require 'push' --import push library

require 'Ball' --import Ball class
require 'Paddle' --import Paddle class

function startState()
   --brings the game back to a start state
   ball:reset()
   gameState = 'start'
   message = 'Hello Start State!'
end

function playState()
   --brings the game to a play state
   gameState = 'play'
   message = 'Hello Play State!'
end

function love.load()
   --[[
      1. set the default scaling filter to nearest neighbor
      2. load our ttf to create a font object
      3. use push library to set up our virtual raster and window
   --]]
   --seed RNG with the current epoch time which will be unique each time the game is run
   math.randomseed(os.time())

   love.graphics.setDefaultFilter('nearest', 'nearest')
   smallFont = love.graphics.newFont('font.ttf', 8)
   largeFont = love.graphics.newFont('font.ttf', 32)
   --initialize variables to track the score of each player
   player1Score = 0
   player2Score = 0
   --instantiate ball and paddles
   paddle1 = Paddle(5, 20, 5, 20)
   paddle2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)
   ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 5, 5)
   startState()
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
   elseif key == 'enter' or key == 'return' then
      if gameState == 'start' then
         playState()
      elseif gameState == 'play' then
         startState()
      end
   end
end

function love.update(dt)
   --called every frame. dt is "delta", the change in time since the last call/frame
   --controls to move the paddle for player 1
   if love.keyboard.isDown('w') then
      paddle1.dy = -PADDLE_SPEED
   elseif love.keyboard.isDown('s') then
      paddle1.dy = PADDLE_SPEED
   end

   --controls to move the paddle for player 2
   if love.keyboard.isDown('up') then
      paddle2.dy = -PADDLE_SPEED
   elseif love.keyboard.isDown('down') then
      paddle2.dy = PADDLE_SPEED
   end

   --update paddle positions
   paddle1:update(dt)
   paddle2:update(dt)
   if gameState == 'play' then
      --update ball positions if game is in play
      ball:update(dt)
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
   ball:render()
   --draw paddles
   paddle1:render()
   paddle2:render()
   --draw text
   love.graphics.setFont(smallFont)
   love.graphics.printf(message, 0, 20, VIRTUAL_WIDTH, 'center')
   love.graphics.setFont(largeFont)
   love.graphics.print(player1Score, VIRTUAL_WIDTH/2 - 50, VIRTUAL_HEIGHT / 3)
   love.graphics.print(player2Score, VIRTUAL_WIDTH/2 + 30, VIRTUAL_HEIGHT / 3)
   --end call to virtual resolution library
   push:apply('end')
end