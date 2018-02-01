local objects = {}
--define objects
local grip = {}
local rope = {}

-- GRIP --

--set grip position data
grip.pos = {}
grip.pos.x = 320; grip.pos.y = 300
--set grip draw data
grip.radius = 16

--set grip functions
function grip.update(dt)
  --set position to physics position
  grip.pos.x, grip.pos.y = grip.body:getPosition()
end

function grip.draw()
  --draw the body of the player
  love.graphics.setColor(0, 32, 200)
  love.graphics.circle("fill", grip.pos.x, grip.pos.y, grip.radius)
  love.graphics.setColor(255, 255, 255)
end

objects.grip = grip

-- ROPE --
--set rope draw data
rope.pos = {}
rope.MAX_LENGTH = 96

function rope.update(dt)
  --set position to physics position
  rope.pos = {rope.joint:getAnchors()}
end

function rope.draw()
  --draw the body of the player
  love.graphics.setColor(200, 200, 200)
  love.graphics.line(rope.pos)
  love.graphics.setColor(255, 255, 255)
end

function rope.getDirection()
  --create vectors
  local direction = Vector(rope.pos[1] - rope.pos[3], rope.pos[2] - rope.pos[4])
  --return angle
  return direction:toPolar()
end

objects.rope = rope

return objects
