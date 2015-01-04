--Script script_time_chaudiere.lua
--Exemple de thermostat reagissant aux changements de températures

commandArray = {}
------------------------------------------------------------------------------------
-- Definition des constantes

temp0 = uservariables['Thermostat_temp_nuit']
temp1 = uservariables['Thermostat_temp_jour']
temp2 = uservariables['Thermostat_temp_absence']
hysteresis = uservariables['Thermostat_temp_hysteresis']

tempSensorDayName='Temp Salon'
tempSensorNightName='Temp Chambres'

radSwitchName='Etat Chaudiere'

confMOnSwitchName='Confort Plus Chaudiere'
forceOnSwitchName='Marche Forcee Chaudiere'
forceOffSwitchName='Extinction Forcee Chaudiere'
absentSwitchName='Absence Chaudiere'
weekPlanningName='Planning Chaudiere'

------------------------------------------------------------------------------------
-- Main program

if otherdevices[weekPlanningName] == 'On' then
   	tempConsigne = temp1
	sensorName   = tempSensorDayName
	print('(Thermostat) Mode Normal - Jour')
else
   	tempConsigne = temp0
	sensorName   = tempSensorNightName
   	print('(Thermostat) Mode Normal - Nuit')
end

if otherdevices[absentSwitchName] == 'On' then
   	tempConsigne = temp2
   	print('(Thermostat) Surcharge mode Absence')
end

if otherdevices[confMOnSwitchName] == 'On' then
   	tempConsigne = tempConsigne + uservariables['Thermostat_temp_confplus']
   	print('(Thermostat) Mode ConfortMax')
end 

if otherdevices_temperature[sensorName] < (tempConsigne-hysteresis) then 
	commandArray[radSwitchName]='On'
        print('(Thermostat) Chaudière sur On')
else if otherdevices_temperature[sensorName] > (tempConsigne+hysteresis) then 
	commandArray[radSwitchName]='Off' 
        print('(Thermostat) Chaudière sur Off')
     end
end

-------------------------------------------------------------------------------------
-- marche forcee et extinction forcee

if otherdevices[forceOnSwitchName] == 'On' then 
	commandArray[radSwitchName]='On' 
      	print('(Thermostat) Surcharge marche forcee chaudiere')
end

if otherdevices[forceOffSwitchName] == 'On' then 
	commandArray[radSwitchName]='Off' 
      	print('(Thermostat) Surcharge extinction forcee chaudiere')
end

------------------------------------------------------------------------------------
-- Ne pas declencher d'event si le switch est deja dans la bonne position

if otherdevices[radSwitchName] == commandArray[radSwitchName] then
      	commandArray={}
      	print('(Thermostat) Commande chaudière déjà positionnée. Rien à faire ...')
end

return commandArray
