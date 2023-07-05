local bizinfo = {
[8] = {name = "East Hook Warehouse", price = 140000, level = 60, baseincome = 12000, pos = {785.70697, -175.26114, 6.09661}, carpos = {799.62286, -179.82402, 6.12096, 154.903793334961}, boatpos = {700.34998, -153.96507, -0.31771, 66.6124649047852}},
[9] = {name = "Fishmarket Warehouse", price = 140000, level = 60, baseincome = 12000, pos = {344.24582, -226.75497, 5.73458}, carpos = {355.487, -224.79695, 4.52157, 178.739471435547}, boatpos = {388.09299, -246.1227, -0.20054, 1.08807575702667}}
}

local bizid = 0
local mults = {0.1,0.1,0.2}
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
			if(biz[8+(i-1)] == 1) then
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
		for i=8,9,1 do
			if(not DoesBlipExist(bizblip[i])) then
				bizblip[i] = AddBlipForCoord(bizinfo[i].pos[1], bizinfo[i].pos[2], bizinfo[i].pos[3])
				ChangeBlipSprite(bizblip[i], 58)
				ChangeBlipScale(bizblip[i], 0.7)
				ChangeBlipNameFromAscii(bizblip[i], bizinfo[i].name)
				SetBlipAsShortRange(bizblip[i], true)
			end
			if(biz[8] == 0) then
				DrawTextAtCoord(bizinfo[i].pos[1], bizinfo[i].pos[2], bizinfo[i].pos[3], GetStringWithoutSpaces(bizinfo[i].name) .. " Price:_" .. bizinfo[i].price .. "$ Level_needed:_" .. bizinfo[i].level, 20)
				ChangeBlipColour(bizblip[i], 0)
			else
				DrawTextAtCoord(bizinfo[i].pos[1], bizinfo[i].pos[2], bizinfo[i].pos[3], GetStringWithoutSpaces(bizinfo[i].name) .. " Income:_" .. bizmoney[8] .. "$ Multiplier:_" .. bizmult[8], 20)
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
									tempitems[#tempitems+1] = "Getting cargo"
									tempitems[#tempitems+1] = "Delivering cargo"
									tempitems[#tempitems+1] = "Returning stolen goods"
									DrawWindow("Business_missions", tempitems)
									while menuactive do
										Wait(0)
									end
									if(menuresult > 0) then
										if(bizcooldown[menuresult] <= 0) then
											if(tempitems[menuresult] == "Getting cargo") then
												vehs[1] = SpawnCar(GetHashKey("MULE"), bizinfo[i].carpos[1], bizinfo[i].carpos[2], bizinfo[i].carpos[3], bizinfo[i].carpos[4])
												blips[1] = AddBlipForCar(vehs[1])
												SetObjective("Get into ~y~the truck")
												TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
												currmission = 1
												missionstarted = 1
											elseif(tempitems[menuresult] == "Delivering cargo") then
												vehs[1] = SpawnCar(GetHashKey("DINGHY"), bizinfo[i].boatpos[1], bizinfo[i].boatpos[2], bizinfo[i].boatpos[3], bizinfo[i].boatpos[4])
												blips[1] = AddBlipForCar(vehs[1])
												SetObjective("Get into ~y~the boat")
												TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
												currmission = 2
												missionstarted = 1
											elseif(tempitems[menuresult] == "Returning stolen goods") then
												local coords = {
												{
												{1222.63074, 692.54181, 37.53048, 329.631591796875},
												{1220.34131, 699.56354, 37.38562, 63.6461448669434},
												{1230.77307, 701.40741, 37.29459, 266.387786865234},
												{1219.79834, 678.57874, 37.95445, 129.504730224609},
												{1207.8634, 676.18048, 38.32405, 103.624786376953},
												{1208.37793, 691.95959, 38.32405, 344.670532226563}
												},
												{
												{1464.08228, 1749.97925, 16.86454, 358.770538330078},
												{1471.24548, 1744.33472, 16.69472, 205.529418945313},
												{1464.8833, 1756.24255, 16.86487, 30.7619094848633},
												{1452.9668, 1754.72046, 16.86456, 99.8762741088867},
												{1444.91833, 1747.17273, 16.86456, 90.881721496582},
												{1432.85205, 1751.79443, 16.92108, 188.308578491211}
												},
												{
												{-174.45229, 1628.27246, 20.42072, 268.370452880859},
												{-176.31972, 1638.01379, 20.42074, 345.157135009766},
												{-170.45729, 1644.94788, 20.56993, 174.240173339844},
												{-162.24394, 1642.88599, 20.56991, 223.172424316406},
												{-161.72272, 1624.61084, 20.42074, 324.4931640625},
												{-159.10135, 1617.47839, 20.42074, 277.207153320313}
												},
												{
												{1.23033, -192.54761, 14.53183, 1.08515310287476},
												{2.50095, -183.26167, 14.53183, 0.71919196844101},
												{-7.246, -192.7766, 14.53183, 149.203155517578},
												{-8.69956, -178.58894, 14.53643, 7.87604951858521},
												{-3.6128, -194.38669, 15.59388, 8.79703712463379},
												{-4.14951, -185.70702, 14.53183, 357.449737548828}
												},
												{
												{-1670.39661, -516.99109, 2.92926, 357.774475097656},
												{-1669.23657, -507.76718, 2.92926, 352.986083984375},
												{-1682.71582, -516.28699, 4.69813, 271.539337158203},
												{-1676.08997, -517.99481, 2.92925, 1.32696902751923},
												{-1678.45703, -503.52725, 2.92926, 352.780029296875},
												{-1686.84802, -503.08646, 2.92925, 98.767936706543}
												},
												{
												{-1525.7301, 886.47595, 24.79625, 179.32389831543},
												{-1532.75757, 881.77179, 24.79625, 258.308471679688},
												{-1521.0343, 878.14838, 24.79625, 240.542236328125},
												{-1516.82397, 887.16693, 24.79628, 337.028045654297},
												{-1515.00439, 899.47546, 24.79625, 219.045394897461},
												{-1506.40845, 898.05902, 24.7398, 246.098724365234}
												}
												}
												local rnd = GenerateRandomIntInRange(1, #coords+1)
												vehs[1] = SpawnCar(GetHashKey("MULE"), coords[rnd][1][1], coords[rnd][1][2], coords[rnd][1][3], coords[rnd][1][4])
												blips[1] = AddBlipForCar(vehs[1])
												for i=2,6,1 do
													peds[i-1] = SpawnPed(GetHashKey("M_Y_GMAF_HI_01"), coords[rnd][i][1], coords[rnd][i][2], coords[rnd][i][3], coords[rnd][i][4])
													GiveWeaponToChar(peds[i-1], 7, 1000, 1)
												end
												SetObjective("Get into ~y~the stolen truck")
												TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
												currmission = 3
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
			for i=8,9,1 do
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
							if(GetDriverOfCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), _i) == GetPlayerChar(GetPlayerId())) then
								RemoveBlip(blips[1])
								local coords = {
								{1054.02954, 308.37515, 31.459, 57.1999359130859},
								{1842.78284, 478.29208, 28.09805, 269.2880859375},
								{338.85815, -296.92734, 4.45197, 178.761276245117},
								{-473.64127, 353.82071, 6.66427, 177.61686706543},
								{-201.68549, 1762.52942, 7.4901, 358.933258056641},
								{855.23834, 1687.11877, 17.05902, 134.813461303711},
								{-1334.41919, 1749.25085, 27.82465, 180.444351196289},
								{-949.13556, 721.93652, 3.8156, 118.671607971191},
								{-1961.59375, 112.44535, 7.57478, 179.819610595703},
								{-1221.37158, -344.00674, 2.83687, 356.038330078125}
								}
								local rnd = GenerateRandomIntInRange(1, #coords+1)
								objs[1] = SpawnObject(GetHashKey("bm_mu_crate_03a"), coords[rnd][1], coords[rnd][2], coords[rnd][3]-1, coords[rnd][4])
								blips[1] = AddBlipForObject(objs[1])
								SetObjective("Collect ~y~the marked cargo")
								currstage = 1
							end
						end
					else
						DrawMessage("~r~Mission failed", "Truck destroyed.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(not IsCarDead(vehs[1])) then
						local ox,oy,oz = GetObjectCoordinates(objs[1], _f, _f, _f)
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							if(GetDriverOfCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), _i) == GetPlayerChar(GetPlayerId())) then
								if(IsVehicleTouchingObject(vehs[1], objs[1]) or IsPlayerNearCoords(ox, oy, oz, 3)) then
									RemoveBlip(blips[1])
									DeleteObject(objs[1])
									blips[1] = AddBlipForCoord(bizinfo[bizid].carpos[1], bizinfo[bizid].carpos[2], bizinfo[bizid].carpos[3])
									SetRoute(blips[1], true)
									SetObjective("Deliver ~y~this crate ~w~to ~y~the warehouse")
									currstage = 2
								end
							end
						else
							PrintStringWithLiteralStringNow("STRING", "~r~You must be in the mission car!", 1000, 1)
						end
					else
						DrawMessage("~r~Mission failed", "Truck destroyed.")
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
						DrawMessage("~r~Mission failed", "Truck destroyed.")
						EndMission()
					end
				end
			elseif(currmission == 2) then
				if(currstage == 0) then
					if(not IsCarDead(vehs[1])) then
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							RemoveBlip(blips[1])
							local coords = {
							{2183.52905, 28.64857, -0.30263, 357.420074462891},
							{1233.72754, 1329.68445, -0.54544, 90.3970947265625},
							{410.25272, 1107.74194, -0.49924, 91.8411712646484},
							{-51.39759, -973.07031, -0.55082, 90.0388946533203},
							{-888.07947, 680.9425, -0.4639, 213.387176513672},
							{-202.37502, 1778.10425, -0.64595, 272.282165527344},
							{-1140.70386, 1893.4895, -0.55617, 175.839309692383},
							{-1890.32617, -722.09705, -0.22085, 94.5669860839844}
							}
							local rnd = GenerateRandomIntInRange(1, #coords+1)
							blips[1] = AddBlipForCoord(coords[rnd][1], coords[rnd][2], coords[rnd][3])
							SetRoute(blips[1], true)
							SetObjective("Deliver ~y~the goods ~w~to ~y~the marked point")
							currstage = 1
						end
					else
						DrawMessage("~r~Mission failed", "Boat destroyed.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(not IsCarDead(vehs[1])) then
						local bp = GetBlipCoords(blips[1])
						DrawCheckpointWithDist(bp.x, bp.y, bp.z, 1.1, 255, 255, 0, 100)
						if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
							if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
								RemoveBlip(blips[1])
								blips[1] = AddBlipForCoord(bizinfo[bizid].boatpos[1], bizinfo[bizid].boatpos[2], bizinfo[bizid].boatpos[3])
								SetRoute(blips[1], true)
								SetObjective("Return ~y~the boat ~w~to ~y~the warehouse")
								currstage = 2
							else
								PrintStringWithLiteralStringNow("STRING", "~r~You must be in the mission car!", 1000, 1)
							end
						end
					else
						DrawMessage("~r~Mission failed", "Boat destroyed.")
						EndMission()
					end
				elseif(currstage == 2) then
					if(not IsCarDead(vehs[1])) then
						local bp = GetBlipCoords(blips[1])
						DrawCheckpointWithDist(bp.x, bp.y, bp.z, 1.1, 255, 255, 0, 100)
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
						DrawMessage("~r~Mission failed", "Truck destroyed.")
						EndMission()
					end
				end
			elseif(currmission == 3) then
				if(currstage == 0) then
					if(not IsCarDead(vehs[1])) then
						for i=1,5,1 do
							if(not IsCharDead(peds[i])) then
								if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
									for j=1,5,1 do
										AttackPlayer(peds[j])
									end
								end
							end
						end
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							RemoveBlip(blips[1])
							blips[1] = AddBlipForCoord(bizinfo[bizid].carpos[1], bizinfo[bizid].carpos[2], bizinfo[bizid].carpos[3])
							SetRoute(blips[1], true)
							SetObjective("Return ~y~this truck ~w~to ~y~the warehouse")
							currstage = 1
						end
					else
						DrawMessage("~r~Mission failed", "Truck destroyed.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(not IsCarDead(vehs[1])) then
						local bp = GetBlipCoords(blips[1])
						DrawCheckpointWithDist(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
						if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
							if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
								experience = experience + mults[3]*1000
								SaveStats()
								DrawMessage("~y~Mission completed", "Income multiplier has been increased (+" .. mults[3] .. "/+" .. mults[3]*1000 .. " EXP)")
								bizMissionsCompleted = bizMissionsCompleted + 1
								SaveDailyStats()
								bizmult[bizid] = bizmult[bizid] + mults[3]
								SaveBizMult()
								bizcooldown[3] = mults[3]*1000
								EndMission()
							else
								PrintStringWithLiteralStringNow("STRING", "~r~You must be in the mission car!", 1000, 1)
							end
						end
					else
						DrawMessage("~r~Mission failed", "Truck destroyed.")
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