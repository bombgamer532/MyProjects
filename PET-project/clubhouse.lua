local bizinfo = {
[13] = {name = "Lost MC", price = 300000, level = 80, baseincome = 28000, pos = {-1715.17285, 354.49796, 26.34677}, carpos = {-1706.724, 359.63171, 25.30671, 238.042846679688}},
[14] = {name = "Angels of Death", price = 300000, level = 80, baseincome = 28000, pos = {-624.85583, 1207.82568, 6.06082}, carpos = {-625.59619, 1212.56946, 5.94787, 267.369842529297}}
}

local bizid = 0
local mults = {0.1,0.2,0.3,0.3}
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
			if(biz[13+(i-1)] == 1) then
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
		for i=13,14,1 do
			if(not DoesBlipExist(bizblip[i])) then
				bizblip[i] = AddBlipForCoord(bizinfo[i].pos[1], bizinfo[i].pos[2], bizinfo[i].pos[3])
				ChangeBlipSprite(bizblip[i], 60)
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
									tempitems[#tempitems+1] = "Stealing bikes"
									tempitems[#tempitems+1] = "Gangmates rescue"
									tempitems[#tempitems+1] = "Ammunition supply"
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
												for i=1,#coords[rnd],1 do
													peds[i] = SpawnPed(GetHashKey("M_Y_GBIK_HI_01"), coords[rnd][i][1], coords[rnd][i][2], coords[rnd][i][3], coords[rnd][i][4])
													GiveWeaponToChar(peds[i], 11, 1000, 1)
													blips[i] = AddBlipForChar(peds[i])
												end
												SetObjective("Reach ~y~the marked point ~w~and kill ~y~all mobsters")
												TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
												currmission = 1
												missionstarted = 1
											elseif(tempitems[menuresult] == "Stealing bikes") then
												vehs[1] = SpawnCar(GetHashKey("YANKEE"), bizinfo[i].carpos[1], bizinfo[i].carpos[2], bizinfo[i].carpos[3], bizinfo[i].carpos[4])
												blips[1] = AddBlipForCar(vehs[1])
												SetObjective("Get into ~y~the truck")
												TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
												currmission = 2
												missionstarted = 1
											elseif(tempitems[menuresult] == "Gangmates rescue") then
												local coords = {
												{-938.27002, 1172.13184, 17.82826, 88.5877456665039},
												{-1260.27991, 732.88684, 20.94757, 169.03678894043},
												{88.53516, 248.13602, 17.67999, 265.214782714844},
												{978.52832, -392.76617, 37.73285, 97.5458297729492},
												{1956.31445, 105.35055, 17.94713, 290.804962158203},
												{965.6507, 628.25311, 38.48837, 87.9751739501953},
												{1377.87854, 1020.00317, 13.63438, 326.672882080078}
												}
												local rnd = GenerateRandomIntInRange(1, #coords+1)
												vehs[1] = SpawnCar(GetHashKey("BURRITO2"), coords[rnd][1], coords[rnd][2], coords[rnd][3], coords[rnd][4])
												peds[1] = SpawnPed(GetHashKey("M_Y_GBIK02_LO_02"), coords[rnd][1], coords[rnd][2], coords[rnd][3], coords[rnd][4])
												blips[1] = AddBlipForChar(peds[1])
												WarpCharIntoCarAsPassenger(peds[1], vehs[1], 1)
												peds[2] = SpawnPed(GetHashKey("M_Y_GBIK_HI_01"), coords[rnd][1], coords[rnd][2], coords[rnd][3], coords[rnd][4])
												WarpCharIntoCar(peds[2], vehs[1])
												peds[3] = SpawnPed(GetHashKey("M_Y_GBIK_HI_01"), coords[rnd][1], coords[rnd][2], coords[rnd][3], coords[rnd][4])
												WarpCharIntoCarAsPassenger(peds[3], vehs[1], 0)
												for i=2,3,1 do
													GiveWeaponToChar(peds[i], 12, 1000, 1)
												end
												TaskCarMission(peds[2], vehs[1], vehs[1], 1, 10.1, 0, 0, 10)
												SetObjective("Rescue ~y~the gangmate")
												TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
												currmission = 3
												missionstarted = 1
											elseif(tempitems[menuresult] == "Ammunition supply") then
												local rx,ry,rz,rh = GetRandomNodeInRadius(GenerateRandomIntInRange(100, 3000))
												vehs[1] = SpawnCar(GetHashKey("NSTOCKADE"), rx,ry,rz,rh)
												blips[1] = AddBlipForCar(vehs[1])
												for i=1,4,1 do
													peds[i] = SpawnPed(GetHashKey("M_Y_COP_TRAFFIC"), rx, ry, rz, rh)
													if(i == 1) then
														WarpCharIntoCar(peds[i], vehs[1])
													else
														WarpCharIntoCarAsPassenger(peds[i], vehs[1], i-2)
													end
													GiveWeaponToChar(peds[i], 15, 1000, 1)
												end
												TaskCarMission(peds[1], vehs[1], vehs[1], 1, 10.1, 0, 0, 10)
												SetObjective("Steal ~y~the weapon truck")
												TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
												currmission = 4
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
			for i=13,14,1 do
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
						SetObjective("Lose ~y~wanted level")
						currstage = 1
					end
				elseif(currstage == 1) then
					if(StoreWantedLevel(GetPlayerId(), _i) == 0) then
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
							{-1273.6106, -602.4035, 2.84201, 352.545257568359},
							{-1292.60107, -605.56049, 2.84201, 288.083312988281},
							{-1292.82446, -595.00677, 2.842, 353.871124267578}
							},
							{
							{-979.68433, 1882.88281, 22.32339, 271.501312255859},
							{-972.10937, 1897.81616, 22.31772, 178.315719604492},
							{-960.23047, 1882.86621, 22.38437, 155.148681640625}
							},
							{
							{101.74678, 1124.16772, 14.56007, 268.247192382813},
							{99.31671, 1144.33167, 14.55841, 358.518707275391},
							{110.41101, 1136.07312, 14.55841, 357.588958740234}
							},
							{
							{-297.07736, -12.1542, 14.65719, 87.6072158813477},
							{-318.60233, -7.41873, 14.65719, 269.592681884766},
							{-317.88873, -15.08945, 14.65719, 266.645812988281}
							},
							{
							{915.88995, 1623.25415, 17.05902, 42.9885864257813},
							{906.78296, 1611.29321, 17.05903, 312.815093994141},
							{898.55768, 1606.48779, 17.05902, 4.06385326385498}
							},
							{
							{1179.74487, 878.74976, 36.08235, 178.538528442383},
							{1186.82312, 878.7724, 36.08454, 153.502960205078},
							{1192.63867, 870.96698, 35.97511, 143.530670166016}
							},
							{
							{1355.76697, -345.26001, 19.02253, 105.508613586426},
							{1344.1344, -346.77448, 18.99173, 178.15641784668},
							{1356.00085, -364.62292, 18.88721, 86.1232681274414}
							}
							}
							local rnd = GenerateRandomIntInRange(1, #coords+1)
							vehs[2] = SpawnCar(GetHashKey("ZOMBIEB"), coords[rnd][1][1], coords[rnd][1][2], coords[rnd][1][3], coords[rnd][1][4])
							vehs[3] = SpawnCar(GetHashKey("HELLFURY"), coords[rnd][2][1], coords[rnd][2][2], coords[rnd][2][3], coords[rnd][2][4])
							vehs[4] = SpawnCar(GetHashKey("BOBBER"), coords[rnd][3][1], coords[rnd][3][2], coords[rnd][3][3], coords[rnd][3][4])
							for i=2,4,1 do
								blips[i-1] = AddBlipForCar(vehs[i])
							end
							SetObjective("Put into ~y~the truck ~w~all ~y~marked bikes")
							currstage = 1
						end
					else
						DrawMessage("~r~Mission failed", "Truck destroyed.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(not IsCarDead(vehs[1])) then
						local bikesdelivered = 0
						for i=2,4,1 do
							if(DoesVehicleExist(vehs[i])) then
								if(not IsCarDead(vehs[i])) then
									if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[i])) then
										if(IsCarTouchingCar(vehs[i], vehs[1])) then
											DeleteCar(vehs[i])
											RemoveBlip(blips[i-1])
										end
									end
								else
									DrawMessage("~r~Mission failed", "Bike destroyed.")
									EndMission()
								end
							else
								bikesdelivered = bikesdelivered + 1
							end
						end
						if(bikesdelivered == 3) then
							for i=1,3,1 do
								local rx,ry,rz,rh = GetRandomNodeInRadius(100)
								vehs[i+1] = SpawnCar(GetHashKey("ZOMBIEB"), rx, ry, rz, rh)
								peds[i] = SpawnPed(GetHashKey("M_Y_GBIK_HI_02"), rx, ry, rz, rh)
								WarpCharIntoCar(peds[i], vehs[i+1])
								GiveWeaponToChar(peds[i], 12, 1000, 1)
								blips[i] = AddBlipForChar(peds[i])
							end
							SetObjective("Get rid of ~y~rival gang members")
							currstage = 2
						end
					else
						DrawMessage("~r~Mission failed", "Truck destroyed.")
						EndMission()
					end
				elseif(currstage == 2) then
					if(not IsCarDead(vehs[1])) then
						local mobsdead = 0
						for i=1,3,1 do
							if(not IsCharDead(peds[i])) then
								AttackPlayer(peds[i])
							else
								RemoveBlip(blips[i])
								mobsdead = mobsdead + 1
							end
						end
						if(mobsdead == 3) then
							blips[1] = AddBlipForCoord(bizinfo[bizid].carpos[1], bizinfo[bizid].carpos[2], bizinfo[bizid].carpos[3])
							SetRoute(blips[1], true)
							SetObjective("Deliver ~y~the truck ~w~to ~y~the clubhouse")
							currstage = 3
						end
					else
						DrawMessage("~r~Mission failed", "Truck destroyed.")
						EndMission()
					end
				elseif(currstage == 3) then
					if(not IsCarDead(vehs[1])) then
						local bp = GetBlipCoords(blips[1])
						DrawCheckpointWithDist(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
						if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
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
					else
						DrawMessage("~r~Mission failed", "Truck destroyed.")
						EndMission()
					end
				end
			elseif(currmission == 3) then
				if(currstage == 0) then
					if(not IsCharDead(peds[1])) then
						for i=2,3,1 do
							if(HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId())) or HasCarBeenDamagedByChar(vehs[1], GetPlayerChar(GetPlayerId()))) then
								for j=2,3,1 do
									AttackPlayer(peds[j])
								end
							end
						end
						if(IsCharDead(peds[2]) and IsCharDead(peds[3])) then
							RemoveBlip(blips[1])
							group = CreateGroup(false, true)
							SetGroupLeader(group, GetPlayerChar(GetPlayerId()))
							SetGroupMember(group, peds[1])
							SetCharNeverLeavesGroup(peds[1], true)
							blips[1] = AddBlipForCoord(bizinfo[bizid].carpos[1], bizinfo[bizid].carpos[2], bizinfo[bizid].carpos[3])
							SetRoute(blips[1], true)
							SetObjective("Bring ~y~the gangmate ~w~to ~y~the clubhouse")
							currstage = 1
						end
					else
						DrawMessage("~r~Mission failed", "Gangmate is dead.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(not IsCharDead(peds[1])) then
						local bp = GetBlipCoords(blips[1])
						DrawCheckpointWithDist(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
						if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
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
						DrawMessage("~r~Mission failed", "Gangmate is dead.")
						EndMission()
					end
				end
			elseif(currmission == 4) then
				if(currstage == 0) then
					if(not IsCarDead(vehs[1])) then
						for i=1,4,1 do
							if(HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId())) or HasCarBeenDamagedByChar(vehs[1], GetPlayerChar(GetPlayerId()))) then
								for j=1,4,1 do
									AttackPlayer(peds[j])
								end
							end
						end
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							RemoveBlip(blips[1])
							AlterWantedLevel(GetPlayerId(), 4)
							ApplyWantedLevelChangeNow(GetPlayerId())
							SetObjective("Lose ~y~wanted level")
							currstage = 1
						end
					else
						DrawMessage("~r~Mission failed", "Truck destroyed.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(not IsCarDead(vehs[1])) then
						if(StoreWantedLevel(GetPlayerId(), _i) == 0) then
							blips[1] = AddBlipForCoord(bizinfo[bizid].carpos[1], bizinfo[bizid].carpos[2], bizinfo[bizid].carpos[3])
							SetRoute(blips[1], true)
							SetObjective("Deliver ~y~this truck ~w~to ~y~the clubhouse")
							currstage = 2
						end
					else
						DrawMessage("~r~Mission failed", "Truck destroyed.")
						EndMission()
					end
				elseif(currstage == 2) then
					if(not IsCarDead(vehs[1])) then
						local bp = GetBlipCoords(blips[1])
						DrawCheckpointWithDist(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
						if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
							experience = experience + mults[4]*1000
							SaveStats()
							DrawMessage("~y~Mission completed", "Income multiplier has been increased (+" .. mults[4] .. "/+" .. mults[4]*1000 .. " EXP)")
							bizMissionsCompleted = bizMissionsCompleted + 1
							SaveDailyStats()
							bizmult[bizid] = bizmult[bizid] + mults[4]
							SaveBizMult()
							bizcooldown[4] = mults[4]*1000
							EndMission()
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