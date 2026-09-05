local chars = "abcdefghijklmnopqrstuvwxyz0123456789"
function randomString(length)
    local result = ""
    for i = 1, length do
        local rand = math.random(1, #chars)
        result = result .. chars:sub(rand, rand)
    end
    return result
end
loadstring(game:HttpGet("https://raw.githubusercontent.com/een493437-dev/rayv3/main/script.lua?"..randomString(8).."="..randomString(8)))()
