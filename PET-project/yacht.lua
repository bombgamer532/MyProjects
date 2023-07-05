local currmission = 0
local currstage = 0
local EndMission = function()
	currmission = 0
	currstage = 0
	CleanMission()
end

CreateThread(function()
	while true do
		Wait(0)
		SetCharAllowedToRunOnBoats(GetPlayerChar(GetPlayerId()), true)
		if(not IsCarDead(yacht)) then
			if(not DoesBlipExist(yachtblip)) then
				yachtblip = AddBlipForCar(yacht, _i)
				ChangeBlipSprite(yachtblip, 48)
				ChangeBlipScale(yachtblip, 0.7)
				ChangeBlipNameFromAscii(yachtblip, "Yacht")
				ChangeBlipColour(yachtblip, 19)
				SetBlipAsShortRange(yachtblip, true)
			end
			LockCarDoors(yacht, 2)
			FreezeCarPosition(yacht, true)
			SetCarCanBeDamaged(yacht, false)
			SetCarCanBeVisiblyDamaged(yacht, false)
			local cx,cy,cz = GetCarCoordinates(yacht)
			local ch = GetCarHeading(yacht)
			DrawCheckpointWithDist(cx+36*math.cos((ch-90)*math.pi/180), cy+36*math.sin((ch-90)*math.pi/180), cz-0.5, 1.1, 255, 255, 0, 100)
			if(IsPlayerNearCoords(cx+36*math.cos((ch-90)*math.pi/180), cy+36*math.sin((ch-90)*math.pi/180), cz-0.5, 1.5)) then
				PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~open boatyard menu", 1000, 1)
				if(IsGameKeyboardKeyJustPressed(18)) then
					local tempitems = {}
					for j=1,#boats,1 do
						if(boats[j] == 1) then
							if(boatspecs[j][1] ~= "Yacht") then
								tempitems[#tempitems+1] = "" .. boatspecs[j][1]
							end
						end
					end
					DrawWindow("Yacht_boatyard", tempitems)
					while menuactive do
						Wait(0)
					end
					if(menuresult > 0) then
						local tempcarid = 0
						for j=1,#boatspecs,1 do
							if(boatspecs[j][1] == tempitems[menuresult]) then
								tempcarid = j
							end
						end
						DrawWindow("" .. tempitems[menuresult], {"Spawn", "Sell ~y~(" .. boatspecs[tempcarid][3]/2 .. "$)"})
						while menuactive do
							Wait(0)
						end
						if(menuresult > 0) then
							if(menuresult == 1) then
								DeleteCar(boat)
								boat = SpawnCar(boatspecs[tempcarid][2], cx+40*math.cos((ch-90)*math.pi/180), cy+40*math.sin((ch-90)*math.pi/180), cz-1, ch-90)
								ChangeCarColour(boat, boattuning[tempcarid][1], boattuning[tempcarid][2])
								SetExtraCarColours(boat, boattuning[tempcarid][3], boattuning[tempcarid][4])
								for j=1,9,1 do
									if(boattuning[tempcarid][j+4] == 0) then
										TurnOffVehicleExtra(boat, j, true)
									else
										TurnOffVehicleExtra(boat, j, false)
									end
								end
								if(boattuning[tempcarid][21] > 0) then
									SetEngineHealth(boat, 2000.1)
									SetPetrolTankHealth(boat, 2000.1)
									SetCarHealth(boat, 2000)
								end
								TriggerEvent('chatMessage', '[Boatyard]', {0, 255, 0}, 'Vehicle spawned near the yacht.')
							elseif(menuresult == 2) then
								money = money + boatspecs[tempcarid][3]/2
								SaveStats()
								boats[tempcarid] = 0
								Saveboats()
								TriggerEvent('chatMessage', '[Boatyard]', {255, 255, 0}, 'Vehicle sold (+' .. boatspecs[tempcarid][3]/2 .. '$).')
							end
						end
					end
				end
			end
			DrawCheckpointWithDist(cx+25*math.cos((ch-90)*math.pi/180), cy+25*math.sin((ch-90)*math.pi/180), cz+5.5, 1.1, 255, 255, 0, 100)
			if(IsPlayerNearCoords(cx+25*math.cos((ch-90)*math.pi/180), cy+25*math.sin((ch-90)*math.pi/180), cz+5.5, 1.5)) then
				PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~open helipad menu", 1000, 1)
				if(IsGameKeyboardKeyJustPressed(18)) then
					local tempitems = {}
					for j=1,#helis,1 do
						if(helis[j] == 1) then
							tempitems[#tempitems+1] = "" .. helispecs[j][1]
						end
					end
					DrawWindow("Yacht_helipad", tempitems)
					while menuactive do
						Wait(0)
					end
					if(menuresult > 0) then
						local tempcarid = 0
						for j=1,#helispecs,1 do
							if(helispecs[j][1] == tempitems[menuresult]) then
								tempcarid = j
							end
						end
						DrawWindow("" .. tempitems[menuresult], {"Spawn", "Sell ~y~(" .. helispecs[tempcarid][3]/2 .. "$)"})
						while menuactive do
							Wait(0)
						end
						if(menuresult > 0) then
							if(menuresult == 1) then
								DeleteCar(heli)
								heli = SpawnCar(helispecs[tempcarid][2], cx+30*math.cos((ch-90)*math.pi/180), cy+30*math.sin((ch-90)*math.pi/180), cz+6, ch)
								ChangeCarColour(heli, helituning[tempcarid][1], helituning[tempcarid][2])
								SetExtraCarColours(heli, helituning[tempcarid][3], helituning[tempcarid][4])
								for j=1,9,1 do
									if(helituning[tempcarid][j+4] == 0) then
										TurnOffVehicleExtra(heli, j, true)
									else
										TurnOffVehicleExtra(heli, j, false)
									end
								end
								if(helituning[tempcarid][21] > 0) then
									SetEngineHealth(heli, 2000.1)
									SetPetrolTankHealth(heli, 2000.1)
									SetCarHealth(heli, 2000)
								end
								WarpCharIntoCar(GetPlayerChar(GetPlayerId()), heli)
								SetHeliBladesFullSpeed(heli)
								TriggerEvent('chatMessage', '[Helipad]', {0, 255, 0}, 'Vehicle spawned at the helipad.')
							elseif(menuresult == 2) then
								money = money + helispecs[tempcarid][3]/2
								SaveStats()
								helis[tempcarid] = 0
								SaveHelis()
								TriggerEvent('chatMessage', '[Helipad]', {255, 255, 0}, 'Vehicle sold (+' .. helispecs[tempcarid][3]/2 .. '$).')
							end
						end
					end
				end
			end
			DrawCheckpointWithDist(cx+2*math.cos((ch+90)*math.pi/180), cy+2*math.sin((ch+90)*math.pi/180), cz+10.5, 1.1, 255, 255, 0, 100)
			if(IsPlayerNearCoords(cx+2*math.cos((ch+90)*math.pi/180), cy+2*math.sin((ch+90)*math.pi/180), cz+10.5, 1.5)) then
				PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~open yacht missions menu", 1000, 1)
				if(IsGameKeyboardKeyJustPressed(18)) then
					local tempitems = {}
					tempitems[#tempitems+1] = "Treasure hunt"
					tempitems[#tempitems+1] = "Terror buster"
					DrawWindow("Yacht_missions", tempitems)
					while menuactive do
						Wait(0)
					end
					if(menuresult > 0) then
						if(tempitems[menuresult] == "Treasure hunt") then
							local amount = 0
							for j=1,#boats,1 do
								if(boats[j] == 1) then
									if(boatspecs[j][1] ~= "Yacht") then
										amount = amount + 1
									end
								end
							end
							if(amount > 0) then
								if(missionstarted == 0) then
									local coords = {
									{-2264.36743, 742.34918, -0.32501, 317.521484375},
									{-1865.72498, 1377.29663, -0.32727, 328.556457519531},
									{-1237.07031, 2186.47583, -0.39029, 259.996429443359},
									{-15.36242, 2229.479, -0.75949, 269.641326904297},
									{1116.31079, 2279.75879, -0.75554, 234.386108398438},
									{2318.02417, 1322.7417, -0.1253, 223.374694824219},
									{3086.6687, 549.16541, -0.14754, 148.200607299805},
									{2771.85889, -222.1777, -0.63242, 121.779655456543},
									{1758.33606, -846.99493, -0.51263, 114.58519744873},
									{587.03577, -1168.21179, -0.34763, 93.6542205810547},
									{-1128.90393, -1041.69421, -0.19226, 63.8529777526855},
									{-2286.82349, -936.29108, -0.52195, 8.81009101867676}
									}
									local finalcoords = {}
									local rnd = GenerateRandomIntInRange(1, #coords+1, _i)
									finalcoords[1] = coords[rnd]
									while coords[rnd]==finalcoords[1] do
										rnd = GenerateRandomIntInRange(1, #coords+1, _i)
									end
									finalcoords[2] = coords[rnd]
									while (coords[rnd]==finalcoords[1] or coords[rnd]==finalcoords[2]) do
										rnd = GenerateRandomIntInRange(1, #coords+1, _i)
									end
									finalcoords[3] = coords[rnd]
									for i=1,3,1 do
										blips[i] = AddBlipForCoord(finalcoords[i][1], finalcoords[i][2], finalcoords[i][3])
									end
									variation = GenerateRandomIntInRange(1, #finalcoords+1)
									SetObjective("Check ~y~the marked points ~w~and find ~y~treasure")
									TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
									currmission = 1
									missionstarted = 1
								else
									TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'Mission in progress!')
								end
							else
								TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'This mission requires you to own a boat!')
							end
						elseif(tempitems[menuresult] == "Terror buster") then
							local amount = 0
							for j=1,#helis,1 do
								if(helis[j] == 1) then
									amount = amount + 1
								end
							end
							if(amount > 0) then
								if(missionstarted == 0) then
									local coords = {
									{
									{-95.28062, -438.33365, 125.58408, 286.070587158203},
									{-80.58325, -431.72495, 125.58405, 237.880737304688},
									{-72.97906, -446.64847, 125.58405, 175.061981201172},
									{-75.33149, -457.38486, 125.58405, 158.104568481445},
									{-91.80392, -454.10846, 125.58405, 88.4201507568359}
									},
									{
									{-258.88074, 222.14899, 222.67656, 146.76481628418},
									{-261.77597, 206.61581, 222.73769, 140.10237121582},
									{-274.55521, 209.05617, 222.59268, 69.7085113525391},
									{-281.18341, 204.60931, 222.96284, 179.552536010742},
									{-267.66714, 228.47795, 220.7292, 285.09033203125}
									},
									{
									{171.35017, -594.65131, 261.72443, 23.9163627624512},
									{163.49371, -602.91998, 261.72443, 137.126190185547},
									{163.51945, -615.66064, 261.72443, 185.247848510742},
									{171.54813, -623.72998, 261.72443, 224.260437011719},
									{178.08119, -616.8678, 261.72443, 339.443725585938}
									},
									{
									{254.67303, -360.84644, 161.99583, 198.533538818359},
									{267.70474, -361.06213, 161.99583, 269.107666015625},
									{275.24875, -359.62131, 160.08382, 146.781311035156},
									{257.23132, -369.93872, 160.08382, 101.702033996582},
									{247.94035, -358.61282, 160.08383, 45.5917091369629}
									},
									{
									{-11.92666, 862.20422, 44.612, 187.909225463867},
									{-18.75857, 857.20209, 44.612, 134.203842163086},
									{-19.48068, 869.89478, 44.61201, 13.1552925109863},
									{-11.00945, 875.84827, 44.61201, 313.364990234375},
									{-12.14763, 881.38989, 44.61198, 14.9516181945801}
									},
									{
									{-517.85211, 896.36371, 65.36012, 337.052032470703},
									{-527.35059, 904.92645, 65.35994, 42.1257171630859},
									{-536.49835, 902.19629, 65.36001, 112.509925842285},
									{-535.68579, 890.73718, 65.35999, 182.879455566406},
									{-529.55634, 878.08997, 65.36002, 201.123138427734}
									},
									{
									{-407.7641, 729.58612, 89.63828, 333.440002441406},
									{-400.37238, 729.93219, 89.63828, 266.186859130859},
									{-398.17441, 722.04694, 89.63828, 243.738311767578},
									{-398.68903, 716.55536, 89.63828, 164.416473388672},
									{-405.83447, 717.12775, 89.63825, 91.0880355834961}
									},
									{
									{72.19701, 491.0322, 108.31844, 351.677062988281},
									{83.19681, 487.84235, 108.31702, 278.322875976563},
									{86.17172, 477.30374, 108.32026, 193.040557861328},
									{76.70102, 471.03778, 108.32457, 123.813041687012},
									{63.49338, 475.38522, 108.30741, 79.681526184082}
									},
									{
									{95.6695, 175.20772, 65.26571, 33.1059265136719},
									{87.04426, 171.0278, 65.26565, 123.722244262695},
									{87.23203, 186.35297, 63.35538, 261.099853515625},
									{96.37072, 188.29193, 63.35538, 287.682434082031},
									{98.17255, 182.20166, 63.35542, 223.554809570313}
									}
									}
									local rnd = GenerateRandomIntInRange(1, #coords+1)
									for i=1,5,1 do
										peds[i] = SpawnPed(GetHashKey("M_M_GUNNUT_01"), coords[rnd][i][1], coords[rnd][i][2], coords[rnd][i][3], coords[rnd][i][4])
										GiveWeaponToChar(peds[i], 14, 1000, 1)
										blips[i] = AddBlipForChar(peds[i])
									end
									SetObjective("Kill all ~y~terrorists")
									TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
									currmission = 2
									missionstarted = 1
								else
									TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'Mission in progress!')
								end
							else
								TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'This mission requires you to own a helicopter!')
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
		if(currmission > 0) then
			if(currmission == 1) then
				if(currstage == 0) then
					for i=1,3,1 do
						if(DoesBlipExist(blips[i])) then
							local bp = GetBlipCoords(blips[i])
							DrawCheckpointWithDist(bp.x, bp.y, bp.z, 3.1, 255, 255, 0, 100)
							if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 5)) then
								if(i == variation) then
									PrintStringWithLiteralStringNow("STRING", "~g~Treasure found!", 5000, 1)
									for j=1,3,1 do
										RemoveBlip(blips[j])
									end
									local cx,cy,cz = GetCarCoordinates(yacht)
									local ch = GetCarHeading(yacht)
									blips[1] = AddBlipForCoord(cx+40*math.cos((ch-90)*math.pi/180), cy+40*math.sin((ch-90)*math.pi/180), cz-2)
									SetObjective("Deliver ~y~the treasure ~w~to ~y~the yacht")
									currstage = 1
									break
								else
									PrintStringWithLiteralStringNow("STRING", "~r~There is no treasure", 5000, 1)
									RemoveBlip(blips[i])
									break
								end
							end
						end
					end
				elseif(currstage == 1) then
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithDist(bp.x, bp.y, bp.z, 3.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 5)) then
						local finalreward = SeparateReward(20000, 1000)
						money = money + finalreward[1]
						experience = experience + finalreward[2]
						SaveStats()
						DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
						EndMission()
					end
				end
			elseif(currmission == 2) then
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
						local px,py,pz = GetCharCoordinates(peds[1])
						local pz = GetGroundZFor3dCoord(px, py, pz)
						objs[1] = SpawnObject(GetHashKey("cj_case_2"), px, py, pz, 0.0)
						blips[1] = AddBlipForObject(objs[1])
						FreezeObjectPosition(objs[1], true)
						SetObjective("Collect ~y~the briefcase")
						currstage = 1
					end
				elseif(currstage == 1) then
					local ox,oy,oz = GetObjectCoordinates(objs[1], _f, _f, _f)
					if(IsPlayerNearCoords(ox, oy, oz, 2)) then
						DeleteObject(objs[1])
						RemoveBlip(blips[1])
						local cx,cy,cz = GetCarCoordinates(yacht)
						local ch = GetCarHeading(yacht)
						blips[1] = AddBlipForCoord(cx+30*math.cos((ch-90)*math.pi/180), cy+30*math.sin((ch-90)*math.pi/180), cz+5.5)
						SetObjective("Deliver ~y~this briefcase ~w~to ~y~the yacht")
						currstage = 2
					end
				elseif(currstage == 2) then
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithAlpha(bp.x, bp.y, bp.z, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 5)) then
						local finalreward = SeparateReward(10000, 500)
						money = money + finalreward[1]
						experience = experience + finalreward[2]
						SaveStats()
						DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
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