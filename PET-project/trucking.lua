truckinfo = {
{"Benson", 2053223216, 40000, 10},
{"Biff", 850991848, 40000, 10},
{"Flatbed", 1353720154, 40000, 10},
{"Mule", 904750859, 25000, 5},
{"Packer", 569305213, 45000, 12},
{"Phantom", 2157618379, 50000, 15},
{"Steed", 1677715180, 22000, 5},
{"Yankee", 3195007082, 30000, 8}
}

local currmission = 0
local currstage = 0
local EndMission = function()
	currmission = 0
	currstage = 0
	CleanMission()
end

trucks = {}
for i=1,#truckinfo,1 do
	trucks[i] = 0
end

RegisterNetEvent('updTrucks')
AddEventHandler('updTrucks', function(data)
	for i=1,#data,1 do
		trucks[i] = tonumber(data[i])
	end
end)

SaveTrucks = function()
	local data = {}
	for i=1,#trucks,1 do
		data[i] = trucks[i]
	end
	TriggerServerEvent('saveTrucks', data)
end

local truckcoords = {
{-1346.93066, -250.74843, 2.92882, 180.054809570313},
{-1490.49744, 1096.14746, 23.33706, 0.880167663097382},
{-473.92484, 1746.47925, 8.70503, 299.694519042969},
{-490.47205, 366.18347, 6.96213, 196.275619506836},
{148.87033, -865.37616, 4.72054, 219.74739074707},
{748.20831, -275.56921, 5.82379, 62.5041847229004},
{2017.23779, 611.00507, 18.01789, 357.092834472656},
{1266.1936, 1484.69885, 16.77278, 266.791534423828}
}

local car = nil
CreateThread(function()
	while true do
		Wait(0)
		if(not DoesBlipExist(truckingblip)) then
			truckingblip = AddBlipForCoord(-933.73364, 313.80618, 4.47026, _i)
			ChangeBlipSprite(truckingblip, 58)
			ChangeBlipColour(truckingblip, 19)
			ChangeBlipScale(truckingblip, 0.7)
			ChangeBlipNameFromAscii(truckingblip, "Trucking")
			SetBlipAsShortRange(truckingblip, true)
		end
		if(missionstarted == 0) then
			DrawTextAtCoord(-933.73364, 313.80618, 4.47026, "Trucking", 20)
			DrawCheckpointWithDist(-933.73364, 313.80618, 4.47026-1, 1.1, 255, 255, 0, 100)
			if(IsPlayerNearCoords(-933.73364, 313.80618, 4.47026, 1)) then
				if(biz[15]==1 or biz[16]==1 or biz[17]==1) then
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~open trucking menu", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						::main::
						local tempitems = {}
						tempitems[#tempitems+1] = "Truck shop"
						tempitems[#tempitems+1] = "Start trucking"
						DrawWindow("Trucking_menu", tempitems)
						while menuactive do
							Wait(0)
						end
						if(menuresult > 0) then
							if(tempitems[menuresult] == "Truck shop") then
								::trucks::
								local tempitems = {}
								for i=1,#truckinfo,1 do
									tempitems[#tempitems+1] = "" .. truckinfo[i][1] .. " - ~y~" .. truckinfo[i][4] .. " cargo ~g~(" .. truckinfo[i][3] .. "$)"
								end
								DrawWindow("Select_truck_to_preview", tempitems)
								while menuactive do
									Wait(0)
								end
								if(menuresult > 0) then
									DeleteCar(carinshowroom)
									carinshowroom = SpawnCar(truckinfo[menuresult][2], -933.73364, 313.80618, 4.47026, 179.663314819336)
									WarpCharIntoCar(GetPlayerChar(GetPlayerId()), carinshowroom)
									SetPlayerControl(GetPlayerId(), false)
									SetCharVisible(GetPlayerChar(GetPlayerId()), false)
									tempcar = menuresult
									::carmenu::
									DrawWindow("" .. truckinfo[tempcar][1], {"Purchase ~g~(" .. truckinfo[tempcar][3] .. "$)"})
									while menuactive do
										Wait(0)
										SetPlayerControl(GetPlayerId(), false)
										if(IsMouseButtonPressed(1)) then
											SetCamActive(GetGameCam(), true)
										else
											SetCamActive(GetGameCam(), false)
										end
									end
									if(menuresult > 0) then
										if(menuresult == 1) then
											if(trucks[tempcar] == 0) then
												if(money >= truckinfo[tempcar][3]) then
													money = money - truckinfo[tempcar][3]
													SaveStats()
													--SetPlayerControl(GetPlayerId(), true)
													--SetCharVisible(GetPlayerChar(GetPlayerId()), true)
													--DetachCar(carinshowroom)
													trucks[tempcar] = 1
													SaveTrucks()
													TriggerEvent('chatMessage', '[Truck shop]', {0, 255, 0}, 'You have bought this truck! You can use it during trucking.')
												else
													TriggerEvent('chatMessage', '[Truck shop]', {255, 0, 0}, 'You do not have enough money!')
												end
											else
												TriggerEvent('chatMessage', '[Truck shop]', {255, 255, 0}, 'You already have this truck.')
											end
										end
										goto carmenu
									else
										goto trucks
									end
								else
									DetachCar(carinshowroom)
									DeleteCar(carinshowroom)
									SetPlayerControl(GetPlayerId(), true)
									SetCharVisible(GetPlayerChar(GetPlayerId()), true)
								end
							elseif(tempitems[menuresult] == "Start trucking") then
								local tempamount = 0
								for i=1,#trucks,1 do
									if(trucks[i] == 1) then
										tempamount = tempamount + 1
									end
								end
								if(tempamount > 0) then
									local tempitems = {}
									for j=1,#trucks,1 do
										if(trucks[j] == 1) then
											tempitems[#tempitems+1] = "" .. truckinfo[j][1]
										end
									end
									DrawWindow("Select_truck_for_mission", tempitems)
									while menuactive do
										Wait(0)
									end
									if(menuresult > 0) then
										local tempcarid = 0
										for j=1,#truckinfo,1 do
											if(truckinfo[j][1] == tempitems[menuresult]) then
												tempcarid = j
											end
										end
										DrawWindow("" .. tempitems[menuresult], {"Spawn", "Sell ~y~(" .. truckinfo[tempcarid][3]/2 .. "$)"})
										while menuactive do
											Wait(0)
										end
										if(menuresult > 0) then
											if(menuresult == 1) then
												DeleteCar(car)
												car = SpawnCar(truckinfo[tempcarid][2], -933.73364, 313.80618, 4.47026, 179.663314819336)
												variation = GenerateRandomIntInRange(1, #truckcoords+1)
												truckcargo = 0
												SetObjective("Drive to ~y~the storage ~w~and buy ~y~cargo")
												TriggerEvent('chatMessage', '[Trucking]', {255, 255, 0}, 'Trucking started!')
												currmission = 1
												missionstarted = 1
											elseif(menuresult == 2) then
												money = money + truckinfo[tempcarid][3]/2
												SaveStats()
												trucks[tempcarid] = 0
												SaveTrucks()
												TriggerEvent('chatMessage', '[Apartment]', {255, 255, 0}, 'Vehicle sold (+' .. truckinfo[tempcarid][3]/2 .. '$).')
											end
										end
									end
								else
									TriggerEvent('chatMessage', '[Trucking]', {255, 0, 0}, 'You must own at least one truck to start trucking!')
								end
							end
						end
					end
				else
					PrintStringWithLiteralStringNow("STRING", "~r~You must own at least one gas station business to use it", 1000, 1)
				end
			end
		end
	end
end)

local dist = 0
CreateThread(function()
	while true do
		Wait(0)
		if(currmission > 0) then
			if(currmission == 1) then
				if(currstage == 0) then
					if(not DoesBlipExist(blips[1])) then
						blips[1] = AddBlipForCoord(truckcoords[variation][1], truckcoords[variation][2], truckcoords[variation][3], _i)
						SetRoute(blips[1], true)
					end
					if(IsCarDead(car)) then
						RemoveBlip(blips[1])
						DrawMessage("~r~Mission failed", "Truck destroyed.")
						SetObjective("")
						Wait(5000)
						DeleteCar(car)
						currstage = 0
						currmission = 0
						missionstarted = 0
					end
					DrawCheckpointWithAlpha(truckcoords[variation][1], truckcoords[variation][2], truckcoords[variation][3]-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(truckcoords[variation][1], truckcoords[variation][2], truckcoords[variation][3], 3)) then
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), car)) then
							if(GetDriverOfCar(car) == GetPlayerChar(GetPlayerId())) then
								PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~open storage menu", 1000, 1)
								if(IsGameKeyboardKeyJustPressed(18)) then
									::cargo::
									local tempitems = {}
									tempitems[#tempitems+1] = "Buy 1 cargo for ~g~1000$"
									tempitems[#tempitems+1] = "Finish deal"
									DrawWindow("Storage_menu", tempitems)
									while menuactive do
										Wait(0)
									end
									if(menuresult > 0) then
										if(tempitems[menuresult] == "Buy 1 cargo for ~g~1000$") then
											local maxcargo = 0
											for i=1,#trucks,1 do
												if(trucks[i] == 1) then
													maxcargo = maxcargo + truckinfo[i][4]
												end
											end
											if(truckcargo < maxcargo) then
												if(money >= 1000) then
													money = money - 1000
													SaveStats()
													truckcargo = truckcargo + 1
													TriggerEvent('chatMessage', '[Cargo]', {0, 255, 0}, 'Cargo bought! You currently have ' .. truckcargo .. ' cargo.')
												else
													TriggerEvent('chatMessage', '[Cargo]', {255, 0, 0}, 'You do not have enough money!')
												end
											else
												TriggerEvent('chatMessage', '[Cargo]', {255, 0, 0}, 'Maximum amount reached!')
											end
											goto cargo
										elseif(tempitems[menuresult] == "Finish deal") then
											if(truckcargo > 0) then
												RemoveBlip(blips[1])
												local tempvar = variation
												while variation==tempvar do
													variation = GenerateRandomIntInRange(1, #truckcoords+1)
												end
												local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
												dist = GetDistanceBetweenCoords3d(px, py, pz, truckcoords[variation][1], truckcoords[variation][2], truckcoords[variation][3])
												SetObjective("Deliver ~y~cargo ~w~to ~y~the marked points")
												currstage = 1
											else
												RemoveBlip(blips[1])
												DrawMessage("~r~Mission aborted", "No cargo to deliver.")
												SetObjective("")
												Wait(5000)
												DeleteCar(car)
												currstage = 0
												currmission = 0
												missionstarted = 0
											end
										end
									end
								end
							else
								PrintStringWithLiteralStringNow("STRING", "You must be in the driver seat!", 1000, 1)
							end
						else
							PrintStringWithLiteralStringNow("STRING", "You must be in your truck!", 1000, 1)
						end
					end
				elseif(currstage == 1) then
					if(not DoesBlipExist(blips[1])) then
						blips[1] = AddBlipForCoord(truckcoords[variation][1], truckcoords[variation][2], truckcoords[variation][3], _i)
						SetRoute(blips[1], true)
					end
					if(IsCarDead(car)) then
						RemoveBlip(blips[1])
						DrawMessage("~r~Mission failed", "Truck destroyed.")
						SetObjective("")
						Wait(5000)
						DeleteCar(car)
						currstage = 0
						currmission = 0
						missionstarted = 0
					end
					DrawCheckpointWithAlpha(truckcoords[variation][1], truckcoords[variation][2], truckcoords[variation][3]-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(truckcoords[variation][1], truckcoords[variation][2], truckcoords[variation][3], 3)) then
						if(IsCharInCar(GetPlayerChar(GetPlayerId()), car)) then
							if(GetDriverOfCar(car) == GetPlayerChar(GetPlayerId())) then
								PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~sell your cargo ~w~(maximum 10 at a time)", 1000, 1)
								if(IsGameKeyboardKeyJustPressed(18)) then
									if(truckcargo <= 10) then
										money = money + 1500*truckcargo + math.floor(dist/10)
										experience = experience + 50*truckcargo
										SaveStats()
										TriggerEvent('chatMessage', '[Cargo]', {0, 255, 0}, 'Cargo sold (+' .. 1500*truckcargo .. '$ + ' .. math.floor(dist/10) .. '$ / +' .. 50*truckcargo .. ' EXP)')
										RemoveBlip(blips[1])
										DeleteCar(car)
										DrawMessage("~y~Mission completed", "All cargo sold. Trucking finished.")
										EndMission()
									else
										money = money + 1500*10 + math.floor(dist/10)
										experience = experience + 50*10
										SaveStats()
										TriggerEvent('chatMessage', '[Cargo]', {0, 255, 0}, 'Cargo sold (+' .. 1500*10 .. '$ + ' .. math.floor(dist/10) .. '$ / +' .. 50*10 .. ' EXP)! Cargo left: ' .. truckcargo-10)
										truckcargo = truckcargo - 10
										RemoveBlip(blips[1])
										local tempvar = variation
										while variation==tempvar do
											variation = GenerateRandomIntInRange(1, #truckcoords+1)
										end
										local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
										dist = GetDistanceBetweenCoords3d(px, py, pz, truckcoords[variation][1], truckcoords[variation][2], truckcoords[variation][3])
									end
								end
							else
								PrintStringWithLiteralStringNow("STRING", "You must be in the driver seat!", 1000, 1)
							end
						else
							PrintStringWithLiteralStringNow("STRING", "You must be in your truck!", 1000, 1)
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