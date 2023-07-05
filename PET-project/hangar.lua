planespecs = {
--name, modelname, price
{"Cessna", 0xB2499163, 100000},
{"Cub", 0x0B040C5E, 150000},
{"Gripen", 0x7C5561CB, 500000}
}
planes = {}
for i=1,#planespecs,1 do
	planes[i] = 0
end

RegisterNetEvent('updPlanes')
AddEventHandler('updPlanes', function(data)
	for i=1,#data,1 do
		planes[i] = tonumber(data[i])
	end
end)

SavePlanes = function()
	local data = {}
	for i=1,#planes,1 do
		data[i] = planes[i]
	end
	TriggerServerEvent('savePlanes', data)
end

hangarinfo = {
{80000, {2212.42871, 800.8634, 5.81304, 229.59538269043, 0}, {2231.68652, 783.82275, 5.81304, 316.550170898438, 0}, 2},
{80000, {2339.04858, 92.48417, 5.81423, 178.600509643555, 0}, {2337.34839, 65.72708, 5.81423, 268.949005126953, 0}, 2}
}
local hangarblip = {}
hangars = {}
for i=1,#hangarinfo,1 do
	hangars[i] = 0
end

RegisterNetEvent('updHangars')
AddEventHandler('updHangars', function(data)
	for i=1,#hangarinfo,1 do
		if(data[i] == nil) then
			data[i] = 0
		end
		hangars[i] = tonumber(data[i])
	end
end)

SaveHangars = function()
	local data = {}
	for i=1,#hangars,1 do
		data[i] = hangars[i]
	end
	TriggerServerEvent('saveHangars', data)
end

CreateThread(function()
	while true do
		Wait(0)
		for i=1,#hangarinfo,1 do
			if(not DoesBlipExist(hangarblip[i])) then
				hangarblip[i] = AddBlipForCoord(hangarinfo[i][2][1], hangarinfo[i][2][2], hangarinfo[i][2][3], _i)
				ChangeBlipSprite(hangarblip[i], 56)
				ChangeBlipScale(hangarblip[i], 0.7)
				ChangeBlipNameFromAscii(hangarblip[i], "Hangar #" .. i)
				SetBlipAsShortRange(hangarblip[i], true)
			end
			if(hangars[i] == 0) then
				DrawTextAtCoord(hangarinfo[i][2][1], hangarinfo[i][2][2], hangarinfo[i][2][3], "Hangar_#" .. i .. " Price:_" .. hangarinfo[i][1] .. "$ Garage_places:_" .. hangarinfo[i][4], 20)
				ChangeBlipColour(hangarblip[i], 0)
			else
				DrawTextAtCoord(hangarinfo[i][2][1], hangarinfo[i][2][2], hangarinfo[i][2][3], "Hangar_#" .. i .. " Owned Garage_places:_" .. hangarinfo[i][4], 20)
				ChangeBlipColour(hangarblip[i], 2)
			end
			DrawCheckpointWithDist(hangarinfo[i][2][1], hangarinfo[i][2][2], hangarinfo[i][2][3]-1, 1.1, 255, 255, 0, 100)
			if(IsPlayerNearCoords(hangarinfo[i][2][1], hangarinfo[i][2][2], hangarinfo[i][2][3], 1)) then
				if(hangars[i] == 0) then
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to purchase ~y~this hangar ~w~for ~g~" .. hangarinfo[i][1] .. "$", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						local hashouse = 0
						for j=1,#houses,1 do
							if(houses[j] == 1) then
								hashouse = 1
							end
						end
						local hashelipad = 0
						for j=1,#helipads,1 do
							if(helipads[j] == 1) then
								hashelipad = 1
							end
						end
						if(hashouse == 1) then
							if(hashelipad == 1) then
								if(money >= hangarinfo[i][1]) then
									money = money - hangarinfo[i][1]
									SaveStats()
									hangars[i] = 1
									SaveHangars()
									TriggerEvent('chatMessage', '[Hangar]', {0, 255, 0}, 'This hangar has been successfully purchased!')
								else
									TriggerEvent('chatMessage', '[Hangar]', {255, 0, 0}, 'You cannot afford it!')
								end
							else
								TriggerEvent('chatMessage', '[Hangar]', {255, 0, 0}, 'You must own a helipad to purchase it!')
							end
						else
							TriggerEvent('chatMessage', '[Hangar]', {255, 0, 0}, 'You must own an apartment to purchase it!')
						end
					end
				else
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~open hangar menu", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						local tempitems = {}
						tempitems[#tempitems+1] = "Open planes list"
						tempitems[#tempitems+1] = "Purchase planes"
						DrawWindow("Hangar_#" .. i, tempitems)
						while menuactive do
							Wait(0)
						end
						if(menuresult > 0) then
							if(tempitems[menuresult] == "Open planes list") then
								local tempitems = {}
								for j=1,#planes,1 do
									if(planes[j] == 1) then
										tempitems[#tempitems+1] = "" .. planespecs[j][1]
									end
								end
								DrawWindow("Garage_menu", tempitems)
								while menuactive do
									Wait(0)
								end
								if(menuresult > 0) then
									local tempcarid = 0
									for j=1,#planespecs,1 do
										if(planespecs[j][1] == tempitems[menuresult]) then
											tempcarid = j
										end
									end
									DrawWindow("" .. tempitems[menuresult], {"Spawn", "Sell ~y~(" .. planespecs[tempcarid][3]/2 .. "$)"})
									while menuactive do
										Wait(0)
									end
									if(menuresult > 0) then
										if(menuresult == 1) then
											DeleteCar(plane)
											if(missionstarted == 0) then
												TriggerServerEvent('restartScript', "cleanup")
												Wait(1000)
											end
											plane = SpawnCar(planespecs[tempcarid][2], hangarinfo[i][3][1], hangarinfo[i][3][2], hangarinfo[i][3][3], hangarinfo[i][3][4])
											ChangeCarColour(plane, planetuning[tempcarid][1], planetuning[tempcarid][2])
											SetExtraCarColours(plane, planetuning[tempcarid][3], planetuning[tempcarid][4])
											for j=1,9,1 do
												if(planetuning[tempcarid][j+4] == 0) then
													TurnOffVehicleExtra(plane, j, true)
												else
													TurnOffVehicleExtra(plane, j, false)
												end
											end
											if(planetuning[tempcarid][21] > 0) then
												SetEngineHealth(plane, 2000.1)
												SetPetrolTankHealth(plane, 2000.1)
												SetCarHealth(plane, 2000)
											end
											TriggerEvent('chatMessage', '[Hangar]', {0, 255, 0}, 'Vehicle spawned at the hangar.')
										elseif(menuresult == 2) then
											money = money + planespecs[tempcarid][3]/2
											SaveStats()
											planes[tempcarid] = 0
											SavePlanes()
											TriggerEvent('chatMessage', '[Hangar]', {255, 255, 0}, 'Vehicle sold (+' .. planespecs[tempcarid][3]/2 .. '$).')
										end
									end
								end
							elseif(tempitems[menuresult] == "Purchase planes") then
								::main::
								local tempitems = {}
								for i=1,#planespecs,1 do
									tempitems[#tempitems+1] = "" .. planespecs[i][1] .. " ~g~(" .. planespecs[i][3] .. "$)"
								end
								DrawWindow("Select_plane_to_preview", tempitems)
								while menuactive do
									Wait(0)
								end
								if(menuresult > 0) then
									DeleteCar(carinshowroom)
									carinshowroom = SpawnCar(planespecs[menuresult][2], hangarinfo[i][3][1], hangarinfo[i][3][2], hangarinfo[i][3][3], hangarinfo[i][3][4])
									WarpCharIntoCar(GetPlayerChar(GetPlayerId()), carinshowroom)
									SetPlayerControl(GetPlayerId(), false)
									SetCharVisible(GetPlayerChar(GetPlayerId()), false)
									::carmenu::
									for j=1,#planespecs,1 do
										if(GetCarModel(carinshowroom, _i) == planespecs[j][2]) then
											tempcar = j
										end
									end
									DrawWindow("" .. planespecs[tempcar][1], {"Purchase ~g~(" .. planespecs[tempcar][3] .. "$)"})
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
											local tempamount = 0
											for j=1,#planes,1 do
												if(planes[j] == 1) then
													tempamount = tempamount + 1
												end
											end
											local tempgarage = 0
											for j=1,#hangars,1 do
												if(hangars[j] == 1) then
													tempgarage = tempgarage + hangarinfo[j][4]
												end
											end
											if(tempamount < tempgarage) then
												if(planes[tempcar] == 0) then
													if(money >= planespecs[tempcar][3]) then
														money = money - planespecs[tempcar][3]
														SaveStats()
														--SetPlayerControl(GetPlayerId(), true)
														--SetCharVisible(GetPlayerChar(GetPlayerId()), true)
														--DetachCar(carinshowroom)
														planes[tempcar] = 1
														SavePlanes()
														TriggerEvent('chatMessage', '[Hangar]', {0, 255, 0}, 'You have bought this plane! You can spawn it at your hangar.')
													else
														TriggerEvent('chatMessage', '[Hangar]', {255, 0, 0}, 'You do not have enough money!')
													end
												else
													TriggerEvent('chatMessage', '[Hangar]', {255, 255, 0}, 'You already have this plane.')
												end
											else
												TriggerEvent('chatMessage', '[Hangar]', {255, 0, 0}, 'Out of garage places!')
											end
										end
										goto carmenu
									else
										goto main
									end
								else
									DetachCar(carinshowroom)
									DeleteCar(carinshowroom)
									SetPlayerControl(GetPlayerId(), true)
									SetCharVisible(GetPlayerChar(GetPlayerId()), true)
								end
							end
						end
					end
				end
			end
		end
	end
end)

local carblip = nil
CreateThread(function()
	while true do
		Wait(0)
		if(not IsCarDead(plane)) then
			if(not IsCharInCar(GetPlayerChar(-1), plane)) then
				if(not DoesBlipExist(carblip)) then
					carblip = AddBlipForCar(plane)
					ChangeBlipSprite(carblip, 56)
					ChangeBlipColour(carblip, 3)
					ChangeBlipScale(carblip, 0.7)
					ChangeBlipNameFromAscii(carblip, "Your plane")
					SetBlipAsShortRange(carblip, true)
				end
			else
				RemoveBlip(carblip)
			end
		else
			RemoveBlip(carblip)
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if(not IsPlayerDead(GetPlayerId())) then
			if(IsCharInAnyPlane(GetPlayerChar(GetPlayerId()))) then
				if(GetDriverOfCar(GetCarCharIsUsing(GetPlayerChar(-1))) == GetPlayerChar(-1)) then
					if(IsPlayerControlOn(GetPlayerId())) then
						local fv = GetCarForwardVector(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())))
						local sv = GetCarSpeedVector(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())), false)
						local angle = GetAngleBetween2dVectors(fv.x, fv.y, sv.x, sv.y)
						if(not IsGameKeyboardKeyPressed(17)) then --w
							if(IsGameKeyboardKeyPressed(31)) then --s
								if(angle>0 and angle<90) then
									local tempspeed = GetCarSpeed(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), _f)
									ApplyForceToCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i),1,0,-(0.1*3),0,0,0,0,1,1,1,1)
								else
									if(IsVehicleOnAllWheels(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i))) then
										local tempspeed = GetCarSpeed(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), _f)
										ApplyForceToCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i),1,0,-(0.1*3),0,0,0,0,1,1,1,1)
									end
								end
							end
						end
						if(angle>0 and angle<90) then
							if(IsGameKeyboardKeyPressed(16)) then --q
								ApplyForceToCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i),1,-0.5,0,0,1*math.cos(math.rad(90)), 1*math.sin(math.rad(90)),0,1,1,1,1)
							end
							if(IsGameKeyboardKeyPressed(18)) then --e
								ApplyForceToCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i),1,0.5,0,0,1*math.cos(math.rad(90)), 1*math.sin(math.rad(90)),0,1,1,1,1)
							end
						else
							if(IsGameKeyboardKeyPressed(16)) then --q
								ApplyForceToCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i),1,0.5,0,0,1*math.cos(math.rad(90)), 1*math.sin(math.rad(90)),0,1,1,1,1)
							end
							if(IsGameKeyboardKeyPressed(18)) then --e
								ApplyForceToCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i),1,-0.5,0,0,1*math.cos(math.rad(90)), 1*math.sin(math.rad(90)),0,1,1,1,1)
							end
						end
					end
				end
			else
				local veh = GetVehiclePlayerWouldEnter(GetPlayerId())
				if(not IsCarDead(veh)) then
					if(IsThisModelAPlane(GetCarModel(veh))) then
						if(IsCharTouchingVehicle(GetPlayerChar(GetPlayerId()), veh)) then
							if(IsControlPressed(0, 3)) then
								if(veh == plane) then
									WarpCharIntoCar(GetPlayerChar(GetPlayerId()), veh)
								else
									if(GetMaximumNumberOfPassengers(veh) > 0) then
										if(IsCarPassengerSeatFree(veh, 0)) then
											WarpCharIntoCarAsPassenger(GetPlayerChar(GetPlayerId()), veh, 0)
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end)