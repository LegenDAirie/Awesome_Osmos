local random = math.random

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local _W = display.contentWidth
local _H = display.contentHeight

local CELL_RADIUS_RANGE = {min=5, max=30}
local CELL_SPEED_RANGE = {min=-100, max=100}

local Cell = {}
function Cell:create(location, velocity, radius)
  local cell = display.newCircle(location.x, location.y, radius)
  cell.centerPoint = display.newCircle(location.x, location.y, radius * .05)
  cell.centerPoint:setFillColor(0, 0, 0, 1 )
  cell:setFillColor( 1, 1, 1, .5 )
  cell.originalRadius = radius
  cell.velocity = velocity

  function cell:move()
    self.x = self.x + self.velocity.x
    self.y = self.y + self.velocity.y
  end

  function cell:collideWithCell(otherCell)
    local cookieMonster
    local cookie
    if self:currentRadius() >= otherCell:currentRadius() then
      cookieMonster = self
      cookie = otherCell

      local pixelsToGrow = -self:distanceToOtherCell(otherCell) / 2

      cookieMonster:growRadiusByPixels(pixelsToGrow)
      cookie:growRadiusByPixels(-pixelsToGrow*2)
    end

  end

  function cell:growRadiusByPixels(pixels)
    local oldRadius = self:currentRadius()
    local newRadius = radius + pixels

    local scale = newRadius / oldRadius

    self:scale(scale, scale)
  end

  function cell:distanceToOtherCell(otherCell)
    local dx = self.x - otherCell.x
    local dy = self.y - otherCell.y
    local distance = math.sqrt(dx*dx + dy*dy)

    return distance - (self:currentRadius() + otherCell:currentRadius())
  end

  function cell:isCollidedWith(otherCell)
    return self:distanceToOtherCell(otherCell) <= 0
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
    x = random(CELL_SPEED_RANGE.min, CELL_SPEED_RANGE.max)/100,
    y = random(CELL_SPEED_RANGE.min, CELL_SPEED_RANGE.max)/100
  }
  local radius = random(CELL_RADIUS_RANGE.min, CELL_RADIUS_RANGE.max)

  return Cell:create(location, velocity, radius)
end


return Cell
