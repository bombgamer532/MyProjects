local currmission = 0
local currstage = 0
local EndMission = function()
	currmission = 0
	currstage = 0
	CleanMission()
end

ProceedToRobbery5 = function()
	local tempitems = {}
	tempitems[#tempitems+1] = "Start robbery"
	if(preps[5][1] == 0) then
		tempitems[#tempitems+1] = "Getting codes"
	else
		tempitems[#tempitems+1] = "Getting codes ~g~(Done)"
	end
	if(preps[5][2] == 0) then
		tempitems[#tempitems+1] = "Escape vehicle"
	else
		tempitems[#tempitems+1] = "Escape vehicle ~g~(Done)"
	end
	if(preps[5][3] == 0) then
		tempitems[#tempitems+1] = "Removing alarm (optional)"
	else
		tempitems[#tempitems+1] = "Removing alarm ~g~(Done)"
	end
	DrawWindow("LCPD_Raid", tempitems)
	while menuactive do
		Wait(0)
		if(currbutton == 1) then
			DrawDescription("Robbery", {
			-----------------------------------------------------------------------------------------------
			"Enter the police station. Start hacking process and wait for it to finish while protecting",
			"from cops. When it's finished, leave the area using stolen police helicopter. Destroy this",
			"helicopter to remove evidence.",
			" ",
			"* Remove alarm system to prevent SWAT from coming to attack you during hacking process."
			})
		elseif(currbutton == 2) then
			DrawDescription("Getting codes", {
			-----------------------------------------------------------------------------------------------
			"Steal a police car, install recording device and park it at the police station to record the",
			"access codes for hacking process."
			})
		elseif(currbutton == 3) then
			DrawDescription("Escape vehicle", {
			-----------------------------------------------------------------------------------------------
			"Steal police helicopter from another police station and park it on the roof of needed police",
			"station to use it for escape during the heist."
			})
		elseif(currbutton == 4) then
			DrawDescription("Removing alarm", {
			-----------------------------------------------------------------------------------------------
			"Steal a bomb from a marked van and plant it on the roof of police station near a satelite."
			})
		end
	end
	if(menuresult > 0) then
		if(tempitems[menuresult] == "Start robbery") then
			if(preps[5][1]==1 and preps[5][2]==1) then
				blips[1] = AddBlipForCoord(82.2326, 1206.578, 19.09254)
				SetRoute(blips[1], true)
				SetObjective("Reach ~y~the police station ~w~and start ~y~hacking process")
				TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
				currmission = 4
				missionstarted = 1
			else
				TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'You have to complete all necessary preparation missions first!')
			end
		elseif(menuresult == 2) then
			if(preps[5][1] == 0) then
				SetObjective("Steal ~y~a police car")
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'Preparation mission started!')
				currmission = 1
				missionstarted = 1
			else
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'This mission is already completed.')
			end
		elseif(menuresult == 3) then
			if(preps[5][2] == 0) then
				vehs[1] = SpawnCar(GetHashKey("polmav"), 2133.52002, 441.27142, 23.71822, 359.125915527344)
				local coords = {
				{2135.60596, 405.1525, 6.08498, 263.884490966797},
				{2119.47388, 413.61859, 6.08499, 52.1892204284668},
				{2136.05518, 420.15942, 19.3438, 176.165725708008},
				{2125.94238, 420.80389, 19.34382, 99.6249389648438},
				{2123.00513, 430.98312, 21.83145, 116.728210449219}
				}
				for i=1,5,1 do
					peds[i] = SpawnPed(GetHashKey("M_Y_COP"), coords[i][1], coords[i][2], coords[i][3], coords[i][4])
					GiveWeaponToChar(peds[i], 7, 1000, 1)
				end
				blips[1] = AddBlipForCar(vehs[1])
				SetObjective("Steal ~y~a police helicopter")
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'Preparation mission started!')
				currmission = 2
				missionstarted = 1
			else
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'This mission is already completed.')
			end
		elseif(menuresult == 4) then
			if(preps[5][3] == 0) then
				local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()), _f, _f, _f)
				local angle = GenerateRandomIntInRange(0, 360, _i)
				local radius = GenerateRandomIntInRange(100, 3000, _i)
				rb,rx,ry,rz,rh = GetNextClosestCarNodeWithHeading(px+radius*math.cos(angle*math.pi/180), py+radius*math.sin(angle*math.pi/180), pz, _f, _f, _f, _f)
				vehs[1] = SpawnCar(GetHashKey("boxville"), rx, ry, rz, rh)
				peds[1] = SpawnPed(GetHashKey("M_M_CHINATOWN_01"), rx, ry, rz, rh)
				WarpCharIntoCar(peds[1], vehs[1])
				TaskCarMission(peds[1], vehs[1], vehs[1], 1, 10.1, 0, 0, 10)
				blips[1] = AddBlipForCar(vehs[1])
				SetObjective("Get ~y~explosives ~w~from ~y~the marked van")
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'Preparation mission started!')
				currmission = 3
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
					if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
						if(IsCarModel(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())), GetHashKey("police")) or 
						IsCarModel(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())), GetHashKey("police2"))) then
							SetCarAsMissionCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())), true)
							vehs[1] = GetCarCharIsUsing(GetPlayerChar(GetPlayerId()))
							SetNetworkIdCanMigrate(GetNetworkIdFromVehicle(vehs[1]), false)
							SetObjective("Lose ~y~wanted level")
							currstage = 1
						end
					end
				elseif(currstage == 1) then
					if(not IsCarDead(vehs[1])) then
						if(StoreWantedLevel(GetPlayerId()) == 0) then
							local coords = {
							{-307.8573, 1539.99805, 20.30938, 359.974426269531},
							{-1148.06714, 1188.22766, 17.50671, 177.032287597656},
							{-1300.18738, 283.09348, 10.80944, 178.410720825195},
							{1058.24109, -296.93875, 21.35996, 356.611114501953},
							{-513.74414, 367.13248, 6.48891, 357.628387451172}
							}
							local rnd = GetClosestCoordWithIndex(coords)
							blips[1] = AddBlipForCoord(coords[rnd][1], coords[rnd][2], coords[rnd][3])
							SetRoute(blips[1], true)
							SetObjective("Install ~y~recording device ~w~into ~y~this car")
							currstage = 2
						end
					else
						DrawMessage("~r~Mission failed", "Police car destroyed.")
						EndMission()
					end
				elseif(currstage == 2) then
					if(not IsCarDead(vehs[1])) then
						local bp = GetBlipCoords(blips[1])
						DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
						if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
							if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
								RemoveBlip(blips[1])
								blips[1] = AddBlipForCoord(68.60052, 1248.03369, 16.00591)
								SetRoute(blips[1], true)
								SetObjective("Park ~y~this car ~w~at ~y~the police station")
								currstage = 3
							else
								PrintStringWithLiteralStringNow("STRING", "~r~You must be in mission vehicle!", 1000, 1)
							end
						end
					else
						DrawMessage("~r~Mission failed", "Police car destroyed.")
						EndMission()
					end
				elseif(currstage == 3) then
					if(not IsCarDead(vehs[1])) then
						local bp = GetBlipCoords(blips[1])
						DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
						if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
							if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
								RemoveBlip(blips[1])
								SetCarForwardSpeed(vehs[1], 0.0)
								TaskLeaveAnyCar(GetPlayerChar(GetPlayerId()))
								while IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1]) do
									Wait(0)
								end
								FreezeCarPosition(vehs[1], true)
								SetNetworkIdCanMigrate(GetNetworkIdFromVehicle(vehs[1]), false)
								SetObjective("Leave ~y~this area")
								currstage = 4
							end
						end
					else
						DrawMessage("~r~Mission failed", "Police car destroyed.")
						EndMission()
					end
				elseif(currstage == 4) then
					if(not IsCarDead(vehs[1])) then
						local cx,cy,cz = GetCarCoordinates(vehs[1])
						if(not IsPlayerNearCoords(cx, cy, cz, 200)) then
							DrawMessage("~y~Preparation mission completed", "Codes have been successfully acquired.")
							preps[5][1] = 1
							SavePreps()
							EndMission()
						end
					else
						DrawMessage("~r~Mission failed", "Police car destroyed.")
						EndMission()
					end
				end
			elseif(currmission == 2) then
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
							blips[1] = AddBlipForCoord(-107.24648, 1215.4281, 19.6106)
							SetRoute(blips[1], true)
							SetObjective("Park ~y~this helicopter ~w~on ~y~the police station helipad")
							currstage = 2
						end
					else
						DrawMessage("~r~Mission failed", "Helicopter destroyed.")
						EndMission()
					end
				elseif(currstage == 1) then
					if(not IsCarDead(vehs[1])) then
						if(StoreWantedLevel(GetPlayerId()) == 0) then
							SetObjective("Park ~y~this helicopter ~w~in ~y~the hideout")
							currstage = 2
						end
					else
						DrawMessage("~r~Mission failed", "Helicopter destroyed.")
						EndMission()
					end
				elseif(currstage == 2) then
					if(not IsCarDead(vehs[1])) then
						local bp = GetBlipCoords(blips[1])
						DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
						if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
							if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
								DrawMessage("~y~Preparation mission completed", "Escape vehicle has been successfully acquired.")
								preps[5][2] = 1
								SavePreps()
								EndMission()
							end
						end
					else
						DrawMessage("~r~Mission failed", "Helicopter destroyed.")
						EndMission()
					end
				end
			elseif(currmission == 3) then
				if(currstage == 0) then
					if(not IsCarDead(vehs[1])) then
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							RemoveBlip(blips[1])
							blips[1] = AddBlipForCoord(94.36557, 1205.22095, 24.19627)
							SetRoute(blips[1], true)
							SetObjective("Plant ~y~the bomb ~w~on ~y~the roof ~w~of the police station")
							currstage = 1
						end
					else
						DrawMessage("~r~Mission failed", "Van destroyed.")
						EndMission()
					end
				elseif(currstage == 1) then
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
						objs[1] = SpawnObject(GetHashKey("ec_bomb_ne"), bp.x, bp.y, bp.z-1, 226.002426147461)
						RemoveBlip(blips[1])
						SetObjective("Leave ~y~this area")
						currstage = 2
					end
				elseif(currstage == 2) then
					local ox,oy,oz = GetObjectCoordinates(objs[1])
					if(not IsPlayerNearCoords(ox, oy, oz, 200)) then
						DrawMessage("~y~Preparation mission completed", "Alarm system has been destroyed.")
						preps[5][3] = 1
						SavePreps()
						EndMission()
					end
				end
			elseif(currmission == 4) then
				if(currstage == 0) then
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
						AlterWantedLevel(GetPlayerId(), 6)
						ApplyWantedLevelChangeNow(GetPlayerId())
						Settimera(0)
						SetObjective("Wait for ~y~hacking process ~w~to be finished (~y~200 ~w~seconds left)")
						currstage = 1
					end
				elseif(currstage == 1) then
					local bp = GetBlipCoords(blips[1])
					if(Timera() < 200000) then
						SetObjective("Wait for ~y~hacking process ~w~to be finished (~y~" .. 200 - math.floor(Timera()/1000) .. " ~w~seconds left)")
						if(preps[5][3] == 0) then
							local pedsdead = 0
							for i=1,3,1 do
								if(IsCharDead(peds[i])) then
									RemoveBlip(blips[i+1])
									pedsdead = pedsdead + 1
								else
									AttackPlayer(peds[i])
								end
							end
							if(pedsdead == 3) then
								for i=1,3,1 do
									DeleteChar(peds[i])
								end
								for i=1,3,1 do
									peds[i] = SpawnPed(GetHashKey("M_Y_SWAT"), 84.91031, 1213.65955, 14.73809, 88.732666015625)
									GiveWeaponToChar(peds[i], 15, 1000, 1)
									RemoveBlip(blips[i+1])
									blips[i+1] = AddBlipForChar(peds[i], _i)
								end
							end
						end
						if(not IsPlayerNearCoords(bp.x, bp.y, bp.z, 10)) then
							local temptimer = Timera()
							Settimerb(0)
							while Timerb()<10000 do
								Wait(0)
								SetObjective("Get back to ~y~the hacking device~w~! ~w~(~y~" .. 10 - math.floor(Timerb()/1000) .. " ~w~seconds left)")
								if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 5)) then
									Settimera(temptimer)
									break
								end
								if(IsPlayerDead(GetPlayerId())) then
									break
								end
							end
							if(Timerb() >= 10000) then
								DrawMessage("~r~Mission failed", "Hacking process has been interrupted.")
								EndMission()
							end
						end
					else
						for i=1,4,1 do
							RemoveBlip(blips[i])
						end
						vehs[1] = SpawnCar(GetHashKey("polmav"), 63.32414, 1255.49438, 30.2211, 225.284805297852)
						blips[1] = AddBlipForCar(vehs[1])
						SetObjective("Get into ~y~the helicopter")
						currstage = 2
					end
				elseif(currstage == 2) then
					if(not IsCarDead(vehs[1])) then
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[1])) then
							RemoveBlip(blips[1])
							SetObjective("Get higher than ~y~100m ~w~to lose ~y~wanted level")
							currstage = 3
						end
					else
						DrawMessage("~r~Mission failed", "Helicopter destroyed.")
						EndMission()
					end
				elseif(currstage == 3) then
					if(not IsCarDead(vehs[1])) then
						AlterWantedLevel(GetPlayerId(), 6)
						ApplyWantedLevelChangeNow(GetPlayerId())
						if(GetCharHeightAboveGround(GetPlayerChar(GetPlayerId())) > 100) then
							AlterWantedLevel(GetPlayerId(), 0)
							ApplyWantedLevelChangeNow(GetPlayerId())
							SetObjective("Destroy ~y~this helicopter")
							currstage = 4
						end
					else
						DrawMessage("~r~Mission failed", "Helicopter destroyed.")
						EndMission()
					end
				elseif(currstage == 4) then
					if(IsCarDead(vehs[1])) then
						local finalreward = SeparateReward(80000, 2000)
						money = money + finalreward[1]
						experience = experience + finalreward[2]
						SaveStats()
						DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
						heistsCompleted = heistsCompleted + 1
						SaveDailyStats()
						for i=1,3,1 do
							preps[5][i] = 0
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