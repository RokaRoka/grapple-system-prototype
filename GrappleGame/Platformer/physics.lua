--physics debug constants
DEBUG_COLOR_PHYSICS = {80, 150, 200}

PhysicsHandle = Class
{
  init = function(self, parent, world, shape, bodyType, wr, h, offset)
    if offset then
      self.body = love.physics.newBody(world, parent.pos.x + offset.x, parent.pos.y + offset.y, bodyType)
    else
      self.body = love.physics.newBody(world, parent.pos.x, parent.pos.y, bodyType)
    end

    if shape == "rectangle" then
      self.shape = love.physics.newRectangleShape(wr, h)
      self.width = wr
      self.height = h
    elseif shape == "circle" then
      self.shape = love.physics.newCircleShape(wr)
      self.radius = wr
    elseif shape == "edge" then
      local x1, y1, x2, y2
      if offset then
        x1 = parent.pos.x + offset.x
        y1 = parent.pos.y + offset.y
        x2 = parent.pos.x + wr + offset.x
        y2 = parent.pos.y + h + offset.y
      else
        x1 = parent.pos.x
        y1 = parent.pos.y
        x2 = parent.pos.x + wr
        y2 = parent.pos.y + h
      end

      self.shape = love.physics.newEdgeShape(x1, y1, x2, y2)
    end

    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(parent) -- set holding object to userdata for collisions
  end
}

function PhysicsHandle:draw() --for debug drawing to see where phuysics are
  local shapeType = self.shape:getType()

  love.graphics.setColor(DEBUG_COLOR_PHYSICS) --set color for drawing phys shapes
  love.graphics.circle("fill", 0, 64, 8)

  if shapeType == "polygon" then
    local x, y =  self.body:getPosition()
    love.graphics.rectangle('line', x, y, self.width, self.height)
  elseif shapeType == "circle" then
    local x, y =  self.body:getPosition()
    love.graphics.circle('line', x, y, self.radius)
  elseif shapeType == "edge" then
    love.graphics.line(self.shape:getPoints())
  end

  love.graphics.setColor(255, 255, 255) -- set back to normal white

end

function PhysicsHandle:clear()
  self.body:destroy()
  self.shape:destroy()
  self.fixture:destroy()
  self = nil
end
