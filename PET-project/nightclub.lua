local bizinfo = {
[10] = {name = "Bahama Mamas", price = 360000, level = 70, baseincome = 30000, pos = {-399.89844, 396.58929, 14.41455}, carpos = {-398.7059, 388.78915, 13.92212, 87.5921020507813}},
--[11] = {name = "Hercules", price = 220000, level = 70, baseincome = 20000, pos = {-438.55597, 348.77353, 11.71665}, carpos = {-449.42618, 357.03915, 11.09064, 357.247985839844}},
--[12] = {name = "Maisonette 9", price = 360000, level = 70, baseincome = 30000, pos = {-487.60895, 162.38007, 7.68131}, carpos = {-459.92557, 153.45244, 9.78754, 177.525100708008}}
}

local bizid = 0
local mults = {0.2,0.2,0.3,0.3}
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
			if(biz[10+(i-1)] == 1) then
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
		for i=10,10,1 do
			if(not DoesBlipExist(bizblip[i])) then
				bizblip[i] = AddBlipForCoord(bizinfo[i].pos[1], bizinfo[i].pos[2], bizinfo[i].pos[3])
				ChangeBlipSprite(bizblip[i], 51)
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
							TriggerEvent('chatMessage', '[Business]', {255, 0, 0}, 'You must reach level 70!')
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
									tempitems[#tempitems+1] = "Getting debts"
									tempitems[#tempitems+1] = "VIP management"
									tempitems[#tempitems+1] = "Delivering goods"
									tempitems[#tempitems+1] = "Equipment"
									DrawWindow("Business_missions", tempitems)
									while menuactive do
										Wait(0)
									end
									if(menuresult > 0) then
										if(bizcooldown[menuresult] <= 0) then
											if(tempitems[menuresult] == "Getting debts") then
												local coords = {
												{-434.0863, 1158.71997, 12.96702, 267.942840576172},
												{59.71159, 1008.80127, 14.75601, 267.140899658203},
												{-716.03937, 1175.33191, 19.353, 87.5165634155273},
												{189.87062, 247.23921, 32.4593, 266.614166259766},
												{-58.21896, -88.64814, 14.75956, 177.564071655273},
												{231.59608, -417.50247, 16.67697, 268.125122070313},
												{-228.20761, -635.75348, 4.94985, 179.14665222168}
												}
												local rnd = GenerateRandomIntInRange(1, #coords+1)
												vehs[1] = SpawnCar(GetHashKey("RUINER"), coords[rnd][1], coords[rnd][2], coords[rnd][3], coords[rnd][4])
												peds[1] = SpawnPed(GetHashKey("M_Y_CLUBFIT"), coords[rnd][1], coords[rnd][2], coords[rnd][3], coords[rnd][4])
												blips[1] = AddBlipForChar(peds[1])
												WarpCharIntoCar(peds[1], vehs[1])
												TaskCarMission(peds[1], vehs[1], vehs[1], 1, 10.1, 0, 0, 10)
												SetObjective("~y~A customer ~w~has escaped without payment! Catch him ~y~alive")
												TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
												currmission = 1
												missionstarted = 1
											elseif(tempitems[menuresult] == "VIP management") then
												local coords = {
												{-293.77295, -197.30251, 14.61381, 356.946502685547},
												{-39.30223, 747.6626, 14.64667, 358.481719970703},
												{-186.24059, 1366.08215, 20.3059, 177.281295776367},
												{-538.62219, 1013.25262, 9.75249, 86.5798645019531},
												{-1.47428, -746.42401, 5.77092, 174.506973266602}
												}
												local rnd = GenerateRandomIntInRange(1, #coords+1)
												vehs[1] = SpawnCar(GetHashKey("COGNOSCENTI"), coords[rnd][1], coords[rnd][2], coords[rnd][3], coords[rnd][4])
												blips[1] = AddBlipForCar(vehs[1])
												SetRoute(blips[1], true)
												peds[1] = SpawnPed(GetHashKey("M_M_LAWYER_01"), coords[rnd][1], coords[rnd][2], coords[rnd][3], coords[rnd][4])
												WarpCharIntoCarAsPassenger(peds[1], vehs[1], 1)
												SetObjective("~y~VIP ~w~is waiting for you at ~y~the marked point")
												TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
												currmission = 2
												missionstarted = 1
											elseif(tempitems[menuresult] == "Delivering goods") then
												local coords = {
												{-1100.06812, 314.57935, 4.48922, 358.135803222656},
												{-1887.30762, -301.14835, 5.442, 358.166290283203},
												{-1540.2583, 1102.85754, 26.69561, 54.0498962402344},
												{293.53537, 1682.78455, 15.85716, 196.921447753906},
												{1320.55725, 1800.6217, 9.43726, 176.92414855957},
												{1012.35211, 682.72125, 26.02414, 359.848571777344},
												{1760.78284, 362.45523, 22.06062, 359.531494140625},
												{1453.74438, -316.40729, 14.6695, 267.196746826172},
												{819.27228, -25.47989, 5.87993, 290.276885986328}
												}
												vehs[1] = SpawnCar(GetHashKey("SPEEDO"), bizinfo[i].carpos[1], bizinfo[i].carpos[2], bizinfo[i].carpos[3], bizinfo[i].carpos[4])
												blips[1] = AddBlipForCar(vehs[1])
												SetObjective("Get into ~y~the van")
												TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
												currmission = 3
												missionstarted = 1
											elseif(tempitems[menuresult] == "Equipment") then
												local coords = {
												{-1010.24841, 1524.1731, 23.21619, 51.5824737548828},
												{-1301.05542, 947.82617, 19.57198, 357.731994628906},
												{-1843.04687, 151.13824, 15.01167, 97.6274642944336},
												{-1199.63306, -185.08418, 3.92877, 180.918838500977},
												{-73.98379, -821.60193, 5.33858, 336.869934082031},
												{1009.14691, -408.22281, 15.8693, 91.3853073120117},
												{1407.42822, 350.95172, 19.00147, 182.876480102539},
												{1864.81726, 686.84686, 27.20218, 356.214660644531},
												{1112.8457, 1854.1936, 11.49665, 58.9172706604004},
												{-210.8152, 1398.16895, 20.35069, 355.495391845703}
												}
												local rnd = GenerateRandomIntInRange(1, #coords+1)
												vehs[1] = SpawnCar(GetHashKey("SPEEDO"), coords[rnd][1], coords[rnd][2], coords[rnd][3], coords[rnd][4])
												blips[1] = AddBlipForCar(vehs[1])
												SetObjective("Steal ~y~the van")
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
			for i=10,12,1 do
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
					if(not IsCharDead(peds[1])) then
						if(HasCharBeenDamagedByChar(peds[1], GetPlayerChar(GetPlayerId())) or HasCarBeenDamagedByChar(vehs[1], GetPlayerChar(GetPlayerId()))) then
							ForcePedToFleeWhilstDrivingVehicle(peds[1], vehs[1])
							while IsCharInCar(peds[1], vehs[1]) do
								Wait(0)
							end
							RemoveBlip(blips[1])
							local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
							objs[1] = SpawnObject(GetHashKey("cj_cash_pile_1"), px, py, pz, 0.0)
							blips[1] = AddBlipForObject(objs[1])
							SetObjective("Collect ~y~the cash")
							currstage = 1
						end
					else
						DrawMessage("~r~Mission failed", "Customer is dead.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(not IsCharDead(peds[1])) then
						local ox,oy,oz = GetObjectCoordinates(objs[1], _f, _f, _f)
						if(IsPlayerNearCoords(ox, oy, oz, 2)) then
							DeleteObject(objs[1])
							RemoveBlip(blips[1])
							blips[1] = AddBlipForCoord(bizinfo[bizid].carpos[1], bizinfo[bizid].carpos[2], bizinfo[bizid].carpos[3])
							SetRoute(blips[1], true)
							SetObjective("Bring ~y~the cash ~w~back to ~y~the club")
							currstage = 2
						end
					else
						DrawMessage("~r~Mission failed", "Customer is dead.")
						EndMission()
					end
				elseif(currstage == 2) then
					if(not IsCharDead(peds[1])) then
						local bp = GetBlipCoords(blips[1])
						DrawCheckpointWithDist(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
						if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
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
					else
						DrawMessage("~r~Mission failed", "Customer is dead.")
						EndMission()
					end
				end
			elseif(currmission == 2) then
				if(currstage == 0) then
					if(not IsCharDead(peds[1])) then
						if(not IsCarDead(vehs[1])) then
							if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
								RemoveBlip(blips[1])
								local coords = {
								{958.04205, -299.32733, 19.56702, 89.0844421386719},
								{1366.80676, 183.06577, 27.08847, 88.7345352172852},
								{1138.79895, 1661.53394, 16.67235, 43.9384574890137},
								{580.9162, 1403.25342, 10.904, 177.21760559082},
								{-1245.89575, 1518.70691, 23.447, 67.9811477661133},
								{-963.24097, 901.39685, 13.59484, 268.571868896484},
								{-1593.87415, 26.21777, 10.11104, 270.958282470703}
								}
								variation = GenerateRandomIntInRange(1, #coords+1)
								blips[1] = AddBlipForCoord(coords[variation][1], coords[variation][2], coords[variation][3])
								SetRoute(blips[1], true)
								SetObjective("Bring ~y~the VIP ~w~to ~y~the destination")
								currstage = 1
							end
						else
							DrawMessage("~r~Mission failed", "VIP vehicle destroyed.")
							EndMission()
						end
					else
						DrawMessage("~r~Mission failed", "VIP is dead.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(not IsCharDead(peds[1])) then
						if(not IsCarDead(vehs[1])) then
							local bp = GetBlipCoords(blips[1])
							DrawCheckpointWithDist(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
							if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
								if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
									SetObjective("Wait for ~y~VIP")
									TaskLeaveAnyCar(peds[1])
									while IsCharInCar(peds[1], vehs[1]) do
										Wait(0)
									end
									local coords = {
									{957.42432, -286.57376, 19.88227, 355.357696533203},
									{1366.51416, 194.99251, 27.68437, 357.499603271484},
									{1147.26453, 1672.7229, 16.72695, 311.704162597656},
									{569.52759, 1402.94495, 11.49163, 87.7053527832031},
									{-1246.49695, 1543.40027, 26.06884, 0.656773865222931},
									{-962.94122, 890.67639, 13.68372, 174.804214477539},
									{-1576.51587, 26.65843, 10.01533, 265.98681640625}
									}
									TaskGoToCoordAnyMeans(peds[1], coords[variation][1], coords[variation][2], coords[variation][3], 3, -1)
									while not IsPedNearCoords(peds[1], coords[variation][1], coords[variation][2], coords[variation][3], 1) do
										Wait(0)
										if(IsCharDead(peds[1])) then
											DrawMessage("~r~Mission failed", "VIP is dead.")
											EndMission()
											break
										end
										if(IsCarDead(vehs[1])) then
											DrawMessage("~r~Mission failed", "VIP vehicle destroyed.")
											EndMission()
											break
										end
									end
									Wait(5000)
									TaskEnterCarAsPassenger(peds[1], vehs[1], 20000, 1)
									while not IsCharInCar(peds[1], vehs[1]) do
										Wait(0)
										TaskEnterCarAsPassenger(peds[1], vehs[1], 20000, 1)
										Wait(1000)
										if(IsCharDead(peds[1])) then
											DrawMessage("~r~Mission failed", "VIP is dead.")
											EndMission()
											break
										end
										if(IsCarDead(vehs[1])) then
											DrawMessage("~r~Mission failed", "VIP vehicle destroyed.")
											EndMission()
											break
										end
									end
									RemoveBlip(blips[1])
									blips[1] = AddBlipForCoord(bizinfo[bizid].carpos[1], bizinfo[bizid].carpos[2], bizinfo[bizid].carpos[3])
									SetRoute(blips[1], true)
									SetObjective("Bring ~y~the VIP ~w~to ~y~the club")
									currstage = 2
								else
									PrintStringWithLiteralStringNow("STRING", "~r~You must be in the mission vehicle!", 1000, 1)
								end
							end
						else
							DrawMessage("~r~Mission failed", "VIP vehicle destroyed.")
							EndMission()
						end
					else
						DrawMessage("~r~Mission failed", "VIP is dead.")
						EndMission()
					end
				elseif(currstage == 2) then
					if(not IsCharDead(peds[1])) then
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
									PrintStringWithLiteralStringNow("STRING", "~r~You must be in the mission vehicle!", 1000, 1)
								end
							end
						else
							DrawMessage("~r~Mission failed", "VIP vehicle destroyed.")
							EndMission()
						end
					else
						DrawMessage("~r~Mission failed", "VIP is dead.")
						EndMission()
					end
				end
			elseif(currmission == 3) then
				if(currstage == 0) then
					if(not IsCarDead(vehs[1])) then
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							RemoveBlip(blips[1])
							local coords = {
							{-1100.06812, 314.57935, 4.48922, 358.135803222656},
							{-1887.30762, -301.14835, 5.442, 358.166290283203},
							{-1540.2583, 1102.85754, 26.69561, 54.0498962402344},
							{293.53537, 1682.78455, 15.85716, 196.921447753906},
							{1320.55725, 1800.6217, 9.43726, 176.92414855957},
							{1012.35211, 682.72125, 26.02414, 359.848571777344},
							{1760.78284, 362.45523, 22.06062, 359.531494140625},
							{1453.74438, -316.40729, 14.6695, 267.196746826172},
							{819.27228, -25.47989, 5.87993, 290.276885986328}
							}
							local rnd = GenerateRandomIntInRange(1, #coords+1)
							blips[1] = AddBlipForCoord(coords[rnd][1], coords[rnd][2], coords[rnd][3])
							SetRoute(blips[1], true)
							SetObjective("Reach ~y~the loading point")
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
								blips[1] = AddBlipForCoord(bizinfo[bizid].carpos[1], bizinfo[bizid].carpos[2], bizinfo[bizid].carpos[3])
								SetRoute(blips[1], true)
								SetObjective("Deliver ~y~the goods ~w~to ~y~the club")
								currstage = 2
							else
								PrintStringWithLiteralStringNow("STRING", "~r~You must be in the mission vehicle!", 1000, 1)
							end
						end
					else
						DrawMessage("~r~Mission failed", "Van destroyed.")
						EndMission()
					end
				elseif(currstage == 2) then
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
								PrintStringWithLiteralStringNow("STRING", "~r~You must be in the mission vehicle!", 1000, 1)
							end
						end
					else
						DrawMessage("~r~Mission failed", "Van destroyed.")
						EndMission()
					end
				end
			elseif(currmission == 4) then
				if(currstage == 0) then
					if(not IsCarDead(vehs[1])) then
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							RemoveBlip(blips[1])
							local rx,ry,rz,rh = GetRandomNodeInRadius(100)
							vehs[2] = SpawnCar(GetHashKey("ORACLE"), rx, ry, rz, rh)
							for i=1,2,1 do
								peds[i] = SpawnPed(GetHashKey("M_Y_GLAT_HI_01"), rx, ry, rz, rh)
								GiveWeaponToChar(peds[i], 7, 1000, 1)
								blips[i] = AddBlipForChar(peds[i])
							end
							WarpCharIntoCar(peds[1], vehs[2])
							WarpCharIntoCarAsPassenger(peds[2], vehs[2], 0)
							SetObjective("Get rid of ~y~rivals")
							currstage = 1
						end
					else
						DrawMessage("~r~Mission failed", "Van destroyed.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(not IsCarDead(vehs[1])) then
						local mobskilled = 0
						for i=1,2,1 do
							if(IsCharDead(peds[i])) then
								mobskilled = mobskilled + 1
								RemoveBlip(blips[i])
							else
								AttackPlayer(peds[i])
							end
						end
						if(mobskilled == 2) then
							SetObjective("Lost ~y~wanted level")
							currstage = 2
						end
					else
						DrawMessage("~r~Mission failed", "Van destroyed.")
						EndMission()
					end
				elseif(currstage == 2) then
					if(not IsCarDead(vehs[1])) then
						if(StoreWantedLevel(GetPlayerId()) == 0) then
							blips[1] = AddBlipForCoord(bizinfo[bizid].carpos[1], bizinfo[bizid].carpos[2], bizinfo[bizid].carpos[3])
							SetRoute(blips[1], true)
							SetObjective("Deliver ~y~the equipment ~w~to ~y~the club")
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
								experience = experience + mults[4]*1000
								SaveStats()
								DrawMessage("~y~Mission completed", "Income multiplier has been increased (+" .. mults[4] .. "/+" .. mults[4]*1000 .. " EXP)")
								bizMissionsCompleted = bizMissionsCompleted + 1
								SaveDailyStats()
								bizmult[10] = bizmult[10] + mults[4]
								SaveBizMult()
								bizcooldown[4] = mults[4]*1000
								EndMission()
							else
								PrintStringWithLiteralStringNow("STRING", "~r~You must be in the mission vehicle!", 1000, 1)
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