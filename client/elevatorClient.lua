peripheral.find("modem", rednet.open)

local controllerID = nil

-- CONFIG --
-- set this to the floor the computer will be working on
-- 1 is the lowest, going up from there
local floor = 3

-- the side that has a redstone connection to the Create contact
-- this will be triggered by the elevator, whenever it passes by the floor
local contactSide = "back"

-- bundled cable connected to the buttons
-- they're expected in the same order as https://tweaked.cc/module/colors.html
-- white - 1st floor, orange - 2nd floor, magenta - 3rd floor, etc. 
local buttonSide = "left"
-- END CONFIG --

-- wait for a controller on the network before doing anything
repeat 
    print("trying to find controller")
    controllerID = rednet.lookup("elevator")
    sleep(5)
until controllerID ~= nil
print("controller found! id: ", controllerID)
local oldButtonState = nil
local buttonState = nil
local oldContactState = nil
local contactState = nil
while true do
    os.pullEvent("redstone")
    contactState = rs.getInput(contactSide)

    -- bundled input is represented by a bitmask of 2^1 to 2^16,
    -- for each of the 16 dye colors. for more info see https://tweaked.cc/module/colors.html
    buttonState = rs.getBundledInput(buttonSide)

    -- only send contact updates if the elevator is passing by
    -- we don't want it to message if the elevator is parked and someone pushes a button
    if contactState and oldContactState ~= true then
        rednet.send(controllerID, {"contact", floor}, "elevator")
        print("contact message sent")
    end

    if buttonState ~= 0 and buttonState ~= oldButtonState then
        -- if multiple buttons are pushed at once, send the highest button value
        -- colors.toBlit rounds down the bitmask to a hex value, which we convert to decimal
        rednet.send(controllerID, { "button", floor, tonumber(colors.toBlit(buttonState), 16) + 1 }, "elevator")
        print("button message sent")
    end
    oldContactState = contactState
    oldButtonState = buttonState
    print("new event, contact is ",contactState, " and button is ", buttonState)
end
