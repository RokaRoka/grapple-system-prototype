--A gamestate for testing various aspects of the game
local debugRoom = {}
DEBUG_COLOR_BG = {60, 58, 55}

function debugRoom:init() -- called once before entering the state for the first time
  -- require game files --
  require("Platformer/object")
  require("Game/Player/Player")
  require("Game/Ground")
  require("Game/GrapplePoint")
  require("Game/TheMoon")
end

function debugRoom:enter(previous, args) -- called when entering this state from another
  --constant variables
  DEBUGROOM_PLAYER_POSITION = {x = 64, y = 432}

  DEBUGROOM_GROUND1_WIDTH = 224 * 2
  DEBUGROOM_GROUND1_HEIGHT = 64
  DEBUGROOM_GROUND1_POSITION = Vector(DEBUGROOM_GROUND1_WIDTH/2, love.graphics.getHeight() - 32)

  DEBUGROOM_GROUND2_POSITION = Vector(DEBUGROOM_GROUND1_WIDTH * 2, love.graphics.getHeight() - 32)

  DEBUGROOM_GROUND3_POSITION = Vector(DEBUGROOM_GROUND1_WIDTH * 4, love.graphics.getHeight() - 32)

  DEBUGROOM_GROUND4_POSITION = Vector(DEBUGROOM_GROUND1_WIDTH * 6, love.graphics.getHeight() - 32)



  DEBUGROOM_STAR_Y = Vector(0,  - (DEBUGROOM_GROUND1_HEIGHT * 5))
  DEBUGROOM_STAR1_POSITION = DEBUGROOM_GROUND2_POSITION + Vector(64, 0) + DEBUGROOM_STAR_Y

  DEBUGROOM_STAR2_POSITION = DEBUGROOM_GROUND3_POSITION + Vector(64, 0) + DEBUGROOM_STAR_Y

  DEBUGROOM_STAR3_POSITION = DEBUGROOM_GROUND4_POSITION + Vector(64 * 3, 0) + DEBUGROOM_STAR_Y

  DEBUGROOM_STAR4_POSITION = DEBUGROOM_GROUND4_POSITION + Vector(64 * 9, 0) + DEBUGROOM_STAR_Y


  DEBUGROOM_GROUND5_POSITION = Vector(DEBUGROOM_GROUND1_WIDTH * 9, love.graphics.getHeight() - 32)
  DEBUGROOM_MOON_POSITION = DEBUGROOM_GROUND5_POSITION + Vector(128, -256)

  --create physics world
  world = require("Platformer/physicsWorld")

  --create camera
  cam = require("Platformer/followingCamera")

  moon = Moon(DEBUGROOM_MOON_POSITION)

  --Vectors are pass by ref, we need to be careful of that
  player = Player(DEBUGROOM_PLAYER_POSITION)
  player:initPhysics(world)

  --set cam to follow player
  cam.init(player)

  ground1 = Ground(DEBUGROOM_GROUND1_POSITION)
  ground1:initPhysics(world, DEBUGROOM_GROUND1_WIDTH, DEBUGROOM_GROUND1_HEIGHT)

  ground2 = Ground(DEBUGROOM_GROUND2_POSITION)
  ground2:initPhysics(world, DEBUGROOM_GROUND1_WIDTH, DEBUGROOM_GROUND1_HEIGHT)

  ground3 = Ground(DEBUGROOM_GROUND3_POSITION)
  ground3:initPhysics(world, DEBUGROOM_GROUND1_WIDTH, DEBUGROOM_GROUND1_HEIGHT)

  ground4 = Ground(DEBUGROOM_GROUND4_POSITION)
  ground4:initPhysics(world, DEBUGROOM_GROUND1_WIDTH, DEBUGROOM_GROUND1_HEIGHT)

  ground4 = Ground(DEBUGROOM_GROUND5_POSITION)
  ground4:initPhysics(world, DEBUGROOM_GROUND1_WIDTH, DEBUGROOM_GROUND1_HEIGHT)


  star1 = GrapplePoint(DEBUGROOM_STAR1_POSITION)
  star1:initPhysics(world)

  star2 = GrapplePoint(DEBUGROOM_STAR2_POSITION)
  star2:initPhysics(world)

  star3 = GrapplePoint(DEBUGROOM_STAR3_POSITION)
  star3:initPhysics(world)

  star4 = GrapplePoint(DEBUGROOM_STAR4_POSITION)
  star4:initPhysics(world)

  if debug.myDebug then
    debug.setupGeneralPage()
  end
end

function debugRoom:update(dt) -- called in love.update
  setFPSupdate() -- set FPS update as first

  --update world
  world:update(dt)

  --update all objects
  Object.updateAll(dt)

  cam:update()

  if debug.myDebug then debug.updateCurrentPage() end
end

function debugRoom:draw() -- called in love.draw
  love.graphics.print("Moonman Goes Home - Escape To Quit")
  love.graphics.setBackgroundColor(DEBUG_COLOR_BG) -- set temp BG color

  --draw all objects
  cam.camera:draw(Object.drawAll)

  if touching then love.graphics.print(text, 64, 64) end

  if debug.myDebug then debug.draw() end

  love.graphics.setBackgroundColor(DEBUG_COLOR_BG) -- set temp BG color

  setFPSdraw() --set FPS draw as last
end

function debugRoom:leave()
  Object.clearAll()
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

function restartLevel()
  return Gamestate.switch(debugRoom)
end

return debugRoom
