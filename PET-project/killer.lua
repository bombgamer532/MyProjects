local currmission = 0
local currstage = 0
local EndMission = function()
	currmission = 0
	currstage = 0
	CleanMission()
end

local group = nil
local mismainblip = {}
local misobj = {}
local mis = {
{pos = {708.21912, 1731.52795, 36.7147, 179.469741821289}, name = "Taxi kill"},
{pos = {1280.52637, -531.01575, 14.40862, 214.676803588867}, name = "RPG kill"},
{pos = {-1748.52844, -491.26862, 3.21411, 359.899108886719}, name = "Crash kill"},
{pos = {-908.95734, 1424.6991, 25.21867, 90.2387313842773}, name = "Sniper kill"}
}
local currass = 0
local asscooldown = 0
CreateThread(function()
	while true do
		Wait(0)
		if(agency > 0) then
			if(asscooldown > 0) then
				Wait(1000)
				asscooldown = asscooldown - 1
				if(asscooldown <= 0) then
					local tempass = currass
					while currass==tempass do
						currass = GenerateRandomIntInRange(1, #mis+1)
					end
					TriggerEvent('chatMessage', '[Contract kill]', {255, 255, 0}, 'New contract kill is available! Look for blip on the map.')
				end
			else
				if(currass == 0) then
					currass = GenerateRandomIntInRange(1, #mis+1)
				end
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if(currass > 0) then
			local i = currass
			if(not DoesBlipExist(mismainblip[i])) then
				mismainblip[i] = AddBlipForCoord(mis[i].pos[1], mis[i].pos[2], mis[i].pos[3])
				ChangeBlipSprite(mismainblip[i], 72)
				--ChangeBlipScale(mismainblip[i], 0.7)
				ChangeBlipNameFromAscii(mismainblip[i], "Contract kill")
				SetBlipAsShortRange(mismainblip[i], true)
			end
			if(not DoesObjectExist(misobj[i])) then
				misobj[i] = SpawnObject(GetHashKey("nj03_misphone"), mis[i].pos[1], mis[i].pos[2], mis[i].pos[3]-1, mis[i].pos[4]-180)
				SetNetworkIdCanMigrate(GetNetworkIdFromObject(misobj[i]), false)
			end
			if(missionstarted == 0) then
				if(IsPlayerNearCoords(mis[i].pos[1], mis[i].pos[2], mis[i].pos[3], 3)) then
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~start mission", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						if(missionstarted == 0) then
							if(mis[i].name == "Taxi kill") then
								peds[1] = SpawnPed(GetHashKey("M_Y_DEALER"), 1237.06482, 497.83145, 28.57873, 53.1115875244141)
								blips[1] = AddBlipForChar(peds[1])
								SetObjective("Kill ~y~the target ~w~(~r~Bonus~w~: Pick him up by taxi and drop into water)")
								TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
								currmission = 1
								missionstarted = 1
							elseif(mis[i].name == "RPG kill") then
								vehs[1] = SpawnCar(GetHashKey("ORACLE"), 754.04816, 274.7843, 41.36925, 88.1333618164063)
								peds[1] = SpawnPed(GetHashKey("M_Y_CHINATOWN_03"), 754.04816, 274.7843, 41.36925, 88.1333618164063)
								blips[1] = AddBlipForChar(peds[1])
								WarpCharIntoCar(peds[1], vehs[1])
								TaskCarMission(peds[1], vehs[1], vehs[1], 1, 10.1, 0, 0, 10)
								SetObjective("Kill ~y~the target ~w~(~r~Bonus~w~: Kill him using rocket launcher)")
								TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
								currmission = 2
								missionstarted = 1
							elseif(mis[i].name == "Crash kill") then
								peds[1] = SpawnPed(GetHashKey("M_M_EE_HEAVY_01"), -304.17285, 674.41785, 12.40956, 311.345550537109)
								blips[1] = AddBlipForChar(peds[1])
								SetObjective("Kill ~y~the target ~w~(~r~Bonus~w~: Kill by crashing into him with a police car)")
								TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
								currmission = 3
								missionstarted = 1
							elseif(mis[i].name == "Sniper kill") then
								vehs[1] = SpawnCar(GetHashKey("PMP600"), -333.74722, 258.3038, 14.84065, 267.629028320313)
								peds[1] = SpawnPed(GetHashKey("m_y_gmaf_hi_02"), -333.74722, 258.3038, 14.84065, 267.629028320313)
								blips[1] = AddBlipForChar(peds[1])
								WarpCharIntoCar(peds[1], vehs[1])
								TaskCarMission(peds[1], vehs[1], vehs[1], 1, 10.1, 0, 0, 10)
								SetObjective("Kill ~y~the target ~w~(~r~Bonus~w~: Kill him using sniper rifle)")
								TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
								currmission = 4
								missionstarted = 1
							end
						else
							TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'Mission in progress!')
						end
					end
				end
			end
		else
			for i=1,#mis,1 do
				if(DoesBlipExist(mismainblip[i])) then
					RemoveBlip(mismainblip[i])
				end
				if(DoesObjectExist(misobj[i])) then
					DeleteObject(misobj[i])
				end
			end
		end
	end
end)

local FinishAssassination = function(bonus)
	if(bonus == 1) then
		local finalreward = {20000, 1500}
		money = money + finalreward[1]
		experience = experience + finalreward[2]
		SaveStats()
		DrawMessage("~y~Assassination completed", "Bonus acquired! You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
	else
		local finalreward = {5000, 500}
		money = money + finalreward[1]
		experience = experience + finalreward[2]
		SaveStats()
		DrawMessage("~y~Assassination completed", "No bonus. You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
	end
	SaveDailyStats()
	EndMission()
	asscooldown = 600
	currass = 0
end

CreateThread(function()
	while true do
		Wait(0)
		if(currmission > 0) then
			if(currmission == 1) then
				if(currstage == 0) then
					if(IsCharDead(peds[1])) then
						if(IsCharInAnyCar(peds[1]) and 
						(IsCarModel(GetCarCharIsUsing(peds[1]), GetHashKey("taxi")) or 
						IsCarModel(GetCarCharIsUsing(peds[1]), GetHashKey("taxi2")) or 
						IsCarModel(GetCarCharIsUsing(peds[1]), GetHashKey("cabby"))) and 
						IsCarInWater(GetCarCharIsUsing(peds[1]))) then
							FinishAssassination(1)
						else
							FinishAssassination(0)
						end
					else
						if(not IsCharInAnyCar(peds[1])) then
							local px,py,pz = GetCharCoordinates(peds[1])
							if(IsPlayerNearCoords(px, py, pz, 10)) then
								if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
									local veh = GetCarCharIsUsing(GetPlayerChar(GetPlayerId()))
									if(IsCarModel(veh, GetHashKey("taxi")) or 
									IsCarModel(veh, GetHashKey("taxi2")) or 
									IsCarModel(veh, GetHashKey("cabby"))) then
										if(not DoesGroupExist(group)) then
											group = CreateGroup(false, true)
											SetGroupLeader(group, GetPlayerChar(GetPlayerId()))
											SetGroupMember(group, peds[1])
											SetCharNeverLeavesGroup(peds[1], true)
										end
									end
								end
							end
						else
							RemoveCharFromGroup(peds[1])
							RemoveGroup(group)
							group = nil
						end
					end
				end
			elseif(currmission == 2) then
				if(currstage == 0) then
					if(IsCharDead(peds[1])) then
						local gw,cw = GetCurrentCharWeapon(GetPlayerChar(GetPlayerId()))
						if(HasCharBeenDamagedByChar(peds[1], GetPlayerChar(GetPlayerId()), false) and
						cw==18) then
							FinishAssassination(1)
						else
							FinishAssassination(0)
						end
					end
				end
			elseif(currmission == 3) then
				if(currstage == 0) then
					if(IsCharDead(peds[1])) then
						if(IsCharInAnyCar(GetPlayerChar(GetPlayerId())) and
						HasCharBeenDamagedByChar(peds[1], GetPlayerChar(GetPlayerId()), false) and
						--not IsPedDoingDriveby(GetPlayerChar(GetPlayerId())) and
						(IsCarModel(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())), GetHashKey("police")) or 
						IsCarModel(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())), GetHashKey("police2")) or 
						IsCarModel(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())), GetHashKey("noose")) or 
						IsCarModel(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())), GetHashKey("pstockade")) or 
						IsCarModel(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())), GetHashKey("nstockade")) or 
						IsCarModel(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())), GetHashKey("polpatriot")))) then
							FinishAssassination(1)
						else
							FinishAssassination(0)
						end
					end
				end
			elseif(currmission == 4) then
				if(currstage == 0) then
					if(IsCharDead(peds[1])) then
						local gw,cw = GetCurrentCharWeapon(GetPlayerChar(GetPlayerId()))
						if(HasCharBeenDamagedByChar(peds[1], GetPlayerChar(GetPlayerId()), false) and
						(cw==16 or cw==17 or cw==35)) then
							FinishAssassination(1)
						else
							FinishAssassination(0)
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