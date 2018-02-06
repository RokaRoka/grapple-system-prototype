--to contain all debug actions in on table
local debug = {}

if not hudebug then --make sure that hudebug is made
  hudebug = require("Libraries.hudebug.hudebug")
end

hudebug.toggle()

--my own variable for tracking info
debug.info = {}

--set position to far right of screen
hudebug.setPosition(love.graphics.getWidth() - 128 * 2, 0)

function debug.setupGeneralPage()
  debug.setupNewPage("General", {
    {"page-count", function() return "Debug Pages: "..hudebug.pageCount end},
    {"fps", function() return "FPS: "..love.timer.getFPS() end},
  })
end

--info is passed. info contain a name and a function to use
function debug.setupNewPage(pageName, info)
  hudebug.pageName(hudebug.pageCount + 1, pageName)
  debug.info[hudebug.pageCount] = info
  return hudebug.pageCount
end

--Add info example:
--[[
  debug.addInfo(self.debugPage,
    {"physics-position",
    function()
      local x, y = self.physicsHandle.body:getPosition()
      return "Physics Position: ("..math.floor(x)..", "..math.floor(y)..")"
    end}
  )
]]
function debug.addInfo(pageNum, info)
  table.insert(debug.info[pageNum], info)
end

function debug.updateCurrentPage()
  for i,v in ipairs(debug.info[hudebug.page]) do
    --update each line in current page
    hudebug.updateMsg( hudebug.page, v[1], v[2]() )
  end
end

function debug.draw()
  hudebug.draw() --draw hudebug

  love.graphics.setColor(255, 255, 255) -- set color to default white
end

function debug.toggleHUDebug()
  hudebug.toggle()
end

function debug.togglePage()
  hudebug.nextPage()
end

return debug
