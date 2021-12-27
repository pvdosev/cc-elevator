local queue = require("queue")

peripheral.find("modem", rednet.open)
rednet.host("elevator", "controller")
print("registered host")

-- CONFIG --
-- total number of floors that the elevator services
local topFloor = 3

-- the sides that have a redstone connection to
-- the Create clutch and gearshift of the elevator
local clutchSide = "front"
local gearshiftSide = "left"

-- Depending on your Create setup, your gearshift could be inverted
-- By default, this program assumes redstone powering the gearshift
-- will make it pull the elevator up. 
-- If your elevator goes up with the gearshift unpowered,
-- set this variable to true.
local gearshiftInvert = false
-- END CONFIG --

-- store future destinations in a queue, separate from current
local currentDest = nil
local destQueue = queue.new()

-- reset elevator, so we know that it's at the highest floor
rs.setOutput(clutchSide, false)
rs.setOutput(gearshiftSide, not gearshiftInvert)
sleep(10)
local currentFloor = topFloor

-- initialization done
while true do
    local id, message = rednet.receive("elevator")
    if message[1] == "button" then
        -- first add calling floor to queue
        queue.push(destQueue, message[2])
        -- then add destination floor to queue
        queue.push(destQueue, message[3])
        print("we're going to floor ", message[2], "and then floor ", message[3])
    elseif message[1] == "contact" then
        currentFloor = message[2]
        if currentDest and currentDest == currentFloor then
            rs.setOutput(clutchSide, true)
            print("we have arrived at floor ", currentDest, "!")
            currentDest == nil
            sleep(5)
        end
    end
    -- check if we have more floors to go to
    if not queue.is_empty(destQueue) and not currentDest then
        -- make sure we're going to a different floor
        repeat 
            currentDest = queue.pop(destQueue)
        until currentDest ~= currentFloor
        -- set the gearshift to false if we need to go down, or vice versa
        -- inverted by gearshiftInvert
        rs.setOutput(gearshiftSide, currentFloor < currentDest ~= gearshiftInvert)
        rs.setOutput(clutchSide, false)
    end
end
