commandArray = {}

-- Handle Corridor light actions and triggers
if (devicechanged['Lumière Couloir'] == 'On') then
	os.execute ('/home/pi/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' 3 pulse 50 &')
	print('(Inter) Couloir actionné.')
end

-- Handle Parking light actions and triggers
if (devicechanged['Lumière Garage'] == 'On') then
	os.execute ('/home/pi/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' 2 pulse 50 &')
	print('(Inter) Garage actionné.')
end

-- Handle Leaving room light actions and triggers
if (devicechanged['Lumière Salon'] == 'On') then
	os.execute ('/home/pi/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' a1 on &')
	print('(Inter) Salon allumé.')
end
if (devicechanged['Lumière Salon'] == 'Off') then
	os.execute ('/home/pi/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' a1 off &')
	print('(Inter) Salon eteint.')
end

-- Handle Leaving room light actions and triggers
if (devicechanged['Lumière Salle-à-manger'] == 'On') then
	os.execute ('/home/pi/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' b1 on &')
	print('(Inter) Salle-à-manger allumé.')
end
if (devicechanged['Lumière Salle-à-manger'] == 'Off') then
	os.execute ('/home/pi/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' b1 off &')
	print('(Inter) Salle-à-manger eteint.')
end

return commandArray
