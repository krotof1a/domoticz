commandArray = {}
if (devicechanged['Chauffage Abrit-piscine'] == 'On') then
	os.execute ('/home/osmc/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' a2 on')
	print('(Inter) Chauffage abrit-piscine allume.')
end
if (devicechanged['Chauffage Abrit-piscine'] == 'Off') then
	os.execute ('/home/osmc/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' a2 off')
	print('(Inter) Chauffage abrit-piscine eteint.')
end
return commandArray
