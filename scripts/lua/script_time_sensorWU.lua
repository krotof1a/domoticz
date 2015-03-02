sensorwu = 'Station Meteo' --sensor from wunderground
local tempsensor = 'Temp Extérieur' --virtual temp sensor you created
local idx = 13 --idx of your virtual temp sensor of wunderground
commandArray = {}
time = os.date("*t")
if((time.min % 10)==0)then
	sWeatherTemp, sWeatherHumidity, sWeatherPressure = otherdevices_svalues[sensorwu]:match("([^;]+);([^;]+);([^;]+)")
	sWeatherTemp = tonumber(sWeatherTemp)
	commandArray['UpdateDevice'] = idx .. '|0|' .. tostring(sWeatherTemp)
end
return commandArray
