# ACCA
Automatic constructor for character animation in LÖVE.

# Overview

It's a simple library for use when you need a easy way to animate characters
working on LÖVE framework.
In relation with the artistic part, in this case you use separate image with
the character movements. The structure of folder tree is what define the
actions.
The library make an object that contain all movements and actions in tree-folder
structure.

#Example of use

Imagine this tree-folder content:

.
├── img
│   └── Scorpion
│       ├── Dizzy
│       │   ├── 01.gif
│       │   ├── 02.gif
│       │   ├── 03.gif
│       │   ├── 04.gif
│       │   ├── 05.gif
│       │   ├── 06.gif
│       │   └── 07.gif
│       ├── Ducking
│       │   ├── 01.gif
│       │   ├── 02.gif
│       │   └── 03.gif
│       ├── Stance
│       │   ├── 01.gif
│       │   ├── 02.gif
│       │   ├── 03.gif
│       │   ├── 04.gif
│       │   ├── 05.gif
│       │   ├── 06.gif
│       │   └── 07.gif
│       └── Walking
│           ├── 01.gif
│           ├── 02.gif
│           ├── 03.gif
│           ├── 04.gif
│           ├── 05.gif
│           ├── 06.gif
│           ├── 07.gif
│           ├── 08.gif
│           └── 09.gif
├── lib
│   └── acca.lua
└── main.lua

Where `img` is the folder where we save the images for our game. Now, the
Scorpion folder is your character and the subdirectories are the actions.
Every single image inside the action is a piece of whole movement of action.

To create a object with the complete set of animations for a single
character, you need use `newCharacter` method:

```lua

Scorpion = newCharacter("img","Scorpion", "gif", 0.1, "Stance")

```

In this example the delay is set to 0.1 seconds and the default action is
«Stance».

See the next main.lua as guideline:

```lua

-- Example: Create and use an Animation
love.filesystem.load("lib/acca.lua")()
x = 400
y = 300

function love.load()
  Scorpion = newCharacter("img","Scorpion", "gif", 0.1, "Stance")
  love.mouse.setVisible = false
end

function love.update(dt)
    -- The animation must be updated so it 
    -- knows when to change frames.
    Scorpion:update(dt)
  if love.keyboard.isDown("left") then
    x = x - 100 * dt
    Scorpion:setAction("Walking")
    Scorpion:setDirection("Backward")
  elseif love.keyboard.isDown("right") then
    x = x + 100 * dt
    Scorpion:setAction("Walking")
    Scorpion:setDirection("Forward")
  elseif love.keyboard.isDown("up") then
    --y = y - 100 * dt
    Scorpion:setAction("Ducking")
    Scorpion:setDirection("Backward")
    Scorpion:setMode("once")
  elseif love.keyboard.isDown("down") then
    --y = y + 100 * dt
    Scorpion:setAction("Ducking")
    Scorpion:setDirection("Forward")
    Scorpion:setMode("once")
  else
    Scorpion:setAction("Stance")
    Scorpion:setDirection("Forward")
  end
end

function love.draw()
    -- Draw the animation the center of the screen.
    Scorpion:draw(x, y, 0, 1, 1)
end

function love.keypressed(key)
  if key == "f" then
    if love.window.getFullscreen() == true then
      love.window.setFullscreen(false)
    else
      love.window.setFullscreen(true)
    end
  elseif key == "escape" then
    love.quit()
  end
end 

```

The previous example in [action](https://www.youtube.com/watch?v=KP3Gh7Dj8gE)

Happy hacking!
