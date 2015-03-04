commandArray = {}

if (devicechanged['Switch Niveau Sécurité'] == 'On') then
	if (globalvariables['Security'] == 'Disarmed') then
		print('(Security) Passage de Désarmé à Armé.')
		os.execute('/home/osmc/tools/alarme.sh init '..uservariables['SecPanel_pincode']..'" &');
	else if (globalvariables['Security'] == 'Armed Away') then
		print('(Security) Passage de Armé à Désarmé.')
		os.execute('/home/osmc/tools/alarme.sh finish '..uservariables['SecPanel_pincode']..'" &');
	end
	end
end

return commandArray
