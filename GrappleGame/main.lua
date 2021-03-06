-- LIBRARIES --

--hump library
Vector = require("Libraries.hump.vector")
Class = require("Libraries.hump.class")
Gamestate = require("Libraries.hump.gamestate")
Signal = require("Libraries.hump.signal")
Camera = require("Libraries.hump.camera")

--lume library
lume = require("Libraries.lume.lume")

--HUDebug library
hudebug = require("Libraries.hudebug.hudebug")

-- OTHER DEPENDANCIES --
--FPScap
--note: FPScap needs to be handled in specific gamestate, due to calling
-- realted FPS draw and update functions
require("Platformer.FPScap")

--DebugState Gamestate
--note: this state is for testing anything one specific thing in the game
-- never more than one mechanic at the time!
debug = require("Platformer.debug")

function love.load(args)
  --debug room
  local debugRoom = require("Game/DebugRoom")


  Gamestate.registerEvents()
  Gamestate.switch(debugRoom)
end

function love.update(dt)
  --updating
end

function love.draw()
  --drawing
end

function love.keypressed(key, scancode, isrepeat)
  if key == "escape" then
    love.event.quit()
  end
end

function love.keyreleased(key)
  --body
end
