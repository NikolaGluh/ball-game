local SpikeHandler = {}

local ScreenSettings = require('ScreenSettings')

-- Spike Data
SpikeHandler.spikeCoordinates = {}
SpikeHandler.direction = false -- false = downwards, true = upwards

-- Spawns a Spike
function SpikeHandler:spawnSpike(spikeData)
    if not spikeData.x or not spikeData.y then warn('X or Y coordinate missing!') end
    if spikeData.y + (spikeData.height or 0) > ScreenSettings.height or spikeData.y - (spikeData.height or 0) < 0 then return end -- Return if spikes go out of bounds

    table.insert(self.spikeCoordinates, spikeData)
end

-- Spawns spikes
function SpikeHandler:spawnSpikes(amountLeft, amountRight)
    SpikeHandler.direction = math.random(1,2) == 1
    local lastPos = SpikeHandler.direction and ScreenSettings.height or 0

    for i=1,amountLeft do -- Spawning spikes on left side
        local yPos

        if SpikeHandler.direction then -- If direction is upwards then
            yPos = lastPos - math.random(4,10) * 10
        else -- Else if direction is downwards
            yPos = lastPos + math.random(4,10) * 10
        end

        lastPos = yPos
        
        SpikeHandler:spawnSpike({x=-5,y=yPos,width=20,height=10})
    end

    SpikeHandler.direction = math.random(1,2) == 1
    lastPos = SpikeHandler.direction and ScreenSettings.height or 0
    for i=1,amountRight do -- Spawning spikes on right side
        local yPos

        if SpikeHandler.direction then -- If direction is upwards then
            yPos = lastPos - math.random(4,10) * 10
        else -- Else if direction is downwards
            yPos = lastPos + math.random(4,10) * 10
        end

        lastPos = yPos
    
        SpikeHandler:spawnSpike({x=ScreenSettings.width - 15,y=yPos,width=20,height=10,rotation=math.pi})
    end
end

-- Removes all spikes
function SpikeHandler:removeSpikes()
    self.spikeCoordinates = {}
end

return SpikeHandler