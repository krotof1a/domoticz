commandArray = {}
if (devicechanged['Portillon'] == 'On') then
	os.execute ('/home/osmc/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' portal '..uservariables['Portail_code']..' 5000')
	print('(Inter) Portillon actionne.')
end
return commandArray
