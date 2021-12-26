peripheral.find("modem", rednet.open)

local controllerID = nil

-- set this to the floor the computer will be working on
-- 1 is the lowest, going up from there
local floor = 1

-- the side that has a redstone connection to the Create contact
-- this will be triggered by the elevator, whenever it passes by the floor
local contactSide = "back"

-- bundled cable connected to the buttons
-- they're expected in the same order as https://tweaked.cc/module/colors.html
-- white - 1st floor, orange - 2nd floor, magenta - 3rd floor, etc. 
local buttonSide = "top"

-- try to find a controller on the network
repeat 
    print("trying to find controller")
    controllerID = rednet.lookup("elevator")
    sleep(5)
until controllerID ~= nil
print("controller found! id: ", controllerID)

local buttonState = nil
local contactState = nil

while true do
    os.pullEvent("redstone")
    contactState = rs.getInput(contactSide)
    buttonState = rs.getBundledInput(buttonSide)
    if contactState then
        rednet.send(controllerID, {"contact", floor}, "elevator")
    end
    if buttonState then
        rednet.send(controllerID, {"button", floor, button}, "elevator")
    end
    print("new message sent, contact is ",contactState, " and button is ", buttonState)
end
