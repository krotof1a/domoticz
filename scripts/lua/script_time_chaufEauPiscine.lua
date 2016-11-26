--Script script_device chaufPiscine.lua
--Vérification activation chauffage de piscine

commandArray = {}
------------------------------------------------------------------------------------
-- Definition des constantes

modeSwitchName='Prise Piscine mode Chauffage'
chaufSwitchName='Chauffage Eau Piscine'
pompChaufSwitchName='Prise Chauffage Piscine'
tempJ = tonumber(otherdevices_temperature['Temp Jardin'] or 0)
tempC = tonumber(otherdevices_svalues['Thermostat Air Chauffage Piscine'] or 0)
tempE = tonumber(otherdevices_svalues['Thermostat Eau Chauffage Piscine'] or 0)
--uvCap = tonumber(string.match(otherdevices_svalues['UV'],'([^;]+)') or 0)
--uvCon = tonumber(otherdevices_svalues['Thermostat UV Chauffage Piscine'] or 0)

s = os.date()
minute = string.sub(s, 16, 16)

------------------------------------------------------------------------------------
-- Main program

if (otherdevices[modeSwitchName] == 'On') then
	return commandArray
end

if (minute=='1' or minute=='6') then

   if (otherdevices[chaufSwitchName] == 'On') then

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
	
   else if (otherdevices[chaufSwitchName] == 'Off') then

        commandArray[pompChaufSwitchName]='Off'

        if (otherdevices[pompChaufSwitchName] == commandArray[pompChaufSwitchName]) then
        	commandArray={}
        else if (commandArray[pompChaufSwitchName] == 'Off') then
                print('(ChaufPiscine) Pompe chauffage piscine arrêtée.')
        end
        end

   end
   end

   return commandArray

end
