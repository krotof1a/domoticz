--Script script_device chaufPiscine.lua
--Vérification activation chauffage de piscine

commandArray = {}
------------------------------------------------------------------------------------
-- Definition des constantes

chaufSwitchName='Chauffage Piscine'
pompChaufSwitchName='Pompe Chauffage Piscine'
tempJ = tonumber(otherdevices_temperature['Temp Jardin'] or 0)
tempC = tonumber(otherdevices_svalues['Thermostat Air Chauffage Piscine'] or 0)
tempE = tonumber(otherdevices_svalues['Thermostat Eau Chauffage Piscine'] or 0)
--uvCap = tonumber(string.match(otherdevices_svalues['UV'],'([^;]+)') or 0)
--uvCon = tonumber(otherdevices_svalues['Thermostat UV Chauffage Piscine'] or 0)

s = os.date()
minute = string.sub(s, 16, 16)

------------------------------------------------------------------------------------
-- Main program

if ((minute=='1' or minute=='6') and otherdevices[chaufSwitchName] == 'On') then

	commandArray[pompChaufSwitchName]='On'
	
	if (tempJ < tempC) then
		print('(ChaufPiscine) Temperature trop basse. Chauffage piscine annulé.')
		commandArray[pompChaufSwitchName]='Off'
	end
	
	--if (uvCap < uvCon) then
	--	print('(ChaufPiscine) UV trop bas. Chauffage piscine annulé.')
	--	commandArray[pompChaufSwitchName]='Off'
	--end
	
	if (otherdevices[pompChaufSwitchName] == commandArray[pompChaufSwitchName]) then
      	commandArray={}
	else if (commandArray[pompChaufSwitchName] == 'On') then
		print('(ChaufPiscine) Pompe chauffage piscine démarrée.')
	end
	end
	
	return commandArray

end

