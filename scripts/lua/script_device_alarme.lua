commandArray = {}
if (devicechanged['Alarme'] == 'All On') then
	print('(Alarme) Sonnerie')
	os.execute('/home/pi/tools/speakCS.sh "Attention! Intrusion en cours!"&')
end
if (devicechanged['Alarme'] == 'All Off') then

end
return commandArray
