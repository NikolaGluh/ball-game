local Player = {
    x = 190, -- Starting position on X axis
    y = 400, -- Starting position on Y axis
    width = 20, -- Width of the player
    height = 20, -- Height of the player
    ySpeed = 0, -- Vertical speed
    gravity = 1000, -- Gravity pulling the player down
    flapStrength = -400, -- Strength of the upward flap
    xSpeed = 250, -- Horizontal speed
    score = 0,
}

local GameState = require('GameState')
local ScreenSettings = require('ScreenSettings')

-- Increasing player's score
function Player:AddScore(points)
    self.score = self.score + points
end

-- Player flaps up
function Player:Flap()
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

-- Check if player has hit the bottom or top border
function Player:HitBorder()
    return Player.y + Player.height < Player.height * 2 or Player.y + Player.height > ScreenSettings.height
end

return Player
