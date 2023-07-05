planetuning = {}
for i=1,#planes,1 do
	planetuning[i] = {}
	for j=1,23,1 do
		planetuning[i][j] = 0
	end
end
rgb = {}
for i=1,3,1 do
	rgb[i] = 0
end

RegisterNetEvent('updPlaneTuning')
AddEventHandler('updPlaneTuning', function(data)
	for i=1,#data,1 do
		for j=1,#data[i],1 do
			planetuning[i][j] = tonumber(data[i][j])
		end
	end
end)

local SaveTuning = function()
	local data = {}
	for i=1,#planes,1 do
		data[i] = {}
	end
	for i=1,#planes,1 do
		for j=1,#planetuning[i],1 do
			data[i][j] = planetuning[i][j]
		end
	end
	TriggerServerEvent('savePlaneTuning', data)
end

local tempcar = 0
CreateThread(function()
	while true do
		Wait(0)
		if(not IsCarDead(plane)) then
			for j=1,#planespecs,1 do
				if(GetCarModel(plane, _i) == planespecs[j][2]) then
					tempcar = j
				end
			end
		end
	end
end)

local tuningblip = nil
CreateThread(function()
	while true do
		Wait(0)
		if(not DoesBlipExist(tuningblip)) then
			tuningblip = AddBlipForCoord(2631.94238, 376.37827, 5.81486, _i)
			ChangeBlipSprite(tuningblip, 75)
			ChangeBlipScale(tuningblip, 0.7)
			ChangeBlipNameFromAscii(tuningblip, "Plane tuning shop")
			ChangeBlipColour(tuningblip, 19)
			SetBlipAsShortRange(tuningblip, true)
		end
		DrawTextAtCoord(2631.94238, 376.37827, 5.81486, "Plane_tuning_shop", 20)
		DrawCheckpointWithDist(2631.94238, 376.37827, 5.81486-1, 1.1, 255, 255, 0, 100)
		if(IsPlayerNearCoords(2631.94238, 376.37827, 5.81486, 10)) then
			if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
				if(GetDriverOfCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), _i) == GetPlayerChar(GetPlayerId())) then
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~enter repair shop", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						if(IsCharInAnyPlane(GetPlayerChar(GetPlayerId()))) then
							SetPlayerControl(GetPlayerId(), false)
							AttachCarToCarPhysically(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), true, 1, 0, 0, 0, 0, 0, 0, 0, 0)
							SetCarCoordinates(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), 2631.94238, 376.37827, 5.81486-1)
							SetCarHeading(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), 179.671646118164)
							SetCarOnGroundProperly(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i))
							FreezeCarPosition(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), true)
							::main::
							local tempitems = {}
							--tempitems[#tempitems+1] = "Clean ~g~(" .. math.floor(GetVehicleDirtLevel(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), _f)) .. "$)"
							local tempprice = 0
							if(IsCharInCar(GetPlayerChar(GetPlayerId()), plane)) then
								for j=1,#planespecs,1 do
									if(GetCarModel(plane, _i) == planespecs[j][2]) then
										tempcar = j
									end
								end
								if(planetuning[tempcar][21] > 0) then
									tempprice = math.floor((2000-GetCarHealth(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), _i))/10)
								else
									tempprice = math.floor((1000-GetCarHealth(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), _i))/10)
								end
							else
								tempprice = math.floor((1000-GetCarHealth(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), _i))/10)
							end
							tempitems[#tempitems+1] = "Repair ~g~(" .. tempprice .. "$)"
							tempitems[#tempitems+1] = "Customize"
							tempitems[#tempitems+1] = "Upgrade"
							tempitems[#tempitems+1] = "Buy repair kit ~g~(200$)"
							--tempitems[#tempitems+1] = "Exit"
							DrawWindow("Liberty_City_Customs", tempitems)
							while menuactive do
								Wait(0)
								if(IsMouseButtonPressed(1)) then
									SetCamActive(GetGameCam(), true)
								else
									SetCamActive(GetGameCam(), false)
								end
							end
							if(menuresult > 0) then
								if(tempitems[menuresult] == "Clean ~g~(" .. math.floor(GetVehicleDirtLevel(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), _f)) .. "$)") then
									if(math.floor(GetVehicleDirtLevel(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), _f)) > 0) then
										if(money >= math.floor(GetVehicleDirtLevel(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), _f))) then
											money = money - math.floor(GetVehicleDirtLevel(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), _f))
											SaveStats()
											SetVehicleDirtLevel(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), 0.0)
											TriggerEvent('chatMessage', '[Repair shop]', {0, 255, 0}, 'Vehicle cleaned!')
										else
											TriggerEvent('chatMessage', '[Repair shop]', {255, 0, 0}, 'You do not have enough money!')
										end
									else
										TriggerEvent('chatMessage', '[Repair shop]', {255, 255, 0}, 'Your vehicle does not require cleaning.')
									end
									goto main
								elseif(tempitems[menuresult] == "Repair ~g~(" .. tempprice .. "$)") then
									if(tempprice > 0) then
										if(money >= tempprice) then
											money = money - tempprice
											SaveStats()
											FixCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i))
											if(IsCharInCar(GetPlayerChar(GetPlayerId()), plane)) then
												if(planetuning[tempcar][21] > 0) then
													SetEngineHealth(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), 2000.1)
													SetPetrolTankHealth(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), 2000.1)
													SetCarHealth(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), 2000)
												end
											end
											TriggerEvent('chatMessage', '[Repair shop]', {0, 255, 0}, 'Vehicle repaired!')
										else
											TriggerEvent('chatMessage', '[Repair shop]', {255, 0, 0}, 'You do not have enough money!')
										end
									else
										TriggerEvent('chatMessage', '[Repair shop]', {255, 255, 0}, 'Your vehicle does not require repair.')
									end
									goto main
								elseif(tempitems[menuresult] == "Customize") then
									if(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i) == plane) then
										for j=1,#planespecs,1 do
											if(GetCarModel(plane, _i) == planespecs[j][2]) then
												tempcar = j
											end
										end
										c = {}
										for j=1,4,1 do
											c[j] = planetuning[tempcar][j]
										end
										for j=1,3,1 do
											rgb[j] = planetuning[tempcar][13+j]
										end
										::customize::
										local amount = 0
										for j=1,4,1 do
											if(planetuning[tempcar][j] ~= c[j]) then
												amount = amount + 1
											end
										end
										for j=1,9,1 do
											if(IsVehicleExtraTurnedOn(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), j)) then
												if(planetuning[tempcar][j+4] ~= 1) then
													amount = amount + 1
												end
											else
												if(planetuning[tempcar][j+4] ~= 0) then
													amount = amount + 1
												end
											end
										end
										for j=1,3,1 do
											if(planetuning[tempcar][13+j] ~= rgb[j]) then
												amount = amount + 1
											end
										end
										local tempitems = {}
										tempitems[#tempitems+1] = "Purchase ~g~(" .. 200*amount .. "$)"
										tempitems[#tempitems+1] = "Color"
										tempitems[#tempitems+1] = "Extras"
										--tempitems[#tempitems+1] = "Neon"
										--tempitems[#tempitems+1] = "Back"
										DrawWindow("Customize", tempitems)
										while menuactive do
											Wait(0)
											if(IsMouseButtonPressed(1)) then
												SetCamActive(GetGameCam(), true)
											else
												SetCamActive(GetGameCam(), false)
											end
										end
										if(menuresult > 0) then
											if(tempitems[menuresult] == "Purchase ~g~(" .. 200*amount .. "$)") then
												if(money >= 200*amount) then
													money = money - 200*amount
													SaveStats()
													
													for j=1,4,1 do
														planetuning[tempcar][j] = c[j]
													end
													for j=1,9,1 do
														if(IsVehicleExtraTurnedOn(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), j)) then
															planetuning[tempcar][j+4] = 1
														else
															planetuning[tempcar][j+4] = 0
														end
													end
													for j=1,3,1 do
														planetuning[tempcar][13+j] = rgb[j]
													end
													SaveTuning()
														
													PrintStringWithLiteralStringNow("STRING", "~g~Purchase is successful", 3000, 1)
												else
													PrintStringWithLiteralStringNow("STRING", "~r~You can't afford it", 1000, 1)
												end
												goto customize
											elseif(tempitems[menuresult] == "Color") then
												::color::
												local tempitems = {}
												tempitems[#tempitems+1] = "Color 1"
												tempitems[#tempitems+1] = "Color 2"
												tempitems[#tempitems+1] = "Color 3"
												tempitems[#tempitems+1] = "Color 4"
												DrawWindow("Customize", tempitems)
												while menuactive do
													Wait(0)
													if(IsMouseButtonPressed(1)) then
														SetCamActive(GetGameCam(), true)
													else
														SetCamActive(GetGameCam(), false)
													end
												end
												if(menuresult > 0) then
													for j=1,4,1 do
														if(tempitems[menuresult] == "Color " .. j) then
															::colorswitch::
															local colors = {
															{10, 10, 10}, --0
															{37, 37, 37}, --1
															{101, 106, 121}, --2
															{88, 89, 90}, --3
															{156, 161, 163}, --4
															{150, 145, 140}, --5
															{81, 84, 89}, --6
															{63, 62, 69}, --7
															{165, 169, 167}, --8
															{151, 149, 146}, --9
															{118, 123, 124}, --10
															{90, 87, 82}, --11
															{173, 176, 176}, --12
															{132, 137, 136}, --13
															{148, 157, 159}, --14
															{164, 167, 165}, --15
															{88, 88, 83}, --16
															{164, 160, 150}, --17
															{175, 177, 177}, --18
															{109, 108, 110}, --19
															{100, 104, 106}, --20
															{82, 86, 97}, --21
															{140, 146, 154}, --22
															{91, 93, 94}, --23
															{189, 190, 198}, --24
															{182, 182, 182}, --25
															{100, 100, 100}, --26
															{226, 6, 6}, --27
															{150, 8, 0}, --28
															{107, 0, 0}, --29
															{97, 16, 9}, --30
															{74, 10, 10}, --31
															{115, 11, 11}, --32
															{87, 7, 7}, --33
															{38, 3, 6}, --34
															{158, 0, 0}, --35
															{20, 0, 2}, --36
															{15, 4, 4}, --37
															{15, 8, 10}, --38
															{57, 25, 29}, --39
															{85, 39, 37}, --40
															{76, 41, 41}, --41
															{116, 29, 40}, --42
															{109, 40, 55}, --43
															{115, 10, 39}, --44
															{100, 13, 27}, --45
															{98, 11, 28}, --46
															{115, 24, 39}, --47
															{171, 152, 143}, --48
															{32, 32, 44}, --49
															{68, 98, 79}, --50
															{46, 91, 32}, --51
															{30, 46, 50}, --52
															{48, 79, 69}, --53
															{77, 98, 104}, --54
															{94, 112, 114}, --55
															{25, 56, 38}, --56
															{45, 58, 53}, --57
															{51, 95, 63}, --58
															{71, 120, 60}, --59
															{147, 163, 150}, --60
															{154, 167, 144}, --61
															{38, 55, 57}, --62
															{76, 117, 183}, --63
															{70, 89, 122}, --64
															{93, 126, 141}, --65
															{59, 78, 120}, --66
															{61, 74, 104}, --67
															{109, 122, 136}, --68
															{22, 34, 72}, --69
															{39, 47, 75}, --70
															{78, 104, 129}, --71
															{106, 122, 140}, --72
															{111, 130, 151}, --73
															{14, 49, 109}, --74
															{57, 90, 131}, --75
															{32, 75, 107}, --76
															{43, 62, 87}, --77
															{54, 65, 85}, --78
															{108, 132, 149}, --79
															{77, 93, 96}, --80
															{64, 108, 143}, --81
															{19, 69, 115}, --82
															{16, 80, 130}, --83
															{56, 86, 148}, --84
															{0, 28, 50}, --85
															{89, 110, 135}, --86
															{34, 52, 87}, --87
															{32, 32, 44}, --88
															{245, 137, 15}, --89
															{145, 115, 71}, --90
															{142, 140, 70}, --91
															{170, 173, 142}, --92
															{174, 155, 127}, --93
															{150, 129, 108}, --94
															{122, 117, 96}, --95
															{157, 152, 114}, --96
															{152, 149, 134}, --97
															{156, 141, 113}, --98
															{105, 30, 59}, --99
															{114, 42, 63}, --100
															{124, 27, 68}, --101
															{34, 25, 24}, --102
															{127, 105, 86}, --103
															{71, 53, 50}, --104
															{105, 88, 83}, --105
															{98, 68, 40}, --106
															{125, 98, 86}, --107
															{170, 157, 132}, --108
															{123, 113, 94}, --109
															{171, 146, 118}, --110
															{99, 82, 90}, --111
															{201, 201, 201}, --112
															{214, 218, 214}, --113
															{159, 157, 148}, --114
															{147, 163, 150}, --115
															{156, 156, 152}, --116
															{167, 162, 143}, --117
															{15, 106, 137}, --118
															{161, 153, 131}, --119
															{163, 173, 198}, --120
															{155, 139, 128}, --121
															{132, 148, 171}, --122
															{158, 164, 171}, --123
															{134, 68, 110}, --124
															{226, 6, 6}, --125
															{71, 120, 60}, --126
															{215, 142, 16}, --127
															{42, 119, 161}, --128
															{66, 31, 33}, --129
															{111, 103, 95}, --130
															{252, 38, 0}, --131
															{252, 109, 0}, --132
															{255, 255, 255} --133
															}
															local tempitems = {}
															for k=0,133,1 do
																tempitems[#tempitems+1] = k
															end
															DrawWindow("Color_" .. j, tempitems, colors)
															while menuactive do
																Wait(0)
																if(IsMouseButtonPressed(1)) then
																	SetCamActive(GetGameCam(), true)
																else
																	SetCamActive(GetGameCam(), false)
																end
															end
															if(menuresult > 0) then
																c[j] = menuresult-1
																ChangeCarColour(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), c[1], c[2])
																SetExtraCarColours(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), c[3], c[4])
																goto colorswitch
															else
																goto color
															end
														end
													end
												else
													goto customize
												end
											elseif(tempitems[menuresult] == "Extras") then
												::extras::
												local tempitems = {}
												for j=1,9,1 do
													if(IsVehicleExtraTurnedOn(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), j)) then
														tempitems[#tempitems+1] = "Extra_" .. j .. ":_1"
													else
														tempitems[#tempitems+1] = "Extra_" .. j .. ":_0"
													end
												end
												DrawWindow("Extras", tempitems)
												while menuactive do
													Wait(0)
													if(IsMouseButtonPressed(1)) then
														SetCamActive(GetGameCam(), true)
													else
														SetCamActive(GetGameCam(), false)
													end
												end
												if(menuresult > 0) then
													for j=1,9,1 do
														if(tempitems[menuresult] == "Extra_" .. j .. ":_1") then
															TurnOffVehicleExtra(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), j, true)
														elseif(tempitems[menuresult] == "Extra_" .. j .. ":_0") then
															TurnOffVehicleExtra(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), j, false)
														end
													end
													goto extras
												else
													goto customize
												end
											elseif(tempitems[menuresult] == "Neon") then
												::neon::
												local tempitems = {}
												tempitems[#tempitems+1] = "Red"
												tempitems[#tempitems+1] = "Green"
												tempitems[#tempitems+1] = "Blue"
												DrawWindow("Neon", tempitems)
												while menuactive do
													Wait(0)
													if(IsMouseButtonPressed(1)) then
														SetCamActive(GetGameCam(), true)
													else
														SetCamActive(GetGameCam(), false)
													end
													local cx,cy,cz = GetCarCoordinates(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), _f, _f, _f)
													DrawLightWithRange(cx, cy, cz, rgb[1], rgb[2], rgb[3], 9.9, 10.1)
												end
												if(menuresult > 0) then
													local tempitem = {menuresult, tempitems[menuresult]}
													::neonswitch::
													local tempitems = {}
													for j=0,255,1 do
														tempitems[#tempitems+1] = j
													end
													DrawWindow("" .. tempitem[2], tempitems)
													while menuactive do
														Wait(0)
														if(IsMouseButtonPressed(1)) then
															SetCamActive(GetGameCam(), true)
														else
															SetCamActive(GetGameCam(), false)
														end
														local cx,cy,cz = GetCarCoordinates(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), _f, _f, _f)
														DrawLightWithRange(cx, cy, cz, rgb[1], rgb[2], rgb[3], 9.9, 10.1)
													end
													if(menuresult > 0) then
														rgb[tempitem[1]] = menuresult
														goto neonswitch
													else
														goto neon
													end
												else
													goto customize
												end
											end
										else
											goto main
										end
									else
										TriggerEvent('chatMessage', '[Repair shop]', {255, 0, 0}, 'This is not your vehicle!')
										goto main
									end
								elseif(tempitems[menuresult] == "Upgrade") then
									if(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i) == plane) then
										for j=1,#planespecs,1 do
											if(GetCarModel(plane, _i) == planespecs[j][2]) then
												tempcar = j
											end
										end
										local tempprices = {
										{5000, 7000, 10000},
										{6000, 10000, 13000},
										{3000, 5000, 7000},
										10000,
										20000,
										15000,
										10000
										}
										if(biz[3]==1 and biz[4]==1) then
											for j=1,3,1 do
												for k=1,3,1 do
													tempprices[j][k] = math.floor(tempprices[j][k]*0.75)
												end
											end
											for j=4,#tempprices,1 do
												tempprices[j] = math.floor(tempprices[j]*0.75)
											end
										end
										::upgrades::
										local tempupg = {}
										for j=1,#tempprices,1 do
											if(j <= 3) then
												if(planetuning[tempcar][16+j] ~= 3) then
													tempupg[j] = "" .. planetuning[tempcar][16+j] .. " -> " .. planetuning[tempcar][16+j]+1 .. " ~g~(" .. tempprices[j][planetuning[tempcar][16+j]+1] .. "$)"
												else
													tempupg[j] = "3 (MAX)"
												end
											else
												if(planetuning[tempcar][16+j] == 0) then
													tempupg[j] = "~g~" .. tempprices[j] .. "$"
												else
													tempupg[j] = "OK"
												end
											end
										end
										local tempitems = {}
										--tempitems[#tempitems+1] = "Engine: " .. tempupg[1]
										--tempitems[#tempitems+1] = "Nitro: " .. tempupg[2]
										--tempitems[#tempitems+1] = "Brakes: " .. tempupg[3]
										--tempitems[#tempitems+1] = "Hydraulics: " .. tempupg[4]
										tempitems[#tempitems+1] = "Armor: " .. tempupg[5]
										--tempitems[#tempitems+1] = "Bullet-proof tires: " .. tempupg[6]
										--tempitems[#tempitems+1] = "Fire protection: " .. tempupg[7]
										--tempitems[#tempitems+1] = "Back"
										DrawWindow("Upgrade", tempitems)
										while menuactive do
											Wait(0)
											if(IsMouseButtonPressed(1)) then
												SetCamActive(GetGameCam(), true)
											else
												SetCamActive(GetGameCam(), false)
											end
										end
										if(menuresult > 0) then
											if(tempitems[menuresult] == "Armor: " .. tempupg[5]) then
												menuresult = 5
											end
											if(menuresult <= 3) then
												if(planetuning[tempcar][16+menuresult] ~= 3) then
													if(money >= tempprices[menuresult][planetuning[tempcar][16+menuresult]+1]) then
														money = money - tempprices[menuresult][planetuning[tempcar][16+menuresult]+1]
														SaveStats()
														planetuning[tempcar][16+menuresult] = planetuning[tempcar][16+menuresult] + 1
														SaveTuning()
														TriggerEvent('chatMessage', '[Repair shop]', {0, 255, 0}, 'Upgrade installed')
													else
														TriggerEvent('chatMessage', '[Repair shop]', {255, 0, 0}, 'You cannot afford it!')
													end
												else
													TriggerEvent('chatMessage', '[Repair shop]', {255, 255, 0}, 'Max level reached')
												end
											else
												if(level >= 30) then
													if(planetuning[tempcar][16+menuresult] == 0) then
														if(money >= tempprices[menuresult]) then
															money = money - tempprices[menuresult]
															SaveStats()
															planetuning[tempcar][16+menuresult] = 1
															SaveTuning()
															TriggerEvent('chatMessage', '[Repair shop]', {0, 255, 0}, 'Upgrade installed')
														else
															TriggerEvent('chatMessage', '[Repair shop]', {255, 0, 0}, 'You cannot afford it!')
														end
													else
														TriggerEvent('chatMessage', '[Repair shop]', {255, 255, 0}, 'Already installed')
													end
												else
													TriggerEvent('chatMessage', '[Repair shop]', {255, 0, 0}, 'Reach level 30 to unlock this!')
												end
											end
											goto upgrades
										else
											goto main
										end
									else
										TriggerEvent('chatMessage', '[Repair shop]', {255, 0, 0}, 'This is not your vehicle!')
										goto main
									end
								elseif(tempitems[menuresult] == "Buy repair kit ~g~(200$)") then
									if(inv[7] < 10) then
										if(money >= 200) then
											money = money - 200
											SaveStats()
											inv[7] = inv[7] + 1
											SaveInv()
											TriggerEvent('chatMessage', '[Repair shop]', {0, 255, 0}, 'Repair kit purchased')
										else
											TriggerEvent('chatMessage', '[Repair shop]', {255, 0, 0}, 'You do not have enough money!')
										end
									else
										TriggerEvent('chatMessage', '[Repair shop]', {255, 0, 0}, 'Maximum amount reached!')
									end
									goto main
								end
							else
								if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
									tempcar = 0
									if(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i) == plane) then
										for j=1,#planespecs,1 do
											if(GetCarModel(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), _i) == planespecs[j][2]) then
												tempcar = j
											end
										end
									end
									if(tempcar > 0) then
										ChangeCarColour(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), planetuning[tempcar][1], planetuning[tempcar][2])
										SetExtraCarColours(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), planetuning[tempcar][3], planetuning[tempcar][4])
										for j=1,9,1 do
											if(planetuning[tempcar][j+4] == 0) then
												TurnOffVehicleExtra(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), j, true)
											else
												TurnOffVehicleExtra(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), j, false)
											end
										end
										--rgb = {}
										for j=1,3,1 do
											rgb[j] = planetuning[tempcar][13+j]
										end
										--[[if(planetuning[tempcar][21] > 0) then
											SetEngineHealth(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), 2000.1)
											SetPetrolTankHealth(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), 2000.1)
											SetCarHealth(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), 2000)
										end]]
										if(planetuning[tempcar][22] > 0) then
											SetCanBurstCarTyres(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), false)
										end
										if(planetuning[tempcar][23] > 0) then
											SetCarProofs(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), 0, 1, 0, 0, 0)
										end
									end
									DetachCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i))
									FreezeCarPosition(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), false)
								end
							end
						else
							TriggerEvent('chatMessage', '[Repair shop]', {255, 0, 0}, 'You must be in a plane to use it!')
						end
					end
				end
			end
		end
	end
end)