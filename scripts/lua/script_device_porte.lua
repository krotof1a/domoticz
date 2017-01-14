commandArray = {}

-- Handle Corridor light
if (devicechanged['Porte Entrée'] == 'Open' and timeofday['Nighttime']) then
	print('(Porte d entrée) Ouverture détectée de nuit.')
	commandArray['Eclairage Entrée']='On'
end

return commandArray

