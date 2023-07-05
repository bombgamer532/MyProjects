local bizinfo = {
[1] = {name = "The Triangle Club", price = 90000, level = 40, baseincome = 7000, pos = {1150.92285, 1670.46143, 16.72696}, carpos = {1154.00061, 1664.83496, 16.7125, 221.922744750977}},
[2] = {name = "Honkers", price = 90000, level = 40, baseincome = 7000, pos = {-1578.08435, 1.42009, 10.01467}, carpos = {-1561.63403, 34.72224, 10.05529, 96.3950042724609}}
}

local bizid = 0
local mults = {0.1,0.2,0.1}
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
			if(biz[1+(i-1)] == 1) then
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
		for i=1,2,1 do
			if(not DoesBlipExist(bizblip[i])) then
				bizblip[i] = AddBlipForCoord(bizinfo[i].pos[1], bizinfo[i].pos[2], bizinfo[i].pos[3])
				ChangeBlipSprite(bizblip[i], 66)
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
									tempitems[#tempitems+1] = "Fighting rivals"
									tempitems[#tempitems+1] = "Pimping"
									tempitems[#tempitems+1] = "Advertisement"
									DrawWindow("Business_missions", tempitems)
									while menuactive do
										Wait(0)
									end
									if(menuresult > 0) then
										if(bizcooldown[menuresult] <= 0) then
											if(tempitems[menuresult] == "Fighting rivals") then
												local coords = {
												{
												{365.31519, 1897.85046, 19.39871, 86.1212310791016},
												{368.29211, 1906.63513, 19.40338, 222.127304077148},
												{382.53482, 1905.29541, 19.40326, 125.999130249023},
												{369.98532, 1916.20313, 19.40293, 169.330154418945},
												{378.96164, 1915.47266, 19.40239, 151.120010375977}
												},
												{
												{620.5155, 752.96082, 2.76355, 94.9952545166016},
												{632.76996, 754.30841, 2.79082, 292.330169677734},
												{626.71185, 772.23737, 2.7881, 109.771789550781},
												{633.35699, 769.86456, 2.80286, 267.537048339844},
												{633.01306, 763.052, 2.78166, 252.890289306641}
												},
												{
												{1576.73499, 881.28833, 16.04552, 350.161224365234},
												{1563.81226, 879.04333, 16.04552, 37.5019683837891},
												{1559.61597, 866.36188, 16.04552, 171.767547607422},
												{1571.80444, 854.3327, 16.04552, 204.692886352539},
												{1583.80115, 860.97778, 16.04552, 312.458312988281}
												},
												{
												{1180.76953, -100.84312, 30.81783, 91.5649261474609},
												{1197.83594, -96.18465, 30.77889, 287.346405029297},
												{1198.21985, -106.93952, 28.49079, 282.082885742188},
												{1210.2533, -113.6012, 28.11411, 184.242431640625},
												{1217.26733, -96.18057, 28.00545, 271.477661132813}
												},
												{
												{-1236.70935, -329.33459, 2.83687, 336.923522949219},
												{-1252.69458, -325.56509, 2.83687, 34.1648635864258},
												{-1259.63098, -331.7258, 2.83687, 162.470260620117},
												{-1258.8999, -347.57712, 2.69365, 228.466110229492},
												{-1242.35706, -347.9129, 2.83687, 185.913070678711}
												},
												{
												{-1615.32056, 734.66791, 28.48078, 350.166076660156},
												{-1626.25452, 727.76489, 28.31625, 249.035903930664},
												{-1634.20996, 715.03711, 28.31624, 219.366760253906},
												{-1628.40637, 707.32288, 28.29687, 358.0751953125},
												{-1612.81702, 713.39569, 27.36064, 89.7054748535156}
												},
												{
												{-1284.88232, 1834.64453, 6.48229, 260.937622070313},
												{-1283.7356, 1852.66772, 6.48229, 260.817291259766},
												{-1295.39026, 1852.90833, 6.48229, 146.413696289063},
												{-1308.86096, 1843.29736, 6.35962, 109.72924041748},
												{-1303.19922, 1833.06641, 6.4823, 349.050170898438}
												}
												}
												local rnd = GenerateRandomIntInRange(1, #coords+1)
												for i=1,5,1 do
													peds[i] = SpawnPed(GetHashKey("M_Y_CHINATOWN_03"), coords[rnd][i][1], coords[rnd][i][2], coords[rnd][i][3], coords[rnd][i][4])
													GiveWeaponToChar(peds[i], 7, 1000, 1)
													blips[i] = AddBlipForChar(peds[i])
												end
												SetObjective("Reach ~y~the marked point ~w~and ~y~defeat a rival gang")
												TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
												currmission = 1
												missionstarted = 1
											elseif(tempitems[menuresult] == "Pimping") then
												vehs[1] = SpawnCar(GetHashKey("PRES"), bizinfo[i].carpos[1], bizinfo[i].carpos[2], bizinfo[i].carpos[3], bizinfo[i].carpos[4])
												blips[1] = AddBlipForCar(vehs[1])
												SetObjective("Get into ~y~the car")
												TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
												currmission = 2
												missionstarted = 1
											elseif(tempitems[menuresult] == "Advertisement") then
												variation = GenerateRandomIntInRange(1, 10, _i)
												vehs[1] = SpawnCar(GetHashKey("SPEEDO"), bizinfo[i].carpos[1], bizinfo[i].carpos[2], bizinfo[i].carpos[3], bizinfo[i].carpos[4])
												blips[1] = AddBlipForCar(vehs[1])
												SetObjective("Get into ~y~the car")
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
			for i=1,2,1 do
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
					local mobskilled = 0
					for i=1,5,1 do
						if(IsCharDead(peds[i])) then
							RemoveBlip(blips[i])
							mobskilled = mobskilled + 1
						else
							if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
								for j=1,5,1 do
									AttackPlayer(peds[j])
								end
							end
						end
					end
					if(mobskilled == 5) then
						SetObjective("Leave ~y~the area")
						currstage = 1
					end
				elseif(currstage == 1) then
					local px,py,pz = GetCharCoordinates(peds[1])
					if(not IsPlayerNearCoords(px, py, pz, 100)) then
						experience = experience + mults[1]*1000
						SaveStats()
						DrawMessage("~y~Mission completed", "Income multiplier has been increased (+" .. mults[1] .. "/+" .. mults[1]*1000 .. " EXP)")
						bizMissionsCompleted = bizMissionsCompleted + 1
						SaveDailyStats()
						bizmult[bizid] = bizmult[bizid] + mults[1]
						SaveBizMult()
						bizcooldown[1] = mults[1]*1000
						EndMission()
					end
				end
			elseif(currmission == 2) then
				if(currstage == 0) then
					if(not IsCarDead(vehs[1])) then
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							RemoveBlip(blips[1])
							local coords = {
							{
							{521.80469, 1981.9386, 23.39717, 186.515197753906},
							{674.48828, 1394.12854, 14.27573, 285.825073242188},
							{605.60486, 752.44574, 2.74658, 88.3418502807617}
							},
							{
							{1119.1272, 802.25201, 34.3074, 85.4348068237305},
							{1801.97522, 512.38684, 28.47958, 271.154388427734},
							{936.59821, -310.98819, 18.42303, 4.63134908676147}
							},
							{
							{100.11052, -302.50079, 14.76734, 178.402847290039},
							{-445.31989, 483.60272, 9.96298, 83.0077285766602},
							{-218.94739, 1427.2511, 20.42733, 176.179321289063}
							},
							{
							{-982.72369, 1724.90332, 15.87128, 272.527954101563},
							{-1462.85498, 931.86731, 23.03875, 356.846984863281},
							{-1333.90344, -229.162, 2.92127, 2.41130304336548}
							}
							}
							local rnd = GenerateRandomIntInRange(1, #coords+1)
							for i=1,3,1 do
								peds[i] = SpawnPed(GetHashKey("F_Y_HOOKER_01"), coords[rnd][i][1], coords[rnd][i][2], coords[rnd][i][3], coords[rnd][i][4])
								blips[i] = AddBlipForChar(peds[i])
							end
							SetObjective("Reach ~y~the marked points ~w~and ~y~collect all hookers")
							currstage = 1
						end
					else
						DrawMessage("~r~Mission failed", "Car destroyed.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(not IsCarDead(vehs[1])) then
						local hookerspicked = 0
						for i=1,3,1 do
							if(not IsCharDead(peds[i])) then
								if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 5)) then
									if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
										if(GetDriverOfCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), _i) == GetPlayerChar(GetPlayerId())) then
											if(not IsCharInCar(peds[i], GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i))) then
												TaskEnterCarAsPassenger(peds[i], GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), 20000, i-1)
												Wait(5000)
											else
												RemoveBlip(blips[i])
												hookerspicked = hookerspicked + 1
											end
										end
									else
										PrintStringWithLiteralStringNow("STRING", "~r~You must be in the mission car!", 1000, 1)
									end
								end
							else
								DrawMessage("~r~Mission failed", "Hooker is dead.")
								EndMission()
								break
							end
						end
						if(hookerspicked == 3) then
							for i=1,3,1 do
								RemoveBlip(blips[i])
							end
							blips[1] = AddBlipForCoord(bizinfo[bizid].carpos[1], bizinfo[bizid].carpos[2], bizinfo[bizid].carpos[3])
							SetRoute(blips[1], true)
							SetObjective("Deliver ~y~the hookers ~w~to ~y~the club")
							currstage = 2
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
								if(GetDriverOfCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), _i) == GetPlayerChar(GetPlayerId())) then
									experience = experience + mults[2]*1000
									SaveStats()
									DrawMessage("~y~Mission completed", "Income multiplier has been increased (+" .. mults[2] .. "/+" .. mults[2]*1000 .. " EXP)")
									bizMissionsCompleted = bizMissionsCompleted + 1
									SaveDailyStats()
									bizmult[bizid] = bizmult[bizid] + mults[2]
									SaveBizMult()
									bizcooldown[2] = mults[2]*1000
									EndMission()
								end
							end
						end
						for i=1,3,1 do
							if(IsCharDead(peds[i])) then
								DrawMessage("~r~Mission failed", "Hooker is dead.")
								EndMission()
								break
							end
						end
					else
						DrawMessage("~r~Mission failed", "Car destroyed.")
						EndMission()
					end
				end
			elseif(currmission == 3) then
				if(currstage == 0) then
					if(not IsCarDead(vehs[1])) then
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							RemoveBlip(blips[1])
							local coords = {
							{1097.89807, 1597.35925, 16.72074, 48.4998321533203},
							{440.48419, 1521.09033, 16.37058, 186.105575561523},
							{884.0686, -476.18893, 15.11254, 174.815505981445},
							{1649.28967, 238.53252, 24.64988, 329.126403808594},
							{-141.11562, 71.96269, 14.76289, 105.35612487793},
							{-174.87476, 275.54675, 14.81819, 177.486602783203},
							{-1505.47253, 587.79315, 19.5723, 336.588104248047},
							{-1005.91272, 1607.04785, 24.00702, 180.540054321289},
							{-1483.07922, 1410.86536, 13.05528, 89.9839935302734}
							}
							local rnd = GenerateRandomIntInRange(1, #coords+1)
							blips[1] = AddBlipForCoord(coords[rnd][1], coords[rnd][2], coords[rnd][3])
							SetRoute(blips[1], true)
							SetObjective("Reach ~y~the marked point ~w~and ~y~drop leaflets")
							currstage = 1
						end
					else
						DrawMessage("~r~Mission failed", "Van destroyed.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(not IsCarDead(vehs[1])) then
						local bp = GetBlipCoords(blips[1])
						DrawCheckpointWithDist(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
						if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
							if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
								RemoveBlip(blips[1])
								local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
								local ph = GetCharHeading(GetPlayerChar(GetPlayerId()), _f)
								px = px + 3*math.cos((ph-90)*math.pi/180)
								py = py + 3*math.sin((ph-90)*math.pi/180)
								objs[1] = SpawnObject(2736900820, px, py, pz-0.5, ph)
								AlterWantedLevel(GetPlayerId(), 2)
								ApplyWantedLevelChangeNow(GetPlayerId())
								SetObjective("You have been reported for illegal advertising. Lose ~y~wanted level")
								currstage = 2
							else
								PrintStringWithLiteralStringNow("STRING", "~r~You must be in the mission car!", 1000, 1)
							end
						end
					else
						DrawMessage("~r~Mission failed", "Van destroyed.")
						EndMission()
					end
				elseif(currstage == 2) then
					if(not IsCarDead(vehs[1])) then
						if(StoreWantedLevel(GetPlayerId(), _i) == 0) then
							blips[1] = AddBlipForCoord(bizinfo[bizid].carpos[1], bizinfo[bizid].carpos[2], bizinfo[bizid].carpos[3])
							SetRoute(blips[1], true)
							SetObjective("Return ~y~the van ~w~to ~y~the club")
							currstage = 3
						end
					else
						DrawMessage("~r~Mission failed", "Van destroyed.")
						EndMission()
					end
				elseif(currstage == 3) then
					if(not IsCarDead(vehs[1])) then
						local bp = GetBlipCoords(blips[1])
						DrawCheckpointWithDist(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
						if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
							if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
								if(GetDriverOfCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), _i) == GetPlayerChar(GetPlayerId())) then
									experience = experience + mults[3]*1000
									SaveStats()
									DrawMessage("~y~Mission completed", "Income multiplier has been increased (+" .. mults[3] .. "/+" .. mults[3]*1000 .. " EXP)")
									bizMissionsCompleted = bizMissionsCompleted + 1
									SaveDailyStats()
									bizmult[bizid] = bizmult[bizid] + mults[3]
									SaveBizMult()
									bizcooldown[3] = mults[3]*1000
									EndMission()
								end
							else
								PrintStringWithLiteralStringNow("STRING", "~r~You must be in the mission car!", 1000, 1)
							end
						end
					else
						DrawMessage("~r~Mission failed", "Van destroyed.")
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