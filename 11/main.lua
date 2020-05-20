WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200
POINTS_TO_WIN = 3

Class = require 'class' --import Class library
push = require 'push' --import push library

require 'Ball' --import Ball class
require 'Paddle' --import Paddle class

function startState()
   --brings the game back to a start state
   ball:reset()
   gameState = 'start'
   message = 'Hello Start State!'
   player1Score = 0
   player2Score = 0
end

function playState()
   --brings the game to a play state
   gameState = 'play'
   message = 'Hello Play State!'
end

function serveState(player)
   --brings the game to a serveState
   ball:reset()
   if player == 1 then
      ball.dx = 100
   elseif player == 2 then
      ball.dx = -100
   end
   servingPlayer = player
   gameState = 'serve'
end

function win(player)
   winningPlayer = player
   gameState = 'victory'
   ball:reset()
end

function love.load()
   --[[
      1. set the default scaling filter to nearest neighbor
      2. load our ttf to create a font object
      3. use push library to set up our virtual raster and window
   --]]
   --seed RNG with the current epoch time which will be unique each time the game is run
   math.randomseed(os.time())
   love.window.setTitle("Pong")
   love.graphics.setDefaultFilter('nearest', 'nearest')
   smallFont = love.graphics.newFont('font.ttf', 8)
   largeFont = love.graphics.newFont('font.ttf', 32)
   winFont = love.graphics.newFont('font.ttf', 24)

   --load audio 
   sounds = {
      ['paddle_hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
      ['scored'] = love.audio.newSource('sounds/score.wav', 'static'),
      ['wall_hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static')
   }

   --initialize variables to track the score of each player
   player1Score = 0
   player2Score = 0

   servingPlayer = math.random(2) == 1 and 1 or 2
   winningPlayer = 0
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
         serveState(servingPlayer)
      elseif gameState == 'serve' then
         playState()
      elseif gameState == 'victory' then
         startState()
      end
   end
end

function score(player)
   sounds['scored']:play()
   if player == 1 then
      player1Score = player1Score + 1
      if player1Score >= POINTS_TO_WIN then
         win(1)
      else
         serveState(2)
      end
   elseif player == 2 then
      player2Score = player2Score + 1
      if player2Score >= POINTS_TO_WIN then
         win(2)
      else
         serveState(1)
      end
   end
end

function love.update(dt)
   --called every frame. dt is "delta", the change in time since the last call/frame
   if gameState == 'play' then

      --detect collision with left and right screen edges(scoring condition)
      if ball.x <= 0 then
         score(2)
      end

      if ball.x >= VIRTUAL_WIDTH - ball.width then
         score(1)
      end

      --detect collision with paddles
      if ball:collides(paddle1) or ball:collides(paddle2) then
         --deflect ball in opposite direction along x axis
         ball.dx = -ball.dx * 1.03
         sounds['paddle_hit']:play()
      end

      --detect collsion with top and bottom of screen
      if ball.y <= 0 or ball.y + ball.height >= VIRTUAL_HEIGHT then
         --deflect ball in opposite direction along y axis
         sounds['wall_hit']:play()
         ball.dy = -ball.dy
         if ball.y <= 0 then
            ball.y = 0
         end
         if ball.y >= VIRTUAL_HEIGHT - ball.height then
            ball.y = VIRTUAL_HEIGHT - ball.height
         end
      end
   end
   --controls to move the paddle for player 1
   if love.keyboard.isDown('w') then
      paddle1.dy = -PADDLE_SPEED
   elseif love.keyboard.isDown('s') then
      paddle1.dy = PADDLE_SPEED
   else
      paddle1.dy = 0
   end

   --controls to move the paddle for player 2
   if love.keyboard.isDown('up') then
      paddle2.dy = -PADDLE_SPEED
   elseif love.keyboard.isDown('down') then
      paddle2.dy = PADDLE_SPEED
   else
      paddle2.dy = 0
   end

   --update paddle positions
   paddle1:update(dt)
   paddle2:update(dt)
   if gameState == 'play' then
      --update ball positions if game is in play
      ball:update(dt)
   end
end

function displayFPS()
   love.graphics.setColor(0,1,0,1) --set drawing color to green
   love.graphics.setFont(smallFont) --set font to small
   love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 40, 20) --print fps
end

function displayScores()
   love.graphics.setColor(1,1,1,1) --set drawing color to white
   love.graphics.setFont(largeFont) --set font to large
   --print player 1 score
   love.graphics.print(player1Score, VIRTUAL_WIDTH/2 - 50, VIRTUAL_HEIGHT / 3)
   --print player 2 score
   love.graphics.print(player2Score, VIRTUAL_WIDTH/2 + 30, VIRTUAL_HEIGHT / 3)
end

function displayMessage()
   love.graphics.setColor(1,1,1,1) --set drawing color to white
   love.graphics.setFont(smallFont) --set font to small
   --love.graphics.printf(message, 0, 20, VIRTUAL_WIDTH, 'center') --print state message
   if gameState == 'start' then
      love.graphics.printf('Welcome to Pong!', 0, 20, VIRTUAL_WIDTH, 'center')
      love.graphics.printf('Press Enter to Play!', 0, 32, VIRTUAL_WIDTH, 'center')
   elseif gameState == 'serve' then
      local serveStr = "Player " .. tostring(servingPlayer) .. "'s turn!"
      love.graphics.printf(serveStr, 0, 20, VIRTUAL_WIDTH, 'center')
      love.graphics.printf('Press Enter to Serve!', 0, 32, VIRTUAL_WIDTH, 'center')
   elseif gameState == 'victory' then
      --print a victory message
      local winStr = "Player " .. tostring(servingPlayer) .. " wins!"
      love.graphics.setFont(winFont)
      love.graphics.printf(winStr, 0, 10, VIRTUAL_WIDTH, 'center')
      love.graphics.setFont(smallFont)
      love.graphics.printf('Press Enter to Serve!', 0, 42, VIRTUAL_WIDTH, 'center')



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
   displayMessage()
   displayScores()
   displayFPS()
   --end call to virtual resolution library
   push:apply('end')
end
