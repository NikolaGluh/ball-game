local Utilities = {}

-- Check if object A is inside object B
function Utilities:isInside(a,b)
    if not a.x or not a.y or not a.width or not a.height then return end
    if not b.x or not b.y or not b.width or not b.height then return end

    return  a.x < b.x + b.width and
            b.x < a.x + a.width and
            a.y < b.y + b.height and
            b.y < a.y + a.height
end

return Utilities
