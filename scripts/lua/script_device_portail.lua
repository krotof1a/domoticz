commandArray = {}
if (devicechanged['Portail'] == 'On') then
	os.execute ('/home/pi/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' portal '..uservariables['Portail_code']..' &')
	print('(Inter) Portail actionne.')
end
if (devicechanged['Portillon'] == 'On') then
	os.execute ('/home/pi/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' portal '..uservariables['Portail_code']..' 5000 &')
	print('(Inter) Portillon actionne.')
end
return commandArray
