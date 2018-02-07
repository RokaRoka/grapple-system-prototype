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

    --player member physics data--
    self.moveVelocity = Vector(0, 0)
    self.grounded = false
    self.jumping = false
    self.airTime = 0

    --player member grapple data--
    self.grappleTarget = nil
  end,
  --Physics Data --EVERYTHING in meters
  gravY = 0.5 * love.physics.getMeter(),

  --Movement data
  moveAccel = 0.4 * love.physics.getMeter(),
  moveDecel = 0.65 * love.physics.getMeter(),
  moveTopSpeed = 12 * love.physics.getMeter(),

  --Air data
  airAccel = 1 * love.physics.getMeter(),

  --Jump data
  jumpPower = -5 * love.physics.getMeter(),
  maxJumpTime = 0.3, --this is in seconds

  --grappling hook data
  grappleRange = 96,
  grappleFired = false,
  grappleCount = 0,
  grappleFailed = false,

  --grapple draw data
  hookColor = {235, 235, 235},
  hookPosition = Vector(0, 0),

  --swinging data
  swinging = false,

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

-- PLAYER CALLBACKS --
function Player:update(dt)
  Object.update(self, dt)
  --is the player moving and is physics active
  if self.physicsHandle then
    if self.grappleFired then
      self:grapplingUpdate(dt)
    end
    self:movement(dt)
  end
end

function Player:draw()
  if self.grappleFired or self.swinging then
    --draw grapple

  end
  Object.draw(self)
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

require("Game/Player/PlayerMovement")
require("Game/Player/PlayerGrapple")
