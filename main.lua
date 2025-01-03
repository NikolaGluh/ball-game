local Player = require('Player')
local GameState = require('GameState')
local SpikeHandler = require('SpikeHandler')
local CubeHandler = require('CubeHandler')
local ScreenSettings = require('ScreenSettings')

-- Assets
local spike = love.graphics.newImage('Assets/spikeWhite.png')
local wallHit = love.audio.newSource('Assets/WallHit.wav', 'static')
local music = love.audio.newSource('Assets/music.ogg', 'stream')

-- Loading the game
function love.load()
    love.window.setMode(ScreenSettings.width, ScreenSettings.height)
    love.window.setTitle('ball game')

    music:setVolume(0.1)
    music:setLooping(true)
    music:play()
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
    if (Player.x + Player.width > ScreenSettings.width or Player.x - Player.width + 20 < 0) and not GameState.disabled then -- Hit one of the walls
        if Player.x + Player.width > ScreenSettings.width then-- Hit right wall
            Player.x = ScreenSettings.width - Player.width
            Player.xSpeed = -math.abs(Player.xSpeed) -- Move left
        elseif Player.x - Player.width + 20 < 0 then -- Hit left wall6
            Player.x = Player.width
            Player.xSpeed = math.abs(Player.xSpeed) -- Move right
        end

        Player:AddScore(1)
        wallHit:play()

        SpikeHandler:RemoveSpikes()
        SpikeHandler:SpawnSpikes(GameState:SpikeAmount(Player), GameState:SpikeAmount(Player))

        if not CubeHandler.CubeData and math.random(1,2) == 1 then
            CubeHandler:SpawnCube({x=Player.xSpeed < 0 and 30 or 350, y=math.random(20,380),width=20,height=20})
        end
    end

    -- Check if the player hits the top or bottom of the screen, or the spikes
    if (Player:HitBorder() or SpikeHandler:PlayerHitSpikes(Player)) and not GameState.disabled then
        GameState.disabled = true
        GameState.gameOverTime = love.timer.getTime()

        Player.gravity = 0
        Player.ySpeed = 0
        Player.xSpeed = 0

        local highScore = tonumber((love.filesystem.read('save.dat'))) or 0
        if Player.score > highScore then
            love.filesystem.write('save.dat', tostring(Player.score))
        end
    end

    -- Removing the cube if player is inside it
    if CubeHandler:PlayerHitCube(Player) then
        CubeHandler:RemoveCube()
        Player:AddScore(1)
    end
end

-- Drawing graphics each frame
function love.draw()
    local bgColor, plrColor = GameState:Theme(Player)
    love.graphics.setColor(bgColor.r or 1, bgColor.g or 1, bgColor.b or 1)

    love.graphics.rectangle('fill', 0, 0, ScreenSettings.width, ScreenSettings.height)

    love.graphics.setColor(plrColor.r or 0, plrColor.g or 0, plrColor.b or 0)

    love.graphics.setFont(love.graphics.newFont(40))

    local scoreWidth = love.graphics.getFont():getWidth(Player.score)
    love.graphics.print(Player.score, (ScreenSettings.width - scoreWidth) / 2, 10)

    love.graphics.circle('fill', Player.x + Player.width / 2, Player.y + Player.height / 2, Player.width / 2)
    --love.graphics.rectangle('fill', Player.x, Player.y, Player.width, Player.height)
    
    for i, spikePos in pairs(SpikeHandler.SpikeCoordinates) do -- Drawing the spikes
        love.graphics.draw(spike, spikePos.x - (spikePos.rotation and 10 or -5), spikePos.y - 5, spikePos.rotation, 1, 1, spikePos.rotation and 25 or 0, spikePos.rotation and 20 or 0)

        --love.graphics.setColor(1, 0, 0) -- Debugging spikes
        --love.graphics.rectangle('fill', spikePos.x, spikePos.y, spikePos.width, spikePos.height)
        --love.graphics.setFont(love.graphics.newFont(20))
        --love.graphics.print(i, spikePos.x, spikePos.y)
    end

    if CubeHandler.CubeData and CubeHandler.CubeData.x and CubeHandler.CubeData.y then -- Drawing the cube
        love.graphics.rectangle('fill', CubeHandler.CubeData.x, CubeHandler.CubeData.y, 20, 20)
    end

    if not GameState.started then -- Starting tip text
        love.graphics.setFont(love.graphics.newFont(20))

        local gameStartWidth = love.graphics.getFont():getWidth("Press 'Space' to start.")
        local gameStartHeight = love.graphics.getFont():getHeight("Press 'Space' to start.")
        love.graphics.print("Press 'Space' to start.", (ScreenSettings.width - gameStartWidth) / 2,(ScreenSettings.height - gameStartHeight) / 2) -- Starting tip text

        local highScore = 'Highscore: ' .. tostring((love.filesystem.read('save.dat') or 0))
        local highScoreWidth = love.graphics.getFont():getWidth(highScore)
        love.graphics.print(highScore, (ScreenSettings.width - highScoreWidth) / 2, 75) -- Highscore text

        love.graphics.setFont(love.graphics.newFont(40))
    end

    if GameState.disabled then
        local gameOverWidth = love.graphics.getFont():getWidth('Game over.')
        local gameOverHeight = love.graphics.getFont():getHeight('Game over.')
        love.graphics.print('Game over.', (ScreenSettings.width - gameOverWidth) / 2,(ScreenSettings.height - gameOverHeight) / 2) -- Game over text

        -- Resets the game after 3 seconds
        if love.timer.getTime() > GameState.gameOverTime + 2 then
            Player.x = 190
            Player.y = 400
            Player.score = 0
            SpikeHandler:RemoveSpikes()
            CubeHandler:RemoveCube()
            Player.gravity = 1000
            Player.ySpeed = 0
            Player.xSpeed = 250
    
            GameState.gameOverTime = 0
            GameState.started = false
            GameState.canShowHighScore = true
            GameState.disabled = false
        end
    end
end

function love.keypressed(key)
    if key == 'space' then
        Player:Flap()
    end
end

function love.mousepressed()
    Player:Flap()
end
