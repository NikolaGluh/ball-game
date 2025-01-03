local GameState = {
    started = false, -- If the game has started
    disabled = false, -- If game is disabled
    gameOverTime = 0, -- Time at which the game ended
}

-- Determine the theme colors based on player's score
function GameState:Theme(player)
    if not player or not player.score then
        return {r=1,g=1,b=1},{r=0,g=0,b=0}
    end

    if player.score >= 100 then
        return {r=0.753,g=0,b=0},{r=0,g=0,b=0}
    elseif player.score >= 80 then
        return {r=0,g=0,b=0},{r=1,g=1,b=1}
    elseif player.score >= 60 then
        return {r=0.247,g=0.075,b=0.569},{r=0,g=0,b=0}
    elseif player.score >= 40 then
        return {r=0.890,g=0.529,b=0.063},{r=1,g=1,b=1}
    elseif player.score >= 25 then
        return {r=0.075,g=0.569,b=0.149},{r=0,g=0,b=0}
    elseif player.score >= 10 then
        return {r=0,g=0.424,b=0.671},{r=1,g=1,b=1}
    elseif player.score < 10 then
        return {r=1,g=1,b=1},{r=0,g=0,b=0}
    end
end

-- Calculate amount of spikes based on player's score
function GameState:SpikeAmount(player)
    if player.score >= 100 then
        return math.random(15,20)
    elseif player.score >= 80 then
        return random(10,20)
    elseif player.score >= 60 then
        return math.random(8,14)
    elseif player.score >= 40 then
        return math.random(6,12)
    elseif player.score >= 25 then
        return math.random(4,10)
    elseif player.score >= 10 then
        return math.random(2,6)
    elseif player.score < 10 then
        return math.random(1,5)
    end
end

return GameState
