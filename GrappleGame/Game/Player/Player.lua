-- PLAYER VARIABLES --
local playerData = {}
--set playerData draw data--
playerData.path = "Game/Images/"
playerData.filename = "moonman.png"
playerData.width = 320 * 0.10
playerData.height = 640 * 0.15

-- PLAYER CLASS --
Player = Class{__includes = Object,
  init = function(self, position)
    Object.init(self, position, "Player")
    self:initGraphics(
      playerData.path,
      playerData.filename,
      ANCHOR_CENTER
    )
    self.imageHandle:setDrawScale(0.15)

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
      debug.addInfo(self.debugPage,
        {"player-momentum",
          function()
            return "Player Momentum: "..self.momentum
          end
        }
      )
    end

    --player general member data
    self.angle = 0

    --player member physics data--
    self.moveVelocity = Vector(0, 0)
    self.grounded = false
    self.jumping = false
    self.airTime = 0
    self.momentum = 0

    --player member grapple data--
    self.grappleTarget = nil
    self.grappledTo = nil
    self.grappleFired = false
    self.grappleFailed = false
    --draw data
    self.hookPosition = Vector(0, 0)

    --player member swinging data
    self.swinging = false
    self.swingRight = true
    self.rope = nil
    self.lastVelocityX = 0
    self.influence = 10

  end,
  --Physics Data --EVERYTHING in meters
  gravY = 0.4 * love.physics.getMeter(),

  --Movement data
  moveAccel = 0.3 * love.physics.getMeter(),
  moveDecel = 0.6 * love.physics.getMeter(),
  moveTopSpeed = 10 * love.physics.getMeter(),

  --Air data
  airAccel = 0.5 * love.physics.getMeter(),
  airDrag = 0.95, --is multiplied to velocity

  --Jump data
  jumpPower = -8 * love.physics.getMeter(),
  maxJumpTime = 0.4, --this is in seconds

  --grappling hook data
  grappleLength = 128,
  grappleCount = 0,

  --grapple draw data
  hookColor = {235, 235, 235},

  --swinging data
  swingAccel = 2,
  goingFastSpeed = 12,
  influenceRefill = 10,
  swingJumpPower = 3,

  --Vector constants
  VECTOR_RIGHT = Vector(1.0, 0),
  VECTOR_LEFT = Vector(-1.0, 0),
  PLAYER_CHECKPOINT = Vector(64, 432)
}

function Player:initPhysics(world)
  Object.initPhysics(self, world,
    "rectangle", -- the player is not a complex shape
    "dynamic", -- the player does move
    playerData.width, playerData.height,
    ANCHOR_CENTER
  )
end

-- PLAYER CALLBACKS --
function Player:update(dt)
  self:checkDeath()
  Object.update(self, dt)
  --is the player moving and is physics active
  if self.physicsHandle then
    if self.grappleFired then
      self:grapplingUpdate(dt)
    elseif self.swinging then
      self:swingUpdate()
    end
    self:movement(dt)
  end
end

function Player:draw()
  if self.grappleFired or self.swinging then
    --draw grapple
    self:grappleDraw()
  end
  Object.draw(self)
  if debug.myDebug and self.moveVelocity:len2() > 0 then
    local x1, y1 = self.pos:unpack()
    local x2, y2 = self.moveVelocity:unpack()
    love.graphics.line(x1, y1,x1 + x2/32 * 2,y1 + y2/32 * 2)
  end
end

function Player:beginContact(fixtureA, fixtureB, contact)
  local otherB = fixtureB:getUserData()
  if otherB.name == "Ground" then
    self.debugLog = "Player grounded!"
    local contactPos = {contact:getPositions()}
    if contactPos[2] > self.pos.y + 48  and contactPos[4] > self.pos.y + 48 then
      self.grounded = true
    end
  end
  if otherB.name == "GrapplePoint" then
    self.debugLog = "GrapplePoint detected!"
    self.grappleTarget = otherB
  end
end

function Player:endContact(fixtureA, fixtureB, contact)

  local otherB = fixtureB:getUserData()
  if otherB.name == "Ground" then
    self.debugLog = "Player not grounded!"
    self.grounded = false
  end
  if otherB.name == "GrapplePoint" then
    self.debugLog = "GrapplePoint lost!"
    self.grappleTarget = nil
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
    if self.grounded then
      self.jumping = true
    elseif self.swinging then
      --swing jump?
      self:swingJump()
    elseif self.grappleTarget then
      --attempt grapple!
      self:fireGrappleHook()
    end
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
    if self.jumping then
      self.jumping = false
    end
  end
end

function Player:checkDeath()
  if self.pos.y > love.graphics.getHeight() * 1.5 then
    --restartLevel()
    local x, y = self.PLAYER_CHECKPOINT:unpack()
    self.physicsHandle.body:setPosition(x, y)
    self.moveVelocity.x = 0
    self.moveVelocity.y = 0
  end
end

require("Game/Player/PlayerMovement")
require("Game/Player/PlayerGrapple")
require("Game/Player/PlayerSwing")
