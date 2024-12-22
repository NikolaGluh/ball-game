local GameState = {
    started = false, -- If the game has started
    disabled = false, -- If game is disabled
    gameOverTime = 0, -- Time at which the game ended
    canShowHighScore = true,
}

function GameState:ScoreColors(player)
    if not player.score then
        return {r=1,g=1,b=1},{r=0,g=0,b=0}
    end

    if player.score >= 100 then
        return {r=1,g=0,b=0},{r=1,g=1,b=1}
    elseif player.score >= 75 then
        return {r=0,g=0,b=0},{r=1,g=1,b=1}
    elseif player.score >= 50 then
        return {r=0.247,g=0.075,b=0.569},{r=0.890,g=0.529,b=0.063}
    elseif player.score >= 25 then
        return {r=0.075,g=0.569,b=0.149},{r=0,g=0,b=0}
    elseif player.score >= 10 then
        return {r=0,g=0.424,b=0.671},{r=1,g=1,b=1}
    elseif player.score < 10 then
        return {r=1,g=1,b=1},{r=0,g=0,b=0}
    end
end

return GameState