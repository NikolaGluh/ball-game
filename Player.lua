local Player = {
    x=190, -- Starting position on X axis
    y=400, -- Starting position on Y axis
    width = 20, -- Width of the player
    height = 20, -- Height of the player
    ySpeed = 0, -- Vertical speed
    gravity = 1000, -- Gravity pulling the player down
    flapStrength = -400, -- Strength of the upward flap
    xSpeed = 250, -- Horizontal speed
    score = 0,
}

function Player:addScore(points)
    self.score = self.score + points
end

return Player