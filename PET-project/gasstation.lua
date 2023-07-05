local bizinfo = {
[15] = {name = "Ron", price = 80000, level = 30, baseincome = 6000, pos = {763.99829, 190.9456, 6.19825}, carpos = {758.95782, 198.31792, 6.15964, 281.703338623047}},
[16] = {name = "Terroil", price = 90000, level = 30, baseincome = 7000, pos = {106.01157, 1120.41931, 14.67003}, carpos = {97.98507, 1129.62805, 14.56007, 357.692565917969}},
[17] = {name = "Globe Oil", price = 85000, level = 30, baseincome = 6500, pos = {-1408.60828, 33.21207, 7.15618}, carpos = {-1399.01733, 44.02945, 7.09356, 237.590728759766}}
}

local bizid = 0
local mults = {0.3,0.2}
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
			if(biz[15+(i-1)] == 1) then
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
		for i=15,17,1 do
			if(not DoesBlipExist(bizblip[i])) then
				bizblip[i] = AddBlipForCoord(bizinfo[i].pos[1], bizinfo[i].pos[2], bizinfo[i].pos[3])
				ChangeBlipSprite(bizblip[i], 61)
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
						DrawWindow("Ron", {"Collect income", "Missions"})
						while menuactive do
							Wait(0)
						end
						if(menuresult > 0) then
							if(menuresult == 1) then
								money = money + bizmoney[15]
								SaveStats()
								TriggerEvent('chatMessage', '[Business]', {0, 255, 0}, 'Income collected')
								bizmoney[15] = 0
								SaveBizMoney()
							elseif(menuresult == 2) then
								if(missionstarted == 0) then
									bizid = i
									local tempitems = {}
									tempitems[#tempitems+1] = "Trucking"
									tempitems[#tempitems+1] = "Removing competition"
									DrawWindow("Business_missions", tempitems)
									while menuactive do
										Wait(0)
									end
									if(menuresult > 0) then
										if(bizcooldown[menuresult] <= 0) then
											if(tempitems[menuresult] == "Trucking") then
												vehs[1] = SpawnCar(GetHashKey("benson"), bizinfo[i].carpos[1], bizinfo[i].carpos[2], bizinfo[i].carpos[3], bizinfo[i].carpos[4])
												blips[1] = AddBlipForCar(vehs[1])
												SetObjective("Get into ~y~the truck")
												TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
												currmission = 1
												missionstarted = 1
											elseif(tempitems[menuresult] == "Removing competition") then
												local coords = {
												{-922.76276, 317.9523, 4.50804, 0.2601577937603},
												{-1111.36584, 1193.29846, 17.58539, 1.1402143239975},
												{-1338.14636, 1740.72449, 27.83946, 135.515655517578},
												{1286.72229, -103.79182, 26.95116, 282.83984375},
												{2118.37524, 110.56972, 5.81509, 91.9930877685547}
												}
												local rnd = GenerateRandomIntInRange(1, #coords+1)
												blips[1] = AddBlipForCoord(coords[rnd][1], coords[rnd][2], coords[rnd][3])
												SetRoute(blips[1], true)
												SetObjective("Plant ~y~a bomb ~w~at ~y~the marked point")
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
			for i=15,17,1 do
				if(biz[i] == 1) then
					bizmoney[i] = bizmoney[i] + bizinfo[i].baseincome*bizmult[i]
					SaveBizMoney()
					TriggerEvent('chatMessage', '[Business]', {0, 255, 0}, 'Ron has got an income (+' .. bizinfo[i].baseincome*bizmult[i] .. '$ / -0.2 multiplier)!')
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
							local coords = {
							{-922.76276, 317.9523, 4.50804, 0.2601577937603},
							{-1111.36584, 1193.29846, 17.58539, 1.1402143239975},
							{-1338.14636, 1740.72449, 27.83946, 135.515655517578},
							{1286.72229, -103.79182, 26.95116, 282.83984375},
							{2118.37524, 110.56972, 5.81509, 91.9930877685547}
							}
							local rnd = GenerateRandomIntInRange(1, #coords+1)
							blips[1] = AddBlipForCoord(coords[rnd][1], coords[rnd][2], coords[rnd][3])
							SetRoute(blips[1], true)
							SetObjective("Collect cargo at ~y~the marked point")
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
						if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 5)) then
							if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
								RemoveBlip(blips[1])
								for i=1,3,1 do
									local rx,ry,rz,rh = GetRandomNodeInRadius(100)
									vehs[i+1] = SpawnCar(GetHashKey("BOBBER"), rx, ry, rz, rh)
									peds[i] = SpawnPed(GetHashKey("M_M_GBIK_LO_03"), rx, ry, rz, rh)
									WarpCharIntoCar(peds[i], vehs[i+1])
									GiveWeaponToChar(peds[i], 9, 1000, 1)
									blips[i] = AddBlipForChar(peds[i])
								end
								SetObjective("Get rid of ~y~rivals")
								currstage = 2
							else
								PrintStringWithLiteralStringNow("STRING", "~r~You must be in the mission car!", 1000, 1)
							end
						end
					else
						DrawMessage("~r~Mission failed", "Truck destroyed.")
						EndMission()
					end
				elseif(currstage == 2) then
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
						SetObjective("Deliver ~y~the cargo ~w~to ~y~the gas station")
						currstage = 3
					end
				elseif(currstage == 3) then
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
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithDist(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
						RemoveBlip(blips[1])
						objs[1] = SpawnObject(GetHashKey("ec_bomb_ne"), bp.x, bp.y, bp.z-1, 0.0)
						blips[1] = AddBlipForObject(objs[1])
						SetObjective("Move back on a safe distance and ~y~shoot the bomb")
						currstage = 1
					end
				elseif(currstage == 1) then
					if(HasObjectBeenDamagedByChar(objs[1], GetPlayerChar(GetPlayerId()))) then
						local ox,oy,oz = GetObjectCoordinates(objs[1])
						DeleteObject(objs[1])
						AddExplosion(ox, oy, oz, 0, 5.1, true, false, 1.1)
						AlterWantedLevel(GetPlayerId(), 3)
						ApplyWantedLevelChangeNow(GetPlayerId())
						RemoveBlip(blips[1])
						SetObjective("Lose ~y~wanted level")
						currstage = 2
					end
				elseif(currstage == 2) then
					if(StoreWantedLevel(GetPlayerId()) == 0) then
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
			if(IsPlayerDead(GetPlayerId())) then
				DrawMessage("~r~Mission failed", "You have died.")
				EndMission()
			end
		end
	end
end)