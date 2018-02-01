local player = {}

--Player mechanic data--
player.inputDirectionHeld = Vector(0, 0)
player.inputAngle = 0
player.influencedDirection = Vector(0, 0)


--player physics data--
player.moveSpeed = Vector(0, 0)

--Movement data
player.moveAccel = 0.45
player.moveDeccel = 0.55
player.moveTop = 8

--air movement data
player.airAccel = 0.35

--swinging data
player.swingSpeed = Vector(0, 0)

--set player position data--
player.pos = {}
player.pos.x = 320; player.pos.y = 320
player.rotation = 0

--set player draw data--
player.width = 32
player.height = 64

--define player update and draw functions--
function player.update(dt)
  --set position to physics position
  player.pos.x, player.pos.y = player.body:getPosition()
  --set rotation to rope rotation
  --player.rotation = rope.getDirection()

  --influence swing for next physics update
  if player.inputDirectionHeld:len() > 0 or player.inputDirectionHeld:len() < 0 then
    --move player--
    --influence swing--
    player.influenceSwing(player.inputDirectionHeld)
  end
end
--[[
function player.draw()
  --draw the body of the player
  love.graphics.setColor(0, 132, 132)
  love.graphics.rectangle("fill", player.pos.x - player.width/2, player.pos.y - player.height/2, player.width, player.height)
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("Player Angle: "..player.rotation, player.pos.x - 48, player.pos.y + 48)
  love.graphics.print("Player Input: "..player.inputDirectionHeld:__tostring(), player.pos.x - 48, player.pos.y + 64)
  love.graphics.print("Player Input Angle:"..player.inputAngle.." radians", player.pos.x - 48, player.pos.y + 96)
  love.graphics.print("Player Swing Influence: "..player.influencedDirection:__tostring(), player.pos.x - 64, player.pos.y + 80)
end

-- PLAYER MECHANIC FUNCTIONS --

--Influence Swing
--Argument: Takes a direction/input for where the player wants to go
--Function: Adds force to the player either forward or backward based on the direction
function player.influenceSwing(direction)
  local inputAngle
  local forceVector

  --find whether the direction moves the player forward or backward
  inputAngle = direction:toPolar()
  player.inputAngle = inputAngle.x/math.pi

  if math.abs(inputAngle.x + (0.5 * math.pi)) > math.abs(player.rotation) and math.abs(inputAngle.x - (0.5 * math.pi)) < math.abs(player.rotation) then
    --player is moving forward
    forceVector = Vector.fromPolar(player.rotation)
  else
    --player is moving backward
    forceVector = Vector.fromPolar(player.rotation - 1 * math.pi)
  end

  player.influencedDirection = forceVector
  --add force to player forward/backward direction
  player.body:applyForce((forceVector * player.airAccel * 10):unpack())

  --cleanup

end

--]]

return player
