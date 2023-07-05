currday = 0
local objectives = 0
local objscompleted = 0

shopsRobbed = 0
timesCopsLost = 0
securicarsStolen = 0
taxiPassed = 0
policePassed = 0
medicPassed = 0
missionsCompleted = 0
orgMissionsCompleted = 0
bizMissionsCompleted = 0
heistsCompleted = 0
busPassed = 0
garbagePassed = 0
firePassed = 0
subwayPassed = 0
RegisterNetEvent('updDailyStats')
AddEventHandler('updDailyStats', function(data)
	for i=1,100,1 do
		if(data[i] == nil) then
			data[i] = 0
		end
	end
	shopsRobbed = tonumber(data[1])
	timesCopsLost = tonumber(data[2])
	securicarsStolen = tonumber(data[3])
	taxiPassed = tonumber(data[4])
	policePassed = tonumber(data[5])
	medicPassed = tonumber(data[6])
	missionsCompleted = tonumber(data[7])
	orgMissionsCompleted = tonumber(data[8])
	bizMissionsCompleted = tonumber(data[9])
	heistsCompleted = tonumber(data[10])
	busPassed = tonumber(data[11])
	garbagePassed = tonumber(data[12])
	firePassed = tonumber(data[13])
	subwayPassed = tonumber(data[14])
end)

SaveDailyStats = function()
	local data = {}
	data[1] = shopsRobbed
	data[2] = timesCopsLost
	data[3] = securicarsStolen
	data[4] = taxiPassed
	data[5] = policePassed
	data[6] = medicPassed
	data[7] = missionsCompleted
	data[8] = orgMissionsCompleted
	data[9] = bizMissionsCompleted
	data[10] = heistsCompleted
	data[11] = busPassed
	data[12] = garbagePassed
	data[13] = firePassed
	data[14] = subwayPassed
	
	TriggerServerEvent('saveDailyStats', data)
end

RegisterNetEvent('updDaily')
AddEventHandler('updDaily', function(data)
	currday = tonumber(data[1])
	objectives = tonumber(data[2])
	objscompleted = tonumber(data[3])
end)

RegisterNetEvent('generateObjectives')
AddEventHandler('generateObjectives', function(day)
	currday = day
	::again::
	objectives = GenerateRandomIntInRange(1, 17)
	if(objectives == 6) then
		if(org == 0) then
			goto again
		end
	elseif(objectives == 7) then
		local bizamount = 0
		for i=1,#biz,1 do
			if(biz[i] == 1) then
				bizamount = bizamount + 1
			end
		end
		if(bizamount == 0) then
			goto again
		end
	elseif(objectives==8 or objectives==9 or objectives==10) then
		if(org == 0) then
			goto again
		end
		local bizamount = 0
		for i=1,#biz,1 do
			if(biz[i] == 1) then
				bizamount = bizamount + 1
			end
		end
		if(bizamount == 0) then
			goto again
		end
	elseif(objectives==15 or objectives==16) then
		if(experience < 5400) then
			goto again
		end
	end
	objscompleted = 0
	SaveDaily()
	shopsRobbed = 0
	timesCopsLost = 0
	securicarsStolen = 0
	taxiPassed = 0
	policePassed = 0
	medicPassed = 0
	missionsCompleted = 0
	orgMissionsCompleted = 0
	bizMissionsCompleted = 0
	heistsCompleted = 0
	busPassed = 0
	garbagePassed = 0
	firePassed = 0
	SaveDailyStats()
end)

SaveDaily = function()
	local data = {}
	data[1] = currday
	data[2] = objectives
	data[3] = objscompleted
	TriggerServerEvent('saveDaily', data)
end

ProceedToDailyObjectives = function()
	::daily::
	local tempitems = {}
	if(objectives == 1) then
		tempitems[#tempitems+1] = "Rob 3 shops ~y~(" .. shopsRobbed .. "/3)"
		tempitems[#tempitems+1] = "Do 10 taxi missions ~y~(" .. taxiPassed .. "/10)"
		tempitems[#tempitems+1] = "Lose wanted level 5 times ~y~(" .. timesCopsLost .. "/5)"
	elseif(objectives == 2) then
		tempitems[#tempitems+1] = "Steal 3 securicars ~y~(" .. securicarsStolen .. "/3)"
		tempitems[#tempitems+1] = "Do 10 police missions ~y~(" .. policePassed .. "/10)"
		tempitems[#tempitems+1] = "Lose wanted level 5 times ~y~(" .. timesCopsLost .. "/5)"
	elseif(objectives == 3) then
		tempitems[#tempitems+1] = "Rob 3 shops ~y~(" .. shopsRobbed .. "/3)"
		tempitems[#tempitems+1] = "Do 5 police missions ~y~(" .. policePassed .. "/5)"
		tempitems[#tempitems+1] = "Do 5 medic missions ~y~(" .. medicPassed .. "/5)"
	elseif(objectives == 4) then
		tempitems[#tempitems+1] = "Do 3 taxi missions ~y~(" .. taxiPassed .. "/3)"
		tempitems[#tempitems+1] = "Do 3 police missions ~y~(" .. policePassed .. "/3)"
		tempitems[#tempitems+1] = "Do 3 medic missions ~y~(" .. medicPassed .. "/3)"
	elseif(objectives == 5) then
		tempitems[#tempitems+1] = "Complete 3 missions ~y~(" .. missionsCompleted .. "/3)"
		tempitems[#tempitems+1] = "Rob 3 shops ~y~(" .. shopsRobbed .. "/3)"
		tempitems[#tempitems+1] = "Steal 3 securicars ~y~(" .. securicarsStolen .. "/3)"
	elseif(objectives == 6) then --org needed
		tempitems[#tempitems+1] = "Complete 3 organization missions ~y~(" .. orgMissionsCompleted .. "/3)"
		tempitems[#tempitems+1] = "Lose wanted level 5 times ~y~(" .. timesCopsLost .. "/5)"
		tempitems[#tempitems+1] = "Complete 3 missions ~y~(" .. missionsCompleted .. "/3)"
	elseif(objectives == 7) then --biz needed
		tempitems[#tempitems+1] = "Complete 3 business missions ~y~(" .. bizMissionsCompleted .. "/3)"
		tempitems[#tempitems+1] = "Do 3 taxi missions ~y~(" .. taxiPassed .. "/3)"
		tempitems[#tempitems+1] = "Lose wanted level 5 times ~y~(" .. timesCopsLost .. "/5)"
	elseif(objectives == 8) then --biz + org needed
		tempitems[#tempitems+1] = "Complete 1 heist ~y~(" .. heistsCompleted .. "/1)"
		tempitems[#tempitems+1] = "Complete 3 organization missions ~y~(" .. orgMissionsCompleted .. "/3)"
		tempitems[#tempitems+1] = "Lose wanted level 5 times ~y~(" .. timesCopsLost .. "/5)"
	elseif(objectives == 9) then --biz + org needed
		tempitems[#tempitems+1] = "Complete 2 missions ~y~(" .. missionsCompleted .. "/2)"
		tempitems[#tempitems+1] = "Complete 2 organization missions ~y~(" .. orgMissionsCompleted .. "/2)"
		tempitems[#tempitems+1] = "Complete 2 business missions ~y~(" .. bizMissionsCompleted .. "/2)"
	elseif(objectives == 10) then --biz + org needed
		tempitems[#tempitems+1] = "Complete 1 heist ~y~(" .. heistsCompleted .. "/1)"
		tempitems[#tempitems+1] = "Do 3 police missions ~y~(" .. policePassed .. "/3)"
		tempitems[#tempitems+1] = "Do 3 medic missions ~y~(" .. medicPassed .. "/3)"
	elseif(objectives == 11) then
		tempitems[#tempitems+1] = "Complete 3 bus routes ~y~(" .. busPassed .. "/3)"
		tempitems[#tempitems+1] = "Collect 3 garbage at garbage trucker job ~y~(" .. garbagePassed .. "/3)"
		tempitems[#tempitems+1] = "Do 3 firefighter missions ~y~(" .. firePassed .. "/3)"
	elseif(objectives == 12) then
		tempitems[#tempitems+1] = "Complete 3 missions ~y~(" .. missionsCompleted .. "/3)"
		tempitems[#tempitems+1] = "Collect 3 garbage at garbage trucker job ~y~(" .. garbagePassed .. "/3)"
		tempitems[#tempitems+1] = "Do 3 police missions ~y~(" .. policePassed .. "/3)"
	elseif(objectives == 13) then
		tempitems[#tempitems+1] = "Do 3 police missions ~y~(" .. policePassed .. "/3)"
		tempitems[#tempitems+1] = "Do 3 medic missions ~y~(" .. medicPassed .. "/3)"
		tempitems[#tempitems+1] = "Do 3 firefighter missions ~y~(" .. firePassed .. "/3)"
	elseif(objectives == 14) then
		tempitems[#tempitems+1] = "Complete 3 bus routes ~y~(" .. busPassed .. "/3)"
		tempitems[#tempitems+1] = "Rob 3 shops ~y~(" .. shopsRobbed .. "/3)"
		tempitems[#tempitems+1] = "Lose wanted level 5 times ~y~(" .. timesCopsLost .. "/5)"
	elseif(objectives == 15) then
		tempitems[#tempitems+1] = "Complete 3 bus routes ~y~(" .. busPassed .. "/3)"
		tempitems[#tempitems+1] = "Complete 2 subway routes ~y~(" .. subwayPassed .. "/2)"
		tempitems[#tempitems+1] = "Steal 3 securicars ~y~(" .. securicarsStolen .. "/3)"
	elseif(objectives == 16) then
		tempitems[#tempitems+1] = "Do 3 firefighter missions ~y~(" .. firePassed .. "/3)"
		tempitems[#tempitems+1] = "Complete 2 subway routes ~y~(" .. subwayPassed .. "/2)"
		tempitems[#tempitems+1] = "Rob 3 shops ~y~(" .. shopsRobbed .. "/3)"
	end
	tempitems[#tempitems+1] = "Receive reward"
	DrawWindow("Daily_objectives", tempitems)
	while menuactive do
		Wait(0)
	end
	if(menuresult > 0) then
		if(menuresult == 4) then
			if(objectives == 1) then
				if(shopsRobbed>=3 and taxiPassed>=10 and timesCopsLost>=5) then
					goto reward
				else
					TriggerEvent('chatMessage', '[Daily objectives]', {255, 0, 0}, 'Conditions not met!')
					goto finish
				end
			elseif(objectives == 2) then
				if(securicarsStolen>=3 and policePassed>=10 and timesCopsLost>=5) then
					goto reward
				else
					TriggerEvent('chatMessage', '[Daily objectives]', {255, 0, 0}, 'Conditions not met!')
					goto finish
				end
			elseif(objectives == 3) then
				if(shopsRobbed>=3 and policePassed>=5 and medicPassed>=5) then
					goto reward
				else
					TriggerEvent('chatMessage', '[Daily objectives]', {255, 0, 0}, 'Conditions not met!')
					goto finish
				end
			elseif(objectives == 4) then
				if(taxiPassed>=3 and policePassed>=3 and medicPassed>=3) then
					goto reward
				else
					TriggerEvent('chatMessage', '[Daily objectives]', {255, 0, 0}, 'Conditions not met!')
					goto finish
				end
			elseif(objectives == 5) then
				if(missionsCompleted>=3 and shopsRobbed>=3 and securicarsStolen>=3) then
					goto reward
				else
					TriggerEvent('chatMessage', '[Daily objectives]', {255, 0, 0}, 'Conditions not met!')
					goto finish
				end
			elseif(objectives == 6) then
				if(orgMissionsCompleted>=3 and timesCopsLost>=5 and missionsCompleted>=3) then
					goto reward
				else
					TriggerEvent('chatMessage', '[Daily objectives]', {255, 0, 0}, 'Conditions not met!')
					goto finish
				end
			elseif(objectives == 7) then
				if(bizMissionsCompleted>=3 and taxiPassed>=3 and timesCopsLost>=5) then
					goto reward
				else
					TriggerEvent('chatMessage', '[Daily objectives]', {255, 0, 0}, 'Conditions not met!')
					goto finish
				end
			elseif(objectives == 8) then
				if(heistsCompleted>=1 and orgMissionsCompleted>=3 and timesCopsLost>=5) then
					goto reward
				else
					TriggerEvent('chatMessage', '[Daily objectives]', {255, 0, 0}, 'Conditions not met!')
					goto finish
				end
			elseif(objectives == 9) then
				if(missionsCompleted>=2 and orgMissionsCompleted>=2 and bizMissionsCompleted>=2) then
					goto reward
				else
					TriggerEvent('chatMessage', '[Daily objectives]', {255, 0, 0}, 'Conditions not met!')
					goto finish
				end
			elseif(objectives == 10) then
				if(heistsCompleted>=1 and policePassed>=3 and medicPassed>=3) then
					goto reward
				else
					TriggerEvent('chatMessage', '[Daily objectives]', {255, 0, 0}, 'Conditions not met!')
					goto finish
				end
			elseif(objectives == 11) then
				if(busPassed>=3 and garbagePassed>=3 and firePassed>=3) then
					goto reward
				else
					TriggerEvent('chatMessage', '[Daily objectives]', {255, 0, 0}, 'Conditions not met!')
					goto finish
				end
			elseif(objectives == 12) then
				if(missionsCompleted>=3 and garbagePassed>=3 and policePassed>=3) then
					goto reward
				else
					TriggerEvent('chatMessage', '[Daily objectives]', {255, 0, 0}, 'Conditions not met!')
					goto finish
				end
			elseif(objectives == 13) then
				if(policePassed>=3 and medicPassed>=3 and firePassed>=3) then
					goto reward
				else
					TriggerEvent('chatMessage', '[Daily objectives]', {255, 0, 0}, 'Conditions not met!')
					goto finish
				end
			elseif(objectives == 14) then
				if(busPassed>=3 and shopsRobbed>=3 and timesCopsLost>=5) then
					goto reward
				else
					TriggerEvent('chatMessage', '[Daily objectives]', {255, 0, 0}, 'Conditions not met!')
					goto finish
				end
			elseif(objectives == 15) then
				if(busPassed>=3 and subwayPassed>=2 and securicarsStolen>=3) then
					goto reward
				else
					TriggerEvent('chatMessage', '[Daily objectives]', {255, 0, 0}, 'Conditions not met!')
					goto finish
				end
			elseif(objectives == 16) then
				if(firePassed>=3 and subwayPassed>=2 and shopsRobbed>=3) then
					goto reward
				else
					TriggerEvent('chatMessage', '[Daily objectives]', {255, 0, 0}, 'Conditions not met!')
					goto finish
				end
			end
			::reward::
			if(objscompleted == 0) then
				money = money + 50000
				experience = experience + 1000
				SaveStats()
				DrawMessage("~y~Daily objectives completed", "You have got 50000$ and 1000 EXP")
				objscompleted = 1
				SaveDaily()
			else
				TriggerEvent('chatMessage', '[Daily objectives]', {255, 0, 0}, 'Daily objectives are already completed! Come back on the next day.')
			end
			::finish::
		else
			goto daily
		end
	end
end