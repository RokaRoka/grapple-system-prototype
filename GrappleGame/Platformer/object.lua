--Object constants
ANCHOR_TOP = 0
ANCHOR_CENTER = 1
ANCHOR_BOTTOM = 2

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

    --random debug text filler
    self.debugLog = "Empty debug log for "..self.name

    --if there is debug, give it a page
    if debug then
      self.debugPage = debug.setupNewPage(self.name.." Debug",
        {
          {"position", function() return "Position: "..tostring(self.pos) end}
        })
      debug.addInfo(self.debugPage,
        {"debug-log",
        function() return self.debugLog end}
      )
    end
  end,
  all = {},

  updateAll = function(dt)
    for i,v in ipairs(Object.all) do --update all objects
      v:update(dt) --update object
    end
  end,

  drawAll = function(dt)
    for i,v in ipairs(Object.all) do --update all objects
      v:draw() --update object
    end
  end
}

function Object:update(dt)
  if self.physicsHandle then
    local x, y = self.physicsHandle.body:getPosition()
    self.pos.x = math.floor(x)
    self.pos.y = math.floor(y)
  end
end

function Object:draw()
  if self.imageHandle then
    self.imageHandle:draw(self.pos, self.angle or 0, self.imageHandle.imageScale or 1)
  end

  if self.physicsHandle then
    self.physicsHandle:draw()
  end

  --draw object center
  if debug then
    love.graphics.setColor(DEBUG_COLOR_OBJECT)
    love.graphics.circle("fill", self.pos.x, self.pos.y, 4)
    love.graphics.setColor(255, 255, 255)
  end
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
  self.physicsHandle = PhysicsHandle(self, world, shape, bodyType, wr, h, offsetType)

  Signal.register('begin-contact-'..self.name,
    function(fixtureA, fixtureB, contact)
      self:beginContact(fixtureA, fixtureB, contact)
    end
  )

  Signal.register('end-contact-'..self.name,
    function(fixtureA, fixtureB, contact)
      self:endContact(fixtureA, fixtureB, contact)
    end
  )

  if debug then
    debug.addInfo(self.debugPage,
      {"physics-position",
      function()
        local x, y = self.physicsHandle.body:getPosition()
        return "Physics Position: ("..math.floor(x)..", "..math.floor(y)..")"
      end}
    )
    debug.addInfo(self.debugPage,
      {"physics-velocity",
      function()
        local x, y = self.physicsHandle.body:getLinearVelocity()
        return "Physics Velocity: ("..math.floor(x)..", "..math.floor(y)..")"
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
