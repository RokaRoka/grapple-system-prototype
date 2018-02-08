--physics debug constants
DEBUG_COLOR_PHYSICS = {80, 150, 200}

PhysicsHandle = Class
{
  init = function(self, parent, world, shape, bodyType, wr, h, anchorMode)
    if anchorMode then
      self.offset = Vector(self:determineOffset(wr, h, anchorMode))
    else
      self.offset = Vector(0, 0)
    end

    self.body = love.physics.newBody(world, parent.pos.x + self.offset.x, parent.pos.y + self.offset.y, bodyType)
    self.body:setFixedRotation(true) -- set fixed rotation cuz we dont want real physics

    if shape == "rectangle" then
      self.shape = love.physics.newRectangleShape(wr, h)
      self.width = wr
      self.height = h
    elseif shape == "circle" then
      self.shape = love.physics.newCircleShape(wr)
      self.radius = wr
    elseif shape == "edge" then
      local x1, y1, x2, y2

      x1 = parent.pos.x + self.offset.x
      y1 = parent.pos.y + self.offset.y
      x2 = parent.pos.x + wr + self.offset.x
      y2 = parent.pos.y + h + self.offset.y

      self.shape = love.physics.newEdgeShape(x1, y1, x2, y2)
    end

    self.fixture = love.physics.newFixture(self.body, self.shape)
    self.fixture:setUserData(parent) -- set holding object to userdata for collisions
  end
}

function PhysicsHandle:determineOffset(wr, h, anchorMode)
  if anchorMode == ANCHOR_TOP then
    return wr/-2, 0
  elseif anchorMode == ANCHOR_CENTER then
    return wr/-2, h/-2
  elseif anchorMode == ANCHOR_BOTTOM then
    return wr/-2, h * -1
  else
    return 0, 0
  end
end

function PhysicsHandle:draw() --for debug drawing to see where physics are
  if debug.myDebug then
    local shapeType = self.shape:getType()

    love.graphics.setColor(DEBUG_COLOR_PHYSICS) --set color for drawing phys shapes
    love.graphics.circle("fill", 0, 64, 8)

    if shapeType == "polygon" then
      local x, y =  self.body:getPosition()
      love.graphics.rectangle('line', x + self.offset.x, y+ self.offset.y, self.width, self.height)

    elseif shapeType == "circle" then
      local x, y =  self.body:getPosition()
      love.graphics.circle('line', x + self.offset.x, y + self.offset.y, self.radius)
    elseif shapeType == "edge" then
      love.graphics.line(self.shape:getPoints()) -- find a way to apply offset here
    end

    love.graphics.setColor(255, 255, 255) -- set back to normal white
  end
end

function PhysicsHandle:setSensor()
    self.fixture:setSensor(true)
end

function PhysicsHandle:clear()
  self.body:destroy()
  --self.shape:destroy()
  --self.fixture:destroy()
  --self = nil
end
