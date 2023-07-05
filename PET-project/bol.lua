local currmission = 0
local currstage = 0
local EndMission = function()
	currmission = 0
	currstage = 0
	CleanMission()
end

ProceedToRobbery1 = function()
	local tempitems = {}
	tempitems[#tempitems+1] = "Start robbery"
	if(preps[1][1] == 0) then
		tempitems[#tempitems+1] = "Explosives"
	else
		tempitems[#tempitems+1] = "Explosives ~g~(Done)"
	end
	if(preps[1][2] == 0) then
		tempitems[#tempitems+1] = "Escape vehicle"
	else
		tempitems[#tempitems+1] = "Escape vehicle ~g~(Done)"
	end
	if(preps[1][3] == 0) then
		tempitems[#tempitems+1] = "Removing guards (optional)"
	else
		tempitems[#tempitems+1] = "Removing guards ~g~(Done)"
	end
	if(preps[1][4] == 0) then
		tempitems[#tempitems+1] = "Decreasing wanted level (optional)"
	else
		tempitems[#tempitems+1] = "Decreasing wanted level ~g~(Done)"
	end
	DrawWindow("Bank_of_Liberty", tempitems)
	while menuactive do
		Wait(0)
		if(currbutton == 1) then
			DrawDescription("Robbery", {
			-----------------------------------------------------------------------------------------------
			"Proceed to Bank of Liberty. Enter the vault by exploding the vault door and grab the cash.",
			"Get out of there using prepared escape vehicle.",
			" ",
			"* You can remove guards out of bank to clear the entrance to the vault.",
			"** Decreasing wanted level lets you receive less amount of wanted level stars after exploding",
			"the vault door."
			})
		elseif(currbutton == 2) then
			DrawDescription("Explosives", {
			-----------------------------------------------------------------------------------------------
			"Break into a mobsters' warehouse and steal a bomb. It will be needed to explode the vault door."
			})
		elseif(currbutton == 3) then
			DrawDescription("Escape vehicle", {
			-----------------------------------------------------------------------------------------------
			"Steal a high-speed sports car to get ability to leave the scene easily."
			})
		elseif(currbutton == 4) then
			DrawDescription("Removing guards", {
			-----------------------------------------------------------------------------------------------
			"Get rid of bank guards in a local police station to prevent their appearance during the heist."
			})
		elseif(currbutton == 5) then
			DrawDescription("Decreasing wanted level", {
			-----------------------------------------------------------------------------------------------
			"Rescue the hacker from the police. They are about to move him to prison on their police car.",
			"Kill them, get control of this police car and move the hacker to the base."
			})
		end
	end
	if(menuresult > 0) then
		if(tempitems[menuresult] == "Start robbery") then
			if(preps[1][1]==1 and preps[1][2]==1) then
				if(preps[1][3] == 0) then
					local coords = {
					{-21.61703, -460.19608, 15.41224, 174.866668701172, 95416941},
					{-19.26509, -477.03503, 15.41224, 357.584442138672, 95416941},
					{-7.64754, -473.79526, 15.41225, 89.3506469726563, 95416941},
					{-16.7963, -455.96094, 15.41224, 180.839706420898, 95416941},
					{-0.0084, -458.97687, 15.41225, 144.755294799805, 95416941},
					{4.34516, -465.18228, 15.41224, 85.4188690185547, 95416941},
					{-0.50669, -473.93738, 8.91244, 267.960968017578, 95416941}
					}
					for i=1,7,1 do
						peds[i] = SpawnPed(GetHashKey("M_Y_COP"), coords[i][1], coords[i][2], coords[i][3], coords[i][4], coords[i][5])
						GiveWeaponToChar(peds[i], 15, 1000, 1)
					end
				end
				objs[1] = SpawnObject(GetHashKey("cj_vault_door"), -15.2525129318237, -474.793640136719, 9.15477848052979, 89.8366470336914, 960532882)
				blips[1] = AddBlipForCoord(-15.02734, -466.41821, 15.41224)
				SetRoute(blips[1], true)
				SetObjective("Reach ~y~the bank")
				TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
				currmission = 5
				missionstarted = 1
			else
				TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'You have to complete all necessary preparation missions first!')
			end
		elseif(menuresult == 2) then
			if(preps[1][1] == 0) then
				local coords = {
				{347.67987, -385.65509, 4.67657, 270.463134765625},
				{369.33496, -360.83432, 5.87973, 89.7828063964844},
				{373.26926, -376.78119, 10.37444, 177.025497436523},
				{342.40948, -360.86914, 10.37448, 178.309997558594},
				{350.50601, -363.78473, 5.89519, 180.068710327148}
				}
				for i=1,5,1 do
					peds[i] = SpawnPed(GetHashKey("M_M_EE_HEAVY_01"), coords[i][1], coords[i][2], coords[i][3], coords[i][4])
					GiveWeaponToChar(peds[i], 14, 1000, 1)
				end
				objs[1] = SpawnObject(GetHashKey("ec_bomb_ne"), 357.62329, -360.29428, 10.37449-1, 179.134216308594)
				blips[1] = AddBlipForObject(objs[1])
				SetObjective("Reach ~y~the point ~w~and steal ~y~explosives")
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'Preparation mission started!')
				currmission = 1
				missionstarted = 1
			else
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'This mission is already completed.')
			end
		elseif(menuresult == 3) then
			if(preps[1][2] == 0) then
				vehs[1] = SpawnCar(GetHashKey("INFERNUS"), 834.2511, -69.67175, 6.00718, 209.019546508789)
				peds[1] = SpawnPed(GetHashKey("M_M_CHINATOWN_01"), 834.2511, -69.67175, 6.00718, 209.019546508789)
				GiveWeaponToChar(peds[1], 12, 1000, 1)
				WarpCharIntoCar(peds[1], vehs[1])
				TaskCarMission(peds[1], vehs[1], vehs[1], 1, 10.1, 0, 0, 10)
				blips[1] = AddBlipForCar(vehs[1])
				SetObjective("Find the marked ~y~vehicle ~w~and steal it")
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'Preparation mission started!')
				currmission = 2
				missionstarted = 1
			else
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'This mission is already completed.')
			end
		elseif(menuresult == 4) then
			if(preps[1][3] == 0) then
				local coords = {
				{-400.7514, -270.82147, 12.70429, 90.8082046508789},
				{-400.47284, -262.3924, 19.1519, 89.7088241577148},
				{-395.81366, -249.31868, 12.83519, 269.436065673828},
				{-415.87863, -258.64996, 12.83519, 179.693740844727},
				{-402.57397, -254.59277, 12.83518, 180.773315429688}
				}
				for i=1,5,1 do
					peds[i] = SpawnPed(GetHashKey("M_Y_COP"), coords[i][1], coords[i][2], coords[i][3], coords[i][4])
					GiveWeaponToChar(peds[i], 15, 1000, 1)
					blips[i] = AddBlipForChar(peds[i])
				end
				SetObjective("Reach ~y~the point ~w~and kill all ~y~cops")
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'Preparation mission started!')
				currmission = 3
				missionstarted = 1
			else
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'This mission is already completed.')
			end
		elseif(menuresult == 5) then
			if(preps[1][4] == 0) then
				vehs[1] = SpawnCar(GetHashKey("POLICE2"), -1075.04175, 1172.95105, 29.37806, 87.7615432739258)
				peds[1] = SpawnPed(GetHashKey("M_Y_DEALER"), -1075.04175, 1172.95105, 29.37806, 87.7615432739258) --hacker
				peds[2] = SpawnPed(GetHashKey("M_Y_COP"), -1075.04175, 1172.95105, 29.37806, 87.7615432739258)
				GiveWeaponToChar(peds[2], 13, 1000, 1)
				peds[3] = SpawnPed(GetHashKey("M_Y_COP"), -1075.04175, 1172.95105, 29.37806, 87.7615432739258)
				GiveWeaponToChar(peds[3], 13, 1000, 1)
				WarpCharIntoCar(peds[2], vehs[1])
				WarpCharIntoCarAsPassenger(peds[3], vehs[1], 1)
				WarpCharIntoCarAsPassenger(peds[1], vehs[1], 2)
				TaskCarMission(peds[2], vehs[1], vehs[1], 1, 10.1, 0, 0, 10)
				blips[1] = AddBlipForChar(peds[1])
				SetObjective("Rescue ~y~the hacker ~w~from ~y~cops")
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
					for i=1,5,1 do
						if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
							for j=1,5,1 do
								AttackPlayer(peds[j])
							end
						end
					end
					local ox,oy,oz = GetObjectCoordinates(objs[1], _f, _f, _f)
					if(IsPlayerNearCoords(ox, oy, oz, 2)) then
						DeleteObject(objs[1])
						RemoveBlip(blips[1])
						blips[1] = AddBlipForCoord(-320.28702, 323.54236, 14.6802)
						SetRoute(blips[1], true)
						SetObjective("Deliver ~y~explosives ~w~to ~y~the base")
						currstage = 1
					end
				elseif(currstage == 1) then
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
						DrawMessage("~y~Preparation mission completed", "Explosives have been successfully acquired.")
						preps[1][1] = 1
						SavePreps()
						EndMission()
					end
				end
			elseif(currmission == 2) then
				if(currstage == 0) then
					if(not IsCarDead(vehs[1])) then
						if(not IsCharDead(peds[1])) then
							if(HasCharBeenDamagedByChar(peds[1], GetPlayerChar(GetPlayerId())) or HasCarBeenDamagedByChar(vehs[1], GetPlayerChar(GetPlayerId()))) then
								AttackPlayer(peds[1])
							end
						end
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							RemoveBlip(blips[1])
							blips[1] = AddBlipForCoord(1.09995, -447.79321, 14.76266)
							SetRoute(blips[1], true)
							SetObjective("Park ~y~this vehicle ~w~near the bank at ~y~the marked point")
							currstage = 1
						end
					else
						DrawMessage("~r~Mission failed", "Escape vehicle destroyed.")
						EndMission()
					end
				elseif(currstage == 1) then
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(not IsCarDead(vehs[1])) then
						if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
							DrawMessage("~y~Preparation mission completed", "Escape vehicle has been successfully prepared.")
							preps[1][2] = 1
							SavePreps()
							EndMission()
						end
					else
						DrawMessage("~r~Mission failed", "Escape vehicle destroyed.")
						EndMission()
					end
				end
			elseif(currmission == 3) then
				if(currstage == 0) then
					local copskilled = 0
					for i=1,5,1 do
						if(not IsCharDead(peds[i])) then
							if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
								for j=1,5,1 do
									AttackPlayer(peds[j])
								end
							end
						else
							RemoveBlip(blips[i])
							copskilled = copskilled + 1
						end
					end
					if(copskilled == 5) then
						AlterWantedLevel(GetPlayerId(), 2)
						ApplyWantedLevelChangeNow(GetPlayerId())
						SetObjective("Lose ~y~wanted level")
						currstage = 1
					end
				elseif(currstage == 1) then
					if(StoreWantedLevel(GetPlayerId(), _i) == 0) then
						DrawMessage("~y~Preparation mission completed", "Guards have been successfully killed.")
						preps[1][3] = 1
						SavePreps()
						EndMission()
					end
				end
			elseif(currmission == 4) then
				if(currstage == 0) then
					if(not IsCharDead(peds[1])) then
						if(IsCharInCar(peds[1], vehs[1])) then
							if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
								RemoveBlip(blips[1])
								blips[1] = AddBlipForCoord(-321.44534, 324.20337, 14.66051)
								SetRoute(blips[1], true)
								SetObjective("Reach ~y~the base ~w~with ~y~the hacker")
								currstage = 1
							end
						else
							WarpCharIntoCarAsPassenger(peds[1], vehs[1], 2)
						end
						for i=2,3,1 do
							if(not IsCharDead(peds[i])) then
								if(HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId())) or HasCarBeenDamagedByChar(vehs[1], GetPlayerChar(GetPlayerId()))) then
									for j=2,3,1 do
										AttackPlayer(peds[j])
									end
								end
							end
						end
					else
						DrawMessage("~r~Mission failed", "Hacker is dead.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(not IsCharDead(peds[1])) then
						local bp = GetBlipCoords(blips[1])
						DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
						if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
							DrawMessage("~y~Preparation mission completed", "Hacker has reached the base.")
							preps[1][4] = 1
							SavePreps()
							EndMission()
						end
					else
						DrawMessage("~r~Mission failed", "Hacker is dead.")
						EndMission()
					end
				end
			elseif(currmission == 5) then
				if(currstage == 0) then
					local bp = GetBlipCoords(blips[1])
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 20)) then
						for i=1,7,1 do
							AttackPlayer(peds[i])
						end
						RemoveBlip(blips[1])
						blips[1] = AddBlipForCoord(-13.73466, -473.97919, 8.91245)
						SetRoute(blips[1], true)
						SetObjective("Plant ~y~the bomb ~w~at ~y~the vault door")
						currstage = 1
					end
				elseif(currstage == 1) then
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
						objs[2] = SpawnObject(GetHashKey("ec_bomb_ne"), bp.x, bp.y, bp.z-1, 269.568908691406, 960532882)
						RemoveBlip(blips[1])
						blips[1] = AddBlipForObject(objs[2])
						SetObjective("Move back on a safe distance and ~y~shoot the bomb")
						currstage = 2
					end
				elseif(currstage == 2) then
					local ox,oy,oz = GetObjectCoordinates(objs[2])
					if(HasObjectBeenDamagedByChar(objs[2], GetPlayerChar(GetPlayerId()))) then
						DeleteObject(objs[1])
						DeleteObject(objs[2])
						AddExplosion(ox, oy, oz, 0, 5.1, true, false, 1.1)
						objs[1] = SpawnObject(GetHashKey("cj_cash_pile_3"), -20.42907, -473.14404, 8.91245-1, 269.951293945313, 960532882)
						if(preps[1][4] == 0) then
							AlterWantedLevel(GetPlayerId(), 6)
							ApplyWantedLevelChangeNow(GetPlayerId())
						else
							AlterWantedLevel(GetPlayerId(), 3)
							ApplyWantedLevelChangeNow(GetPlayerId())
						end
						RemoveBlip(blips[1])
						blips[1] = AddBlipForObject(objs[1])
						SetObjective("Collect ~y~the cash")
						currstage = 3
					end
				elseif(currstage == 3) then
					local ox,oy,oz = GetObjectCoordinates(objs[1])
					if(IsPlayerNearCoords(ox, oy, oz, 2)) then
						DeleteObject(objs[1])
						local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
						objs[1] = SpawnObject(GetHashKey("cj_mk_drug_bag"), px, py, pz, 0.0)
						AttachObjectToPed(objs[1],GetPlayerChar(GetPlayerId()),0x4B2,0.3,0,0,0,-math.pi/2,math.pi,0)
						vehs[1] = SpawnCar(GetHashKey("INFERNUS"), 1.64801, -447.90308, 14.76078, 269.800415039063)
						RemoveBlip(blips[1])
						blips[1] = AddBlipForCar(vehs[1])
						SetObjective("Reach ~y~the escape vehicle")
						currstage = 4
					end
				elseif(currstage == 4) then
					if(not IsCarDead(vehs[1])) then
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							RemoveBlip(blips[1])
							blips[1] = AddBlipForCoord(-304.9006, 1456.6875, 18.9675)
							SetRoute(blips[1], true)
							SetObjective("Drive to ~y~the hideout")
							currstage = 5
						end
					else
						RemoveBlip(blips[1])
						SetObjective("Escape vehicle is broken. Find another way to ~y~lose cops")
						currstage = 6
					end
				elseif(currstage == 5) then
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(not IsCarDead(vehs[1])) then
						if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
							AlterWantedLevel(GetPlayerId(), 0)
							ApplyWantedLevelChangeNow(GetPlayerId())
							local finalreward = SeparateReward(100000, 2500)
							money = money + finalreward[1]
							experience = experience + finalreward[2]
							SaveStats()
							DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
							heistsCompleted = heistsCompleted + 1
							SaveDailyStats()
							for i=1,4,1 do
								preps[1][i] = 0
							end
							SavePreps()
							EndMission()
						end
					else
						RemoveBlip(blips[1])
						SetObjective("Escape vehicle is broken. Find another way to ~y~lose cops")
						currstage = 6
					end
					if(StoreWantedLevel(GetPlayerId(), _i) == 0) then
						local finalreward = SeparateReward(100000, 2500)
						money = money + finalreward[1]
						experience = experience + finalreward[2]
						SaveStats()
						DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
						heistsCompleted = heistsCompleted + 1
						SaveDailyStats()
						for i=1,4,1 do
							preps[1][i] = 0
						end
						SavePreps()
						EndMission()
					end
				elseif(currstage == 6) then
					if(StoreWantedLevel(GetPlayerId(), _i) == 0) then
						local finalreward = SeparateReward(100000, 2500)
						money = money + finalreward[1]
						experience = experience + finalreward[2]
						SaveStats()
						DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
						heistsCompleted = heistsCompleted + 1
						SaveDailyStats()
						for i=1,4,1 do
							preps[1][i] = 0
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