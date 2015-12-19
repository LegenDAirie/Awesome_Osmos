local random = math.random

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

local CELL_RADIUS_RANGE = {min=5, max=30}

Cell = {}
function Cell:create(x, y, radius)
  local cell = display.newCircle(x, y, radius)
  cell.radius = radius

  physics.addBody(cell, "dynamic", { density=.1, friction=0.0, bounce=0.0, radius=radius })

  return cell
end

function Cell:createRandom()
  local x = random(0, _W)
  local y = random(0, _H)
  local radius = random(CELL_RADIUS_RANGE.min, CELL_RADIUS_RANGE.max)

  return Cell:create(x, y, radius)
end

function Cell:moveThingy(event, GameThing)

  local oldCell = GameThing.cell

  local dx = oldCell.x - event.x
  local dy = oldCell.y - event.y

  local magnitude = math.sqrt(dx * dx + dy * dy)
  local normalizedVector = {
    x = dx / magnitude,
    y = dy / magnitude
  }

  local newRadius = 5

  local cell = Cell:create(oldCell.x, oldCell.y, oldCell.radius - newRadius)
  local ejectedCell = Cell:create(cell.x + normalizedVector.x * (cell.radius + newRadius + 1), oldCell.y + normalizedVector.y * (cell.radius + newRadius+ 1), newRadius)

  local force = {x = -normalizedVector.x * 2, y  = -normalizedVector.y * 2}
  cell:applyForce( force.x*100, force.y*100, cell.x, cell.y)
  ejectedCell:applyForce( -force.x, -force.y, cell.x, cell.y)

  oldCell:removeSelf()
  GameThing.cell = cell
  -- end
end


function Cell:onLocalCollision(event)
  local cell1 = event.target
  local cell2 = event.other

  local biggerCell
  local smallerCell
  if cell1.radius >= cell2.radius then
    biggerCell = cell1
    smallerCell = cell2
  else
    biggerCell = cell2
    smallerCelll = cell1
  end
end

function Cell:scaleCell(scale)

end
return Cell
