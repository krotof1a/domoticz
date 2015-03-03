commandArray = {}

if (devicechanged['Switch Niveau Sécurité'] == 'On') then
	if (globalvariables['Security'] == 'Disarmed') then
		print('(Security) Passage de Désarmé à Armé.')
		os.execute('wget -o /dev/zero -O /dev/zero "http://192.168.0.22:5665/json.htm?type=command&param=setsecstatus&secstatus=2&seccode='..uservariables['SecPanel_pincode']..'" &');
	else if (globalvariables['Security'] == 'Armed Away') then
		print('(Security) Passage de Armé à Désarmé.')
		os.execute('wget -o /dev/zero -O /dev/zero "http://192.168.0.22:5665/json.htm?type=command&param=setsecstatus&secstatus=0&seccode='..uservariables['SecPanel_pincode']..'" &');
	end
	end
end

return commandArray
