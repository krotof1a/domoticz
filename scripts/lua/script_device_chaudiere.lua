commandArray = {}
if (devicechanged['Etat Chaudiere'] == 'On') then
	os.execute ('/home/pi/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' 2 on')
	print('(Inter) Chaudiere allumee.')
end
if (devicechanged['Etat Chaudiere'] == 'Off') then
	os.execute ('/home/pi/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' 2 off')
	print('(Inter) Chaudiere eteinte.')
end
return commandArray
