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
		commandArray['Lumière Couloir']='On'
	end
end

-- Handle alarm
if ((devicechanged['Porte Entrée'] == 'Open' or devicechanged['Porte Cuisine'] == 'Open')
    and globalvariables['Security'] == 'Armed Away') then
	print('(Porte) Ouverture porte en mode securisé')
	os.execute('/home/osmc/tools/alarme.sh start &')
end

return commandArray
