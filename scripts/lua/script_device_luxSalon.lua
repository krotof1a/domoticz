commandArray = {}
if (devicechanged['Lumière Salon'] == 'On') then
	os.execute ('/home/pi/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' 1 on')
	print('(Inter) Salon allume.')
end
if (devicechanged['Lumière Salon'] == 'Off') then
	os.execute ('/home/pi/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' 1 off')
	print('(Inter) Salon eteint.')
end
return commandArray
