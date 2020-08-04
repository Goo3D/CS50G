-- GD50 Pong Remake V-04
-- Adding random number generation
-- Adding gameState functionality
-- Clamping Paddles to screen.



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

--  ------------------------------------------------------
--                     LOAD CYCLE
--  ------------------------------------------------------
function love.load()


  love.graphics.setDefaultFilter('nearest', 'nearest')  -- Use nearest filtering

  math.randomseed(os.time())  -- RNG seed current time


  -- retro-looking font
  smallFont = love.graphics.newFont('font.ttf', 8)
  -- larger font for drawing the score on the screen
  scoreFont = love.graphics.newFont('font.ttf', 32)


  -- set LÖVE2D's active font to the smallFont obect
  love.graphics.setFont(smallFont)


  -- initialize virtual resolution
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

  -- velocity and position variables for our ball when play starts
  ballX = VIRTUAL_WIDTH / 2 - 2
  ballY = VIRTUAL_HEIGHT / 2 - 2

  -- math.random returns a random value between the left and right number
  ballDX = math.random(2) == 1 and 100 or -100
  ballDY = math.random(-50, 50)

  -- game state variable used to transition between different parts of the game
  -- (used for beginning, menus, main game, high score list, etc.)
  -- we will use this to determine behavior during render and update
  gameState = 'start'

end

--  ---------------------------------------------------
--                 UPDATE CYCLE
--  ---------------------------------------------------

function love.update(dt)
    -- player 1 movement
    if love.keyboard.isDown('w') then
        -- add negative paddle speed to current Y scaled by deltaTime
        -- now, we clamp our position between the bounds of the screen
        -- math.max returns the greater of two values; 0 and player Y
        -- will ensure we don't go above it
        player1Y = math.max(0, player1Y + -PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('s') then
        -- add positive paddle speed to current Y scaled by deltaTime
        -- math.min returns the lesser of two values; bottom of the egde minus paddle height
        -- and player Y will ensure we don't go below it
        player1Y = math.min(VIRTUAL_HEIGHT - 20, player1Y + PADDLE_SPEED * dt)
    end

    -- player 2 movement
    if love.keyboard.isDown('up') then
        -- add negative paddle speed to current Y scaled by deltaTime
        player2Y = math.max(0, player2Y + -PADDLE_SPEED * dt)
    elseif love.keyboard.isDown('down') then
        -- add positive paddle speed to current Y scaled by deltaTime
        player2Y = math.min(VIRTUAL_HEIGHT - 20, player2Y + PADDLE_SPEED * dt)
    end

    -- update our ball based on its DX and DY only if we're in play state;
    -- scale the velocity by dt so movement is framerate-independent
    if gameState == 'play' then
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
    end


end





-- Keyboard handling, called by LÖVE2D each frame;
function love.keypressed(key)

    if key == 'escape' then  -- keys can be accessed by string name
      love.event.quit()
      -- if we press enter during the start state of the game, we'll go into play mode
      -- during play mode, the ball will move in a random direction
      elseif key == 'enter' or key == 'return' then
          if gameState == 'start' then
              gameState = 'play'
          else
              gameState = 'start'
              -- start ball's position in the middle of the screen
              ballX = VIRTUAL_WIDTH / 2 - 2
              ballY = VIRTUAL_HEIGHT / 2 - 2

              -- given ball's x and y velocity a random starting value
              -- the and/or pattern here is Lua's way of accomplishing a ternary operation
              -- in other programming languages like C
              ballDX = math.random(2) == 1 and 100 or -100
              ballDY = math.random(-50, 50) * 1.5
            end

    end
end






--                 DRAW CYCLE

function love.draw()


  push:apply('start')    -- begin rendering at virtual resolution
  love.graphics.clear(.15, .15, .15, 1)    --clear screen with a spicific color

  -- draw welcome text toward the top of the screen
  love.graphics.setFont(smallFont)
  if gameState == 'start' then
      love.graphics.printf('Hello Start State!', 0, 20, VIRTUAL_WIDTH, 'center')
  else
      love.graphics.printf('Hello Play State!', 0, 20, VIRTUAL_WIDTH, 'center')
  end

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
