commandArray = {}

-- Handle talking
if (devicechanged['Podcast']) then
	speach = otherdevices_svalues['Podcast']
	print('(Podcast) Lecture de '..speach)
	os.execute('/home/chip/tools-domo/readPocast.sh "'..speach..'"')
end

return commandArray

