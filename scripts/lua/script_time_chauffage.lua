--Script script_time_chauffage.lua
--Exemple de thermostat reagissant aux changements de températures

commandArray = {}
------------------------------------------------------------------------------------
-- Definition des constantes

consigneAPName='Thermostat Abrit-piscine'
temp0 = otherdevices_svalues[consigneAPName] + 0
tempSensorName='Station Meteo'
radSwitchName='Pompe Chauffage Piscine'
s = os.date()
minutes = string.sub(s, 15, 16)

------------------------------------------------------------------------------------
-- Main program
-- Allumage toutess les heures si gel

if (minutes=='15') then
	print('(Thermostat2) Consigne lue - E:'..temp0)
	if (otherdevices_temperature[tempSensorName] < temp0) then 
		commandArray[radSwitchName]='On'
        	print('(Thermostat2) Chauffage sur On')
	else
        	print('(Thermostat2) Temperature trop haute. Rien à faire.')
	end
end
-- Extinction toutes les heures à xx:25
if (minutes=='25') then
	commandArray[radSwitchName]='Off' 
        print('(Thermostat2) Chauffage sur Off')
end

------------------------------------------------------------------------------------
-- Ne pas declencher d'event si le switch est deja dans la bonne position

if ((minutes=='15' or minutes=='25') and 
    (otherdevices[radSwitchName] == commandArray[radSwitchName])) then
      	commandArray={}
      	print('(Thermostat2) Commande chauffage déjà positionnée. Rien à faire ...')
end

return commandArray
