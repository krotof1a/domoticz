commandArray = {}

-- Handle thermostat change quickly
if (devicechanged['Thermostat Maison'] or
    devicechanged['Confort Plus Chaudiere'] or
    devicechanged['Absence Chaudiere'] or
    devicechanged['Marche Forcee Chaudiere'] or
    devicechanged['Extinction Forcee Chaudiere']) then
	print('(Thermostat) Activateur positionné')
	commandArray['Variable:ActNow'] = 'On'
end

return commandArray

