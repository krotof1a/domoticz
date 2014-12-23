commandArray = {}
if (devicechanged['Etat Chaudiere'] == 'On') then
	os.execute ('/home/pi/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' casto 1381719')
	print('(Inter) Chaudiere allumee.')
end
if (devicechanged['Etat Chaudiere'] == 'Off') then
	os.execute ('/home/pi/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' casto 1381716')
	print('(Inter) Chaudiere eteinte.')
end
return commandArray
