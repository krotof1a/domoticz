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
tempM = otherdevices_temperature['Temp Chambre Matthieu'] or 0

function round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end

if (t>700 and t<2100) then
	-- Entre 7h et 21h : prépondérance sonde salle-à-manger
	tempX = round((4*tempS + tempN + tempM)/6, 2)
else
	-- De nuit, prépondérance sonde chambre
	tempX = round((2*tempS + 2*tempN + 2*tempM)/6, 2)
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
	--commandArray[rad2SwitchName]='Off'
        print('(Thermostat) Chaudière sur On')
else if tempX > (tempC+hysteresis) then 
	commandArray[radSwitchName]='Off' 
	--commandArray[rad2SwitchName]='On' 
        print('(Thermostat) Chaudière sur Off')
     end
end

-------------------------------------------------------------------------------------
-- marche forcee et extinction forcee

if otherdevices[forceOnSwitchName] == 'On' then 
	commandArray[radSwitchName]='On' 
	--commandArray[rad2SwitchName]='Off' 
      	print('(Thermostat) Surcharge marche forcee chaudiere')
end

if otherdevices[forceOffSwitchName] == 'On' then 
	commandArray[radSwitchName]='Off' 
	--commandArray[rad2SwitchName]='On' 
      	print('(Thermostat) Surcharge extinction forcee chaudiere')
end

------------------------------------------------------------------------------------
-- Ne pas declencher d'event si le switch est deja dans la bonne position

--if (otherdevices[radSwitchName] == commandArray[radSwitchName]) then
--      	commandArray={}
--      	print('(Thermostat) Commande chaudière déjà positionnée. Rien à faire ...')
--end

-------------------------------------------------------------------------------
-- Reset Activateur si besoin
if (actnow=='On') then
	commandArray['Variable:ActNow']='Off'
end

end

-------------------------------------------------------------------------------
-- Vérif date dernier update capteur chambre M
tCurrent = os.time()
sLastUpdate = otherdevices_lastupdate['Temp Chambre Matthieu']
--print('Last update sonde chambre M: '..sLastUpdate)
sLUyear = string.sub(sLastUpdate, 1, 4)
sLUmonth = string.sub(sLastUpdate, 6, 7)
sLUday = string.sub(sLastUpdate, 9, 10)
sLUhour = string.sub(sLastUpdate, 12, 13)
sLUminutes = string.sub(sLastUpdate, 15, 16)
sLUseconds = string.sub(sLastUpdate, 18, 19)
tLastUpdate = os.time{year=sLUyear, month=sLUmonth, day=sLUday, hour=sLUhour, min=sLUminutes, sec=sLUseconds}
sDifference = (os.difftime (tCurrent, tLastUpdate))
if (sDifference>1200) then
	-- Reset it
	os.execute('/home/pi/tools-domo/sendEvent.sh 15')
	print('(Test) Reset du reveil car temperature manquante pendant plus de 20mn')
end

return commandArray

