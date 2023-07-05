local bizinfo = {
[5] = {name = "Topaz Car Park", price = 90000, level = 50, baseincome = 7000, pos = {54.20298, 1112.75818, 3.59875}, finish = {67.26603, 1136.34607, 2.91673}},
[6] = {name = "Airport Parking Zone", price = 120000, level = 50, baseincome = 10000, pos = {2276.02515, 372.60135, 7.4955}, finish = {2254.93652, 382.73367, 7.49221}},
[7] = {name = "Leftwood Car Park", price = 100000, level = 50, baseincome = 8000, pos = {-1035.18567, 1404.40918, 25.83926}, finish = {-1021.47223, 1453.32385, 28.02073}}
}

local bizid = 0
local mults = {0.1,0.2}
local bizcooldown = {}
for i=1,#mults,1 do
	bizcooldown[i] = 0
end
CreateThread(function()
	while true do
		Wait(1000)
		for i=1,#bizcooldown,1 do
			if(bizcooldown[i] > 0) then
				bizcooldown[i] = bizcooldown[i] - 1
			end
		end
	end
end)

local realmults = {}
for i=1,#mults,1 do
	realmults[i] = mults[i]
end
CreateThread(function()
	while true do
		Wait(0)
		local amount = 0
		for i=1,3,1 do
			if(biz[5+(i-1)] == 1) then
				amount = amount + 1
			end
		end
		if(amount > 0) then
			for i=1,#mults,1 do
				mults[i] = realmults[i] + 0.1*(amount-1)
			end
		end
	end
end)

local currmission = 0
local currstage = 0
local EndMission = function()
	currmission = 0
	currstage = 0
	CleanMission()
end

local bizblip = {}
CreateThread(function()
	while true do
		Wait(0)
		for i=5,7,1 do
			if(not DoesBlipExist(bizblip[i])) then
				bizblip[i] = AddBlipForCoord(bizinfo[i].pos[1], bizinfo[i].pos[2], bizinfo[i].pos[3])
				ChangeBlipSprite(bizblip[i], 79)
				ChangeBlipScale(bizblip[i], 0.7)
				ChangeBlipNameFromAscii(bizblip[i], bizinfo[i].name)
				SetBlipAsShortRange(bizblip[i], true)
			end
			if(biz[i] == 0) then
				DrawTextAtCoord(bizinfo[i].pos[1], bizinfo[i].pos[2], bizinfo[i].pos[3], GetStringWithoutSpaces(bizinfo[i].name) .. " Price:_" .. bizinfo[i].price .. "$ Level_needed:_" .. bizinfo[i].level, 20)
				ChangeBlipColour(bizblip[i], 0)
			else
				DrawTextAtCoord(bizinfo[i].pos[1], bizinfo[i].pos[2], bizinfo[i].pos[3], GetStringWithoutSpaces(bizinfo[i].name) .. " Income:_" .. bizmoney[i] .. "$ Multiplier:_" .. bizmult[i], 20)
				ChangeBlipColour(bizblip[i], 2)
			end
			DrawCheckpointWithDist(bizinfo[i].pos[1], bizinfo[i].pos[2], bizinfo[i].pos[3]-1, 1.1, 255, 255, 0, 100)
			if(IsPlayerNearCoords(bizinfo[i].pos[1], bizinfo[i].pos[2], bizinfo[i].pos[3], 1)) then
				DrawDescription("Business", {
				-----------------------------------------------------------------------------------------------
				"Business lets you get a passive income, which depends on multiplier. This multiplier can be",
				"increased by doing business missions. Each business has its own set of missions.",
				"All businesses are separated between categories. When you own several businesses of same",
				"type, you increase multiplier increase rate by doing missions.",
				"Income is received once per in-game day in 00:00. After that, income multiplier gets lowered.",
				"If you stop taking care of your business, its multiplier will reach zero and you will stop",
				"receiving income.",
				"Businesses are also needed to get access to heists (via organization). Some businesses provide",
				"access to some additional side-jobs."
				})
				if(biz[i] == 0) then
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to purchase ~y~" .. bizinfo[i].name .. " ~w~business ~w~for ~g~" .. bizinfo[i].price .. "$", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						if(level >= bizinfo[i].level) then
							if(money >= bizinfo[i].price) then
								money = money - bizinfo[i].price
								SaveStats()
								biz[i] = 1
								SaveBiz()
								TriggerEvent('chatMessage', '[Business]', {0, 255, 0}, 'This business has been successfully purchased!')
							else
								TriggerEvent('chatMessage', '[Business]', {255, 0, 0}, 'You cannot afford it!')
							end
						else
							TriggerEvent('chatMessage', '[Business]', {255, 0, 0}, 'You must reach level ' .. bizinfo[i].level .. '!')
						end
					end
				else
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~open business menu", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						DrawWindow(bizinfo[i].name, {"Collect income", "Missions"})
						while menuactive do
							Wait(0)
						end
						if(menuresult > 0) then
							if(menuresult == 1) then
								money = money + bizmoney[i]
								SaveStats()
								TriggerEvent('chatMessage', '[Business]', {0, 255, 0}, 'Income collected')
								bizmoney[i] = 0
								SaveBizMoney()
							elseif(menuresult == 2) then
								if(missionstarted == 0) then
									bizid = i
									local tempitems = {}
									tempitems[#tempitems+1] = "Parking vehs"
									tempitems[#tempitems+1] = "Car returning"
									DrawWindow("Business_missions", tempitems)
									while menuactive do
										Wait(0)
									end
									if(menuresult > 0) then
										if(bizcooldown[menuresult] <= 0) then
											if(tempitems[menuresult] == "Parking vehs") then
												local coords = {
												{-240.54962, 178.41364, 14.72077, 0.00997207593172789},
												{15.51096, -712.09052, 9.40292, 0.996797740459442},
												{-1597.84607, -358.18616, 2.56068, 267.993988037109},
												{-1472.36938, 695.5827, 19.59766, 327.502044677734},
												{-1042.61011, 1639.30029, 35.45897, 87.7922973632813},
												{908.5426, 1722.71875, 16.79771, 312.091156005859},
												{1196.71875, 809.58325, 35.97434, 132.887084960938},
												{1762.4873, 493.53668, 28.91337, 311.545806884766},
												{1039.07605, -513.0072, 14.81829, 359.177917480469},
												{-510.95981, 1763.35742, 8.60495, 192.207885742188}
												}
												local carlist = {
												"FELTZER",
												"INFERNUS",
												"PMP600",
												"ORACLE",
												"LANDSTALKER",
												"FEROCI",
												"HUNTLEY",
												"COMET",
												"COQUETTE",
												"COGNOSCENTI",
												"CAVALCADE",
												"BANSHEE",
												"PATRIOT",
												"RUINER",
												"SULTAN",
												"SULTANRS",
												"SUPERGT",
												"TURISMO"
												}
												local rnd = GenerateRandomIntInRange(1, #coords+1)
												vehs[1] = SpawnCar(GetHashKey(carlist[GenerateRandomIntInRange(1, #carlist+1)]), coords[rnd][1], coords[rnd][2], coords[rnd][3], coords[rnd][4])
												blips[1] = AddBlipForCar(vehs[1])
												SetObjective("Get into ~y~the client's car")
												TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
												currmission = 1
												missionstarted = 1
											elseif(tempitems[menuresult] == "Car returning") then
												local coords = {
												{-938.27002, 1172.13184, 17.82826, 88.5877456665039},
												{-1260.27991, 732.88684, 20.94757, 169.03678894043},
												{88.53516, 248.13602, 17.67999, 265.214782714844},
												{978.52832, -392.76617, 37.73285, 97.5458297729492},
												{1956.31445, 105.35055, 17.94713, 290.804962158203},
												{965.6507, 628.25311, 38.48837, 87.9751739501953},
												{1377.87854, 1020.00317, 13.63438, 326.672882080078}
												}
												local carlist = {
												"FELTZER",
												"INFERNUS",
												"PMP600",
												"ORACLE",
												"LANDSTALKER",
												"FEROCI",
												"HUNTLEY",
												"COMET",
												"COQUETTE",
												"COGNOSCENTI",
												"CAVALCADE",
												"BANSHEE",
												"PATRIOT",
												"RUINER",
												"SULTAN",
												"SULTANRS",
												"SUPERGT",
												"TURISMO"
												}
												local rnd = GenerateRandomIntInRange(1, #coords+1)
												vehs[1] = SpawnCar(GetHashKey(carlist[GenerateRandomIntInRange(1, #carlist+1)]), coords[rnd][1], coords[rnd][2], coords[rnd][3], coords[rnd][4])
												blips[1] = AddBlipForCar(vehs[1])
												peds[1] = SpawnPed(GetHashKey("M_Y_GMAF_HI_01"), coords[rnd][1], coords[rnd][2], coords[rnd][3], coords[rnd][4])
												GiveWeaponToChar(peds[1], 12, 1000, 1)
												TaskCarMission(peds[1], vehs[1], vehs[1], 1, 20.1, 4, 0, 10)
												SetObjective("Get into ~y~the stolen car")
												TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
												currmission = 2
												missionstarted = 1
											end
										else
											TriggerEvent('chatMessage', '[Business]', {255, 0, 0}, 'This mission will be available in ' .. math.floor(bizcooldown[menuresult]) .. ' seconds!')
										end
									end
								else
									TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'Mission in progress!')
								end
							end
						end
					end
				end
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		local h,m = GetTimeOfDay(_i, _i)
		if(h==0 and m==0) then
			for i=5,7,1 do
				if(biz[i] == 1) then
					bizmoney[i] = bizmoney[i] + bizinfo[i].baseincome*bizmult[i]
					SaveBizMoney()
					TriggerEvent('chatMessage', '[Business]', {0, 255, 0}, bizinfo[i].name .. ' has got an income (+' .. bizinfo[i].baseincome*bizmult[i] .. '$ / -0.2 multiplier)!')
					bizmult[i] = bizmult[i] - 0.2
					if(bizmult[i] < 0) then
						bizmult[i] = 0
					end
					SaveBizMult()
				end
			end
			while m==0 do
				Wait(0)
				h,m = GetTimeOfDay(_i, _i)
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if(currmission > 0) then
			if(currmission == 1) then
				if(currstage == 0) then
					if(not IsCarDead(vehs[1])) then
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							RemoveBlip(blips[1])
							blips[1] = AddBlipForCoord(bizinfo[bizid].finish[1], bizinfo[bizid].finish[2], bizinfo[bizid].finish[3])
							SetRoute(blips[1], true)
							SetObjective("Park ~y~this car ~w~at ~y~the parking lot")
							currstage = 1
						end
					else
						DrawMessage("~r~Mission failed", "Car destroyed.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(not IsCarDead(vehs[1])) then
						local bp = GetBlipCoords(blips[1])
						DrawCheckpointWithDist(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
						if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
							if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
								experience = experience + mults[1]*1000
								SaveStats()
								DrawMessage("~y~Mission completed", "Income multiplier has been increased (+" .. mults[1] .. "/+" .. mults[1]*1000 .. " EXP)")
								bizMissionsCompleted = bizMissionsCompleted + 1
								SaveDailyStats()
								bizmult[bizid] = bizmult[bizid] + mults[1]
								SaveBizMult()
								bizcooldown[1] = mults[1]*1000
								EndMission()
							else
								PrintStringWithLiteralStringNow("STRING", "~r~You must be in the mission car!", 1000, 1)
							end
						end
					else
						DrawMessage("~r~Mission failed", "Car destroyed.")
						EndMission()
					end
				end
			elseif(currmission == 2) then
				if(currstage == 0) then
					if(not IsCarDead(vehs[1])) then
						if(HasCharBeenDamagedByChar(peds[1], GetPlayerChar(GetPlayerId())) or HasCarBeenDamagedByChar(vehs[1], GetPlayerChar(GetPlayerId()))) then
							AttackPlayer(peds[1])
						end
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							RemoveBlip(blips[1])
							blips[1] = AddBlipForCoord(bizinfo[bizid].finish[1], bizinfo[bizid].finish[2], bizinfo[bizid].finish[3])
							SetRoute(blips[1], true)
							SetObjective("Return ~y~this car ~w~to ~y~the parking lot")
							currstage = 1
						end
					else
						DrawMessage("~r~Mission failed", "Car destroyed.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(not IsCarDead(vehs[1])) then
						local bp = GetBlipCoords(blips[1])
						DrawCheckpointWithDist(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
						if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
							if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
								experience = experience + mults[2]*1000
								SaveStats()
								DrawMessage("~y~Mission completed", "Income multiplier has been increased (+" .. mults[2] .. "/+" .. mults[2]*1000 .. " EXP)")
								bizMissionsCompleted = bizMissionsCompleted + 1
								SaveDailyStats()
								bizmult[bizid] = bizmult[bizid] + mults[2]
								SaveBizMult()
								bizcooldown[2] = mults[2]*1000
								EndMission()
							else
								PrintStringWithLiteralStringNow("STRING", "~r~You must be in the mission car!", 1000, 1)
							end
						end
					else
						DrawMessage("~r~Mission failed", "Car destroyed.")
						EndMission()
					end
				end
			end
			if(IsPlayerDead(GetPlayerId())) then
				DrawMessage("~r~Mission failed", "You have died.")
				EndMission()
			end
		end
	end
end)