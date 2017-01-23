--Script script_time_sanityCheck.lua
--Vérification post départ au travail

commandArray = {}
------------------------------------------------------------------------------------
-- Definition des constantes

sanitySwitchName='Watchdog'
lux001SwitchName='Eclairage Salon'
lux002SwitchName='Eclairage Salle-à-manger'
lux003SwitchName='Eclairage Chambre C&C'
lux004SwitchName='Eclairage Chambre Amis'
luxStatus='OK'

ouv001SwitchName='Porte Entrée'
ouv002SwitchName='Fenêtre Cuisine'
ouvStatus='OK'

------------------------------------------------------------------------------------
-- Main program

if (devicechanged[sanitySwitchName] == 'On') then

	-- Vérif lumières
	print('(SanityCheck) Vérification des lumières')
	if (otherdevices[lux001SwitchName] == 'On') then
		print('(SanityCheck) La lumière du bureau est allumée')
		luxStatus='KO'
	end
	if (otherdevices[lux002SwitchName] == 'On') then
		print('(SanityCheck) La lumière de la salle-à-manger est allumée')		
		luxStatus='KO'
	end
	if (otherdevices[lux003SwitchName] == 'On') then
		print('(SanityCheck) La lumière de la chambre parentale est allumée')		
		luxStatus='KO'
	end
	if (otherdevices[lux004SwitchName] == 'On') then
		print('(SanityCheck) La lumière de la chambre d amis est allumée')		
		luxStatus='KO'
	end

	-- Vérif Ouvrants
	print('(SanityCheck) Vérification des porte(s)/fenêtre(s)')
	if (otherdevices[ouv001SwitchName] == 'Open') then
		print('(SanityCheck) La porte d entrée est ouverte')
		ouvStatus='KO'
	end
	if (otherdevices[ouv002SwitchName] == 'Open') then
		print('(SanityCheck) La fenêtre de la cuisine est ouverte')		
		ouvStatus='KO'
	end
	
	-- Statut vérif
	if (luxStatus == 'OK') then
		print('(SanityCheck) Lumières OK')
	else
		commandArray['SendNotification']='Lumière allumée à la maison.'
	end
	if (ouvStatus == 'OK') then
		print('(SanityCheck) Ouvrants OK')
	else
		commandArray['SendNotification']=commandArray['SendNotification']..'Porte ou fenêtre ouverte à la maison.'
	end
	if (luxStatus == 'KO' or ouvStatus == 'KO') then
		return commandArray
	end
end
