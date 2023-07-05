local currmission = 0
local currstage = 0
local EndMission = function()
	currmission = 0
	currstage = 0
	CleanMission()
end

ProceedToRobbery3 = function()
	local tempitems = {}
	tempitems[#tempitems+1] = "Start robbery"
	if(preps[3][1] == 0) then
		tempitems[#tempitems+1] = "Explosives"
	else
		tempitems[#tempitems+1] = "Explosives ~g~(Done)"
	end
	if(preps[3][2] == 0) then
		tempitems[#tempitems+1] = "Cargo plans (optional)"
	else
		tempitems[#tempitems+1] = "Cargo plans ~g~(Done)"
	end
	DrawWindow("Platypus", tempitems)
	while menuactive do
		Wait(0)
		if(currbutton == 1) then
			DrawDescription("Robbery", {
			-----------------------------------------------------------------------------------------------
			"Proceed to the Platypus cargo ship. Fight your way to the interior and find the crate.",
			"Explode this crage using a bomb to open it and get the cash. After that leave the area.",
			" ",
			"* You can get higher reward when you have cargo plans. In this case, you have to check several",
			"crates to find values."
			})
		elseif(currbutton == 2) then
			DrawDescription("Explosives", {
			-----------------------------------------------------------------------------------------------
			"Steal a van with explosives to get a bomb. It will be needed to get access to cash in a crate."
			})
		elseif(currbutton == 3) then
			DrawDescription("Cargo plans", {
			-----------------------------------------------------------------------------------------------
			"There is a temporary russian mafia base which holds cargo plans of Platypus. Fight your way",
			"to the blueprints and deliver them to the base. They will give you ability to steal more",
			"values to increase your final reward."
			})
		end
	end
	if(menuresult > 0) then
		if(tempitems[menuresult] == "Start robbery") then
			if(preps[3][1] == 1) then
				local coords = {
				{748.47955, -196.52092, 14.48633, 165.192001342773, 0},
				{737.68335, -224.66594, 9.89692, 327.9833984375, 0},
				{726.98743, -249.2765, 9.87682, 232.312164306641, 0},
				{718.49854, -269.61478, 9.87866, 327.069671630859, 0},
				{702.94177, -302.61813, 9.87795, 334.397644042969, 0},
				{688.66815, -299.44196, 3.29574, 242.348541259766, -391071229},
				{703.62439, -287.34003, 3.29574, 83.1865386962891, -391071229},
				{699.34589, -272.71292, 3.29574, 236.635604858398, -391071229},
				{708.80219, -264.63776, 3.29574, 296.290374755859, -391071229},
				{714.73785, -250.50609, 3.29573, 72.4534072875977, -391071229}
				}
				for i=1,10,1 do
					peds[i] = SpawnPed(GetHashKey("M_M_EE_HEAVY_01"), coords[i][1], coords[i][2], coords[i][3], coords[i][4], coords[i][5])
					GiveWeaponToChar(peds[i], 14, 1000, 1)
				end
				objs[1] = SpawnObject(GetHashKey("bm_mu_crate_03a"), 688.39545, -298.77335, 3.29574-1, 244.091522216797, -391071229)
				blips[1] = AddBlipForCoord(689.66284, -299.40927, 3.29574)
				SetRoute(blips[1], true)
				SetObjective("Reach ~y~the marked crate ~w~in ~y~the ship ~w~and place ~y~the bomb")
				TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
				currmission = 3
				missionstarted = 1
			else
				TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'You have to complete all necessary preparation missions first!')
			end
		elseif(menuresult == 2) then
			if(preps[3][1] == 0) then
				vehs[1] = SpawnCar(GetHashKey("BURRITO"), 1387.82141, -382.97992, 18.76711, 186.829452514648)
				peds[1] = SpawnPed(GetHashKey("M_M_EE_HEAVY_01"), 1387.82141, -382.97992, 18.76711, 186.829452514648)
				GiveWeaponToChar(peds[1], 13, 1000, 1)
				WarpCharIntoCar(peds[1], vehs[1])
				peds[2] = SpawnPed(GetHashKey("M_M_EE_HEAVY_01"), 1387.82141, -382.97992, 18.76711, 186.829452514648)
				GiveWeaponToChar(peds[2], 13, 1000, 1)
				WarpCharIntoCarAsPassenger(peds[2], vehs[1], 0)
				TaskCarMission(peds[1], vehs[1], vehs[1], 1, 10.1, 0, 0, 10)
				blips[1] = AddBlipForCar(vehs[1])
				SetObjective("Get ~y~the van")
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'Preparation mission started!')
				currmission = 1
				missionstarted = 1
			else
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'This mission is already completed.')
			end
		elseif(menuresult == 3) then
			if(preps[3][2] == 0) then
				local coords = {
				{1383.30652, -710.61444, 6.91599, 113.99503326416},
				{1397.33179, -717.94049, 6.6762, 124.483795166016},
				{1407.69312, -708.51959, 6.53076, 79.1893692016602},
				{1402.8811, -703.32068, 6.50878, 172.52522277832},
				{1390.5813, -706.79297, 6.99927, 304.256805419922}
				}
				for i=1,5,1 do
					peds[i] = SpawnPed(GetHashKey("M_M_EE_HEAVY_01"), coords[i][1], coords[i][2], coords[i][3], coords[i][4])
					GiveWeaponToChar(peds[i], 7, 1000, 1)
				end
				objs[1] = SpawnObject(2736900820, 1393.54236, -707.44965, 7.81148-1, 32.3262710571289)
				blips[1] = AddBlipForObject(objs[1])
				SetObjective("Reach ~y~the point ~w~and steal ~y~cargo plans")
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'Preparation mission started!')
				currmission = 2
				missionstarted = 1
			else
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'This mission is already completed.')
			end
		end
	end
end

CreateThread(function()
	while true do
		Wait(0)
		if(currmission > 0) then
			if(currmission == 1) then
				if(currstage == 0) then
					if(not IsCarDead(vehs[1])) then
						for i=1,2,1 do
							if(HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId())) or HasCarBeenDamagedByChar(vehs[1], GetPlayerChar(GetPlayerId()))) then
								AttackPlayer(peds[i])
							end
						end
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							RemoveBlip(blips[1])
							blips[1] = AddBlipForCoord(1402.51965, -4.63598, 25.32224)
							SetRoute(blips[1], true)
							SetObjective("Deliver ~y~this van ~w~to ~y~the base")
							currstage = 1
						end
					else
						DrawMessage("~r~Mission failed", "Van destroyed.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(not IsCarDead(vehs[1])) then
						local bp = GetBlipCoords(blips[1])
						DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
						if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
							if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
								DrawMessage("~y~Preparation mission completed", "Explosives have been successfully acquired.")
								preps[3][1] = 1
								SavePreps()
								EndMission()
							end
						end
					else
						DrawMessage("~r~Mission failed", "Van destroyed.")
						EndMission()
					end
				end
			elseif(currmission == 2) then
				if(currstage == 0) then
					for i=1,5,1 do
						if(not IsCharDead(peds[i])) then
							if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
								for j=1,5,1 do
									AttackPlayer(peds[j])
								end
							end
						end
					end
					local ox,oy,oz = GetObjectCoordinates(objs[1])
					if(IsPlayerNearCoords(ox, oy, oz, 2)) then
						RemoveBlip(blips[1])
						DeleteObject(objs[1])
						blips[1] = AddBlipForCoord(1402.38928, -4.66061, 25.32224)
						SetRoute(blips[1], true)
						SetObjective("Deliver ~y~the plans ~w~to ~y~the base")
						currstage = 1
					end
				elseif(currstage == 1) then
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
						DrawMessage("~y~Preparation mission completed", "Cargo plans have been successfully acquired.")
						preps[3][2] = 1
						SavePreps()
						EndMission()
					end
				end
			elseif(currmission == 3) then
				if(currstage == 0) then
					for i=1,10,1 do
						if(not IsCharDead(peds[i])) then
							if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
								for j=1,10,1 do
									AttackPlayer(peds[j])
								end
							end
						end
					end
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
						RemoveBlip(blips[1])
						objs[2] = SpawnObject(GetHashKey("ec_bomb_ne"), 689.66284, -299.40927, 3.29574-1, 240.687530517578, -391071229)
						blips[1] = AddBlipForObject(objs[2])
						SetObjective("Move back on a safe distance and ~y~shoot the bomb")
						currstage = 1
					end
				elseif(currstage == 1) then
					local x1,y1,z1 = GetObjectCoordinates(objs[1])
					local h1 = GetObjectHeading(objs[1])
					local x2,y2,z2 = GetObjectCoordinates(objs[2])
					if(HasObjectBeenDamagedByChar(objs[2], GetPlayerChar(GetPlayerId()))) then
						DeleteObject(objs[1])
						DeleteObject(objs[2])
						AddExplosion(x2, y2, z2, 0, 5.1, true, false, 1.1)
						objs[1] = SpawnObject(GetHashKey("bm_mu_crate_03b"), x1, y1, z1, h1, -391071229)
						objs[2] = SpawnObject(GetHashKey("cj_cash_pile_3"), x1, y1, z1, h1, -391071229)
						RemoveBlip(blips[1])
						SetObjective("Collect ~y~the cash")
						currstage = 2
					end
				elseif(currstage == 2) then
					local ox,oy,oz = GetObjectCoordinates(objs[2])
					if(IsPlayerNearCoords(ox, oy, oz, 2)) then
						DeleteObject(objs[2])
						local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
						objs[2] = SpawnObject(GetHashKey("cj_mk_drug_bag"), px, py, pz, 0.0)
						AttachObjectToPed(objs[2],GetPlayerChar(GetPlayerId()),0x4B2,0.3,0,0,0,-math.pi/2,math.pi,0)
						RemoveBlip(blips[1])
						if(preps[3][2] == 1) then
							local coords = {
							{699.30347, -290.2919, 3.29574, 71.064094543457},
							{697.92975, -273.8028, 3.29574, 152.369674682617},
							{718.09143, -254.60588, 3.29574, 63.70166015625}
							}
							for i=1,3,1 do
								blips[i] = AddBlipForCoord(coords[i][1], coords[i][2], coords[i][3])
							end
							SetObjective("Search for ~y~values ~w~at ~y~the marked points")
							currstage = 3
						else
							SetObjective("Escape ~y~the ship ~w~and leave ~y~this area")
							currstage = 4
						end
					end
				elseif(currstage == 3) then
					local itemscollected = 0
					for i=1,3,1 do
						if(DoesBlipExist(blips[i])) then
							local bp = GetBlipCoords(blips[i])
							DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
							if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
								RemoveBlip(blips[i])
								PrintStringWithLiteralStringNow("STRING", "~y~Item collected", 3000, 1)
							end
						else
							itemscollected = itemscollected + 1
						end
					end
					if(itemscollected == 3) then
						SetObjective("Escape ~y~the ship ~w~and leave ~y~this area")
						currstage = 4
					end
				elseif(currstage == 4) then
					if(not IsPlayerNearCoords(712.54913, -255.03664, 9.87892, 200)) then
						if(preps[3][2] == 0) then
							local finalreward = SeparateReward(30000, 1500)
							money = money + finalreward[1]
							experience = experience + finalreward[2]
							SaveStats()
							DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
							heistsCompleted = heistsCompleted + 1
							SaveDailyStats()
						else
							local finalreward = SeparateReward(40000, 1700)
							money = money + finalreward[1]
							experience = experience + finalreward[2]
							SaveStats()
							DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
							heistsCompleted = heistsCompleted + 1
							SaveDailyStats()
						end
						for i=1,2,1 do
							preps[3][i] = 0
						end
						SavePreps()
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