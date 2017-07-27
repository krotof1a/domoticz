commandArray = {}

-- Handle talking
if (devicechanged['Podcast']) then
	speach = otherdevices_svalues['Podcast']
	if (speach=="") then
		print('(Podcast) Arret')
		os.execute('sudo killall mpg321')
	else
		print('(Podcast) Lecture de '..speach)
		os.execute('/home/pi/tools-domo/readPodcast.sh "'..speach..'"&')
	end
end

return commandArray

