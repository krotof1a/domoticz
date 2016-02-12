--Script script_time_chaudiere.lua
--Exemple de thermostat reagissant aux changements de températures

commandArray = {}
------------------------------------------------------------------------------------
-- Definition des constantes

s = os.date()
minutes = string.sub(s, 16, 16)
heures  = string.sub(s, 12, 13)
t = heures*100+minutes

tempC = otherdevices_svalues['Thermostat Maison'] or 0
tempSensorDayName='Temp Salle-à-manger'
tempS = otherdevices_temperature['Temp Salle-à-manger'] or 0
tempSensorNightName='Temp Chambre Matthieu'
tempN = otherdevices_temperature['Temp Chambre Matthieu'] or 0
if (t>700 and t<2100) then
	-- Entre 7h et 21h : prépondérance sonde salle-à-manger
	tempX = (2*tempS + tempN)/3
else
	-- De nuit, prépondérance sonde chambre
	tempX = (tempS + 2*tempN)/3
end

radSwitchName='Chaudière'
confMOnSwitchName='Confort Plus Chaudiere'
forceOnSwitchName='Marche Forcee Chaudiere'
forceOffSwitchName='Extinction Forcee Chaudiere'
absentSwitchName='Absence Chaudiere'

hysteresis = uservariables['Hysteresis'] or 0
confortplus = uservariables['ConfortPlus'] or 0
temp2 = uservariables['TempAbsence'] or 0

if (minutes=='0' or minutes=='5') then

------------------------------------------------------------------------------------
-- Main program
if otherdevices[absentSwitchName] == 'On' then
   	tempC = temp2
   	print('(Thermostat) Surcharge mode Absence')
end

if otherdevices[confMOnSwitchName] == 'On' then
   	tempC = tempC + confortplus
   	print('(Thermostat) Mode ConfortMax')
end 

print('(Thermostat) Consigne : '..tempC..', Temp calculée : '..tempX)

if tempX < (tempC-hysteresis) then 
	commandArray[radSwitchName]='On'
        print('(Thermostat) Chaudière sur On')
else if tempX > (tempC+hysteresis) then 
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

end

return commandArray
