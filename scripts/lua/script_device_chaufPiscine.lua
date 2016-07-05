--Script script_device chaufPiscine.lua
--Vérification activatino chauffage de piscine

commandArray = {}
------------------------------------------------------------------------------------
-- Definition des constantes

chaufSwitchName='Chauffage Piscine'
tempJ = tonumber(otherdevices_temperature['Temp Jardin'] or 0)
tempC = tonumber(otherdevices_svalues['Thermostat Air Chauffage Piscine'] or 0)
uvCap = tonumber(string.match(otherdevices_svalues['UV'],'([^;]+)') or 0)
uvCon = tonumber(otherdevices_svalues['Thermostat UV Chauffage Piscine'] or 0)

------------------------------------------------------------------------------------
-- Main program

if (devicechanged[chaufSwitchName] == 'On') then

	if (tempJ < tempC) then
		print('(ChaufPiscine) Temperature trop basse. Chauffage pisine annulé dans 5s')
		commandArray[chaufSwitchName]='Off'
		os.execute ("sleep 5")
		return commandArray 	
	end
	
	if (uvCap < uvCon) then
		print('(ChaufPiscine) UV trop bas. Chauffage pisine annulé dans 5s')
		commandArray[chaufSwitchName]='Off'
		os.execute ("sleep 5")
		return commandArray 	
	end

end

