commandArray = {}

-- Handle talking
if (devicechanged['TTS']) then
	speach = otherdevices_svalues['TTS']
	print('(Parle) '..speach)
	os.execute('pico2wave -l fr-FR -w /dev/shm/talk.wav "Pause. '..speach..'"')
	os.execute('aplay /dev/shm/talk.wav')
	os.execute('rm -f /dev/shm/talk.wav')
end

return commandArray

