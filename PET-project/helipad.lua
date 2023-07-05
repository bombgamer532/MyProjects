helispecs = {
--name, modelname, price
{"Maverick", 0x9D0450CA, 100000},
{"Annihilator", 0x31F0B376, 250000},
{"Buzzard", 0x2F03547B, 500000},
{"Skylift", 0x3E48BF23, 200000},
{"Swift", 0xEBC24DF2, 150000}
}
helis = {}
for i=1,#helispecs,1 do
	helis[i] = 0
end

RegisterNetEvent('updHelis')
AddEventHandler('updHelis', function(data)
	for i=1,#data,1 do
		helis[i] = tonumber(data[i])
	end
end)

SaveHelis = function()
	local data = {}
	for i=1,#helis,1 do
		data[i] = helis[i]
	end
	TriggerServerEvent('saveHelis', data)
end

heliinfo = {
{50000, {-1200.01343, 1687.46619, 34.56126, 88.8040084838867},{-1189.71167, 1689.87488, 36.42554, 88.968132019043}, 2},
{50000, {207.06772, -192.0123, 53.90823, 293.767852783203}, {199.01733, -198.50685, 55.81288, 294.353240966797}, 2},
{50000, {2221.93823, 711.95807, 5.81304, 46.5909538269043}, {2214.21484, 718.84058, 5.83532, 227.432525634766}, 2},
{50000, {209.76486, 317.17746, 28.06914, 88.5179595947266}, {220.66356, 319.20682, 29.93185, 88.6853408813477}, 2}
}
local heliblip = {}
helipads = {}
for i=1,#heliinfo,1 do
	helipads[i] = 0
end

RegisterNetEvent('updHelipads')
AddEventHandler('updHelipads', function(data)
	for i=1,#heliinfo,1 do
		if(data[i] == nil) then
			data[i] = 0
		end
		helipads[i] = tonumber(data[i])
	end
end)

SaveHelipads = function()
	local data = {}
	for i=1,#helipads,1 do
		data[i] = helipads[i]
	end
	TriggerServerEvent('saveHelipads', data)
end

CreateThread(function()
	while true do
		Wait(0)
		for i=1,#heliinfo,1 do
			if(not DoesBlipExist(heliblip[i])) then
				heliblip[i] = AddBlipForCoord(heliinfo[i][2][1], heliinfo[i][2][2], heliinfo[i][2][3], _i)
				ChangeBlipSprite(heliblip[i], 56)
				ChangeBlipScale(heliblip[i], 0.7)
				ChangeBlipNameFromAscii(heliblip[i], "Helipad #" .. i)
				SetBlipAsShortRange(heliblip[i], true)
			end
			if(helipads[i] == 0) then
				DrawTextAtCoord(heliinfo[i][2][1], heliinfo[i][2][2], heliinfo[i][2][3], "Helipad_#" .. i .. " Price:_" .. heliinfo[i][1] .. "$ Garage_places:_" .. heliinfo[i][4], 20)
				ChangeBlipColour(heliblip[i], 0)
			else
				DrawTextAtCoord(heliinfo[i][2][1], heliinfo[i][2][2], heliinfo[i][2][3], "Helipad_#" .. i .. " Owned Garage_places:_" .. heliinfo[i][4], 20)
				ChangeBlipColour(heliblip[i], 2)
			end
			DrawCheckpointWithDist(heliinfo[i][2][1], heliinfo[i][2][2], heliinfo[i][2][3]-1, 1.1, 255, 255, 0, 100)
			if(IsPlayerNearCoords(heliinfo[i][2][1], heliinfo[i][2][2], heliinfo[i][2][3], 1)) then
				if(helipads[i] == 0) then
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to purchase ~y~this helipad ~w~for ~g~" .. heliinfo[i][1] .. "$", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						local hashouse = 0
						for j=1,#houses,1 do
							if(houses[j] == 1) then
								hashouse = 1
							end
						end
						if(hashouse == 1) then
							if(money >= heliinfo[i][1]) then
								money = money - heliinfo[i][1]
								SaveStats()
								helipads[i] = 1
								SaveHelipads()
								TriggerEvent('chatMessage', '[Helipad]', {0, 255, 0}, 'This helipad has been successfully purchased!')
							else
								TriggerEvent('chatMessage', '[Helipad]', {255, 0, 0}, 'You cannot afford it!')
							end
						else
							TriggerEvent('chatMessage', '[Helipad]', {255, 0, 0}, 'You must own an apartment to purchase it!')
						end
					end
				else
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~open helipad menu", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						local tempitems = {}
						tempitems[#tempitems+1] = "Open helicopters list"
						tempitems[#tempitems+1] = "Purchase helicopters"
						DrawWindow("Helipad_#" .. i, tempitems)
						while menuactive do
							Wait(0)
						end
						if(menuresult > 0) then
							if(tempitems[menuresult] == "Open helicopters list") then
								local tempitems = {}
								for j=1,#helis,1 do
									if(helis[j] == 1) then
										tempitems[#tempitems+1] = "" .. helispecs[j][1]
									end
								end
								DrawWindow("Garage_menu", tempitems)
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
											if(missionstarted == 0) then
												TriggerServerEvent('restartScript', "cleanup")
												Wait(1000)
											end
											heli = SpawnCar(helispecs[tempcarid][2], heliinfo[i][3][1], heliinfo[i][3][2], heliinfo[i][3][3], heliinfo[i][3][4])
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
							elseif(tempitems[menuresult] == "Purchase helicopters") then
								::main::
								local tempitems = {}
								for i=1,#helispecs,1 do
									tempitems[#tempitems+1] = "" .. helispecs[i][1] .. " ~g~(" .. helispecs[i][3] .. "$)"
								end
								DrawWindow("Select_helicopter_to_preview", tempitems)
								while menuactive do
									Wait(0)
								end
								if(menuresult > 0) then
									DeleteCar(carinshowroom)
									carinshowroom = SpawnCar(helispecs[menuresult][2], heliinfo[i][3][1], heliinfo[i][3][2], heliinfo[i][3][3], heliinfo[i][3][4])
									WarpCharIntoCar(GetPlayerChar(GetPlayerId()), carinshowroom)
									SetPlayerControl(GetPlayerId(), false)
									SetCharVisible(GetPlayerChar(GetPlayerId()), false)
									::carmenu::
									for j=1,#helispecs,1 do
										if(j == 1) then
											if(GetCarModel(carinshowroom, _i) == 0x9D0450CA) then
												tempcar = j
											end
										else
											if(GetCarModel(carinshowroom, _i) == helispecs[j][2]) then
												tempcar = j
											end
										end
									end
									DrawWindow("" .. helispecs[tempcar][1], {"Purchase ~g~(" .. helispecs[tempcar][3] .. "$)"})
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
											for j=1,#helis,1 do
												if(helis[j] == 1) then
													tempamount = tempamount + 1
												end
											end
											local tempgarage = 0
											for j=1,#helipads,1 do
												if(helipads[j] == 1) then
													tempgarage = tempgarage + heliinfo[j][4]
												end
											end
											if(tempamount < tempgarage) then
												if(helis[tempcar] == 0) then
													if(money >= helispecs[tempcar][3]) then
														money = money - helispecs[tempcar][3]
														SaveStats()
														--SetPlayerControl(GetPlayerId(), true)
														--SetCharVisible(GetPlayerChar(GetPlayerId()), true)
														--DetachCar(carinshowroom)
														helis[tempcar] = 1
														SaveHelis()
														TriggerEvent('chatMessage', '[Helipad]', {0, 255, 0}, 'You have bought this helicopter! You can spawn it at your helipad.')
													else
														TriggerEvent('chatMessage', '[Helipad]', {255, 0, 0}, 'You do not have enough money!')
													end
												else
													TriggerEvent('chatMessage', '[Helipad]', {255, 255, 0}, 'You already have this helicopter.')
												end
											else
												TriggerEvent('chatMessage', '[Helipad]', {255, 0, 0}, 'Out of garage places!')
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
		if(not IsCarDead(heli)) then
			if(not IsCharInCar(GetPlayerChar(-1), heli)) then
				if(not DoesBlipExist(carblip)) then
					carblip = AddBlipForCar(heli)
					ChangeBlipSprite(carblip, 56)
					ChangeBlipColour(carblip, 3)
					ChangeBlipScale(carblip, 0.7)
					ChangeBlipNameFromAscii(carblip, "Your helicopter")
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