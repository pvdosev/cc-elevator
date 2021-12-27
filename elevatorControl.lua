peripheral.find("modem", rednet.open)

rednet.host("elevator", "controller")
print("registered host")
-- total number of floors that the elevator services
local floors = 3

-- the sides that have a redstone connection to
-- the Create clutch and gearshift of the elevator
local clutchSide = "front"
local gearshiftSide = "left"

while true do
    local id, message = rednet.receive("elevator") 
end
