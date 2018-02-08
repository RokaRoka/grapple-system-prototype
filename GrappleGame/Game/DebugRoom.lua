--A gamestate for testing various aspects of the game
local debugRoom = {}
DEBUG_COLOR_BG = {60, 58, 55}

function debugRoom:init() -- called once before entering the state for the first time
  -- require game files --
  require("Platformer/object")
  require("Game/Player/Player")
  require("Game/Ground")
  require("Game/GrapplePoint")
end

function debugRoom:enter(previous, args) -- called when entering this state from another
  --constant variables
  DEBUGROOM_PLAYER_POSITION = {x = 128, y = love.graphics.getHeight() - 256}

  DEBUGROOM_GROUND1_WIDTH = 512 * 2
  DEBUGROOM_GROUND1_HEIGHT = 64
  DEBUGROOM_GROUND1_POSITION = Vector(DEBUGROOM_GROUND1_WIDTH/2, love.graphics.getHeight() - 32)

  DEBUGROOM_STAR_Y = Vector(0, love.graphics.getHeight() - (DEBUGROOM_GROUND1_HEIGHT * 5))
  DEBUGROOM_STAR1_POSITION = Vector(512 + 256, 0) + DEBUGROOM_STAR_Y

  --create physics world
  world = require("Platformer/physicsWorld")

  --Vectors are pass by ref, we need to be careful of that
  player = Player(DEBUGROOM_PLAYER_POSITION)
  player:initPhysics(world)

  ground1 = Ground(DEBUGROOM_GROUND1_POSITION)
  ground1:initPhysics(world, DEBUGROOM_GROUND1_WIDTH, DEBUGROOM_GROUND1_HEIGHT)

  star1 = GrapplePoint(DEBUGROOM_STAR1_POSITION)
  star1:initPhysics(world)

  if debug.myDebug then
    debug.setupGeneralPage()
  end
end

function debugRoom:update(dt) -- called in love.update
  setFPSupdate() -- set FPS update as first

  --update all objects
  Object.updateAll(dt)

  world:update(dt)

  if debug.myDebug then debug.updateCurrentPage() end
end

function debugRoom:draw() -- called in love.draw
  love.graphics.print("DebugRoom")
  love.graphics.setBackgroundColor(DEBUG_COLOR_BG) -- set temp BG color

  --draw all objects
  Object.drawAll()

  if touching then love.graphics.print(text, 64, 64) end

  if debug.myDebug then debug.draw() end

  love.graphics.setBackgroundColor(DEBUG_COLOR_BG) -- set temp BG color

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

  --Player key presses
  player:keypressed(key, isrepeat)
end

function debugRoom:keyreleased(key)
  --Player key releases
  player:keyreleased(key)
end

return debugRoom
