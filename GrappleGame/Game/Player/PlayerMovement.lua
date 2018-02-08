function Player:movement(dt)
  --set the y grav on these jank physics
  local _
  _, self.moveVelocity.y = self.physicsHandle.body:getLinearVelocity()

  --x velocity math
  --if holding a direction, accelerate
  if self.inputDirectionHeld.x > 0 or self.inputDirectionHeld.x < 0 then
    if not self.swinging then
      self:accelerate()
    else
      --swing influence
      self:influenceSwingSpeed()
    end
  elseif self.moveVelocity.x < 0 or self.moveVelocity.x > 0 then
    --decelerate since input is not held
    self:decelerate()
  end

  --y velocity math
  if not self.grounded then
    --apply additional grav to velocity y
    self:applyGravity()
  end

  if self.jumping then
    self:applyJump()
    self.airTime = self.airTime + dt
    if self.airTime > self.maxJumpTime then
      self.airTime = 0
      self.jumping = false
    end
  end

  --update movement
  self.lastVelocityX = self.moveVelocity.x
  self:updateVelocity()
end

function Player:getMomentum()
  self.momentum = self.moveVelocity:len()
end

--updates moveVelocity
function Player:accelerate()
  --get the direction held by the player
  local sign = lume.sign(self.inputDirectionHeld.x)
  self.moveVelocity.x = self.moveVelocity.x + self.moveAccel * sign
  if sign > 0 then
    self.moveVelocity.x = lume.clamp(self.moveVelocity.x, 0, self.moveTopSpeed)
  else
    self.moveVelocity.x = lume.clamp(self.moveVelocity.x, self.moveTopSpeed * -1 , 0)
  end
end

--updates moveVelocity
function Player:decelerate()
  --get the direction of movement first
  local sign = lume.sign(self.moveVelocity.x)
  if self.grounded then
    if sign > 0 then
      self.moveVelocity.x = lume.clamp(self.moveVelocity.x - self.moveDecel, 0, self.moveTopSpeed)
    else
      self.moveVelocity.x = lume.clamp(self.moveVelocity.x + self.moveDecel, self.moveTopSpeed *-1 , 0)
    end
  elseif self.moveVelocity.y > -4 or self.swinging then
    self.moveVelocity.x = self.moveVelocity.x * self.airDrag
  end
end

function Player:applyGravity()
  --if not colliding with ground <- add This
  self.moveVelocity.y = self.moveVelocity.y + self.gravY
end

function Player:updateVelocity()
  self.physicsHandle.body:setLinearVelocity(self.moveVelocity:unpack())
end

function Player:applyJump()
  self.moveVelocity.y = self.jumpPower
end
