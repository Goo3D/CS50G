-- GD50 Pong Remake V-03
-- Adding a new TextFont
-- Adding Paddles and ball
-- Adding Keyboard control


-- Declaraciones simbolicas
WINDOW_WIDTH = 1280  -- Tamaño de la ventana
WINDOW_HEIGHT = 720
VIRTUAL_WIDTH = 432  -- Tamaño virtual de la ventana
VIRTUAL_HEIGHT = 243
PADDLE_SPEED = 400 -- Velocidad de las palas

-- push is a library that will allow us to draw our game at a virtual
-- resolution, instead of however large our window is; used to provide
-- a more retro aesthetic
-- https://github.com/Ulydev/push

push = require 'push'


--                     LOAD CYCLE

function love.load()


  love.graphics.setDefaultFilter('nearest', 'nearest')  -- Use nearest filtering

  -- more "retro-looking" font object we can use for any text
  smallFont = love.graphics.newFont('font.ttf', 8)

  -- larger font for drawing the score on the screen
  scoreFont = love.graphics.newFont('font.ttf', 32)


  -- set LÖVE2D's active font to the smallFont obect
  love.graphics.setFont(smallFont)


  -- initialize our virtual resolution, which will be rendered within our
  -- actual window no matter its dimensions; replaces our love.window.setMode call
  -- from the last example
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
      fullscreen = false,
      resizable = false,
      vsync = true
  })

  -- initialize score variables, used for rendering on the screen and keeping
  -- track of the winner
  player1Score = 0
  player2Score = 0

  -- paddle positions on the Y axis (they can only move up or down)
  player1Y = 30
  player2Y = VIRTUAL_HEIGHT - 50

end

--                 UPDATE CYCLE


--[[
    Runs every frame, with "dt" passed in, our delta in seconds
    since the last frame, which LÖVE2D supplies us.
]]
function love.update(dt)
    -- player 1 movement
    if love.keyboard.isDown('w') then
        -- add negative paddle speed to current Y scaled by deltaTime
        player1Y = player1Y + -PADDLE_SPEED * dt
    elseif love.keyboard.isDown('s') then
        -- add positive paddle speed to current Y scaled by deltaTime
        player1Y = player1Y + PADDLE_SPEED * dt
    end

    -- player 2 movement
    if love.keyboard.isDown('up') then
        -- add negative paddle speed to current Y scaled by deltaTime
        player2Y = player2Y + -PADDLE_SPEED * dt
    elseif love.keyboard.isDown('down') then
        -- add positive paddle speed to current Y scaled by deltaTime
        player2Y = player2Y + PADDLE_SPEED * dt
    end
end





-- Keyboard handling, called by LÖVE2D each frame;
function love.keypressed(key)

    if key == 'escape' then  -- keys can be accessed by string name
      love.event.quit()
    end
end






--                 DRAW CYCLE

function love.draw()


  push:apply('start')    -- begin rendering at virtual resolution
  love.graphics.clear(.15, .15, .15, 1)    --clear screen with a spicific color

  -- draw welcome text toward the top of the screen
  love.graphics.setFont(smallFont)
  love.graphics.printf('Hello Pong!', 0, 20, VIRTUAL_WIDTH, 'center')


  -- draw score on the left and right center of the screen
  -- need to switch font to draw before actually printing
  love.graphics.setFont(scoreFont)
  love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50,
      VIRTUAL_HEIGHT / 3)
  love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30,
      VIRTUAL_HEIGHT / 3)




-- First paddle (Left side)
  love.graphics.rectangle('fill', 10, player1Y, 5, 20)
-- Seccond paddle (right side)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH - 10, player2Y, 5, 20)
-- ball (center)
  love.graphics.rectangle('fill', VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)


  push:apply('end')  -- end rendering at virtual resolution



end
