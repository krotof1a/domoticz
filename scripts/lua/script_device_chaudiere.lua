commandArray = {}
if (devicechanged['Etat Chaudiere'] == 'On') then
	os.execute ('/home/osmc/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' 1 on')
	print('(Inter) Chaudiere allumee.')
end
if (devicechanged['Etat Chaudiere'] == 'Off') then
	os.execute ('/home/osmc/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' 1 off')
	print('(Inter) Chaudiere eteinte.')
end
return commandArray
