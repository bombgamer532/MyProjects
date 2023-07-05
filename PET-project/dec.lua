local currmission = 0
local currstage = 0
local EndMission = function()
	currmission = 0
	currstage = 0
	CleanMission()
end

ProceedToRobbery6 = function()
	local tempitems = {}
	tempitems[#tempitems+1] = "Start robbery"
	if(preps[6][1] == 0) then
		tempitems[#tempitems+1] = "Weak points"
	else
		tempitems[#tempitems+1] = "Weak points ~g~(Done)"
	end
	if(preps[6][2] == 0) then
		tempitems[#tempitems+1] = "Explosives"
	else
		tempitems[#tempitems+1] = "Explosives ~g~(Done)"
	end
	if(preps[6][3] == 0) then
		tempitems[#tempitems+1] = "Removing reinforcement (optional)"
	else
		tempitems[#tempitems+1] = "Removing reinforcement ~g~(Done)"
	end
	DrawWindow("Deconstruction", tempitems)
	while menuactive do
		Wait(0)
		if(currbutton == 1) then
			DrawDescription("Robbery", {
			-----------------------------------------------------------------------------------------------
			"Eliminate all mobsters on the construction site, plant bombs and explode the site.",
			" ",
			"* Reinforcement will come after the explosion if you won't remove it."
			})
		elseif(currbutton == 2) then
			DrawDescription("Weak points", {
			-----------------------------------------------------------------------------------------------
			"Steal blueprints from the restricted area to get information about weak points of the",
			"construction."
			})
		elseif(currbutton == 3) then
			DrawDescription("Explosives", {
			-----------------------------------------------------------------------------------------------
			"Steal 3 bombs out of 3 vans around the city which will be used during the heist."
			})
		elseif(currbutton == 4) then
			DrawDescription("Removing reinforcement", {
			-----------------------------------------------------------------------------------------------
			"Destroy 3 gang vans to remove ability for reinforcement to come."
			})
		end
	end
	if(menuresult > 0) then
		if(tempitems[menuresult] == "Start robbery") then
			if(preps[6][1]==1 and preps[6][2]==1) then
				local coords = {
				{34.06042, -859.58398, 4.814, 257.684814453125},
				{37.17902, -852.26794, 4.814, 304.609527587891},
				{28.27521, -855.60468, 4.81401, 49.4900131225586},
				{28.22337, -868.87366, 4.814, 177.534057617188},
				{22.17626, -864.09698, 4.814, 24.9218406677246},
				{30.5108, -918.46375, 4.73423, 329.059753417969},
				{22.32272, -917.02563, 4.9868, 58.2530632019043},
				{17.01734, -927.05396, 4.73617, 164.891876220703},
				{26.42246, -931.8587, 4.73166, 245.464294433594},
				{36.75984, -928.9386, 4.73423, 289.992065429688},
				{66.12793, -915.83368, 14.1366, 242.897155761719},
				{67.22126, -909.98334, 14.1366, 356.921081542969},
				{60.21806, -904.1687, 14.1366, 41.580394744873},
				{53.46563, -911.27844, 14.13659, 141.429992675781},
				{55.76568, -920.26984, 14.13659, 186.647521972656},
				{103.03545, -963.50513, 14.73743, 319.529968261719},
				{106.96849, -969.55713, 14.73743, 237.051818847656},
				{101.09076, -978.01691, 14.73743, 144.678909301758},
				{91.27393, -972.9444, 14.73743, 72.7702255249023},
				{85.33853, -979.6922, 14.73743, 138.427459716797}
				}
				for i=1,20,1 do
					peds[i] = SpawnPed(GetHashKey("M_Y_GMAF_LO_01"), coords[i][1], coords[i][2], coords[i][3], coords[i][4])
					GiveWeaponToChar(peds[i], 14, 1000, 1)
					blips[i] = AddBlipForChar(peds[i])
				end
				SetObjective("Kill ~y~all mobsters")
				TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
				currmission = 4
				missionstarted = 1
			else
				TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'You have to complete all necessary preparation missions first!')
			end
		elseif(menuresult == 2) then
			if(preps[6][1] == 0) then
				local coords = {
				{-161.15054, 1554.29736, 18.43323, 208.081115722656},
				{-168.27971, 1555.00513, 18.35846, 97.0014495849609},
				{-150.11389, 1551.48254, 18.43442, 182.076538085938},
				{-147.20801, 1555.69873, 18.39666, 99.8852920532227},
				{-154.20341, 1559.14966, 18.35433, 261.025573730469},
				{-136.18643, 1562.63806, 18.60906, 294.807189941406},
				{-177.56331, 1553.97131, 18.22162, 148.4052734375},
				{-175.90178, 1547.80811, 18.34767, 180.404159545898},
				{-185.76404, 1554.54236, 18.3077, 68.3658981323242},
				{-188.78012, 1560.00464, 18.31637, 30.5819854736328}
				}
				for i=1,10,1 do
					peds[i] = SpawnPed(GetHashKey("M_Y_GTRI_LO_02"), coords[i][1], coords[i][2], coords[i][3], coords[i][4])
					GiveWeaponToChar(peds[i], 12, 1000, 1)
				end
				objs[1] = SpawnObject(2736900820, -162.1284, 1556.39868, 18.33707-1, 184.597518920898)
				blips[1] = AddBlipForObject(objs[1])
				SetRoute(blips[1], true)
				SetObjective("Reach ~y~the point ~w~and steal ~y~blueprints")
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'Preparation mission started!')
				currmission = 1
				missionstarted = 1
			else
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'This mission is already completed.')
			end
		elseif(menuresult == 3) then
			if(preps[6][2] == 0) then
				for i=1,3,1 do
					local rx,ry,rz,rh = GetRandomNodeInRadius(GenerateRandomIntInRange(100, 1000))
					vehs[i] = SpawnCar(GetHashKey("SPEEDO"), rx, ry, rz, rh)
					peds[i] = SpawnPed(GetHashKey("M_Y_GMAF_LO_02"), rx, ry, rz, rh)
					GiveWeaponToChar(peds[i], 9, 1000, 1)
					WarpCharIntoCar(peds[i], vehs[i])
					TaskCarMission(peds[i], vehs[i], vehs[i], 1, 10.1, 0, 0, 10)
					blips[i] = AddBlipForCar(vehs[i])
				end
				SetObjective("Steal ~y~all explosives ~w~from ~y~the marked vans ~w~(~y~0/3~w~)")
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'Preparation mission started!')
				currmission = 2
				missionstarted = 1
			else
				TriggerEvent('chatMessage', '[Preparation]', {255, 255, 0}, 'This mission is already completed.')
			end
		elseif(menuresult == 4) then
			if(preps[6][3] == 0) then
				local coords = {
				{662.04498, 1003.75049, 2.93215, 85.2341918945313},
				{662.68921, 993.55518, 2.93215, 86.6323013305664},
				{647.4411, 988.77161, 2.93215, 356.534240722656}
				}
				for i=1,3,1 do
					vehs[i] = SpawnCar(GetHashKey("BURRITO2"), coords[i][1], coords[i][2], coords[i][3], coords[i][4])
					blips[i] = AddBlipForCar(vehs[i])
				end
				local coords = {
				{643.43622, 998.45483, 2.93215, 92.7380065917969},
				{652.62164, 1008.03186, 2.93215, 350.086700439453},
				{657.12189, 1005.48431, 2.93215, 106.99259185791},
				{650.52734, 997.68933, 2.93215, 124.617546081543},
				{656.98596, 993.84045, 2.93215, 44.2695426940918}
				}
				for i=1,5,1 do
					peds[i] = SpawnPed(GetHashKey("M_Y_GMAF_LO_02"), coords[i][1], coords[i][2], coords[i][3], coords[i][4])
					GiveWeaponToChar(peds[i], 14, 1000, 1)
				end
				SetObjective("Destroy ~y~the marked vans")
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
					for i=1,10,1 do
						if(not IsCharDead(peds[i])) then
							if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
								for j=1,10,1 do
									AttackPlayer(peds[j])
								end
							end
						end
					end
					local ox,oy,oz = GetObjectCoordinates(objs[1])
					if(IsPlayerNearCoords(ox, oy, oz, 1)) then
						RemoveBlip(blips[1])
						DeleteObject(objs[1])
						blips[1] = AddBlipForCoord(-417.32382, -73.82101, 10.76585)
						SetRoute(blips[1], true)
						SetObjective("Deliver ~y~the blueprints ~w~to ~y~the base")
						currstage = 1
					end
				elseif(currstage == 1) then
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
						DrawMessage("~y~Preparation mission completed", "You have got the information about weak points of the construction.")
						preps[6][1] = 1
						SavePreps()
						EndMission()
					end
				end
			elseif(currmission == 2) then
				if(currstage == 0) then
					local carscollected = 0
					for i=1,3,1 do
						if(not IsCarDead(vehs[i])) then
							if(DoesBlipExist(blips[i])) then
								if(IsCharInCar(GetPlayerChar(GetPlayerId()), vehs[i])) then
									RemoveBlip(blips[i])
									PrintStringWithLiteralStringNow("STRING", "~g~Explosive collected", 5000, 1)
								end
							else
								carscollected = carscollected + 1
							end
						else
							DrawMessage("~r~Mission failed", "Van with explosive destroyed.")
							EndMission()
							break
						end
					end
					SetObjective("Steal ~y~all explosives ~w~from ~y~the marked vans ~w~(~y~" .. carscollected .. "/3~w~)")
					if(carscollected == 3) then
						SetObjective("Lose ~y~wanted level")
						currstage = 1
					end
				elseif(currstage == 1) then
					if(StoreWantedLevel(GetPlayerId()) == 0) then
						blips[1] = AddBlipForCoord(-417.32382, -73.82101, 10.76585)
						SetRoute(blips[1], true)
						SetObjective("Deliver ~y~the explosives ~w~to ~y~the base")
						currstage = 2
					end
				elseif(currstage == 2) then
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
						DrawMessage("~y~Preparation mission completed", "Explosives have been successfully acquired.")
						preps[6][2] = 1
						SavePreps()
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
					local vansdestroyed = 0
					for i=1,3,1 do
						if(IsCarDead(vehs[i])) then
							RemoveBlip(blips[i])
							vansdestroyed = vansdestroyed + 1
						end
					end
					if(vansdestroyed == 3) then
						SetObjective("Lose ~y~wanted level")
						currstage = 1
					end
				elseif(currstage == 1) then
					if(StoreWantedLevel(GetPlayerId()) == 0) then
						DrawMessage("~y~Preparation mission completed", "Reinforcement has been destroyed.")
						preps[6][3] = 1
						SavePreps()
						EndMission()
					end
				end
			elseif(currmission == 4) then
				if(currstage == 0) then
					local mobskilled = 0
					for i=1,20,1 do
						if(not IsCharDead(peds[i])) then
							if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
								for j=1,20,1 do
									AttackPlayer(peds[j])
								end
							end
						else
							RemoveBlip(blips[i])
							mobskilled = mobskilled + 1
						end
					end
					if(mobskilled == 20) then
						local coords = {
						{19.32262, -874.19415, 4.814, 336.674987792969},
						{63.94903, -904.82617, 4.73446, 264.09375},
						{21.10339, -930.97919, 4.72284, 294.036499023438}
						}
						for i=1,3,1 do
							blips[i] = AddBlipForCoord(coords[i][1], coords[i][2], coords[i][3])
						end
						SetObjective("Plant ~y~bombs ~w~at ~y~marked points ~w~(~y~0/3~w~)")
						currstage = 1
					end
				elseif(currstage == 1) then
					local bombsplanted = 0
					for i=1,3,1 do
						if(DoesBlipExist(blips[i])) then
							local bp = GetBlipCoords(blips[i])
							DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
							if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
								RemoveBlip(blips[i])
								objs[i] = SpawnObject(GetHashKey("ec_bomb_ne"), bp.x, bp.y, bp.z-1, 0.0)
							end
						else
							bombsplanted = bombsplanted + 1
						end
					end
					SetObjective("Plant ~y~bombs ~w~at ~y~marked points ~w~(~y~" .. bombsplanted .. "/3~w~)")
					if(bombsplanted == 3) then
						SetObjective("Get back on ~y~a safe distance")
						currstage = 2
					end
				elseif(currstage == 2) then
					if(not IsPlayerNearCoords(34.45421, -893.44818, 4.98552, 100)) then
						--[[for i=1,3,1 do
							local ox,oy,oz = GetObjectCoordinates(objs[i])
							DeleteObject(objs[i])
							AddExplosion(ox, oy, oz, 0, 5.1, true, false, 1.1)
						end]]
						if(preps[6][3] == 0) then
							for i=1,20,1 do
								DeleteChar(peds[i])
							end
							local coords = {
							{-26.2188, -800.13599, 5.19012, 272.076080322266},
							{54.15704, -653.61218, 13.78873, 177.432357788086},
							{128.57201, -766.58716, 4.7164, 117.26643371582}
							}
							for i=1,3,1 do
								vehs[i] = SpawnCar(GetHashKey("BURRITO2"), coords[i][1], coords[i][2], coords[i][3], coords[i][4])
								for j=1,4,1 do
									peds[4*(i-1)+j] = SpawnPed(GetHashKey("M_Y_GMAF_LO_01"), coords[i][1], coords[i][2], coords[i][3], coords[i][4])
									if(j == 1) then
										WarpCharIntoCar(peds[4*(i-1)+j], vehs[i])
									else
										WarpCharIntoCarAsPassenger(peds[4*(i-1)+j], vehs[i], j-2)
									end
									GiveWeaponToChar(peds[4*(i-1)+j], 13, 1000, 1)
									blips[4*(i-1)+j] = AddBlipForChar(peds[4*(i-1)+j])
								end
							end
							SetObjective("Get rid of ~y~reinforcement")
							currstage = 3
						else
							SetObjective("Lose ~y~wanted level")
							currstage = 4
						end
					end
				elseif(currstage == 3) then
					local mobskilled = 0
					for i=1,12,1 do
						if(not IsCharDead(peds[i])) then
							AttackPlayer(peds[i])
						else
							RemoveBlip(blips[i])
							mobskilled = mobskilled + 1
						end
					end
					if(mobskilled == 12) then
						SetObjective("Lose ~y~wanted level")
						currstage = 4
					end
				elseif(currstage == 4) then
					if(StoreWantedLevel(GetPlayerId()) == 0) then
						local finalreward = SeparateReward(60000, 1500)
						money = money + finalreward[1]
						experience = experience + finalreward[2]
						SaveStats()
						DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
						heistsCompleted = heistsCompleted + 1
						SaveDailyStats()
						for i=1,3,1 do
							preps[6][i] = 0
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