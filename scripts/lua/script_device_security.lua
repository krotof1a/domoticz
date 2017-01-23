commandArray = {}

if (devicechanged['Sécurité'] == 'On') then
	print('(Security) Passage de Désarmé à Armé.')
	os.execute('/home/chip/tools-domo/alarme.sh init '..uservariables['SecPanel_pincode']..' &');
else if (devicechanged['Sécurité'] == 'Off') then
	print('(Security) Passage de Armé à Désarmé.')
	os.execute('/home/chip/tools-domo/alarme.sh finish '..uservariables['SecPanel_pincode']..' &');
end
end

-- Handle alarm
if ((devicechanged['Porte Entrée'] == 'Open' or devicechanged['Porte Cuisine'] == 'Open' or devicechanged['Fenêtre Cuisine'] == 'Open')
    and globalvariables['Security'] == 'Armed Away') then
	print('(Security) Ouverture acces en mode securisé')
	os.execute('/home/chip/tools-domo/alarme.sh start &')
	commandArray['SendNotification']='Intrusion détectée !'
end

return commandArray
