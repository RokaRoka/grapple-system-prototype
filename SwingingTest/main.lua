-- LIBRARIES --
Vector = require("hump.vector")

local world

local player = {}
local objects = {}

local rope = {}
local grip = {}

function love.load(args)
  --load required files
  player = require("player")
  objects = require("objects")

  --set world
  world = love.physics.newWorld(0, 9.81, true)


  --set player physics data
  player.body = love.physics.newBody(world, player.pos.x, player.pos.y, "dynamic")
  player.shape = love.physics.newRectangleShape(player.width, player.height)
  player.fixture = love.physics.newFixture(player.body, player.shape, 5)
  player.body:setFixedRotation(true)
  player.body:setGravityScale(5)

  --[[

  grip = objects.grip

  --set grip physics data
  grip.body = love.physics.newBody(world, grip.pos.x, grip.pos.y, "static")
  grip.shape = love.physics.newCircleShape(grip.radius)
  grip.fixture = love.physics.newFixture(grip.body, grip.shape)

  rope = objects.rope

  --set rope physics data
  rope.joint = love.physics.newRopeJoint(player.body, grip.body, player.pos.x, player.pos.y - player.height/2, grip.pos.x, grip.pos.y, rope.MAX_LENGTH, false)]]

end

function love.update(dt)
  world:update(dt)
  player.update(dt)
  --grip.update(dt)
  --rope.update(dt)
end

function love.draw()
  --rope.draw()
  --grip.draw()
  player.draw()
end

function love.keypressed(key, scancode, isrepeat)
  --debug exit
  if key == "escape" then
    love.event.quit()
  end
  -- Player Mechanics --
  --[[movement
  if key == 'w' then
    --add force
    player.body:applyLinearImpulse(1000, 0)
  end
  ]]
  
  if key == 'a' then
    --swing left
    player.inputDirectionHeld = player.inputDirectionHeld + Vector(-1, 0)
    --player.influenceSwing( Vector(-1, 0) )
  elseif key == 'd' then
    --swing right
    player.inputDirectionHeld = player.inputDirectionHeld + Vector(1, 0)
    --player.influenceSwing( Vector(1.0, 0) )
  end
end

function love.keyreleased(key)
  if key == 'a' then
    --end swinging left
    player.inputDirectionHeld = player.inputDirectionHeld - Vector(-1, 0)
    --player.influenceSwing( Vector(-1, 0) )
  elseif key == 'd' then
    --end swinging right
    player.inputDirectionHeld = player.inputDirectionHeld - Vector(1, 0)
    --player.influenceSwing( Vector(1.0, 0) )
  end
end
