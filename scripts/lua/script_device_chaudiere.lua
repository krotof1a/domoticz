commandArray = {}
if (devicechanged['Etat Chaudiere'] == 'On') then
	os.execute ('/home/osmc/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' 1 on &')
	print('(Inter) Chaudiere allumee.')
end
if (devicechanged['Etat Chaudiere'] == 'Off') then
	os.execute ('/home/osmc/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' 1 off &')
	print('(Inter) Chaudiere eteinte.')
end
if (devicechanged['Chauffage Abrit-piscine'] == 'On') then
	os.execute ('/home/osmc/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' a2 on &')
	print('(Inter) Chauffage abrit-piscine allume.')
end
if (devicechanged['Chauffage Abrit-piscine'] == 'Off') then
	os.execute ('/home/osmc/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' a2 off &')
	print('(Inter) Chauffage abrit-piscine eteint.')
end
return commandArray
