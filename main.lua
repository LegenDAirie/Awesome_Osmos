
local Cell = require("cell")

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

local cellContainer = {}

for i = 1, 15 do
  cellContainer[i] = Cell:createRandom()
end

local playerCell = Cell:create({x=centerX, y=centerY},{x=0, y=0}, 25)
cellContainer[#cellContainer+1] = playerCell

local function moveThingy(event)
  local dx = playerCell.x - event.x
  local dy = playerCell.y - event.y

  local magnitude = math.sqrt(dx * dx + dy * dy)
  local normalizedVector = {
    x = dx / magnitude,
    y = dy / magnitude
  }


  local scale = .9
  playerCell:scale(scale, scale)
  local radius = playerCell:currentRadius()
  local newRadius = radius * math.sqrt(.1)

  local force = {x = -normalizedVector.x, y  = -normalizedVector.y}
  playerCell.velocity.x = playerCell.velocity.x + force.x
  playerCell.velocity.y = playerCell.velocity.y + force.y

  local ejectedCell = Cell:create({
    x = playerCell.x + normalizedVector.x * (radius + newRadius),
    y = playerCell.y + normalizedVector.y * (radius + newRadius)
  },{
    x = -force.x,
    y = -force.y
  }, newRadius)

  cellContainer[#cellContainer+1] = ejectedCell
end

function pokeHandler(event)
  if ( event.phase == "began" ) then
    moveThingy(event, moveThingy)
  end
end

Runtime:addEventListener( "touch", pokeHandler )

local tick = function( event )
  for i = 1, #cellContainer do
    local cell = cellContainer[i]
    cell:move()
  end

  for _, cell in ipairs(cellContainer) do
    for _, otherCell in ipairs(cellContainer) do
      if cell ~= otherCell then
        if cell:isCollidedWith(otherCell) then
          cell:collideWithCell(otherCell)
        end
      end
    end
  end

  local newCells = {}
  for _, cell in ipairs(cellContainer) do
    if cell:currentRadius() > 1 then
      newCells[#newCells + 1] = cell
    else
      cell:removeSelf()
    end
  end

  cellContainer = newCells

end

Runtime:addEventListener( "enterFrame", tick )
