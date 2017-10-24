commandArray = {}

-- Definitions
RECEIVER_VOLUME = "Volume Pioneer" -- Control ON/OFF and VOLUME

-- Main code
if devicechanged[RECEIVER_VOLUME] then
	if (otherdevices[RECEIVER_VOLUME] == "Off") then
		os.execute("curl http://localhost:8102/action=off")
	else if (otherdevices[RECEIVER_VOLUME] == "On") then
		os.execute("curl http://localhost:8102/action=on")
	else
		NewLevel = otherdevices_svalues[RECEIVER_VOLUME]
		os.execute("curl http://localhost:8102/action=vol"..NewLevel)
	end
	end
end

return commandArray

