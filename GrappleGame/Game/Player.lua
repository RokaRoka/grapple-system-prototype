-- PLAYER VARIABLES --
local playerData = {}
--Player mechanic data--
playerData.inputAngle = 0

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
    if debug.myDebug then
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
    self.grounded = false
    self.jumping = false
    self.airTime = 0
  end,
  --Physics Data
  gravY = 0.85,

  --Movement data
  moveAccel = 1.15,
  moveDecel = 1.35,
  moveTopSpeed = 50,

  --Air data
  airAccel = 1.5,

  --Jump data
  jumpPower = -50,
  maxJumpTime = 0.75,

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
  if key == "space" then
    self.jumping = true
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

  if key == "space" then
    self.jumping = false
  end
end

function Player:movement(dt)
  --set the y grav on these jank physics
  local _
  _, self.moveVelocity.y = self.physicsHandle.body:getLinearVelocity()

  --x velocity math
  --if holding a direction, accelerate
  if self.inputDirectionHeld.x > 0 or self.inputDirectionHeld.x < 0 then
    self:accelerate()
  elseif self.moveVelocity.x < 0 or self.moveVelocity.x > 0 then
    --decelerate since input is not held and the player is moving
    self:decelerate()
  end

  --y velocity math
  if self.jumping then
    self:applyJump()
    self.airTime = self.airTime + dt
    if self.airTime > self.maxJumpTime then
      self.airTime = 0
      self.jumping = false
    end
  end
  --if not grounded, apply gravity
  if not self.grounded then --if in the air
    --apply additional grav to velocity y
    self:applyGravity()
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

function Player:applyGravity()
  --if not colliding with ground <- add This
  self.moveVelocity.y = self.moveVelocity.y + self.gravY
end

function Player:updateVelocity()
  self.physicsHandle.body:setLinearVelocity(self.moveVelocity:unpack())
end

function Player:applyJump()
  self.moveVelocity.y = self.jumpPower
end
