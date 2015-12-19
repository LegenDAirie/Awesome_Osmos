local random = math.random

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

local CELL_RADIUS_RANGE = {min=5, max=30}

local Cell = {}
function Cell:create(location, velocity, radius)
  local cell = display.newCircle(location.x, location.y, radius)
  cell.radius = radius
  cell.originalRadius = radius
  cell.velocity = velocity

  function cell:move()
    self.x = self.x + self.velocity.x
    self.y = self.y + self.velocity.y
  end

  function cell:currentRadius()
    return self.xScale * self.originalRadius
  end

  return cell
end

function Cell:createRandom()
  local location = {
    x = random(0, _W),
    y = random(0, _H)
  }
  local velocity = {
    x = random(-1, 1),
    y = random(-1, 1)
  }
  local radius = random(CELL_RADIUS_RANGE.min, CELL_RADIUS_RANGE.max)

  return Cell:create(location, velocity, radius)
end

-- function Cell:moveThingy(event, GameThing)
--
--   local cell = GameThing.cell
--
--   local dx = cell.x - event.x
--   local dy = cell.y - event.y
--
--   local magnitude = math.sqrt(dx * dx + dy * dy)
--   local normalizedVector = {
--     x = dx / magnitude,
--     y = dy / magnitude
--   }
--
--   local newRadius = 5
--
--   cell.radius = cell.xScale*cell.width
--   cell.size= .9 * cell.radius
--
--   -- local cell = Cell:create(cell.x, cell.y, cell.radius - newRadius)
--   -- cell.radius = cell.radius - 5
--   cell:scale(cell.size, cell.size)
--   -- print(cell.width)
--   -- print(cell.xScale*cell.width)
--   cell.size = 1
--   -- cell.yScale = 1
--   local ejectedCell = Cell:create(cell.x + normalizedVector.x * (cell.radius + newRadius + 1), cell.y + normalizedVector.y * (cell.radius + newRadius+ 1), newRadius)
--
--   local force = {x = -normalizedVector.x * 2, y  = -normalizedVector.y * 2}
--   cell.velocity.x = cell.velocity.x + force.x
--   cell.velocity.y = cell.velocity.y + force.y
--
--
--   -- cell:removeSelf()
--   -- GameThing.cell = cell
--   -- end
-- end


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

function Cell:sizeCell(size)

end

-- setmetatable(CellMetatable, Cell)
setmetatable(Cell, CellMetatable)
return Cell
