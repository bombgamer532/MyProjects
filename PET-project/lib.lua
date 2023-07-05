local currmission = 0
local currstage = 0
local EndMission = function()
	currmission = 0
	currstage = 0
	CleanMission()
end

ProceedToRobbery2 = function()
	local tempitems = {}
	tempitems[#tempitems+1] = "Start robbery"
	if(preps[2][1] == 0) then
		tempitems[#tempitems+1] = "Helicopter"
	else
		tempitems[#tempitems+1] = "Helicopter ~g~(Done)"
	end
	if(preps[2][2] == 0) then
		tempitems[#tempitems+1] = "Removing security"
	else
		tempitems[#tempitems+1] = "Removing security ~g~(Done)"
	end
	if(preps[2][3] == 0) then
		tempitems[#tempitems+1] = "Hacker"
	else
		tempitems[#tempitems+1] = "Hacker ~g~(Done)"
	end
	if(preps[2][4] == 0) then
		tempitems[#tempitems+1] = "Removing guards (optional)"
	else
		tempitems[#tempitems+1] = "Removing guards ~g~(Done)"
	end
	DrawWindow("Libertonian", tempitems)
	while menuactive do
		Wait(0)
		if(currbutton == 1) then
			DrawDescription("Robbery", {
			-----------------------------------------------------------------------------------------------
			"Use a helicopter to reach the Libertonian museum's roof. Enter the museum through the hole and",
			"proceed to the safe. Let the hacker to finish the hacking process and steal the cash. Escape",
			"the museum and lose wanted level.",
			" ",
			"* You can remove guards out of museum to clear your way to the safe."
			})
		elseif(currbutton == 2) then
			DrawDescription("Helicopter", {
			-----------------------------------------------------------------------------------------------
			"Steal located helicopter which is being protected by several mobsters."
			})
		elseif(currbutton == 3) then
			DrawDescription("Removing security", {
			-----------------------------------------------------------------------------------------------
			"Inspect the outer side of the museum to find and remove security devices."
			})
		elseif(currbutton == 4) then
			DrawDescription("Hacker", {
			-----------------------------------------------------------------------------------------------
			"Rescue a hacker out of mobsters hideout and deliver him to the base."
			})
		elseif(currbutton == 5) then
			DrawDescription("Removing guards", {
			-----------------------------------------------------------------------------------------------
			"Get rid of museum guards who are moving in an armored truck to prevent their appearance during",
			"the heist."
			})
		end
	end
	if(menuresult > 0) then
		if(tempitems[menuresult] == "Start robbery") then
			if(preps[2][1]==1 and preps[2][2]==1 and preps[2][3]==1) then
				vehs[1] = SpawnCar(GetHashKey("MAVERICK"), -1105.90588, 635.06915, 8.71457, 0.0765133425593376)
				blips[1] = AddBlipForCar(vehs[1])
				SetObjective("Get into ~y~the helicopter")
				TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
				currmission = 5
				missionstarted = 1
			else
				TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'You have to complete all necessary preparation missions first!')
			end
		elseif(menuresult == 2) then
			if(preps[2][1] == 0) then
				local coords = {
				{-696.55347, 337.50708, 4.05752, 344.607025146484},
				{-714.71826, 342.26419, 4.05752, 312.881805419922},
				{-722.44012, 355.91183, 10.50577, 267.694244384766},
				{-708.74597, 380.71762, 8.24887, 180.835357666016},
				{-707.80023, 371.81924, 4.05752, 191.383560180664}
				}
				for i=1,5,1 do
					peds[i] = SpawnPed(GetHashKey("M_M_EE_HEAVY_01"), coords[i][1], coords[i][2], coords[i][3], coords[i][4])
					GiveWeaponToChar(peds[i], 7, 1000, 1)
				end
				vehs[1] = SpawnCar(GetHashKey("MAVERICK"), -708.62787, 356.89606, 4.07658, 269.875671386719)
				blips[1] = AddBlipForCar(vehs[1])
				SetObjective("Reach ~y~the point ~w~and steal ~y~a helicopter")
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'Preparation mission started!')
				currmission = 1
				missionstarted = 1
			else
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'This mission is already completed.')
			end
		elseif(menuresult == 3) then
			if(preps[2][2] == 0) then
				local coords = {
				{-84.6755294799805, 766.136535644531, 16.9698314666748, 89.0222549438477},
				{-126.944808959961, 838.538940429688, 21.7106628417969, 269.246398925781},
				{-88.7225646972656, 878.532470703125, 17.057243347168, 176.723205566406}
				}
				for i=1,3,1 do
					objs[i] = SpawnObject(GetHashKey("bm_alarm3"), coords[i][1], coords[i][2], coords[i][3], coords[i][4])
					FreezeObjectPosition(objs[i], true)
					blips[i] = AddBlipForObject(objs[i])
				end
				SetObjective("Reach ~y~the museum ~w~and shoot all ~y~security devices")
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'Preparation mission started!')
				currmission = 2
				missionstarted = 1
			else
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'This mission is already completed.')
			end
		elseif(menuresult == 4) then
			if(preps[2][3] == 0) then
				local coords = {
				{-79.37378, 1457.14893, 19.03283, 43.3368339538574, 2102448973},
				{-85.20275, 1468.01147, 19.0328, 133.770416259766, 2102448973},
				{-84.53753, 1457.48425, 19.0328, 42.5873756408691, 2102448973},
				{-83.98035, 1463.52795, 19.03281, 131.501876831055, 2102448973}
				}
				for i=1,4,1 do
					if(i == 1) then
						peds[i] = SpawnPed(GetHashKey("M_Y_DEALER"), coords[i][1], coords[i][2], coords[i][3], coords[i][4], coords[i][5])
						blips[i] = AddBlipForChar(peds[i])
					else
						peds[i] = SpawnPed(GetHashKey("M_M_CHINATOWN_01"), coords[i][1], coords[i][2], coords[i][3], coords[i][4], coords[i][5])
						GiveWeaponToChar(peds[i], 9, 1000, 1)
					end
				end
				SetObjective("Reach ~y~the point~w~, kill all ~y~gangsters ~w~and find ~y~the hacker")
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'Preparation mission started!')
				currmission = 3
				missionstarted = 1
			else
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'This mission is already completed.')
			end
		elseif(menuresult == 5) then
			if(preps[2][4] == 0) then
				vehs[1] = SpawnCar(GetHashKey("PSTOCKADE"), 751.52997, 1731.95667, 36.67887, 315.610198974609)
				for i=1,4,1 do
					peds[i] = SpawnPed(GetHashKey("M_Y_COP_TRAFFIC"), 751.52997, 1731.95667, 36.67887, 315.610198974609)
					GiveWeaponToChar(peds[i], 13, 1000, 1)
					if(i == 1) then
						WarpCharIntoCar(peds[i], vehs[1])
					else
						WarpCharIntoCarAsPassenger(peds[i], vehs[1], i-2)
					end
					blips[i] = AddBlipForChar(peds[i])
				end
				TaskCarMission(peds[1], vehs[1], vehs[1], 1, 10.1, 0, 0, 10)
				SetObjective("Take down ~y~cops ~w~in ~y~the van")
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
						for i=1,5,1 do
							if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
								for j=1,5,1 do
									AttackPlayer(peds[j])
								end
							end
						end
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							RemoveBlip(blips[1])
							blips[1] = AddBlipForCoord(-1105.02661, 636.93701, 8.69029)
							SetRoute(blips[1], true)
							SetObjective("Deliver ~y~this helicopter ~w~to ~y~the base")
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
								preps[2][1] = 1
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
					local secdestroyed = 0
					for i=1,3,1 do
						if(DoesObjectExist(objs[i])) then
							if(HasObjectBeenDamagedByChar(objs[i], GetPlayerChar(GetPlayerId()))) then
								DeleteObject(objs[i])
								RemoveBlip(blips[i])
							end
						else
							RemoveBlip(blips[i])
							secdestroyed = secdestroyed + 1
						end
					end
					if(secdestroyed == 3) then
						AlterWantedLevel(GetPlayerId(), 3)
						ApplyWantedLevelChangeNow(GetPlayerId())
						SetObjective("Lose ~y~wanted level")
						currstage = 1
					end
				elseif(currstage == 1) then
					if(StoreWantedLevel(GetPlayerId(), _i) == 0) then
						DrawMessage("~y~Preparation mission completed", "Security devices have been successfully destroyed.")
						preps[2][2] = 1
						SavePreps()
						EndMission()
					end
				end
			elseif(currmission == 3) then
				if(currstage == 0) then
					if(not IsCharDead(peds[1])) then
						local gangkilled = 0
						for i=2,4,1 do
							if(not IsCharDead(peds[i])) then
								if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
									for j=2,4,1 do
										AttackPlayer(peds[j])
									end
								end
							else
								gangkilled = gangkilled + 1
							end
						end
						if(gangkilled == 3) then
							group = CreateGroup(false, true)
							SetGroupLeader(group, GetPlayerChar(GetPlayerId()))
							SetGroupMember(group, peds[1])
							SetCharNeverLeavesGroup(peds[1], true)
							SetObjective("Find ~y~a vehicle ~w~and let ~y~the hacker ~w~enter it")
							currstage = 1
						end
					else
						DrawMessage("~r~Mission failed", "Hacker is dead.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(not IsCharDead(peds[1])) then
						if(IsCharInAnyCar(peds[1])) then
							RemoveBlip(blips[1])
							blips[1] = AddBlipForCoord(-1094.14941, 660.20868, 8.50523)
							SetRoute(blips[1], true)
							SetObjective("Reach ~y~the base ~w~with ~y~the hacker")
							currstage = 2
						end
					else
						DrawMessage("~r~Mission failed", "Hacker is dead.")
						EndMission()
					end
				elseif(currstage == 2) then
					if(not IsCharDead(peds[1])) then
						local bp = GetBlipCoords(blips[1])
						DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
						if(IsPedNearCoords(peds[1], bp.x, bp.y, bp.z, 5)) then
							DrawMessage("~y~Preparation mission completed", "Hacker has reached the base.")
							preps[2][3] = 1
							SavePreps()
							EndMission()
						end
					else
						DrawMessage("~r~Mission failed", "Hacker is dead.")
						EndMission()
					end
				end
			elseif(currmission == 4) then
				if(currstage == 0) then
					local copskilled = 0
					for i=1,4,1 do
						if(not IsCharDead(peds[i])) then
							if(HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId())) or HasCarBeenDamagedByChar(vehs[1], GetPlayerChar(GetPlayerId()))) then
								AttackPlayer(peds[i])
							end
						else
							RemoveBlip(blips[i])
							copskilled = copskilled + 1
						end
					end
					if(copskilled == 4) then
						AlterWantedLevel(GetPlayerId(), 2)
						ApplyWantedLevelChangeNow(GetPlayerId())
						SetObjective("Lose ~y~wanted level")
						currstage = 1
					end
				elseif(currstage == 1) then
					if(StoreWantedLevel(GetPlayerId(), _i) == 0) then
						DrawMessage("~y~Preparation mission completed", "Guards have been successfully killed.")
						preps[2][4] = 1
						SavePreps()
						EndMission()
					end
				end
			elseif(currmission == 5) then
				if(currstage == 0) then
					if(not IsCarDead(vehs[1])) then
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							RemoveBlip(blips[1])
							blips[1] = AddBlipForCoord(-108.62285, 786.67816, 34.9987)
							SetRoute(blips[1], true)
							SetObjective("Reach ~y~the roof ~w~of ~y~the museum")
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
								RemoveBlip(blips[1])
								if(preps[2][4] == 0) then
									local coords = {
									{-122.65177, 800.82996, 25.93733, 181.017120361328, 2004012895},
									{-118.44327, 820.64221, 25.93732, 180.277130126953, 2004012895},
									{-99.28966, 790.65265, 25.93733, 90.0820999145508, 2004012895},
									{-92.17482, 807.84888, 25.93733, 175.986801147461, 2004012895},
									{-96.50108, 837.2381, 25.93733, 175.960342407227, 2004012895},
									{-120.41201, 850.49146, 25.93731, 220.416366577148, 2004012895},
									{-103.62041, 853.30719, 25.93732, 177.956359863281, 2004012895}
									}
									for i=1,7,1 do
										peds[i] = SpawnPed(GetHashKey("M_Y_COP_TRAFFIC"), coords[i][1], coords[i][2], coords[i][3], coords[i][4], coords[i][5])
										GiveWeaponToChar(peds[i], 15, 1000, 1)
									end
								end
								objs[1] = SpawnObject(GetHashKey("gb_safe01"), -88.72375, 876.94171, 25.93739-1, 0.073516845703, -221274360)
								FreezeObjectPosition(objs[1], true)
								blips[1] = AddBlipForObject(objs[1])
								SetObjective("Jump down through ~y~a hole in the roof ~w~and find ~y~the safe")
								currstage = 2
							end
						end
					else
						DrawMessage("~r~Mission failed", "Helicopter destroyed.")
						EndMission()
					end
				elseif(currstage == 2) then
					for i=1,7,1 do
						if(not IsCharDead(peds[i])) then
							if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
								for j=1,7,1 do
									AttackPlayer(peds[j])
								end
							end
						end
					end
					local ox,oy,oz = GetObjectCoordinates(objs[1])
					if(IsPlayerNearCoords(ox, oy, oz, 5)) then
						Settimera(0)
						SetObjective("Wait for ~y~hacker ~w~to open ~y~the safe ~w~(~y~200 ~w~seconds left)")
						currstage = 3
					end
				elseif(currstage == 3) then
					if(Timera() < 200000) then
						AlterWantedLevel(GetPlayerId(), 4)
						ApplyWantedLevelChangeNow(GetPlayerId())
						SetObjective("Wait for ~y~hacker ~w~to open ~y~the safe ~w~(~y~" .. 200 - math.floor(Timera()/1000) .. " ~w~seconds left)")
					else
						RemoveBlip(blips[1])
						objs[2] = SpawnObject(GetHashKey("cj_cash_pile_3"), -88.81821, 875.716, 25.93726-1, 359.211547851563, -221274360)
						blips[1] = AddBlipForObject(objs[2])
						SetObjective("Collect ~y~the cash")
						currstage = 4
					end
				elseif(currstage == 4) then
					local ox,oy,oz = GetObjectCoordinates(objs[2])
					if(IsPlayerNearCoords(ox, oy, oz, 2)) then
						DeleteObject(objs[2])
						local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
						objs[2] = SpawnObject(GetHashKey("cj_mk_drug_bag"), px, py, pz, 0.0)
						AttachObjectToPed(objs[2],GetPlayerChar(GetPlayerId()),0x4B2,0.3,0,0,0,-math.pi/2,math.pi,0)
						AlterWantedLevel(GetPlayerId(), 4)
						ApplyWantedLevelChangeNow(GetPlayerId())
						RemoveBlip(blips[1])
						SetObjective("Escape ~y~the museum ~w~and lose ~y~wanted level")
						currstage = 5
					end
				elseif(currstage == 5) then
					if(StoreWantedLevel(GetPlayerId(), _i) == 0) then
						local finalreward = SeparateReward(120000, 3000)
						money = money + finalreward[1]
						experience = experience + finalreward[2]
						SaveStats()
						DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
						heistsCompleted = heistsCompleted + 1
						SaveDailyStats()
						for i=1,4,1 do
							preps[2][i] = 0
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