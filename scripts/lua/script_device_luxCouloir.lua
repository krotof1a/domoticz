commandArray = {}
if (devicechanged['Lumière Couloir'] == 'On') then
	os.execute ('/home/pi/tools/sendCS.sh '..uservariables['Emetteur_pin']..' '..uservariables['Emetteur_code']..' 3 pulse 50')
	print('(Inter) Couloir actionne.')
end
if (devicechanged['Porte Entrée'] == 'Open') then
	commandArray['Lumière Couloir']='On'
	print('(Porte) Ouverture porte d entree detectee.')
end

return commandArray
