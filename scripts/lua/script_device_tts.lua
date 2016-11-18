commandArray = {}

-- Handle talking
if (devicechanged['TTS']) then
	speach = otherdevices_svalues['TTS']
	print('(Parle) '..speach)
	os.execute('pico2wave -l fr-FR -w /tmp/talk.wav "Pause. '..speach..'"')
	os.execute('aplay /tmp/talk.wav')
	os.execute('rm -f /tmp/talk.wav')
end

return commandArray

