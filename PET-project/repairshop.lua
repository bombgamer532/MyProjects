local bizinfo = {
[3] = {name = "F Auto Repair", price = 65000, level = 20, baseincome = 4500, pos = {1790.29871, 192.80301, 21.09239}, finish = {1793.57104, 195.18954, 21.09239}},
[4] = {name = "Muscle Mary's", price = 70000, level = 20, baseincome = 5000, pos = {705.50323, 1512.13904, 14.84259}, finish = {711.24908, 1506.17749, 14.8426}}
}

local bizid = 0
local mults = {0.1,0.3}
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
		for i=1,2,1 do
			if(biz[3+(i-1)] == 1) then
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
		for i=3,4,1 do
			if(not DoesBlipExist(bizblip[i])) then
				bizblip[i] = AddBlipForCoord(bizinfo[i].pos[1], bizinfo[i].pos[2], bizinfo[i].pos[3])
				ChangeBlipSprite(bizblip[i], 91)
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
						if(level >= 20) then
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
									tempitems[#tempitems+1] = "Car stealing"
									tempitems[#tempitems+1] = "Tuning"
									DrawWindow("Business_missions", tempitems)
									while menuactive do
										Wait(0)
									end
									if(menuresult > 0) then
										if(bizcooldown[menuresult] <= 0) then
											if(tempitems[menuresult] == "Car stealing") then
												local coords = {
												{2009.57678, 646.00641, 18.01969, 267.803253173828},
												{1330.32532, 885.23065, 13.72902, 268.110046386719},
												{1041.29163, 498.88367, 19.30016, 187.650192260742},
												{1315.82483, -68.38197, 27.34535, 359.085235595703},
												{956.47583, -505.29242, 15.16238, 89.8489227294922},
												{321.65414, -427.9624, 4.69798, 358.2607421875},
												{-233.44554, -266.67172, 14.47199, 267.517822265625},
												{-421.99133, 294.79132, 11.16813, 179.48583984375},
												{-131.74034, 1217.47168, 17.00859, 86.6949844360352},
												{494.06747, 1639.99487, 20.09853, 359.036193847656},
												{1105.24939, 1762.06604, 10.74311, 332.117736816406},
												{589.24908, 737.91138, 2.80116, 90.302001953125},
												{434.98962, 38.47533, 8.85856, 94.8979949951172},
												{-1080.55713, -247.3073, 3.78148, 328.728912353516},
												{-1774.60583, -8.00294, 9.31047, 15.1414785385132},
												{-1463.86133, 702.13556, 19.61952, 238.359786987305},
												{-960.82159, 1132.83044, 17.4348, 176.713912963867},
												{-1358.9884, 1714.7854, 27.82516, 334.229705810547}
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
												SetObjective("Steal ~y~the marked vehicle")
												TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
												currmission = 1
												missionstarted = 1
											elseif(tempitems[menuresult] == "Tuning") then
												local coords = {
												{2009.57678, 646.00641, 18.01969, 267.803253173828},
												{1330.32532, 885.23065, 13.72902, 268.110046386719},
												{1041.29163, 498.88367, 19.30016, 187.650192260742},
												{1315.82483, -68.38197, 27.34535, 359.085235595703},
												{956.47583, -505.29242, 15.16238, 89.8489227294922},
												{321.65414, -427.9624, 4.69798, 358.2607421875},
												{-233.44554, -266.67172, 14.47199, 267.517822265625},
												{-421.99133, 294.79132, 11.16813, 179.48583984375},
												{-131.74034, 1217.47168, 17.00859, 86.6949844360352},
												{494.06747, 1639.99487, 20.09853, 359.036193847656},
												{1105.24939, 1762.06604, 10.74311, 332.117736816406},
												{589.24908, 737.91138, 2.80116, 90.302001953125},
												{434.98962, 38.47533, 8.85856, 94.8979949951172},
												{-1080.55713, -247.3073, 3.78148, 328.728912353516},
												{-1774.60583, -8.00294, 9.31047, 15.1414785385132},
												{-1463.86133, 702.13556, 19.61952, 238.359786987305},
												{-960.82159, 1132.83044, 17.4348, 176.713912963867},
												{-1358.9884, 1714.7854, 27.82516, 334.229705810547}
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
												SetObjective("Reach ~y~the marked vehicle ~w~and ~y~enter it")
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
			for i=3,4,1 do
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
							AlterWantedLevel(GetPlayerId(), 2)
							ApplyWantedLevelChangeNow(GetPlayerId())
							SetObjective("You have been reported for car stealing. Lose ~y~wanted level")
							currstage = 1
						end
					else
						DrawMessage("~r~Mission failed", "Car destroyed.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(StoreWantedLevel(GetPlayerId(), _i) == 0) then
						blips[1] = AddBlipForCoord(bizinfo[bizid].finish[1], bizinfo[bizid].finish[2], bizinfo[bizid].finish[3])
						SetRoute(blips[1], true)
						SetObjective("Deliver ~y~this vehicle ~w~to ~y~the repair shop")
						currstage = 2
					end
					if(IsCarDead(vehs[1])) then
						DrawMessage("~r~Mission failed", "Car destroyed.")
						EndMission()
					end
				elseif(currstage == 2) then
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
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							SetRoute(blips[1], false)
							blips[2] = AddBlipForCoord(bizinfo[bizid].finish[1], bizinfo[bizid].finish[2], bizinfo[bizid].finish[3])
							SetRoute(blips[2], true)
							SetObjective("Deliver ~y~this vehicle ~w~to ~y~the repair shop")
							currstage = 1
						end
					else
						DrawMessage("~r~Mission failed", "Car destroyed.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(not IsCarDead(vehs[1])) then
						local bp = GetBlipCoords(blips[2])
						DrawCheckpointWithDist(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
						if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
							if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
								RemoveBlip(blips[2])
								SetRoute(blips[1], true)
								SetObjective("Return ~y~this vehicle ~w~to ~y~the client")
								currstage = 2
							else
								PrintStringWithLiteralStringNow("STRING", "~r~You must be in the mission car!", 1000, 1)
							end
						end
					else
						DrawMessage("~r~Mission failed", "Car destroyed.")
						EndMission()
					end
				elseif(currstage == 2) then
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