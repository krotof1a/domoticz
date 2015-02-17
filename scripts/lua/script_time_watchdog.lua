commandArray = {}

if (tonumber(otherdevices_svalues['Pi CPU']) > 95) then
        os.execute ('/home/osmc/tools/killRadioReception.sh')
	print ('(Watchdog) Killed radioReception process  ...');
end

return commandArray
