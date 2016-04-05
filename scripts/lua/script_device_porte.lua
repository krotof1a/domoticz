commandArray = {}

-- Handle Corridor light
if (devicechanged['Porte Entrée'] == 'Open' and timeofday['Nighttime']) then
	heureMin = 800
	heureMax = 2030
	t1 = os.date()
	hh = string.sub(t1,12,13)
	mm = string.sub(t1,15,16)
	t2 = hh*100+mm
	if (t2 > heureMin and t2 < heureMax) then
		print('(Porte d entrée) Ouverture détectée de nuit.')
		commandArray['Eclairage Couloir']='On'
	end
end

return commandArray

