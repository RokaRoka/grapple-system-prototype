function Player:swingUpdate(dt)
  self:updateMomentum()
  self:checkSwingDirection()
  self:checkForStandstill()
  self:rotateToRope()
end

function Player:enterSwingState()
  self.swinging = true
  self.grappledTo = self.grappleTarget
  self:setRope()
  self:rotateToRope()

  if self.pos.y < self.grappledTo.pos.y then
    self.swingRight = self.moveVelocity.x > 0
  else
    self.swingRight = self.moveVelocity.x < 0
  end
  --self:momentumToVelocity()
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
    self.grappleLength, true
  )
end

function Player:checkSwingDirection()
  local sign = lume.sign(self.moveVelocity.x)
  local sign2 = lume.sign(self.lastVelocityX)
  if sign ~= sign2 then
    self.swingRight = not self.swingRight
  end
end

function Player:momentumToVelocity()
  if self.swingRight then
    self.moveVelocity = Vector.fromPolar(self.angle, self.momentum)
  else
    self.moveVelocity = Vector.fromPolar(self.angle + math.pi * 2, self.momentum * self.airDrag) --apply drag for better feeling
  end
end

function Player:influenceSwingSpeed()
  if self.influence > 0 then
    --self.momentum = self.momentum + self.swingAccel
    self.moveVelocity.x = self.moveVelocity.x + self.swingAccel * lume.sign(self.inputDirectionHeld.x)
    self.influence = self.influence - self.swingAccel
    --[[
    if self.influence < 0 then
      self.moveVelocity.x = self.physicsHandle.body:getLinearVelocity() + (self.swingAccel + self.influence) * sign
    else
      self.moveVelocity.x = self.physicsHandle.body:getLinearVelocity() + (self.swingAccel * sign)
    end
    ]]
  end
end

function Player:ropeTension()
  --local angle = self:getRopeAngle() - 0.5*math.pi
  --local tension =  self.gravY * math.cos(angle) --the rest of the "gravY" is gravTangent!
  --local gravTangent = self.gravY - tension
  --self.moveVelocity.y = self.moveVelocity.y - tension
  local tensionX, tensionY = self.rope:getReactionForce(3/60)

  self.moveVelocity.y = self.moveVelocity.y - tensionY * love.physics.getMeter()
  self.moveVelocity.x = self.moveVelocity.x - tensionX * love.physics.getMeter()

  self.debugLog = "Tensions x and y"..lume.round(tensionX).." "..lume.round(tensionY)
end

function Player:gravityCleanup()
  local tensionX, tensionY = self.rope:getReactionForce(3/60)
  if math.abs(self.moveVelocity.x) < 8 and lume.round(self.moveVelocity.y * 32) == lume.round(tensionY * 32) then
    self.moveVelocity.y = 0
  end
end

function Player:checkForStandstill()
  if lume.sign(self.lastVelocityX) ~= lume.sign(self.moveVelocity.x) or
     self.lastVelocityX == 0 then
    self.influence = self.influenceRefill
  end
end

function Player:setAngle(angle)
  self.angle = angle
  self.physicsHandle.body:setAngle(self.angle)
end

function Player:getRopeAngle()
  local x1, y1, x2, y2 = self.rope:getAnchors()
  return math.atan2(y1 - y2, x1 - x2)
end

function Player:rotateToRope()
  local angle = self:getRopeAngle()
  --set rotation
  self:setAngle(angle - 0.5*math.pi)
end
