--Object constants
DEBUG_COLOR_OBJECT = {150, 50, 150}

--load object dependancy
require "Platformer/image"
require "Platformer/physics"

Object = Class
{
  init = function(self, position, name)
    --init stuff here
    if Vector.isvector(position) then
      self.pos = position
    else
      self.pos = Vector(position.x, position.y)
    end
    self.name = name

    table.insert(Object.all, self)
    self.index = #Object.all + 1

    --if there is debug, give it a page
    if debug then
      self.debugPage = debug.setupNewPage(self.name.." Debug",
        {
          {"position", function() return "Position: "..tostring(self.pos) end}
        })
    end
  end,
  all = {}
}

function Object:update(dt)
  --if there is a physics body, update pos to physics body position.
end

function Object:draw()
  if self.physicsHandle then
    --self.pos = Vector(self.physicsHandle.body:getPosition())
  end

  if self.imageHandle then
    self.imageHandle:draw(self.pos)
  end

  if self.physicsHandle then
    self.physicsHandle:draw()
  end

  --draw object center
  if debug then
    love.graphics.setColor(DEBUG_COLOR_OBJECT)
    love.graphics.circle("fill", self.pos.x, self.pos.y, 8)
  end
  love.graphics.setColor(255, 255, 255)
end

function Object:clear()
  --delete member variables
  self.pos = nil
  self.name = nil
  if self.imageHandle then -- if there is an image handler, delete it
    self.imageHandle:clear()
  end
  if self.physicsHandle then -- if there is a physics handler, clear all the physics
    self.physicsHandle:clear()
  end
  table.remove(Object.all, self.index)
  self.index = nil
  self = nil
end

-- Physics functions --
--use DRAW_ACHOR for offsetType
function Object:initPhysics(world, shape, bodyType, wr, h, offsetType)
  if offsetType == DRAW_ANCHOR_TOP then
    self.physicsHandle = PhysicsHandle(self, world, shape, bodyType, wr, h, Vector(wr/-2, 0))
  elseif offsetType == DRAW_ANCHOR_CENTER then
    self.physicsHandle = PhysicsHandle(self, world, shape, bodyType, wr, h, Vector(wr/-2, h/-2))
  elseif offsetType == DRAW_ANCHOR_BOTTOM then
    self.physicsHandle = PhysicsHandle(self, world, shape, bodyType, wr, h, Vector(wr/-2, h * -1))
  else --default
    self.physicsHandle = PhysicsHandle(self, world, shape, bodyType, wr, h)
  end

  Signal.register('begin-contact-'..self.name, function(fixtureA, fixtureB, contact) self:beginContact(fixtureA, fixtureB, contact) end)
  Signal.register('end-contact-'..self.name, function(fixtureA, fixtureB, contact) self:endContact(fixtureA, fixtureB, contact) end)

  if debug then
    debug.addInfo(self.debugPage,
      {"physics-position",
      function()
        local x, y = self.physicsHandle.body:getPosition()
        return "Physics Position: ("..math.floor(x)..", "..math.floor(y)..")"
      end}
    )
  end
end

function Object:beginContact(fixtureA, fixtureB, contact)
  --to be overwritten
end

function Object:endContact(fixtureA, fixtureB, contact)
  --to be overwritten
end

-- Draw functions --

function Object:initGraphics(path, filename, drawAnchorMode, flag, tileData, tileWidthSpacing, tileHeightSpacing)
  if flag then
    if flag == "-sb" then
      --make a spritebatch
      self.imageHandle = TileHandle(path, filename, tileData, tileWidthSpacing, tileHeightSpacing)
      if debug then
        debug.addInfo( self.debugPage,
          {"tile-amount",
          function() return "Tile Amount: "..self.imageHandle.spriteBatch:getCount() end
          }
        )
      end
    else
      self.imageHandle = ImageHandle(path, filename, drawAnchorMode)
    end
  else
    self.imageHandle = ImageHandle(path, filename, drawAnchorMode)
  end

  if debug then
    debug.addInfo(self.debugPage,
      {"draw-offset", function() return "Image Offset"..tostring(self.imageHandle.offset) end}
    )
  end
end
