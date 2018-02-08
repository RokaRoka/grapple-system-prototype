-- Ground CLASS --
Ground = Class{__includes = Object,
  init = function(self, position)
    Object.init(self, position, "Ground")
  end
}

function Ground:initPhysics(world, wr, h)
  self.width = wr
  self.height = h
  Object.initPhysics(self, world,"rectangle", -- the ground is not a complex shape
    "static", -- the ground doesnt move
    wr, h,
    ANCHOR_CENTER
  )
end

function Ground:draw()
  if self.width and self.height then
    love.graphics.setColor(50, 50, 75)
    love.graphics.rectangle("fill", self.pos.x - self.width/2, self.pos.y - self.height/2, self.width, self.height)
    love.graphics.setColor(40, 40, 55)
    love.graphics.rectangle("line", self.pos.x - self.width/2, self.pos.y - self.height/2, self.width, self.height)
    love.graphics.setColor(255, 255, 255)
  end
end
