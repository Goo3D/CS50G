-- GD50 Pong Remake V-01


-- Declaraciones simbolicas
WINDOW_WIDTH = 1280  -- Tamaño de la ventana
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
-- https://github.com/Ulydev/push

push = require 'push'


--                     LOAD CYCLE

function love.load()


  love.graphics.setDefaultFilter('nearest', 'nearest')  -- Use nearest filtering

  -- initialize our virtual resolution, which will be rendered within our
  -- actual window no matter its dimensions; replaces our love.window.setMode call
  -- from the last example
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
      fullscreen = false,
      resizable = false,
      vsync = true
  })



end

--                 UPDATE CYCLE


-- Keyboard handling, called by LÖVE2D each frame;
function love.keypressed(key)

    if key == 'escape' then  -- keys can be accessed by string name
      love.event.quit()
    end
end






--                 DRAW CYCLE

function love.draw()


  push:apply('start')    -- begin rendering at virtual resolution

  -- note we are now using virtual width and height now for text placement
  love.graphics.printf('Hello Pong!', 0, VIRTUAL_HEIGHT / 2 - 6, VIRTUAL_WIDTH, 'center')


  push:apply('end')  -- end rendering at virtual resolution



end
