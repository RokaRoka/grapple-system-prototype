--physics world
local world = love.physics.newWorld(0, 9.81)

--physics world settings

local beginContact = function(fixtureA, fixtureB, contact)
	Signal.emit('begin-contact'..'-'..fixtureA:getUserData().name, fixtureA, fixtureB, contact)
  Signal.emit('begin-contact'..'-'..fixtureB:getUserData().name, fixtureA, fixtureB, contact)
end
local endContact = function(fixtureA, fixtureB, contact)
	Signal.emit('end-contact'..'-'..fixtureA:getUserData().name, fixtureA, fixtureB, contact)
  Signal.emit('end-contact'..'-'..fixtureB:getUserData().name, fixtureA, fixtureB, contact)
end

world:setCallbacks(beginContact, endContact)

return world --return world to the file that called
