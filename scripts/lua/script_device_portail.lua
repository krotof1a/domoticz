commandArray = {}
if (devicechanged['Portail'] == 'On') then
	os.execute ('/home/osmc/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' portal '..uservariables['Portail_code'])
	print('(Inter) Portail actionne.')
end
return commandArray
