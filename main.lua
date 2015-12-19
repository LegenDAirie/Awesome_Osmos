
local physics = require( "physics" )
physics.start()
physics.setGravity( 0, 0 )
physics.setDrawMode( "hybrid" )  --overlays collision outlines on normal display objects

local Cell = require("cell")

local GameThing = {}

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

local cellContainer = {}

-- for i = 1, 15 do
--   cellContainer[i] = Cell:createRandom()
-- end

GameThing.cell = Cell:create(centerX, centerY, 100)

function pokeHandler(event)
  if ( event.phase == "began" ) then
    Cell:moveThingy(event, GameThing)
  end
end

function collisionHandler ()
  
end

Runtime:addEventListener( "touch", pokeHandler )
Runtime:addEventListener( "collision", collisionHandler )
