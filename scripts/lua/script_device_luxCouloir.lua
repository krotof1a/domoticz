commandArray = {}

heureMin = 800
heureMax = 2030

if (devicechanged['Lumière Couloir'] == 'On') then
	os.execute ('/home/osmc/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' 3 pulse 50')
	print('(Inter) Couloir actionne.')
end
if (devicechanged['Porte Entrée'] == 'Open' and timeofday['Nighttime']) then
	t1 = os.date()
	hh = string.sub(t1,12,13)
	mm = string.sub(t1,15,16)
	t2 = hh*100+mm
	if (t2 > heureMin and t2 < heureMax) then
		commandArray['Lumière Couloir']='On'
		print('(Porte) Ouverture porte d entree detectee.')
	end
end
return commandArray
