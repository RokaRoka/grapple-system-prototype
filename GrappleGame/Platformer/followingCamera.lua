local followCamera = {}

followCamera.camera = Camera(0, 0)

followCamera.active = false

function followCamera.init(player)
  followCamera.player = player
  --followCamera.lastPlayerPos = player.pos
  followCamera.active = true

  if debug.myDebug then
    debug.setupNewPage("Camera Debug",
    {
      {"position", function()
        local x, y = followCamera.camera:position()
        return "Position: "..x..", "..y  end}
    })
  end
end

function followCamera:update()
  if player.swinging then
    local x, y = player.grappledTo.pos:unpack()
    followCamera.camera:lockPosition(x, y, Camera.smooth.damped(4))
  else
    if player.pos.x > followCamera.camera.x + 48 or player.pos.x < followCamera.camera.x + 48 then
      followCamera.camera:lockX(player.pos.x, Camera.smooth.damped(3))
    end
    followCamera.camera:lockY(player.pos.y - 64)
  end

end

return followCamera
