local currmission = 0
local currstage = 0
local EndMission = function()
	currmission = 0
	currstage = 0
	CleanMission()
end
local tempcar = nil

local cafecoords = {
{-1572.75037, 461.73026, 24.9496, 239.948699951172},
{-330.04291, 1394.24402, 12.41896, 269.362274169922},
{966.72644, -174.15999, 23.69951, 105.562049865723}
}

druginv = {}
for i=1,6,1 do
	druginv[i] = 0
end

RegisterNetEvent('updDrugs')
AddEventHandler('updDrugs', function(data)
	for i=1,#druginv,1 do
		if(data[i] == nil) then
			data[i] = 0
		end
		druginv[i] = tonumber(data[i])
	end
end)

SaveDrugs = function()
	local data = {}
	for i=1,#druginv,1 do
		data[i] = druginv[i]
	end
	TriggerServerEvent('saveDrugs', data)
end

local drugcooldown = 0
local guncooldown = 0
CreateThread(function()
	while true do
		Wait(1000)
		if(drugcooldown > 0) then
			drugcooldown = drugcooldown - 1
		end
		if(guncooldown > 0) then
			guncooldown = guncooldown - 1
		end
	end
end)

local drugprices = {
700, --heroin
850, --coke
200, --ecstasy
250, --acid
100, --weed
70 --downers
}
local drugvariation = {
{"Downers", "Acid"},
{"Coke", "Ecstasy"},
{"Acid", "Ecstasy"},
{"Weed", "Downers"},
{"Heroin", "Acid"},
{"Ecstasy", "Coke"},
{"Downers", "Ecstasy"},
{"Downers", "Heroin"}
}

local wepitems = {
"Weapon",
"Ammo",
"Explosive"
}
local wepprices = {
500,
300,
1000
}
local wepamounts = {}
for i=1,#wepitems,1 do
	wepamounts[i] = 0
end

local cafeblip = {}
CreateThread(function()
	while true do
		Wait(0)
		for i=1,#cafecoords,1 do
			if(not DoesBlipExist(cafeblip[i])) then
				cafeblip[i] = AddBlipForCoord(cafecoords[i][1], cafecoords[i][2], cafecoords[i][3], _i)
				ChangeBlipSprite(cafeblip[i], 24)
				ChangeBlipScale(cafeblip[i], 0.7)
				--ChangeBlipColour(cafeblip[i], 19)
				ChangeBlipNameFromAscii(cafeblip[i], "Internet cafe")
				SetBlipAsShortRange(cafeblip[i], true)
			end
			DrawTextAtCoord(cafecoords[i][1], cafecoords[i][2], cafecoords[i][3], "Internet", 20)
			DrawCheckpointWithDist(cafecoords[i][1], cafecoords[i][2], cafecoords[i][3]-1, 1.1, 255, 255, 0, 100)
			if(IsPlayerNearCoords(cafecoords[i][1], cafecoords[i][2], cafecoords[i][3], 1)) then
				PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~open menu", 1000, 1)
				if(IsGameKeyboardKeyJustPressed(18)) then
					if(org > 0) then
						local bizes = 0
						for j=1,#biz,1 do
							if(biz[j] == 1) then
								bizes = bizes + 1
							end
						end
						if(bizes >= 2) then
							tempitems = {}
							tempitems[#tempitems+1] = "Find drug dealer"
							tempitems[#tempitems+1] = "Start gunrunning"
							DrawWindow("Internet", tempitems)
							while menuactive do
								Wait(0)
								if(currbutton == 1) then
									DrawDescription("Drug dealing", {
									---------------------------------------------------------------------------------------------------
									"Find a drug dealer to buy/sell drugs. Each dealer sells a specific drug and buys a specific drug.",
									"You can get great profits when you sell great amount of drugs at once, so it makes sense to",
									"collect drugs of the same type.",
									"Tip: To check your current amount of drugs, use player menu."
									})
								elseif(currbutton == 2) then
									DrawDescription("Gunrunning", {
									---------------------------------------------------------------------------------------------------
									"Find a supplier to buy ammunition. After that visit 3 clients and sell your stuff to them. Each",
									"client has specific ammunition needs and will buy only specific stuff. So there is no guarantee",
									"that you will manage to sell all your stuff.",
									"Tip: You must own at least one van to start this job. You can interact with supplier and clients",
									"only using your van."
									})
								end
							end
							if(menuresult > 0) then
								if(tempitems[menuresult] == "Find drug dealer") then
									if(missionstarted == 0) then
										if(drugcooldown == 0) then
											if(IsCharDead(peds[1])) then
												var = GenerateRandomIntInRange(1, #drugvariation+1)
												var2 = GenerateRandomIntInRange(1, 11)
												var3 = 0
												local rx,ry,rz,rh = GetRandomNodeInRadius(GenerateRandomIntInRange(100, 3000))
												peds[1] = SpawnPed(GetHashKey("M_Y_DEALER"), rx, ry, rz, rh)
												SetCharInvincible(peds[1], true)
												blips[1] = AddBlipForChar(peds[1])
												ChangeBlipNameFromAscii(blips[1], "Dealer")
												if(clan ~= "0") then
													for j=1,#areacoords,1 do
														if(areaowners[j] == clan) then
															if(rx>areacoords[j][1]-100 and rx<areacoords[j][1]+100) then
																if(ry>areacoords[j][2]-100 and ry<areacoords[j][2]+100) then
																	var3 = 1
																end
															end
														end
													end
												end
												TriggerEvent('chatMessage', '[Internet]', {0, 255, 0}, 'Drug dealer has been located on the map.')
											else
												TriggerEvent('chatMessage', '[Internet]', {255, 0, 0}, 'Drug dealer has been already found!')
											end
										else
											TriggerEvent('chatMessage', '[Internet]', {255, 0, 0}, 'Currently you cannot search for a dealer. Wait for ' .. drugcooldown .. ' seconds.')
										end
									else
										TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'Mission in progress!')
									end
								elseif(tempitems[menuresult] == "Start gunrunning") then
									if(guncooldown == 0) then
										local tempamount = 0
										for j=1,#vehs,1 do
											if(vehs[j] == 1) then
												if(carnames[j] == "Burrito" or
												carnames[j] == "Moonbeam" or
												carnames[j] == "Pony" or
												carnames[j] == "Slamvan") then
													tempamount = tempamount + 1
												end
											end
										end
										if(tempamount > 0) then
											if(missionstarted == 0) then
												coords = {
												{-1185.1344, 1463.94446, 21.05077, 267.596527099609},
												{-1839.9281, 151.78607, 15.01167, 285.279907226563},
												{11.96769, -692.96643, 9.40575, 357.043823242188},
												{79.94794, 787.28229, 20.16056, 87.8648834228516},
												{850.92987, 1472.91199, 14.1987, 178.791381835938},
												{1262.99475, 429.50653, 23.6039, 358.569244384766},
												{1137.97498, -537.97272, 13.5382, 91.8314361572266}
												}
												local rnd = GenerateRandomIntInRange(1, #coords+1)
												for i=1,#wepitems,1 do
													wepamounts[i] = 0
												end
												blips[1] = AddBlipForCoord(coords[rnd][1], coords[rnd][2], coords[rnd][3])
												SetRoute(blips[1], true)
												SetObjective("Reach ~y~the marked point ~w~on ~y~a van ~w~and ~y~make a deal")
												TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Gunrunning started!')
												currmission = 1
												missionstarted = 1
											else
												TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'Mission in progress!')
											end
										else
											TriggerEvent('chatMessage', '[Gunrunning]', {255, 0, 0}, 'You must own a van to start this job!')
										end
									else
										TriggerEvent('chatMessage', '[Internet]', {255, 0, 0}, 'Currently you cannot start gunrunning. Wait for ' .. guncooldown .. ' seconds.')
									end
								end
							end
						else
							TriggerEvent('chatMessage', '[Internet]', {255, 0, 0}, 'You must own at least 2 businesses to use it (Needed for doing illegal business).')
						end
					else
						TriggerEvent('chatMessage', '[Internet]', {255, 0, 0}, 'You must own an organization to use it (Needed for doing illegal business).')
					end
				end
			end
		end
	end
end)

function GetDrugId(name)
	if(name == "Heroin") then
		return 1
	elseif(name == "Coke") then
		return 2
	elseif(name == "Ecstasy") then
		return 3
	elseif(name == "Acid") then
		return 4
	elseif(name == "Weed") then
		return 5
	elseif(name == "Downers") then
		return 6
	end
end

function GeometricalProgression(base, denominator, steps)
	for i=2,steps,1 do
		base = base*denominator
	end
	return base
end

CreateThread(function()
	while true do
		Wait(0)
		if(missionstarted == 0) then
			if(not IsCharDead(peds[1])) then
				local px,py,pz = GetCharCoordinates(peds[1])
				if(IsPlayerNearCoords(px, py, pz, 3)) then
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~deal", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						::main::
						local drugid = GetDrugId(drugvariation[var][1])
						local drugid2 = GetDrugId(drugvariation[var][2])
						tempitems = {}
						if(var3 == 0) then
							tempitems[#tempitems+1] = "Buy " .. drugvariation[var][1] .. " - ~g~" .. drugprices[drugid] .. "$ ~y~(" .. var2 .. " left)"
						else
							tempitems[#tempitems+1] = "Buy " .. drugvariation[var][1] .. " - ~g~" .. math.floor(drugprices[drugid]/2) .. "$ ~y~(" .. var2 .. " left)"
						end
						tempitems[#tempitems+1] = "Sell " .. drugvariation[var][2]
						tempitems[#tempitems+1] = "Finish deal"
						DrawWindow("Dealer", tempitems)
						while menuactive do
							Wait(0)
						end
						if(menuresult > 0) then
							--if(tempitems[menuresult] == "Buy " .. drugvariation[var][1] .. " ~y~(" .. var2 .. " left)") then
							if(menuresult == 1) then
								if(var2 > 0) then
									local drugid = GetDrugId(drugvariation[var][1])
									local drugprice = drugprices[drugid]
									if(var3 == 1) then
										drugprice = math.floor(drugprice/2)
									end
									if(money >= drugprice) then
										money = money - drugprice
										SaveStats()
										druginv[drugid] = druginv[drugid] + 1
										SaveDrugs()
										var2 = var2 - 1
										TriggerEvent('chatMessage', '[Dealer]', {255, 255, 0}, '' .. drugvariation[var][1] .. ' purchased.')
									else
										TriggerEvent('chatMessage', '[Dealer]', {255, 0, 0}, 'You cannot afford it!')
									end
								else
									TriggerEvent('chatMessage', '[Dealer]', {255, 0, 0}, 'No drugs left!')
								end
								goto main
							--elseif(tempitems[menuresult] == "Sell " .. drugvariation[var][2]) then
							elseif(menuresult == 2) then
								local drugid = GetDrugId(drugvariation[var][2])
								if(druginv[drugid] > 0) then
									local finalmoney = math.floor(drugprices[drugid]*druginv[drugid]+GeometricalProgression(drugprices[drugid]/100, 2, druginv[drugid])/1000)
									money = money + finalmoney
									SaveStats()
									TriggerEvent('chatMessage', '[Dealer]', {0, 255, 0}, 'You have successfully sold ' .. druginv[drugid] .. ' ' .. drugvariation[var][2] .. ' for ' .. finalmoney .. '$!')
									druginv[drugid] = 0
									SaveDrugs()
								else
									TriggerEvent('chatMessage', '[Dealer]', {255, 0, 0}, 'You have nothing to sell!')
								end
								goto main
							--elseif(tempitems[menuresult] == "Finish deal") then
							elseif(menuresult == 3) then
								DeleteChar(peds[1])
								drugcooldown = GenerateRandomIntInRange(300, 420)
								TriggerEvent('chatMessage', '[Dealer]', {255, 255, 0}, 'The deal has been finished.')
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
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 3)) then
						if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
							if(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())) == car) then
								if(IsCarModel(car, GetHashKey("burrito")) or 
								IsCarModel(car, GetHashKey("moonbeam")) or 
								IsCarModel(car, GetHashKey("pony")) or 
								IsCarModel(car, GetHashKey("slamvan"))) then
									PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~deal", 1000, 1)
									if(IsGameKeyboardKeyJustPressed(18)) then
										::main2::
										local tempitems = {}
										for i=1,#wepitems,1 do
											tempitems[#tempitems+1] = "Buy " .. wepitems[i] .. " - ~g~" .. wepprices[i] .. "$ ~y~(".. wepamounts[i] .. ")"
										end
										tempitems[#tempitems+1] = "Finish deal"
										DrawWindow("Supplier", tempitems)
										while menuactive do
											Wait(0)
										end
										if(menuresult > 0) then
											for i=1,#wepitems,1 do
												if(menuresult == i) then
													if(wepamounts[i] < 10) then
														if(money >= wepprices[i]) then
															money = money - wepprices[i]
															SaveStats()
															wepamounts[i] = wepamounts[i] + 1
															TriggerEvent('chatMessage', '[Supplier]', {0, 255, 0}, '' .. wepitems[i] .. ' purchased.')
														else
															TriggerEvent('chatMessage', '[Supplier]', {255, 0, 0}, 'You cannot afford it!')
														end
													else
														TriggerEvent('chatMessage', '[Supplier]', {255, 0, 0}, 'Maximum amount reached!')
													end
													goto main2
												end
											end
											--if(menuresult == #tempitems) then
											if(tempitems[menuresult] == "Finish deal") then
												RemoveBlip(blips[1])
												vars = {}
												for i=1,3,1 do
													local rx,ry,rz,rh = GetRandomNodeInRadius(GenerateRandomIntInRange(500, 1000))
													peds[i] = SpawnPed(GetHashKey("M_M_GUNNUT_01"), rx, ry, rz, rh)
													blips[i] = AddBlipForChar(peds[i])
													SetCharInvincible(peds[i], true)
													vars[i] = {}
													for j=1,#wepitems,1 do
														vars[i][j] = GenerateRandomIntInRange(0, 6)
													end
												end
												tempcar = GetCarCharIsUsing(GetPlayerChar(GetPlayerId()))
												SetObjective("Sell your ammunition to ~y~clients ~w~(~y~0/3~w~)")
												currstage = 1
											end
										end
									end
								else
									PrintStringWithLiteralStringNow("STRING", "You must be in a van!", 1000, 1)
								end
							else
								PrintStringWithLiteralStringNow("STRING", "You must be your car!", 1000, 1)
							end
						else
							PrintStringWithLiteralStringNow("STRING", "You must be in a vehicle!", 1000, 1)
						end
					end
				elseif(currstage == 1) then
					if(IsCarDead(tempcar)) then
						tempcar = nil
						TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'Van destroyed. Mission failed!')
						EndMission()
					else
						local dealsfinished = 0
						for i=1,3,1 do
							if(not IsCharDead(peds[i])) then
								local px,py,pz = GetCharCoordinates(peds[i])
								if(IsPlayerNearCoords(px, py, pz, 3)) then
									if(IsCharInCar(GetPlayerChar(GetPlayerId()), tempcar)) then
										PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~deal", 1000, 1)
										if(IsGameKeyboardKeyJustPressed(18)) then
											::main3::
											local tempitems = {}
											for j=1,#vars,1 do
												tempitems[#tempitems+1] = "Sell " .. wepitems[j] .. " ~y~(".. vars[i][j] .. " needed / " .. wepamounts[j] .. " left)"
											end
											tempitems[#tempitems+1] = "Finish deal"
											DrawWindow("Supplier", tempitems)
											while menuactive do
												Wait(0)
											end
											if(menuresult > 0) then
												for j=1,#wepitems,1 do
													if(menuresult == j) then
														if(vars[i][j] > 0) then
															if(wepamounts[j] > 0) then
																local finalmoney = wepprices[j]*2
																money = money + finalmoney
																SaveStats()
																wepamounts[j] = wepamounts[j] - 1
																vars[i][j] = vars[i][j] - 1
																TriggerEvent('chatMessage', '[Client]', {0, 255, 0}, '' .. wepitems[j] .. ' has been sold for ' .. finalmoney .. '$')
															else
																TriggerEvent('chatMessage', '[Client]', {255, 0, 0}, 'You ran out of ' .. wepitems[j] .. '!')
															end
														else
															TriggerEvent('chatMessage', '[Client]', {255, 0, 0}, '' .. wepitems[j] .. ' is not needed!')
														end
														goto main3
													end
												end
												--if(menuresult == #tempitems) then
												if(tempitems[menuresult] == "Finish deal") then
													RemoveBlip(blips[i])
													DeleteChar(peds[i])
													TriggerEvent('chatMessage', '[Client]', {255, 255, 0}, 'The deal with this client has been finished.')
												end
											end
										end
									else
										PrintStringWithLiteralStringNow("STRING", "You must be in the van!", 1000, 1)
									end
								end
							else
								dealsfinished = dealsfinished + 1
							end
						end
						SetObjective("Sell your ammunition to ~y~clients ~w~(~y~" .. dealsfinished .. "/3~w~)")
						if(dealsfinished == 3) then
							guncooldown = GenerateRandomIntInRange(300, 420)
							TriggerEvent('chatMessage', '[Gunrunning]', {0, 255, 0}, 'Gunrunning has been finished!')
							tempcar = nil
							EndMission()
						end
					end
				end
			end
			if(IsPlayerDead(GetPlayerId())) then
				TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'You have died. Mission failed!')
				EndMission()
			end
		end
	end
end)