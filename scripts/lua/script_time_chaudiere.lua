--Script Planner_01.lua
--Exemple de thermostat reagissant aux changements de températures

commandArray = {}
------------------------------------------------------------------------------------
-- Definition des constantes
-- temp0 = nuit / absence
-- temp1 = jour / présence
-- temp2 = fonction Confort +
-- temp3 = Hors Gel / absence longue durée
-- hyteresis = variation autorisée en °

temp0 = 17
temp1 = 20
temp2 = temp1 + 1
temp3 = 7
hysteresis = 0.3
tempSensorDayName='Temp Salon'
tempSensorNightName='Temp Chambres'
radSwitchName='Etat Chaudiere'
confMOnSwitchName='Confort Plus Chaudiere'
forceOnSwitchName='Marche Forcee Chaudiere'
forceOffSwitchName='Extinction Forcee Chaudiere'

--Define a planning for a week
--possible ranges  0/0/0 to 23/59/59
--multiple ranges per day allowed

WeekPlanning = {Monday=      {
                              {starting={H=6,M=30,S=0},ending={H=8,M=30,S=0}},
                              {starting={H=17,M=45,S=0},ending={H=20,M=30,S=0}}--Beware, no comma on the last line
                              },
                  Tuesday=   {
                              {starting={H=6,M=30,S=0},ending={H=8,M=30,S=0}},
                              {starting={H=17,M=45,S=0},ending={H=20,M=30,S=0}}--Beware, no comma on the last line
                              },
                  Wednesday= {
                              {starting={H=6,M=30,S=0},ending={H=8,M=30,S=0}},
                              {starting={H=17,M=45,S=0},ending={H=20,M=30,S=0}}--Beware, no comma on the last line
                              },
                  Thursday=  {
                              {starting={H=6,M=30,S=0},ending={H=8,M=30,S=0}},
                              {starting={H=17,M=45,S=0},ending={H=20,M=30,S=0}}--Beware, no comma on the last line
                              },
                  Friday=    {
                              {starting={H=6,M=30,S=0},ending={H=8,M=30,S=0}},
                              {starting={H=17,M=45,S=0},ending={H=20,M=30,S=0}}--Beware, no comma on the last line      
                              },
                  Saturday=  {
                              {starting={H=7,M=30,S=0},ending={H=21,M=00,S=00}}--Beware, no comma on the last line
                              },
                  Sunday=    {
                              {starting={H=7,M=30,S=0},ending={H=21,M=00,S=00}}--Beware, no comma on the last line
                              }--Beware, no comma on the last line      
                  }


------------------------------------------------------------------------------------
--Function checking that values in the planning are in correct range
--param WeekPlanning :  a week planning table

function CheckingWeekPlanningStructure(WeekPlanning)
	if WeekPlanning == nil then return -1,"Error !!! WeekPlanning table not well set" end
	for kday,vday in pairs(WeekPlanning) do 
		  for kperiods,vperiods in ipairs(vday) do
				local PSH = vperiods["starting"].H; local PSM = vperiods["starting"].M; local PSS = vperiods["starting"].S
				local PEH = vperiods["ending"].H; local PEM = vperiods["ending"].M;  local PES = vperiods["ending"].S
				local PS = PSH.."/"..PSM.."/"..PSS
				local PE = PEH.."/"..PEM.."/"..PES
				if ( 23 < PSH or PSH < 0) then return 0,"Error in WeekPlanning, values out of range for: "..kday.." range: "..PS.." - "..PE end
				if ( 23 < PEH or PEH < 0) then return 0,"Error in WeekPlanning, values out of range for: "..kday.." range: "..PS.." - "..PE end
				if ( 59 < PSM or PSM < 0) then return 0,"Error in WeekPlanning, values out of range for: "..kday.." range: "..PS.." - "..PE end
				if ( 59 < PEM or PEM < 0) then return 0,"Error in WeekPlanning, values out of range for: "..kday.." range: "..PS.." - "..PE end
				if ( 59 < PSS or PSS < 0) then return 0,"Error in WeekPlanning, values out of range for: "..kday.." range: "..PS.." - "..PE end
				if ( 59 < PES or PES < 0) then return 0,"Error in WeekPlanning, values out of range for: "..kday.." range: "..PS.." - "..PE end            
		  end
	end
	return 1,"No error"
end

------------------------------------------------------------------------------------
--Function checking if the current time is in range of time in a week planning
--DateTime, the current date time obtain with os.date("*t",os.time()); 
--a week planning table
--IsDebug, true diplay debug information, false no display
--if overlapped ranges in planning first matched in list selected

function InPlannedPeriods(DateTime,WeekPlanning,IsDebug)

	local InPeriod = -1 --Returned value, 0 = out of period, 1 in period
	PeriodInfos = "Error" --detail on the matched period
	if IsDebug == nil then IsDebug = false end
	if IsDebug == true then print("----- InPlannedPeriods function in debug mode -----\n") end

	--WARNING weekday table, Sunday is 1
	local WeekDays={Monday=2,Tuesday=3,Wednesday=4,Thursday=5,Friday=6,Saturday=7,Sunday=1}

	if DateTime == nil then return -1,"Error !!! DateTime value not well set" end
	if WeekPlanning == nil then return -1,"Error !!! WeekPlanning table not well set" end
	
	local ElapsedTimeInSeconds = DateTime.hour*3600 + DateTime.min*60 +DateTime.sec
	if IsDebug==true then print("Total time elapsed in second for this day: ",ElapsedTimeInSeconds,"\n")end
	
	CPS,Err = CheckingWeekPlanningStructure(WeekPlanning)
	if CPS ~= 1 then 
		  if IsDebug == nil then print(Err)end
		  return -1,Err
		  end

	for kday,vday in pairs(WeekPlanning) do 
		  --if IsDebug==true then print(kday,":",DateTime.wday,":",WeekDays[kday],"\n") end
		  if (DateTime.wday == WeekDays[kday]) then 
				if IsDebug==true then print("\t----- Bingo !!! we are on: ",kday," -----\n") end
				  
				for kperiods,vperiods in ipairs(vday) do            
						local PeriodStarting = vperiods["starting"]
						local PeriodEnding = vperiods["ending"]
						if IsDebug==true then 
							--print("\tStart: ",PeriodStarting.H,"/",PeriodStarting.M,"/",PeriodStarting.S,"\t")
							--print("End: ",PeriodEnding.H,"/",PeriodEnding.M,"/",PeriodEnding.S,"\n")
							end
						local PeriodStartingSeconds = PeriodStarting.H*3600 + PeriodStarting.M*60 + PeriodStarting.S
						local PeriodEndingSeconds = PeriodEnding.H*3600 + PeriodEnding.M*60 + PeriodEnding.S
						--print("Current: ",ElapsedTimeInSeconds,"\tStart: ",PeriodStartingSeconds,"\tEnd: ",PeriodEndingSeconds,"\n")
						if ((ElapsedTimeInSeconds >= PeriodStartingSeconds) and (ElapsedTimeInSeconds <= PeriodEndingSeconds))then 
							local PS = PeriodStarting.H..":"..PeriodStarting.M..":"..PeriodStarting.S
							local PE = PeriodEnding.H..":"..PeriodEnding.M..":"..PeriodEnding.S
							if IsDebug==true then 
								  print("----- Bingo !!! we are in the time period: ")                              
								  print(PS,"\t")
								  print(PE,"\n")
								  print("----- Leaving InPlannedPeriods function debug mode -----\n")
								  end
							PeriodInfos =       "Matching "..kday.." period: "..PS.." - "..PE  
							return 1,PeriodInfos
							end
				end  
		  end
	end -- for
	return 0,"No period matched"
end

------------------------------------------------------------------------------------
--Main program

--use of the function checking if the current time is in range of time in a week planning
T=os.date("*t",os.time()); 
print("Current Date:",os.date())
-- print(T.wday.."\t"..T.hour.."\t"..T.min.."\t"..T.sec.."\n")
-- InPeriod,PeriodInfos = InPlannedPeriods(T,WeekPlanning,true) --mode debug
InPeriod,PeriodInfos = InPlannedPeriods(T,WeekPlanning) --mode normal
print(PeriodInfos)

-- fonction ConfortMax
if otherdevices[confMOnSwitchName] == 'On'
then
   tempConsigne = temp2
   print('ConfortMax On')
else
   tempConsigne = temp1
end 
-- fonction ConfortMax

if InPeriod == 1 then 
   --print(otherdevices_temperature[tempSensorDayName]) 
   if otherdevices_temperature[tempSensorDayName] < (tempConsigne-hysteresis)
      then commandArray[radSwitchName]='On'
          print('Jour chaudiere ON')
   else if otherdevices_temperature[tempSensorDayName] > (tempConsigne+hysteresis)
	  then commandArray[radSwitchName]='Off' 
          print('Jour chaudiere OFF')
      end
   end
else
   --print(otherdevices_temperature[tempSensorNightName]) 
   if otherdevices_temperature[tempSensorNightName] < (temp0-hysteresis)
      then commandArray[radSwitchName]='On' 
      print('Nuit chaudiere ON')
   else if otherdevices_temperature[tempSensorNightName] > (temp0+hysteresis)
	  then commandArray[radSwitchName]='Off' 
      print('Nuit chaudiere OFF')
      end
   end
end

-- marche forcee et fonction absence

if otherdevices[forceOnSwitchName] == 'On' 
   then commandArray[radSwitchName]='On' 
      print('Marche forcee chaudiere')
end

if otherdevices[forceOffSwitchName] == 'On' 
   then commandArray[radSwitchName]='Off' 
      print('Extinction forcee chaudiere')
end

-- Ne pas declencher d'event si le switch est deja dans la bonne position
if otherdevices[radSwitchName] == commandArray[radSwitchName]
   then
      commandArray={}
      print('Nothing to do ...')
end

return commandArray
