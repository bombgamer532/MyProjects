local currmission = 0
local currstage = 0
local EndMission = function()
	currmission = 0
	currstage = 0
	CleanMission()
end

ProceedToRobbery4 = function()
	local tempitems = {}
	tempitems[#tempitems+1] = "Start robbery"
	if(preps[4][1] == 0) then
		tempitems[#tempitems+1] = "Escape vehicle"
	else
		tempitems[#tempitems+1] = "Escape vehicle ~g~(Done)"
	end
	if(preps[4][2] == 0) then
		tempitems[#tempitems+1] = "Prison transport"
	else
		tempitems[#tempitems+1] = "Prison transport ~g~(Done)"
	end
	if(preps[4][3] == 0) then
		tempitems[#tempitems+1] = "Transport schedule"
	else
		tempitems[#tempitems+1] = "Transport schedule ~g~(Done)"
	end
	if(preps[4][4] == 0) then
		tempitems[#tempitems+1] = "Weakening the cops (optional)"
	else
		tempitems[#tempitems+1] = "Weakening the cops ~g~(Done)"
	end
	DrawWindow("Prison_Break", tempitems)
	while menuactive do
		Wait(0)
		if(currbutton == 1) then
			DrawDescription("Robbery", {
			-----------------------------------------------------------------------------------------------
			"Pretend to be a prison guards and enter the facility using stolen prison bus. Find the needed",
			"prisoner, fight your way to the helicopter and deliver him to the airport.",
			" ",
			"* Weakening the cops lets you remove their armor vests during the heist."
			})
		elseif(currbutton == 2) then
			DrawDescription("Escape vehicle", {
			-----------------------------------------------------------------------------------------------
			"Steal a helicopter from highly secured helipad. It will be needed to deliver the prisoner."
			})
		elseif(currbutton == 3) then
			DrawDescription("Prison transport", {
			-----------------------------------------------------------------------------------------------
			"Steal a prison transport out of armored convoy. It will be needed to enter the facility",
			"with less attention."
			})
		elseif(currbutton == 4) then
			DrawDescription("Transport schedule", {
			-----------------------------------------------------------------------------------------------
			"Get the briefcase with transport schedule out of local police station. It is needed to enter",
			"the facility in the correct time to prevent suspicions."
			})
		elseif(currbutton == 5) then
			DrawDescription("Weakening the cops", {
			-----------------------------------------------------------------------------------------------
			"Get rid of armor supply to the facility to remove ability for guards to wear amour vests."
			})
		end
	end
	if(menuresult > 0) then
		if(tempitems[menuresult] == "Start robbery") then
			if(preps[4][1]==1 and preps[4][2]==1 and preps[4][3]==1) then
				vehs[1] = SpawnCar(GetHashKey("PSTOCKADE"), -968.89117, 1895.14185, 22.34476, 175.086700439453)
				blips[1] = AddBlipForCar(vehs[1])
				SetObjective("Get into ~y~the prison transport")
				TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
				currmission = 5
				missionstarted = 1
			else
				TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'You have to complete all necessary preparation missions first!')
			end
		elseif(menuresult == 2) then
			if(preps[4][1] == 0) then
				ClearAreaOfCars(-824.43665, 779.51196, 6.32802, 50)
				vehs[1] = SpawnCar(GetHashKey("MAVERICK"), -824.43665, 779.51196, 6.32802, 269.908416748047)
				local coords = {
				{-852.83331, 767.68854, 4.46572, 84.4955215454102},
				{-860.68005, 758.45032, 4.46541, 149.06071472168},
				{-856.84686, 792.75751, 4.46572, 161.925704956055},
				{-842.77368, 800.63068, 4.46574, 300.876098632813},
				{-841.53912, 791.2558, 4.46572, 208.588821411133},
				{-841.51923, 775.63574, 4.46572, 57.9818267822266},
				{-835.57886, 784.55304, 4.46572, 173.306427001953},
				{-836.07812, 772.55084, 4.46572, 87.4431076049805},
				{-830.18225, 784.9809, 6.32803, 359.211730957031},
				{-822.39557, 772.49988, 6.32802, 200.291091918945}
				}
				for i=1,10,1 do
					peds[i] = SpawnPed(GetHashKey("M_M_GUNNUT_01"), coords[i][1], coords[i][2], coords[i][3], coords[i][4])
					GiveWeaponToChar(peds[i], 9, 1000, 1)
				end
				blips[1] = AddBlipForCar(vehs[1])
				SetObjective("Steal ~y~the helicopter")
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'Preparation mission started!')
				currmission = 1
				missionstarted = 1
			else
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'This mission is already completed.')
			end
		elseif(menuresult == 3) then
			if(preps[4][2] == 0) then
				vehs[1] = SpawnCar(GetHashKey("PSTOCKADE"), -1750.85718, 610.56317, 26.27603, 358.212066650391)
				blips[1] = AddBlipForCar(vehs[1])
				peds[1] = SpawnPed(GetHashKey("M_Y_COP_TRAFFIC"), -1750.85718, 610.56317, 26.27603, 358.212066650391)
				GiveWeaponToChar(peds[1], 13, 1000, 1)
				WarpCharIntoCar(peds[1], vehs[1])
				TaskCarMission(peds[1], vehs[1], vehs[1], 1, 10.1, 0, 0, 10)
				vehs[2] = SpawnCar(GetHashKey("POLPATRIOT"), -1751.08557, 596.68207, 25.57375, 357.410034179688)
				peds[2] = SpawnPed(GetHashKey("M_Y_COP_TRAFFIC"), -1751.08557, 596.68207, 25.57375, 357.410034179688)
				GiveWeaponToChar(peds[2], 13, 1000, 1)
				WarpCharIntoCar(peds[2], vehs[2])
				TaskCarMission(peds[2], vehs[2], vehs[1], 2, 10.1, 0, 0, 10)
				vehs[3] = SpawnCar(GetHashKey("POLPATRIOT"), -1750.92578, 582.96326, 24.86137, 357.238739013672)
				peds[3] = SpawnPed(GetHashKey("M_Y_COP_TRAFFIC"), -1750.92578, 582.96326, 24.86137, 357.238739013672)
				GiveWeaponToChar(peds[3], 13, 1000, 1)
				WarpCharIntoCar(peds[3], vehs[3])
				TaskCarMission(peds[3], vehs[3], vehs[2], 2, 10.1, 0, 0, 10)
				SetObjective("Steal ~y~the prison transport")
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'Preparation mission started!')
				currmission = 2
				missionstarted = 1
			else
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'This mission is already completed.')
			end
		elseif(menuresult == 4) then
			if(preps[4][3] == 0) then
				objs[1] = SpawnObject(GetHashKey("cj_case_2"), -1231.51453, -292.97003, 2.92882-1, 357.979553222656)
				FreezeObjectPosition(objs[1], true)
				local coords = {
				{-1237.58521, -288.24112, 2.92883, 340.831024169922},
				{-1230.46606, -274.25427, 2.92883, 265.078063964844},
				{-1250.15784, -275.77161, 2.92882, 44.703914642334},
				{-1246.58313, -264.41901, 2.92882, 354.944641113281},
				{-1249.8656, -250.60849, 2.92882, 176.594787597656}
				}
				for i=1,5,1 do
					peds[i] = SpawnPed(GetHashKey("M_Y_COP_TRAFFIC"), coords[i][1], coords[i][2], coords[i][3], coords[i][4])
					GiveWeaponToChar(peds[i], 7, 1000, 1)
				end
				blips[1] = AddBlipForObject(objs[1])
				SetObjective("Get ~y~the prison transport schedule ~w~at ~y~the police station")
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'Preparation mission started!')
				currmission = 3
				missionstarted = 1
			else
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'This mission is already completed.')
			end
		elseif(menuresult == 5) then
			if(preps[4][4] == 0) then
				local coords = {
				{-1207.42456, 1167.24243, 29.36387, 87.2196884155273},
				{-58.11467, 731.70032, 14.68301, 177.260589599609},
				{746.2854, 1828.12488, 34.02995, 314.482116699219}
				}
				for i=1,3,1 do
					vehs[i] = SpawnCar(GetHashKey("POLICE2"), coords[i][1], coords[i][2], coords[i][3], coords[i][4])
					peds[i] = SpawnPed(GetHashKey("M_Y_COP"), coords[i][1], coords[i][2], coords[i][3], coords[i][4])
					GiveWeaponToChar(peds[i], 10, 1000, 1)
					WarpCharIntoCar(peds[i], vehs[i])
					TaskCarMission(peds[i], vehs[i], vehs[i], 1, 10.1, 0, 0, 10)
					blips[i] = AddBlipForCar(vehs[i])
				end
				SetObjective("Destroy ~y~all police vehs ~w~with ~y~armor supply")
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'Preparation mission started!')
				currmission = 4
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
						for i=1,10,1 do
							if(not IsCharDead(peds[i])) then
								if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
									for j=1,10,1 do
										AttackPlayer(peds[j])
									end
								end
							end
						end
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							RemoveBlip(blips[1])
							blips[1] = AddBlipForCoord(-1975.9502, -479.46008, 3.13311)
							SetRoute(blips[1], true)
							SetObjective("Land ~y~this helicopter ~w~at ~y~the marked point")
							currstage = 1
						end
					else
						DrawMessage("~r~Mission failed", "Helicopter destroyed.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(not IsCarDead(vehs[1])) then
						local bp = GetBlipCoords(blips[1])
						DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
						if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
							if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
								DrawMessage("~y~Preparation mission completed", "Helicopter has been successfully acquired.")
								preps[4][1] = 1
								SavePreps()
								EndMission()
							end
						end
					else
						DrawMessage("~r~Mission failed", "Helicopter destroyed.")
						EndMission()
					end
				end
			elseif(currmission == 2) then
				if(currstage == 0) then
					if(not IsCarDead(vehs[1])) then
						for i=1,3,1 do
							if(HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId())) or HasCarBeenDamagedByChar(vehs[i], GetPlayerChar(GetPlayerId()))) then
								AttackPlayer(peds[i])
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
						DrawMessage("~r~Mission failed", "Prison transport destroyed.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(not IsCarDead(vehs[1])) then
						if(StoreWantedLevel(GetPlayerId(), _i) == 0) then
							blips[1] = AddBlipForCoord(-968.89117, 1895.14185, 22.34476)
							SetRoute(blips[1], true)
							SetObjective("Deliver ~y~the prison transport ~w~to ~y~the base")
							currstage = 2
						end
					else
						DrawMessage("~r~Mission failed", "Prison transport destroyed.")
						EndMission()
					end
				elseif(currstage == 2) then
					if(not IsCarDead(vehs[1])) then
						local bp = GetBlipCoords(blips[1])
						DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
						if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
							if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
								DrawMessage("~y~Preparation mission completed", "Prison transport has been successfully acquired.")
								preps[4][2] = 1
								SavePreps()
								EndMission()
							end
						end
					else
						DrawMessage("~r~Mission failed", "Prison transport destroyed.")
						EndMission()
					end
				end
			elseif(currmission == 3) then
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
					local ox,oy,oz = GetObjectCoordinates(objs[1], _f, _f, _f)
					if(IsCharTouchingObject(GetPlayerChar(GetPlayerId()), objs[1]) or IsPlayerNearCoords(ox, oy, oz, 2)) then
						DeleteObject(objs[1])
						RemoveBlip(blips[1])
						AlterWantedLevel(GetPlayerId(), 3)
						ApplyWantedLevelChangeNow(GetPlayerId())
						SetObjective("Lose ~y~wanted level")
						currstage = 1
					end
				elseif(currstage == 1) then
					if(StoreWantedLevel(GetPlayerId(), _i) == 0) then
						blips[1] = AddBlipForCoord(-968.89117, 1895.14185, 22.34476)
						SetRoute(blips[1], true)
						SetObjective("Deliver ~y~this briefcase ~w~to ~y~the base")
						currstage = 2
					end
				elseif(currstage == 2) then
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
						DrawMessage("~y~Preparation mission completed", "Prison transport schedule has been successfully acquired.")
						preps[4][3] = 1
						SavePreps()
						EndMission()
					end
				end
			elseif(currmission == 4) then
				if(currstage == 0) then
					local carsdestroyed = 0
					for i=1,3,1 do
						if(not IsCarDead(vehs[i])) then
							if(HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId())) or HasCarBeenDamagedByChar(vehs[i], GetPlayerChar(GetPlayerId()))) then
								AttackPlayer(peds[i])
							end
						else
							RemoveBlip(blips[i])
							carsdestroyed = carsdestroyed + 1
						end
					end
					if(carsdestroyed == 3) then
						SetObjective("Lose ~y~wanted level")
						currstage = 1
					end
				elseif(currstage == 1) then
					if(StoreWantedLevel(GetPlayerId(), _i) == 0) then
						DrawMessage("~y~Preparation mission completed", "Armor supply has been successfully destroyed.")
						preps[4][4] = 1
						SavePreps()
						EndMission()
					end
				end
			elseif(currmission == 5) then
				if(currstage == 0) then
					if(not IsCarDead(vehs[1])) then
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							RemoveBlip(blips[1])
							blips[1] = AddBlipForCoord(-1146.22852, -469.39551, 2.20519)
							SetRoute(blips[1], true)
							SetObjective("Proceed into ~y~the prison")
							currstage = 1
						end
					else
						DrawMessage("~r~Mission failed", "Prison transport destroyed.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(not IsCarDead(vehs[1])) then
						local bp = GetBlipCoords(blips[1])
						DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
						if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
							if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
								RemoveBlip(blips[1])
								local coords = {
								{-968.38934, -351.53949, 3.41062, 179.772033691406},
								{-1120.81909, -353.0322, 3.17672, 295.615051269531},
								{-1094.79285, -348.00061, 3.17951, 312.126892089844},
								{-1064.71423, -335.43469, 3.18361, 22.6916217803955},
								{-1044.89014, -351.62292, 3.21659, 186.207534790039},
								{-1046.41077, -367.60046, 3.25538, 291.271392822266},
								{-1031.63391, -388.68701, 3.15138, 263.458984375},
								{-1001.54303, -409.83533, 3.18206, 196.52897644043},
								{-972.75458, -397.1355, 3.84103, 320.230041503906},
								{-947.87579, -409.1871, 3.84146, 57.7431526184082},
								{-943.71454, -432.84283, 3.84147, 183.630279541016},
								{-1004.80035, -422.52344, 3.34177, 289.530609130859},
								{-1068.21558, -426.11435, 3.19015, 112.974380493164},
								{-1105.73962, -441.79361, 2.58799, 354.349273681641},
								{-1126.16235, -421.52603, 3.18385, 272.104858398438}
								}
								for i=1,15,1 do
									if(i == 1) then
										peds[i] = SpawnPed(GetHashKey("M_Y_PRISONAOM"), coords[i][1], coords[i][2], coords[i][3], coords[i][4])
										blips[1] = AddBlipForChar(peds[i])
									else
										peds[i] = SpawnPed(GetHashKey("M_M_FATCOP_01"), coords[i][1], coords[i][2], coords[i][3], coords[i][4])
										GiveWeaponToChar(peds[i], 15, 1000, 1)
										if(preps[4][4] == 0) then
											AddArmourToChar(peds[i], 100)
										end
									end
								end
								SetObjective("Find ~y~the prisoner")
								currstage = 2
							end
						end
					end
				elseif(currstage == 2) then
					if(not IsCharDead(peds[1])) then
						for i=2,15,1 do
							if(not IsCharDead(peds[i])) then
								if(HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
									for j=2,15,1 do
										AttackPlayer(peds[j])
									end
								end
							end
						end
						if(IsPedNearPlayer(peds[1], GetPlayerChar(GetPlayerId()), 5)) then
							RemoveBlip(blips[1])
							AlterWantedLevel(GetPlayerId(), 6)
							ApplyWantedLevelChangeNow(GetPlayerId())
							for j=2,15,1 do
								AttackPlayer(peds[j])
							end
							vehs[2] = SpawnCar(GetHashKey("MAVERICK"), -1975.9502, -479.46008, 3.13311, 356.926788330078)
							blips[1] = AddBlipForCar(vehs[2])
							group = CreateGroup(false, true)
							SetGroupLeader(group, GetPlayerChar(GetPlayerId()))
							SetGroupMember(group, peds[1])
							SetCharNeverLeavesGroup(peds[1], true)
							SetObjective("Bring ~y~the prisoner ~w~to ~y~the helicopter")
							currstage = 3
						end
					else
						DrawMessage("~r~Mission failed", "The prisoner is dead.")
						EndMission()
					end
				elseif(currstage == 3) then
					if(not IsCarDead(vehs[2])) then
						if(not IsCharDead(peds[1])) then
							if(IsCharInCar(peds[1], vehs[2])) then
								RemoveBlip(blips[1])
								blips[1] = AddBlipForCoord(2230.85767, 737.43079, 5.83532)
								SetRoute(blips[1], true)
								SetObjective("Deliver ~y~this prisoner ~w~to ~y~the airport")
								currstage = 4
							end
						else
							DrawMessage("~r~Mission failed", "The prisoner is dead.")
							EndMission()
						end
					else
						DrawMessage("~r~Mission failed", "Helicopter destroyed.")
						EndMission()
					end
				elseif(currstage == 4) then
					if(IsCharDead(peds[1])) then
						DrawMessage("~r~Mission failed", "The prisoner is dead.")
						EndMission()
					elseif(IsCarDead(vehs[2])) then
						DrawMessage("~r~Mission failed", "Helicopter destroyed.")
						EndMission()
					else
						local bp = GetBlipCoords(blips[1])
						DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
						if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
							if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[2])) then
								AlterWantedLevel(GetPlayerId(), 0)
								ApplyWantedLevelChangeNow(GetPlayerId())
								local finalreward = SeparateReward(150000, 3500)
								money = money + finalreward[1]
								experience = experience + finalreward[2]
								SaveStats()
								DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
								heistsCompleted = heistsCompleted + 1
								SaveDailyStats()
								for i=1,4,1 do
									preps[4][i] = 0
								end
								SavePreps()
								EndMission()
							end
						end
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