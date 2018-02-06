-- Ground CLASS --
Ground = Class{__includes = Object,
  init = function(self, position)
    Object.init(self, position, "Ground")
  end
}

function Ground:initPhysics(world, wr, h)
  Object.initPhysics(self, world,
    "rectangle", -- the ground is not a complex shape
    "static", -- the ground doesnt move
    wr, h,
    ANCHOR_CENTER
  )
end
