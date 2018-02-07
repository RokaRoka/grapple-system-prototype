local grappleData = {}
grappleData.path = "Game/Images/"
grappleData.filename = "starPoint.png"

GrapplePoint = Class{__includes = Object,
  init = function(self, position)
    Object.init(self, position, "GrapplePoint")

    --set up graphics
    self:initGraphics(grappleData.path,
                      grappleData.filename,
                      ANCHOR_CENTER
    )
    self.imageHandle:setDrawScale(0.1)

    --member variables
    self.playerInRange = false
  end,

  --trigger size
  triggerRange = 128
}

function GrapplePoint:initPhysics(world)
  Object.initPhysics(
      world, "circle",
      static, GrapplePoint.triggerRange
  )
  self.physicsHandle:setSensor()
end
