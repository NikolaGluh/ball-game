local SpikeHandler = {}

local ScreenSettings = require('ScreenSettings')
local Util = require('Utilities')

-- Spike Data
SpikeHandler.SpikeCoordinates = {}
SpikeHandler.Direction = false -- false = downwards, true = upwards

-- Check if player is inside spikes
function SpikeHandler:PlayerHitSpikes(player)
    if not player.xSpeed then return end

    local hit = false

    for _,spikePos in pairs(self.SpikeCoordinates) do
        if (not spikePos.rotation and player.xSpeed < 0) or (spikePos.rotation and player.xSpeed > 0) then
            if Util:isInside(player, spikePos) then
                hit = true
                break
            end
        end
    end

    return hit
end

-- Spawns a Spike
function SpikeHandler:SpawnSpike(spikeData)
    if not spikeData.x or not spikeData.y then warn('X or Y coordinate missing!') end
    if spikeData.y + (spikeData.height or 0) > ScreenSettings.height or spikeData.y - (spikeData.height or 0) < 0 then return end -- Return if spikes go out of bounds

    table.insert(self.SpikeCoordinates, spikeData)
end

-- Spawns spikes
function SpikeHandler:SpawnSpikes(amountLeft, amountRight)
    self.Direction = math.random(1,2) == 1
    local lastPos = self.Direction and ScreenSettings.height or 0

    for i=1,amountLeft do -- Spawning spikes on left side
        local yPos

        if self.Direction then -- If direction is upwards then
            yPos = lastPos - math.random(4,10) * 10
        else -- Else if direction is downwards
            yPos = lastPos + math.random(4,10) * 10
        end

        lastPos = yPos
        
        self:SpawnSpike({x=-5,y=yPos,width=20,height=10})
    end

    self.Direction = math.random(1,2) == 1
    lastPos = self.Direction and ScreenSettings.height or 0
    for i=1,amountRight do -- Spawning spikes on right side
        local yPos

        if self.Direction then -- If direction is upwards then
            yPos = lastPos - math.random(4,10) * 10
        else -- Else if direction is downwards
            yPos = lastPos + math.random(4,10) * 10
        end

        lastPos = yPos
    
        self:SpawnSpike({x=ScreenSettings.width - 15,y=yPos,width=20,height=10,rotation=math.pi})
    end
end

-- Removes all spikes
function SpikeHandler:RemoveSpikes()
    self.SpikeCoordinates = {}
end

return SpikeHandler
