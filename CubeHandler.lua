local CubeHandler = {}

local Util = require('Utilities')

CubeHandler.CubeData = nil

-- Check if player is inside the cube
function CubeHandler:PlayerHitCube(player)
    if not player.xSpeed then return end
    if not self.CubeData then return end

    return Util:isInside(player, self.CubeData)
end

-- Spawns a cube
function CubeHandler:SpawnCube(cubeData)
    if not cubeData.x or not cubeData.y then warn('X or Y coordinate missing!') end
    
    self.CubeData = cubeData
end

-- Removes the cube
function CubeHandler:RemoveCube()
    self.CubeData = nil
end

return CubeHandler