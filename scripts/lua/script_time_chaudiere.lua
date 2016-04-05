--Script script_time_chaudiere.lua
--Exemple de thermostat reagissant aux changements de températures

commandArray = {}
------------------------------------------------------------------------------------
-- Definition des constantes

s = os.date()
minute = string.sub(s, 16, 16)
minutes = string.sub(s, 15, 16)
heures  = string.sub(s, 12, 13)
t = heures*100+minutes

tempC = otherdevices_svalues['Thermostat Maison'] or 0
tempS = otherdevices_temperature['Temp Salle-à-manger'] or 0
tempN = otherdevices_temperature['Temp Chambre Clément'] or 0

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

if (t>700 and t<2100) then
	-- Entre 7h et 21h : prépondérance sonde salle-à-manger
	tempX = round((2*tempS + tempN)/3, 2)
else
	-- De nuit, prépondérance sonde chambre
	tempX = round((tempS + 2*tempN)/3, 2)
end

radSwitchName='Chaudière'
confMOnSwitchName='Confort Plus Chaudiere'
forceOnSwitchName='Marche Forcee Chaudiere'
forceOffSwitchName='Extinction Forcee Chaudiere'
absentSwitchName='Absence Chaudiere'

hysteresis = uservariables['Hysteresis'] or 0
confortplus = uservariables['ConfortPlus'] or 0
temp2 = uservariables['TempAbsence'] or 0
actnow = uservariables['ActNow'] or 'Off'

------------------------------------------------------------------------------------
-- Main program

if (minute=='0' or minute=='5' or actnow=='On') then

if otherdevices[absentSwitchName] == 'On' then
   	tempC = temp2
   	print('(Thermostat) Surcharge mode Absence')
end

if otherdevices[confMOnSwitchName] == 'On' then
   	tempC = tempC + confortplus
   	print('(Thermostat) Mode ConfortMax')
end 

print('(Thermostat) Consigne : '..tempC..', Hysteresis : '..hysteresis..', Temp calculée : '..tempX)

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

if (otherdevices[radSwitchName] == commandArray[radSwitchName]) then
      	commandArray={}
      	print('(Thermostat) Commande chaudière déjà positionnée. Rien à faire ...')
end

-------------------------------------------------------------------------------
-- Reset Activateur si besoin
if (actnow=='On') then
	commandArray['Variable:ActNow']='Off'
end

end

return commandArray

