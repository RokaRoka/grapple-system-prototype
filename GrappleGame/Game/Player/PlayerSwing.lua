function Player:swingUpdate(dt)
  self:checkForStandstill()
  self:rotateToRope()
end

function Player:enterSwingState()
  self.swinging = true
  self.grappledTo = self.grappleTarget
  self:setRope()
end

function Player:exitSwingState()
  self.swing = false
  self.rope:destroy()
end

function Player:setRope()
  local x1, y1 = self.pos:unpack()
  local x2, y2 = self.grappleTarget.pos:unpack()
  self.rope = love.physics.newRopeJoint(
    self.physicsHandle.body, self.grappleTarget.physicsHandle.body,
    x1, y1, x2, y2,
    self.grappleLength
  )
end

function Player:influenceSwingSpeed()
  local sign = lume.sign(self.inputDirectionHeld.x)
  if self.influence > 0 then
    self.influence = self.influence - self.swingAccel * sign
    if self.influence < 0 then
      self.moveVelocity.x = self.physicsHandle.body:getLinearVelocity() + (self.swingAccel + self.influence) * sign
    else
      self.moveVelocity.x = self.physicsHandle.body:getLinearVelocity() + (self.swingAccel * sign)
    end
  end
end

function Player:checkForStandstill()
  if lume.sign(self.lastVelocityX) ~= lume.sign(self.moveVelocity.x) or
     self.lastVelocityX == 0 then
    self.influence = self.influenceRefill
  end
end

function Player:setAngle(angle)
  self.debugLog = "Angle: "..angle
  self.angle = angle
  self.physicsHandle.body:setAngle(self.angle)
end

function Player:rotateToRope()
  --find perpendicular direction to rope
  local x1, y1, x2, y2 = self.rope:getAnchors()
  local angle = math.atan2(y1 - y2, x1 - x2)
  --set rotation
  self:setAngle(angle - 0.5*math.pi)
end
