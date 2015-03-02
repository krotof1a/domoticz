commandArray = {}

-- Handle Corridor light actions and triggers
if (devicechanged['Lumière Couloir'] == 'On') then
	os.execute ('/home/osmc/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' 3 pulse 50')
	print('(Inter) Couloir actionne.')
end

-- Handle Parking light actions and triggers
if (devicechanged['Lumière Garage'] == 'On') then
	os.execute ('/home/osmc/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' 2 pulse 50')
	print('(Inter) Garage actionne.')
end

-- Handle Leaving room light actions and triggers
if (devicechanged['Lumière Salon'] == 'On') then
	os.execute ('/home/osmc/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' a1 on')
	print('(Inter) Salon allume.')
end
if (devicechanged['Lumière Salon'] == 'Off') then
	os.execute ('/home/osmc/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' a1 off')
	print('(Inter) Salon eteint.')
end

return commandArray
