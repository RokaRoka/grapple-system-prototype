--A gamestate for testing various aspects of the game
local debugRoom = {}
DEBUG_COLOR_BG = {30, 25, 32}

function debugRoom:init() -- called once before entering the state for the first time
  -- require game files --
  require("Platformer/object")
  require("Game/Player")
  require("Game/Ground")
end

function debugRoom:enter(previous, args) -- called when entering this state from another
  --constant variables
  DEBUGROOM_PLAYER_POSITION = Vector(128, 128)

  DEBUGROOM_GROUND1_WIDTH = 512
  DEBUGROOM_GROUND1_HEIGHT = 64
  DEBUGROOM_GROUND1_POSITION = Vector(256, love.graphics.getHeight() - 32)

  --create physics world
  world = require("Platformer/physicsWorld")

  --test a player and ground
  player = Player(DEBUGROOM_PLAYER_POSITION)
  player:initPhysics(world)

  ground1 = Ground(DEBUGROOM_GROUND1_POSITION)
  ground1:initPhysics(world, DEBUGROOM_GROUND1_WIDTH, DEBUGROOM_GROUND1_HEIGHT)

  if debug then
    debug.setupGeneralPage()
  end
end

function debugRoom:update(dt) -- called in love.update
  setFPSupdate() -- set FPS update as first

  --update all objects
  Object.updateAll(dt)

  world:update(dt)

  if debug then debug.updateCurrentPage() end
end

function debugRoom:draw() -- called in love.draw
  love.graphics.print("DebugRoom")
  love.graphics.setBackgroundColor(DEBUG_COLOR_BG) -- set temp BG color

  --draw all objects
  Object.drawAll()

  if debug then debug.draw() end

  setFPSdraw() --set FPS draw as last
end

function debugRoom:leave()

end

function debugRoom:keypressed(key, scancode, isrepeat)
  --toggle hudebug
  if key == '~' and debug then
    debug.toggleHUDebug()
  end
  if key == 'tab' and debug then
    debug.togglePage()
  end
end

return debugRoom
