--Script script_time_chauffage.lua
--Exemple de thermostat reagissant aux changements de températures

commandArray = {}
------------------------------------------------------------------------------------
-- Definition des constantes

modeSwitchName='Prise Piscine mode Chauffage'
consigneAPName='Thermostat Abrit-piscine'
tempC = otherdevices_svalues[consigneAPName] + 0
tempSensorName='Temp Abrit-piscine'
tempA = otherdevices_temperature[tempSensorName] + 0
radSwitchName='Prise Chauffage Piscine'
hysteresis = uservariables['Hysteresis_AP'] or 0

s = os.date()
minutes = string.sub(s, 15, 16)
minute = string.sub(s, 16, 16)

------------------------------------------------------------------------------------
-- Main program
if (otherdevices[modeSwitchName] == 'Off') then
        return commandArray
end

-- Allumage toutess les heures si gel
if (minute=='1' or minute=='6') then
	print('(Thermostat2) Consigne : '..tempC..', Hysteresis : '..hysteresis..', Temp lue : '..tempA)

	if tempA < (tempC-hysteresis) then 
		commandArray[radSwitchName]='On'
 		print('(Thermostat2) Chauffage sur On')
	else if tempA > (tempC+hysteresis) then 
		commandArray[radSwitchName]='Off' 
	        print('(Thermostat2) Chauffage sur Off')
     	end
	end
end

------------------------------------------------------------------------------------
-- Ne pas declencher d'event si le switch est deja dans la bonne position

--if ((minute=='1' or minute=='6') and 
--    (otherdevices[radSwitchName] == commandArray[radSwitchName])) then
--      	commandArray={}
--      	print('(Thermostat2) Commande chauffage déjà positionnée. Rien à faire ...')
--end

return commandArray
