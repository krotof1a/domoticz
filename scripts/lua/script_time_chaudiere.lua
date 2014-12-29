--Script script_time_chaudiere.lua
--Exemple de thermostat reagissant aux changements de températures

commandArray = {}
------------------------------------------------------------------------------------
-- Definition des constantes
temp0 = uservariables['Thermostat_temp_nuit']
temp1 = uservariables['Thermostat_temp_jour']
temp2 = temp1 + uservariables['Thermostat_temp_confplus']
temp3 = uservariables['Thermostat_temp_absence']
hysteresis = uservariables['Thermostat_temp_hysteresis']
tempSensorDayName='Temp Salon'
tempSensorNightName='Temp Chambres'
radSwitchName='Etat Chaudiere'
confMOnSwitchName='Confort Plus Chaudiere'
forceOnSwitchName='Marche Forcee Chaudiere 2h'
forceOffSwitchName='Extinction Forcee Chaudiere 2h'
weekPlanningName='Planning Chaudiere'

------------------------------------------------------------------------------------
--Main program
InPeriod=0
if otherdevices[weekPlanningName] == 'On'
then
   InPeriod=1
   print('(Thermostat) Planning chaudiere On')
else
   print('(Thermostat) Planning chaudiere Off')
end

if otherdevices[confMOnSwitchName] == 'On'
then
   tempConsigne = temp2
   print('(Thermostat) ConfortMax On')
else
   tempConsigne = temp1
end 

if InPeriod == 1 then 
   --print(otherdevices_temperature[tempSensorDayName]) 
   if otherdevices_temperature[tempSensorDayName] < (tempConsigne-hysteresis)
      then commandArray[radSwitchName]='On'
          print('(Thermostat) Jour chaudiere ON')
   else if otherdevices_temperature[tempSensorDayName] > (tempConsigne+hysteresis)
	  then commandArray[radSwitchName]='Off' 
          print('(Thermostat) Jour chaudiere OFF')
      end
   end
else
   --print(otherdevices_temperature[tempSensorNightName]) 
   if otherdevices_temperature[tempSensorNightName] < (temp0-hysteresis)
      then commandArray[radSwitchName]='On' 
      print('(Thermostat) Nuit chaudiere ON')
   else if otherdevices_temperature[tempSensorNightName] > (temp0+hysteresis)
	  then commandArray[radSwitchName]='Off' 
      print('(Thermostat) Nuit chaudiere OFF')
      end
   end
end

-- marche forcee et fonction absence

if otherdevices[forceOnSwitchName] == 'On' 
   then commandArray[radSwitchName]='On' 
      print('(Thermostat) Marche forcee chaudiere')
end

if otherdevices[forceOffSwitchName] == 'On' 
   then commandArray[radSwitchName]='Off' 
      print('(Thermostat) Extinction forcee chaudiere')
end

-- Ne pas declencher d'event si le switch est deja dans la bonne position
if otherdevices[radSwitchName] == commandArray[radSwitchName]
   then
      commandArray={}
      print('(Thermostat) Switch already set. Nothing to do ...')
end

return commandArray
