commandArray = {}
if (devicechanged['Lumière Garage'] == 'On') then
	os.execute ('/home/pi/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' 2 pulse 50')
	print('(Inter) Garage actionne.')
end
return commandArray
