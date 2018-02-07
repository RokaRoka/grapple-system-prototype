local grappleData = {}
grappleData.path = "Game/Images/"
grappleData.filename = "starPoint.png"
grappleData.filename2 = "starPoint2.png"

GrapplePoint = Class{__includes = Object,
  init = function(self, position)
    Object.init(self, position, "GrapplePoint")

    --set up graphics
    self:initGraphics(grappleData.path,
                      grappleData.filename,
                      ANCHOR_CENTER
    )
    self.imageHandle:setDrawScale(0.1)

    self:initSecondImage()

    --member variables
    self.playerInRange = false
  end,

  --trigger size
  triggerRadius = 64
}

--extra image to draw for player
function GrapplePoint:initSecondImage()
  self.image2 = love.graphics.newImage(grappleData.path..grappleData.filename2)
end

function GrapplePoint:initPhysics(world)
  Object.initPhysics(
      self, world, "circle",
      static, GrapplePoint.triggerRadius
  )
  self.physicsHandle:setSensor()
end

function GrapplePoint:beginContact(fixtureA, fixtureB, contact)
  self.debugLog = "Begin contact for GrapplePoint!"
  if fixtureA:getUserData().name == "Player" or fixtureB:getUserData().name == "Player" then
    self.debugLog = "It works!"
    self.playerInRange = true
  end
end

function GrapplePoint:endContact(fixtureA, fixtureB, contact)
  self.debugLog = "Begin contact for GrapplePoint!"
  if fixtureA:getUserData().name == "Player" or fixtureB:getUserData().name == "Player" then
    self.debugLog = "Player Left D:!"
    self.playerInRange = false
  end
end

function GrapplePoint:draw()
  Object.draw(self)
  if self.playerInRange then
    love.graphics.draw(self.image2,
      self.pos.x + self.imageHandle.offset.x,
      self.pos.y + self.imageHandle.offset.y,
      0, --rotation
      self.imageHandle.imageScale, self.imageHandle.imageScale
    )
  end
end
