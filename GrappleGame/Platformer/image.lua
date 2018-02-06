DEBUG_COLOR_IMAGE = {50, 150, 125}

ImageHandle = Class
{
  init = function(self, path, filename, drawAnchorMode)
    self.image = love.graphics.newImage(path..filename)
    self.drawAnchorMode = drawAnchorMode
    self.width, self.height = self.image:getDimensions()

    --set offset based on anchor mode and image dimensions
    self.offset = Vector(self:determineOffset())
  end
}

function ImageHandle:determineOffset()
  if self.drawAnchorMode == ANCHOR_TOP then
    return (self.width * (self.imageScale or 0))/-2, 0
  elseif self.drawAnchorMode == ANCHOR_CENTER then
    return (self.width * (self.imageScale or 0))/-2, (self.height * (self.imageScale or 0)) /-2
  elseif self.drawAnchorMode == ANCHOR_BOTTOM then
    return (self.width * (self.imageScale or 0))/-2, (self.height * (self.imageScale or 0)) * -1
  else
    return 0, 0
  end
end

function ImageHandle:setDrawScale(newScale)
  self.imageScale = newScale
  self.offset = Vector(self:determineOffset())
end

function ImageHandle:draw(position, angle, scale)
  if debug then
    love.graphics.setColor(DEBUG_COLOR_IMAGE) --fill debug circle for debug
    love.graphics.circle("fill", position.x, position.y, 8)
    love.graphics.setColor(255, 255, 255)
  end

  love.graphics.draw(self.image, position.x + self.offset.x, position.y + self.offset.y, angle, scale, scale)
end

function ImageHandle:clear()
  self.image = nil
  self.offset = nil
end

--tile constants
TILE_HEIGHT = 64
TILE_WIDTH = 64

TileHandle = Class
{__includes = ImageHandle,
  init = function(self, path, filename, tileData, tileWidthSpacing, tileHeightSpacing)
    self.image = love.graphics.newImage(path..filename)
    self.quads = {}
    self.tileData = tileData

    self:createQuads()
    self:createSpriteBatch()
    self:addSprites(tileWidthSpacing, tileHeightSpacing)

    self.offset = Vector(0, 0)
  end
}

function TileHandle:createQuads()
  local tiles_x, tiles_y = self.image:getDimensions()

  --amount of tiles based on tile size constants
  tiles_x = math.floor(tiles_x/TILE_WIDTH)
  tiles_y = math.floor(tiles_y/TILE_HEIGHT)

  for i=1, tiles_y do
    for j=1, tiles_x do
      --create a quad for each sprite in the image going left to right, then top to bottom
      --stores them all sequentially in a table
      self.quads[ ((i-1) * j) + j ] = love.graphics.newQuad(
            (j - 1) * TILE_WIDTH, (i - 1) * TILE_HEIGHT,
            TILE_WIDTH, TILE_HEIGHT,
            tiles_x * TILE_WIDTH, tiles_y * TILE_HEIGHT)
    end
  end
end

function TileHandle:createSpriteBatch()
  self.spriteBatch = love.graphics.newSpriteBatch(self.image, 1000, "static")
end

function TileHandle:addSprites(tileWidthSpacing, tileHeightSpacing)
  tileWidthSpacing = tileWidthSpacing or 0
  tileHeightSpacing = tileHeightSpacing or 0

  for i,v in ipairs(self.tileData) do --iterates through each row (v) of map (tileData)
    for ii, vv in ipairs(v) do --iterates for each element (vv) in the row (v)
      self.spriteBatch:add( self.quads[vv],
      (ii - 1) * tileWidthSpacing, (i - 1) * tileHeightSpacing)
    end
  end
end

function TileHandle:draw(position)
  if debug then
    love.graphics.setColor(DEBUG_COLOR_IMAGE) --fill debug circle for debug
    love.graphics.circle("fill", position.x, position.y, 8)
    love.graphics.setColor(255, 255, 255)
  end

  love.graphics.draw(self.spriteBatch, position.x + self.offset.x, position.y + self.offset.y, rotation or 0)
end
