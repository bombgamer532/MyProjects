boatspecs = {
--name, modelname, price
{"Dinghy", 0x3D961290, 40000},
{"Jetmax", 0x33581161, 40000},
{"Marquis", 0xC1CE1183, 30000},
{"Reefer", 0x68E27CB6, 30000},
{"Squalo", 0x17DF5EC2, 40000},
{"Tropic", 0x1149422F, 30000},
{"Yacht", 0x3F724E66, 200000},
{"Blade", 0xB820ED5E, 40000},
{"Floater", 0x98CC6F33, 30000},
{"Smuggler", 0x38527DEC, 50000}
}
boats = {}
for i=1,#boatspecs,1 do
	boats[i] = 0
end

RegisterNetEvent('updBoats')
AddEventHandler('updBoats', function(data)
	for i=1,#data,1 do
		boats[i] = tonumber(data[i])
	end
end)

SaveBoats = function()
	local data = {}
	for i=1,#boats,1 do
		data[i] = boats[i]
	end
	TriggerServerEvent('saveBoats', data)
end

boatinfo = {
{50000, {-387.85327, -561.76099, 1.48209, 29.8562812805176}, {-382.73557, -548.36633, -0.50918, 27.3558616638184}, 3},
{50000, {2186.80908, 25.71133, 1.3434, 89.8614959716797}, {2176.90454, 23.19636, -0.22707, 180.105575561523}, 3},
{50000, {1046.10437, 1117.67737, 1.31443, 0.170279577374458}, {1032.4718, 1110.01453, -0.53126, 353.346496582031}, 3},
{50000, {-695.86713, 1199.22083, 1.68848, 75.8526840209961}, {-708.66663, 1203.40234, -0.43356, 169.431991577148}, 3},
{50000, {-2017.4375, -116.44175, 1.77306, 179.404418945313}, {-2017.46692, -124.60894, -0.66312, 92.4106369018555}, 3}
}
local boatblip = {}
boatyards = {}
for i=1,#boatinfo,1 do
	boatyards[i] = 0
end

RegisterNetEvent('updBoatyards')
AddEventHandler('updBoatyards', function(data)
	for i=1,#boatinfo,1 do
		if(data[i] == nil) then
			data[i] = 0
		end
		boatyards[i] = tonumber(data[i])
	end
end)

SaveBoatyards = function()
	local data = {}
	for i=1,#boatyards,1 do
		data[i] = boatyards[i]
	end
	TriggerServerEvent('saveBoatyards', data)
end

CreateThread(function()
	while true do
		Wait(0)
		for i=1,#boatinfo,1 do
			if(not DoesBlipExist(boatblip[i])) then
				boatblip[i] = AddBlipForCoord(boatinfo[i][2][1], boatinfo[i][2][2], boatinfo[i][2][3], _i)
				ChangeBlipSprite(boatblip[i], 48)
				ChangeBlipScale(boatblip[i], 0.7)
				ChangeBlipNameFromAscii(boatblip[i], "Boatyard #" .. i)
				SetBlipAsShortRange(boatblip[i], true)
			end
			if(boatyards[i] == 0) then
				DrawTextAtCoord(boatinfo[i][2][1], boatinfo[i][2][2], boatinfo[i][2][3], "Boatyard_#" .. i .. " Price:_" .. boatinfo[i][1] .. "$ Garage_places:_" .. boatinfo[i][4], 20)
				ChangeBlipColour(boatblip[i], 0)
			else
				DrawTextAtCoord(boatinfo[i][2][1], boatinfo[i][2][2], boatinfo[i][2][3], "Boatyard_#" .. i .. " Owned Garage_places:_" .. boatinfo[i][4], 20)
				ChangeBlipColour(boatblip[i], 2)
			end
			DrawCheckpointWithDist(boatinfo[i][2][1], boatinfo[i][2][2], boatinfo[i][2][3]-1, 1.1, 255, 255, 0, 100)
			if(IsPlayerNearCoords(boatinfo[i][2][1], boatinfo[i][2][2], boatinfo[i][2][3], 1)) then
				if(boatyards[i] == 0) then
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to purchase ~y~this boatyard ~w~for ~g~" .. boatinfo[i][1] .. "$", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						local hashouse = 0
						for j=1,#houses,1 do
							if(houses[j] == 1) then
								hashouse = 1
							end
						end
						if(hashouse == 1) then
							if(money >= boatinfo[i][1]) then
								money = money - boatinfo[i][1]
								SaveStats()
								boatyards[i] = 1
								SaveBoatyards()
								TriggerEvent('chatMessage', '[Boatyard]', {0, 255, 0}, 'This boatyard has been successfully purchased!')
							else
								TriggerEvent('chatMessage', '[Boatyard]', {255, 0, 0}, 'You cannot afford it!')
							end
						else
							TriggerEvent('chatMessage', '[Boatyard]', {255, 0, 0}, 'You must own an apartment to purchase it!')
						end
					end
				else
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~open boatyard menu", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						local tempitems = {}
						tempitems[#tempitems+1] = "Open boats list"
						tempitems[#tempitems+1] = "Purchase boats"
						DrawWindow("Boatyard_#" .. i, tempitems)
						while menuactive do
							Wait(0)
						end
						if(menuresult > 0) then
							if(tempitems[menuresult] == "Open boats list") then
								local tempitems = {}
								for j=1,#boats,1 do
									if(boats[j] == 1) then
										tempitems[#tempitems+1] = "" .. boatspecs[j][1]
									end
								end
								DrawWindow("Garage_menu", tempitems)
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
											if(boatspecs[tempcarid][1] == "Yacht") then
												DeleteCar(yacht)
												RemoveBlip(yachtblip)
												local coords = {
												{-529.63379, 2039.76245, -0.38107, 271.696228027344},
												{1944.99768, 1520.64111, -0.45675, 194.838821411133},
												{2067.3645, -553.62286, -0.17268, 105.141761779785},
												{-975.93256, -1028.28748, -0.14308, 64.8627395629883},
												{-2620.62476, -230.35472, -0.50019, 353.522369384766}
												}
												local cc = GetClosestCoordWithIndex(coords)
												yacht = SpawnCar(boatspecs[tempcarid][2], coords[cc][1], coords[cc][2], coords[cc][3]-8, coords[cc][4])
												TriggerEvent('chatMessage', '[Boatyard]', {0, 255, 0}, 'Yacht delivered to the marked point (yellow sail marker).')
											else
												DeleteCar(boat)
												if(missionstarted == 0) then
													TriggerServerEvent('restartScript', "cleanup")
													Wait(1000)
												end
												boat = SpawnCar(boatspecs[tempcarid][2], boatinfo[i][3][1], boatinfo[i][3][2], boatinfo[i][3][3], boatinfo[i][3][4])
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
												TriggerEvent('chatMessage', '[Boatyard]', {0, 255, 0}, 'Vehicle spawned at the boatyard.')
											end
										elseif(menuresult == 2) then
											money = money + boatspecs[tempcarid][3]/2
											SaveStats()
											boats[tempcarid] = 0
											Saveboats()
											TriggerEvent('chatMessage', '[Boatyard]', {255, 255, 0}, 'Vehicle sold (+' .. boatspecs[tempcarid][3]/2 .. '$).')
										end
									end
								end
							elseif(tempitems[menuresult] == "Purchase boats") then
								::main::
								local tempitems = {}
								for i=1,#boatspecs,1 do
									tempitems[#tempitems+1] = "" .. boatspecs[i][1] .. " ~g~(" .. boatspecs[i][3] .. "$)"
								end
								DrawWindow("Select_boat_to_preview", tempitems)
								while menuactive do
									Wait(0)
								end
								if(menuresult > 0) then
									DeleteCar(carinshowroom)
									if(boatspecs[menuresult][1] ~= "Yacht") then
										carinshowroom = SpawnCar(boatspecs[menuresult][2], boatinfo[i][3][1], boatinfo[i][3][2], boatinfo[i][3][3], boatinfo[i][3][4])
										WarpCharIntoCar(GetPlayerChar(GetPlayerId()), carinshowroom)
										SetPlayerControl(GetPlayerId(), false)
										SetCharVisible(GetPlayerChar(GetPlayerId()), false)
									end
									::carmenu::
									if(boatspecs[menuresult][1] ~= "Yacht") then
										for j=1,#boatspecs,1 do
											if(GetCarModel(carinshowroom, _i) == boatspecs[j][2]) then
											--if(GetStringFromHashKey(GetCarModel(carinshowroom, _i)) == boatspecs[j][2]) then
												tempcar = j
											end
										end
										DrawWindow("" .. boatspecs[tempcar][1], {"Purchase ~g~(" .. boatspecs[tempcar][3] .. "$)"})
									else
										tempcar = 7
										DrawWindow("" .. boatspecs[tempcar][1], {"Purchase ~g~(" .. boatspecs[tempcar][3] .. "$)"})
									end
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
											for j=1,#boats,1 do
												if(boats[j] == 1) then
													tempamount = tempamount + 1
												end
											end
											local tempgarage = 0
											for j=1,#boatyards,1 do
												if(boatyards[j] == 1) then
													tempgarage = tempgarage + boatinfo[j][4]
												end
											end
											if(tempamount < tempgarage) then
												if(boats[tempcar] == 0) then
													if(money >= boatspecs[tempcar][3]) then
														money = money - boatspecs[tempcar][3]
														SaveStats()
														--SetPlayerControl(GetPlayerId(), true)
														--SetCharVisible(GetPlayerChar(GetPlayerId()), true)
														--DetachCar(carinshowroom)
														boats[tempcar] = 1
														SaveBoats()
														TriggerEvent('chatMessage', '[Boatyard]', {0, 255, 0}, 'You have bought this boat! You can spawn it at your boatyard.')
													else
														TriggerEvent('chatMessage', '[Boatyard]', {255, 0, 0}, 'You do not have enough money!')
													end
												else
													TriggerEvent('chatMessage', '[Boatyard]', {255, 255, 0}, 'You already have this boat.')
												end
											else
												TriggerEvent('chatMessage', '[Boatyard]', {255, 0, 0}, 'Out of garage places!')
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
		if(not IsCarDead(boat)) then
			if(not IsCharInCar(GetPlayerChar(-1), boat)) then
				if(not DoesBlipExist(carblip)) then
					carblip = AddBlipForCar(boat)
					ChangeBlipSprite(carblip, 48)
					ChangeBlipColour(carblip, 3)
					ChangeBlipScale(carblip, 0.7)
					ChangeBlipNameFromAscii(carblip, "Your boat")
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