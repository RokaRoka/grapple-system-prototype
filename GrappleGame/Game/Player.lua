-- PLAYER VARIABLES --
local playerData = {}
--Player mechanic data--
playerData.inputDirectionHeld = Vector(0, 0)
playerData.inputAngle = 0

--playerData physics data--
playerData.moveSpeed = Vector(0, 0)
--Movement data
playerData.moveAccel = 0.45
playerData.moveDeccel = 0.55
playerData.moveTopSpeed = 8
--air movement data
playerData.airAccel = 0.35
--swinging data
playerData.swingSpeed = Vector(0, 0)
playerData.swingTopSpeed = 10

--set playerData draw data--
playerData.path = "Game/Images/"
playerData.filename = "hero.png"
playerData.width = 32
playerData.height = 64

-- PLAYER CLASS --
Player = Class{__includes = Object,
  init = function(self, position)
    Object.init(self, position, "Player")
    self:initGraphics(
      playerData.path,
      playerData.filename,
      ANCHOR_CENTER
    )
    self.imageHandle:setDrawScale(0.5)

    --some player data
  end

}

function Player:initPhysics(world)
  Object.initPhysics(self, world,
    "rectangle", -- the player is not a complex shape
    "dynamic", -- the player does move
    playerData.width, playerData.height,
    ANCHOR_CENTER
  )
end

function Player:keypressed(key, isrepeat)
  --body
  if key == "a" then
    self:moveInput(Vector(-1, 0)) --store the input as player direction
  elseif key == "d" then
    self:moveInput(Vector(1, 0))
  end
end

function Player:keyreleased(key, isrepeat)
  --body
  if key == "a" then
    self:moveInput(Vector(1, 0)) --do the opposite for released
  elseif key == "d" then
    self:moveInput(Vector(-1, 0))
  end
end

function Player:moveInput(direction)
  --store input
end

function Player:accelerate(accelX)

end

function Player:deccelerate(deccelY)

end

function Player:jump(impulseY)

end
