local Player = require('Player')
local GameState = require('GameState')
local Util = require('Utilities')
local SpikeHandler = require('SpikeHandler')
local ScreenSettings = require('ScreenSettings')

-- Assets
local spike = love.graphics.newImage('Assets/spike.png')
local wallHit = love.audio.newSource('Assets/WallHit.wav', 'static')

-- Calculate amount of spikes based on player's score
local function calculateAmount()
    if Player.score >= 100 then
        return math.random(15,20)
    elseif Player.score >= 75 then
        return math.random(10,20)
    elseif Player.score >= 50 then
        return math.random(5,15)
    elseif Player.score >= 25 then
        return math.random(4,10)
    elseif Player.score >= 10 then
        return math.random(2,6)
    elseif Player.score < 10 then
        return math.random(1,5)
    end
end

-- Check if player has hit the bottom or top border
local function playerHitBorder()
    return Player.y + Player.height < Player.height * 2 or Player.y + Player.height > ScreenSettings.height
end
 
-- Check if player is inside spikes
local function playerHitSpikes()
    local hit = false

    for _,spikePos in pairs(SpikeHandler.spikeCoordinates) do
        if (not spikePos.rotation and Player.xSpeed < 0) or (spikePos.rotation and Player.xSpeed > 0) then
            if Util:isInside(Player, spikePos) then
                hit = true
                break
            end
        end
    end

    return hit
end

local function flap()
    -- Player flaps up
    if not GameState.disabled then
        Player.ySpeed = Player.flapStrength
    end

    if not GameState.started then
        GameState.started = true
    end

    if GameState.canShowHighScore then
        GameState.canShowHighScore = false
    end
end

-- Loading the game
function love.load()
    love.window.setMode(ScreenSettings.width, ScreenSettings.height)
    love.window.setTitle('ball game')
end

-- Updating logic every frame
function love.update(dt)
    if not GameState.started then return end
    -- Apply gravity
    Player.ySpeed = Player.ySpeed + Player.gravity * dt

    -- Move the player vertically
    Player.y = Player.y + Player.ySpeed * dt

    -- Move the player horizontally (constant speed)
    Player.x = Player.x + Player.xSpeed * dt

    -- Handle player bouncing off walls
    if Player.x + Player.width > ScreenSettings.width and not GameState.disabled then -- Hit right wall
        Player.x = ScreenSettings.width - Player.width
        Player.xSpeed = -math.abs(Player.xSpeed) -- Move left
        Player:addScore(1)
        wallHit:play()

        SpikeHandler:removeSpikes()

        SpikeHandler:spawnSpikes(calculateAmount(), calculateAmount())
    elseif Player.x - Player.width + 20 < 0 and not GameState.disabled then -- Hit left wall
        Player.x = Player.width
        Player.xSpeed = math.abs(Player.xSpeed) -- Move right
        Player:addScore(1)
        wallHit:play()

        SpikeHandler:removeSpikes()

        SpikeHandler:spawnSpikes(calculateAmount(), calculateAmount())
    end

    -- Check if the player hits the top or bottom of the screen, or the spikes
    if (playerHitBorder() or playerHitSpikes()) and not GameState.disabled then
        Player.gravity = 0
        Player.ySpeed = 0
        Player.xSpeed = 0

        GameState.gameOverTime = love.timer.getTime()
        GameState.disabled = true

        local highScore = tonumber((love.filesystem.read('save.dat'))) or 0
        if Player.score > highScore then
            love.filesystem.write('save.dat', tostring(Player.score))
        end
    end
end

-- Drawing graphics each frame
function love.draw()
    local bgColor, plrColor = GameState:ScoreColors(Player)
    love.graphics.setColor(bgColor.r or 1, bgColor.g or 1, bgColor.b or 1)

    love.graphics.rectangle('fill', 0, 0, ScreenSettings.width, ScreenSettings.height)

    love.graphics.setColor(plrColor.r or 0, plrColor.g or 0, plrColor.b or 0)

    love.graphics.setFont(love.graphics.newFont(40))

    local scoreWidth = love.graphics.getFont():getWidth(Player.score)
    love.graphics.print(Player.score, (ScreenSettings.width - scoreWidth) / 2, 10)

    if GameState.canShowHighScore then
        love.graphics.setFont(love.graphics.newFont(20))
        local highScore = 'Highscore: ' .. tostring((love.filesystem.read('save.dat') or 0))
        local highScoreWidth = love.graphics.getFont():getWidth(highScore)
        love.graphics.print(highScore, (ScreenSettings.width - highScoreWidth) / 2, 75)
        love.graphics.setFont(love.graphics.newFont(40))
    end

    love.graphics.circle('fill', Player.x + Player.width / 2, Player.y + Player.height / 2, Player.width / 2)
    --love.graphics.rectangle('fill', Player.x, Player.y, Player.width, Player.height)

    if GameState.disabled then
        local gameOverWidth = love.graphics.getFont():getWidth('Game over.')
        local gameOverHeight = love.graphics.getFont():getHeight('Game over.')

        love.graphics.print('Game over.', (ScreenSettings.width - gameOverWidth) / 2,(ScreenSettings.height - gameOverHeight) / 2)

        -- Quit the game after 3 seconds
        if love.timer.getTime() > GameState.gameOverTime + 3 then
            love.event.quit('Game over.')
        end
    end
    
    for i, spikePos in pairs(SpikeHandler.spikeCoordinates) do
        love.graphics.draw(spike, spikePos.x - (spikePos.rotation and 10 or -5), spikePos.y - 5, spikePos.rotation, 1, 1, spikePos.rotation and 25 or 0, spikePos.rotation and 20 or 0)

        --love.graphics.setColor(1, 0, 0) -- Debugging spikes
        --love.graphics.rectangle('fill', spikePos.x, spikePos.y, spikePos.width, spikePos.height)
        --love.graphics.setFont(love.graphics.newFont(20))
        --love.graphics.print(i, spikePos.x, spikePos.y)
    end

    if not GameState.started then
        love.graphics.setFont(love.graphics.newFont(20))
        local gameStartWidth = love.graphics.getFont():getWidth("Press 'Space' to start.")
        local gameStartHeight = love.graphics.getFont():getHeight("Press 'Space' to start.")

        love.graphics.print("Press 'Space' to start.", (ScreenSettings.width - gameStartWidth) / 2,(ScreenSettings.height - gameStartHeight) / 2)
    end
end

function love.keypressed(key)
    if key == 'space' then
        flap()
    end
end

function love.mousepressed()
    flap()
end
