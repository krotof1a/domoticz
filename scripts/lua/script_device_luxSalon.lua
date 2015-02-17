commandArray = {}
if (devicechanged['Lumière Salon'] == 'On') then
	os.execute ('/home/osmc/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' a1 on')
	print('(Inter) Salon allume.')
end
if (devicechanged['Lumière Salon'] == 'Off') then
	os.execute ('/home/osmc/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' a1 off')
	print('(Inter) Salon eteint.')
end
return commandArray
