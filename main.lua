
-- local physics = require( "physics" )
-- physics.start()
-- physics.setGravity( 0, 0 )
-- physics.setDrawMode( "hybrid" )  --overlays collision outlines on normal display objects

local Cell = require("cell")

local GameThing = {}

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

local cellContainer = {}

for i = 1, 15 do
  cellContainer[i] = Cell:createRandom()
end

GameThing.cell = Cell:create({x=centerX, y=centerY},{x=0, y=0}, 100)

local function moveThingy(event)

  local cell = GameThing.cell

  local dx = cell.x - event.x
  local dy = cell.y - event.y

  local magnitude = math.sqrt(dx * dx + dy * dy)
  local normalizedVector = {
    x = dx / magnitude,
    y = dy / magnitude
  }


  local scale = .9

  cell:scale(scale, scale)
  local radius = cell:currentRadius()
  local newRadius = radius * math.sqrt(.1)

  local force = {x = -normalizedVector.x, y  = -normalizedVector.y}
  cell.velocity.x = cell.velocity.x + force.x
  cell.velocity.y = cell.velocity.y + force.y

  local ejectedCell = Cell:create({
    x = cell.x + normalizedVector.x * (radius + newRadius),
    y = cell.y + normalizedVector.y * (radius + newRadius)
  },{
    x = -force.x,
    y = -force.y
  }, newRadius)
  -- ejectedCell.velocity.x = -force.x
  -- ejectedCell.velocity.y = -force.y

  cellContainer[#cellContainer+1] = ejectedCell
end

function pokeHandler(event)
  if ( event.phase == "began" ) then
    moveThingy(event, moveThingy)
  end
end

Runtime:addEventListener( "touch", pokeHandler )

local tick = function( event )
  GameThing.cell:move()
  -- print(#cellContainer)
  for i = 1, #cellContainer do
    local cell = cellContainer[i]
    cell:move()
  end
end

Runtime:addEventListener( "enterFrame", tick )
