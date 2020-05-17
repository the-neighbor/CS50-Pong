WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

push = require 'push'

function love.load()
   --[[
      1. set the default scaling filter to nearest neighbor
      2. load our ttf to create a font object
      3. use push library to set up our virtual raster and window
   --]]
   love.graphics.setDefaultFilter('nearest', 'nearest')
   smallFont = love.graphics.newFont('font.ttf', 8)
   love.graphics.setFont(smallFont)
   push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
      fullscreen = false,
      vsync = true,
      resizable = false
   })
end

function love.keypressed(key)
   if key == 'escape' then
      love.event.quit()
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
   love.graphics.rectangle('fill', 5, 20, 5, 20)
   love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 40, 5, 20)
   --draw text
   love.graphics.printf("Hello Pong!", 0, 20, VIRTUAL_WIDTH, 'center')
   --end call to virtual resolution library
   push:apply('end')
end