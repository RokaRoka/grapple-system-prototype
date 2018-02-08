--an update for when the player launches the grappling hook
function Player:grapplingUpdate(dt)
  self:grappleMove()
  local currentHookPosition = Vector(
    lume.lerp(self.pos.x, self.grappleTarget.pos.x,self.grappleCount/5),
    lume.lerp(self.pos.y, self.grappleTarget.pos.y,self.grappleCount/5)
  )
  self:updateGrapplePosition(currentHookPosition)
  if self:checkGrappleComplete() then
    self.grappleFired = false
    self:enterSwingState()
  end
end

function Player:grappleDraw()
  local oldColor = {love.graphics.getColor()}
  love.graphics.setColor(self.hookColor)
  local x1, y1 = self.pos:unpack()
  local x2, y2 = self.hookPosition:unpack()
  love.graphics.line(x1, y1, x2, y2)
  love.graphics.setColor( oldColor )
end

--starts the grappling update
function Player:fireGrappleHook()
  self.grappleFired = true
  self.grappleCount = 0
end

--when moving, player has four frames to catch grapple point
function Player:grappleMove()
  self.grappleCount = self.grappleCount + 1
end

function Player:checkGrappleComplete()
  if self.grappleCount > 4 then
    return true
  end
end

function Player:updateGrapplePosition(hookPosition)
  self.hookPosition = hookPosition
end
