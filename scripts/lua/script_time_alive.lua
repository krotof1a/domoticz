
t1 = os.time()
s = otherdevices_lastupdate['Temp Chambres']
year = string.sub(s, 1, 4)
month = string.sub(s, 6, 7)
day = string.sub(s, 9, 10)
hour = string.sub(s, 12, 13)
minutes = string.sub(s, 15, 16)
seconds = string.sub(s, 18, 19)
t2 = os.time{year=year, month=month, day=day, hour=hour, min=minutes, sec=seconds}
difference = (os.difftime (t1, t2))

commandArray = {}

if (difference > 120) then
	commandArray['SendNotification']='Alerte coupure de courant#Le courant a été coupé à '..s..' .'
end 

return commandArray
