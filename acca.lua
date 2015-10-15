--[[

ACCA: Automatic Constructor for Character Animation in LÖVE

Copyright (C) 2015 Nelson Lombardo

License: MIT

Based on Bart Bes work.
]]

local anim_mt = {}
anim_mt.__index = anim_mt

function newCharacter(folder, element, ext, delay, default)
    local a = {
    list = {},
    action = {},
    actual = default,
    previous = ""
  }
  --love.graphics.print(folder.."/"..element, 0, 0)
  local actions = love.filesystem.getDirectoryItems(folder.."/"..element)
  for k, v in ipairs(actions) do
    --love.graphics.print(action, 0, 0)
    if love.filesystem.isDirectory(folder.."/"..element.."/"..v) then
      a.action[v] = {
        img = {},
        frames = 1,
        delays = {},
        timer = 0,
        position = 1,
        speed = 1,
        playing = true,
        mode = 1,
        direction = 1
      }
      table.insert(a.list, v)
      -- Need get all pictures
      local file = "01."..ext
      local path = folder.."/"..element.."/"..v.."/"
      while love.filesystem.exists(path..file) do
        a.action[v].img[a.action[v].frames] = love.graphics.newImage(path..file)
        a.action[v].frames = a.action[v].frames + 1
        if a.action[v].frames <= 9 then 
          file = "0"..a.action[v].frames.."."..ext
        else
          file = a.action[v].frames.."."..ext
        end
      end
      a.action[v].frames = a.action[v].frames - 1 
      -- Ready
      for i=1,a.action[v].frames do
        table.insert(a.action[v].delays, delay)
      end
    end
  end
  a.action[a.actual].playing = true
    return setmetatable(a, anim_mt)
end

function anim_mt:setAction(action)
  self.actual = action
  self.action[action].playing = true
end

function anim_mt:update(dt)
  local selfie = self.action[self.actual]
    if not selfie.playing then return end
    selfie.timer = selfie.timer + dt * selfie.speed
    if selfie.timer > selfie.delays[selfie.position] then
        selfie.timer = selfie.timer - selfie.delays[selfie.position]
        selfie.position = selfie.position + 1 * selfie.direction
    if selfie.position == 0 then
      selfie.position = selfie.frames
        elseif selfie.position > selfie.frames then
            if selfie.mode == 1 then
                selfie.position = 1
            elseif selfie.mode == 2 then
                selfie.position = selfie.position - 1
                self:stop()
            elseif selfie.mode == 3 then
                selfie.direction = -1
                selfie.position = selfie.position - 1
            end
        elseif selfie.position < 1 then 
      if selfie.mode == 2 then
        selfie.position = 1
        selfie:stop()
      elseif selfie.mode == 3 then
        selfie.direction = 1
        selfie.position = selfie.position + 1
      end
        end
    end
end

function anim_mt:setDirection (dir)
  local selfie = self.action[self.actual]
  if dir == "Forward" then
    selfie.direction = 1
  elseif dir == "Backward" then
    selfie.direction = -1
  end
end

function anim_mt:draw( x, y, angle, sx, sy)
  local selfie = self.action[self.actual]
  love.graphics.draw(selfie.img[selfie.position], x, y, angle, sx, sy)
end

function anim_mt:play()
  local selfie = self.action[self.actual]
  selfie.playing = true
end

function anim_mt:stop()
  local selfie = self.action[self.actual]
  selfie.playing = false
end

function anim_mt:reset()
  local selfie = self.action[self.actual]
  selfie:seek(0)
end

function anim_mt:seek(frame)
  local selfie = self.action[self.actual]
  selfie.position = frame
  selfie.timer = 0
end

function anim_mt:getCurrentFrame()
  local selfie = self.action[self.actual]
  return selfie.position
end

function anim_mt:getSize()
  local selfie = self.action[self.actual]
  return selfie.frames
end

function anim_mt:setDelay(frame, delay)
  local selfie = self.action[self.actual]
  self[self.action].delays[frame] = delay
end

function anim_mt:setSpeed(speed)
  local selfie = self.action[self.actual]
  self[self.action].speed = speed
end

function anim_mt:getWidth()
  return self[self.action].frames[self.position]:getWidth()
end

function anim_mt:getHeight()
  return self[self.action].frames[self.position]:getHeight()
end

function anim_mt:setMode(mode)
  local selfie = self.action[self.actual]
  if mode == "loop" then
        selfie.mode = 1
    elseif mode == "once" then
        selfie.mode = 2
    elseif mode == "bounce" then
        selfie.mode = 3
    end
end
