-- PLAYER VARIABLES --
local playerData = {}
--Player mechanic data--
playerData.inputAngle = 0

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

    --Player member vars--
    self.inputDirectionHeld = Vector()
    if debug then
      debug.addInfo(self.debugPage,
        {"player-input",
          function()
            return "Player Input Vector: "..
              self.inputDirectionHeld.x..", "..
              self.inputDirectionHeld.y
          end
        }
      )
    end

    --player physics data--
    self.moveVelocity = Vector(0, 0)
  end,
  --Physics Data
  extraGravY = 0.25,

  --Movement data
  moveAccel = 0.75,
  moveDecel = 0.85,
  moveTopSpeed = 25,

  --Vector constants
  VECTOR_RIGHT = Vector(1.0, 0),
  VECTOR_LEFT = Vector(-1.0, 0)

}

function Player:initPhysics(world)
  Object.initPhysics(self, world,
    "rectangle", -- the player is not a complex shape
    "dynamic", -- the player does move
    playerData.width, playerData.height,
    ANCHOR_CENTER
  )
end

function Player:update(dt)
  Object.update(self, dt)
  --is the player moving and is physics active
  if self.physicsHandle then
    self:movement(dt)
  end
end

function Player:keypressed(key, isrepeat)
  --body
  if key == "a" then
     --store the input as player direction
    self.inputDirectionHeld = self.inputDirectionHeld + Player.VECTOR_LEFT
  elseif key == "d" then
    self.inputDirectionHeld = self.inputDirectionHeld + Player.VECTOR_RIGHT
  end
end

function Player:keyreleased(key)
  --body
  if key == "a" then
     --do the opposite for released
    self.inputDirectionHeld = self.inputDirectionHeld - self.VECTOR_LEFT
  elseif key == "d" then
    self.inputDirectionHeld = self.inputDirectionHeld - self.VECTOR_RIGHT
  end
end

function Player:movement(dt)
  --set the y grav on these jank physics
  local _
  _, self.moveVelocity.y = self.physicsHandle.body:getLinearVelocity()

  --is the player pressing any x movement
  if self.inputDirectionHeld.x > 0 or self.inputDirectionHeld.x < 0 then
    --accelerate, since input is being held
    self:accelerate()
  elseif self.moveVelocity.x < 0 or self.moveVelocity.x > 0 then
    --decelerate since input is not held and the player is moving
    self:decelerate()

  end

  --y velocity stuff
  if self.moveVelocity.y > 0 or self.moveVelocity.y < 0 then
    --apply additional grav to velocity y
  end
  --update movement
  self:updateVelocity()
end

--updates moveVelocity
function Player:accelerate()
  --get the direction held by the player
  local sign = lume.sign(self.inputDirectionHeld.x)
  self.moveVelocity.x = self.moveVelocity.x + self.moveAccel * sign
  if sign > 0 then
    self.moveVelocity.x = lume.clamp(self.moveVelocity.x, 0, self.moveTopSpeed)
  else
    self.moveVelocity.x = lume.clamp(self.moveVelocity.x, self.moveTopSpeed * -1 , 0)
  end
end

--updates moveVelocity
function Player:decelerate()
  --get the direction of movement first
  local sign = lume.sign(self.moveVelocity.x)

  if sign > 0 then
    self.moveVelocity.x = lume.clamp(self.moveVelocity.x - self.moveDecel, 0, self.moveTopSpeed)
  else
    self.moveVelocity.x = lume.clamp(self.moveVelocity.x + self.moveDecel, self.moveTopSpeed *-1 , 0)
  end
end

function Player:addGravity()
  --if not colliding with ground <- add This
  self.moveVelocity.y = self.moveVelocity.y + self.extraGravY
end

function Player:updateVelocity()
  self.physicsHandle.body:setLinearVelocity(self.moveVelocity:unpack())
end

function Player:jump(impulseY)

end
