local moon = {}

moon.path = "Game/Images/"
moon.filename = "themoon.jpg"

-- Ground CLASS --
Moon = Class{__includes = Object,
  init = function(self, position)
    Object.init(self, position, "Moon")
    self:initGraphics(
      moon.path,
      moon.filename,
      ANCHOR_CENTER
    )
    self.imageHandle:setDrawScale(0.5)
    self.font = love.graphics.newFont("Game/Fonts/championship.ttf", 18)
    --self.theMoonText = love.graphics.newText(self.font, self.theMoonText)
  end
}

function Moon:draw()
  Object.draw(self)
  --love.graphics.draw(self.theMoonText, self.pos.x - 64, self.pos.y - 16)
end
