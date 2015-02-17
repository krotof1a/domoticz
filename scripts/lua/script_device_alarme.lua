commandArray = {}
if (devicechanged['Alarme'] == 'All On') then
	print('(Alarme) Sonnerie démarrée.')
	os.execute('/home/osmc/tools/alarme.sh &')
end
if (devicechanged['Alarme'] == 'All Off') then
	print('(Alarme) Sonnerie arrêtée.')
	os.execute('killall aplay')
end
return commandArray
