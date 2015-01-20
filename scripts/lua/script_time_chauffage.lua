--Script script_time_chauffage.lua
--Exemple de thermostat reagissant aux changements de températures

commandArray = {}
------------------------------------------------------------------------------------
-- Definition des constantes

temp0 = uservariables['Thermostat_temp_abrit-piscine']
tempSensorName='Pression Atmosphérique'
radSwitchName='Chauffage Abrit-piscine'
s = os.date()
minutes = string.sub(s, 15, 16)

------------------------------------------------------------------------------------
-- Main program
-- Allumage toutess les heures si gel

if (minutes=='15' and otherdevices_temperature[tempSensorName] < temp0) then 
	commandArray[radSwitchName]='On'
        print('(Thermostat2) Chauffage sur On')
end
-- Extinction toutes les heures à xx:25
if (minutes=='25') then
	commandArray[radSwitchName]='Off' 
        print('(Thermostat2) Chauffage sur Off')
end

------------------------------------------------------------------------------------
-- Ne pas declencher d'event si le switch est deja dans la bonne position

if otherdevices[radSwitchName] == commandArray[radSwitchName] then
      	commandArray={}
      	print('(Thermostat2) Commande chauffage déjà positionnée. Rien à faire ...')
end

return commandArray
