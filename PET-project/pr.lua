local prcoords = {
{{245.37164, -705.11041, 4.95597, 58.2442855834961}, {216.95587, -702.38885, 4.95417, 148.615341186523}},
{{1433.75598, 1705.16309, 16.70929, 85.8973541259766}, {1414.7041, 1692.81042, 16.70914, 178.844299316406}},
{{-1252.71118, -552.43097, 2.87905, 357.115051269531}, {-1261.30432, -524.00049, 2.95553, 88.6528930664063}}
}
local check = 0
local checks = {
{
{-363.6123, -157.35989, 14.6835, 0.851987183094025},
{-49.2877, 620.72009, 14.71336, 358.548065185547},
{-263.00586, 1581.48621, 20.46971, 266.650115966797},
{967.16064, 1914.79517, 23.03574, 269.369750976563}
},
{
{1334.25952, 972.99823, 13.58943, 128.942504882813},
{1809.16663, 620.26685, 28.98873, 178.899719238281},
{1102.57446, -71.00346, 36.3031, 178.452682495117},
{7.93727, -567.96887, 14.76787, 178.904724121094}
},
{
{-1662.02051, 558.1134, 26.42106, 347.853851318359},
{-1095.4502, 1113.31128, 13.72357, 358.301635742188},
{-151.05048, 1341.33179, 20.47754, 87.6926803588867}
}
}

local restimer = 0
local prmainblip = {}
local prblip = {}
CreateThread(function()
	while true do
		Wait(0)
		for i=1,#prcoords,1 do
			if(not DoesBlipExist(prmainblip[i])) then
				prmainblip[i] = AddBlipForCoord(prcoords[i][1][1], prcoords[i][1][2], prcoords[i][1][3], _i)
				ChangeBlipSprite(prmainblip[i], 65)
				ChangeBlipScale(prmainblip[i], 0.7)
				ChangeBlipNameFromAscii(prmainblip[i], "Pursuit Race " .. i)
				SetBlipAsShortRange(prmainblip[i], true)
			end
			if(gamemode == 0) then
				DrawTextAtCoord(prcoords[i][1][1], prcoords[i][1][2], prcoords[i][1][3], "Pursuit_Race_" .. i, 20)
				DrawCheckpointWithAlpha(prcoords[i][1][1], prcoords[i][1][2], prcoords[i][1][3]-1, 10.1, 255, 255, 0, 100)
				if(IsPlayerNearCoords(prcoords[i][1][1], prcoords[i][1][2], prcoords[i][1][3], 5)) then
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~start pursuit race", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						if(missionstarted == 0) then
							if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
								if(GetDriverOfCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), _i) == GetPlayerChar(GetPlayerId())) then
									local racers = {}
									for j=0,31,1 do
										if(IsNetworkPlayerActive(j)) then
											if(IsSpecificPlayerNearCoords(j, prcoords[i][1][1], prcoords[i][1][2], prcoords[i][1][3], 5)) then
												if(IsCharInAnyCar(GetPlayerChar(j, _i))) then
													if(GetDriverOfCar(GetCarCharIsUsing(GetPlayerChar(j, _i), _i), _i) == GetPlayerChar(j, _i)) then
														racers[#racers+1] = j
													end
												end
											end
										end
									end
									if(#racers >= 2) then
										for k=1,#racers,1 do
											local step = 0
											for j=3,33,3 do
												if(k > j) then
													step = step + 1
												end
											end
											if(k==1 or k==4 or k==7 or k==10 or k==13 or k==16 or k==19 or k==22 or k==25 or k==28 or k==31) then
												TriggerServerEvent('setPlayerPos', racers[k], prcoords[i][2][1]+5*step*math.cos((prcoords[i][2][4]-90)*math.pi/180), prcoords[i][2][2]+5*step*math.sin((prcoords[i][2][4]-90)*math.pi/180), prcoords[i][2][3], prcoords[i][2][4])
											elseif(k==2 or k==5 or k==8 or k==11 or k==14 or k==17 or k==20 or k==23 or k==26 or k==29 or k==32) then
												TriggerServerEvent('setPlayerPos', racers[k], prcoords[i][2][1]+5*step*math.cos((prcoords[i][2][4]-90)*math.pi/180)+3*math.cos((prcoords[i][2][4]+180)*math.pi/180), prcoords[i][2][2]+5*step*math.sin((prcoords[i][2][4]-90)*math.pi/180)+3*math.sin((prcoords[i][2][4]+180)*math.pi/180), prcoords[i][2][3], prcoords[i][2][4])
											elseif(k==3 or k==6 or k==9 or k==12 or k==15 or k==18 or k==21 or k==24 or k==27 or k==30 or k==33) then
												TriggerServerEvent('setPlayerPos', racers[k], prcoords[i][2][1]+5*step*math.cos((prcoords[i][2][4]-90)*math.pi/180)+3*math.cos((prcoords[i][2][4]-0)*math.pi/180), prcoords[i][2][2]+5*step*math.sin((prcoords[i][2][4]-90)*math.pi/180)+3*math.sin((prcoords[i][2][4]-0)*math.pi/180), prcoords[i][2][3], prcoords[i][2][4])
											end
											TriggerServerEvent('startPursuitRace', i, racers[k])
										end
									else
										TriggerEvent('chatMessage', '[Pursuit Race]', {255, 0, 0}, 'There must be at least 2 players in the circle to start race!')
									end
								else
									TriggerEvent('chatMessage', '[Pursuit Race]', {255, 0, 0}, 'You must be a driver of this car to start race!')
								end
							else
								TriggerEvent('chatMessage', '[Pursuit Race]', {255, 0, 0}, 'You must be in a car to start race!')
							end
						else
							TriggerEvent('chatMessage', '[Deathmatch]', {255, 0, 0}, 'Mission in progress!')
						end
					end
				end
			end
		end
		if(gamemode == 4) then
			AlterWantedLevel(GetPlayerId(), 6)
			ApplyWantedLevelChangeNow(GetPlayerId())
			if(not IsPlayerDead(GetPlayerId())) then
				if(IsPlayerControlOn(GetPlayerId())) then
					if(not IsGameKeyboardKeyPressed(19)) then
						DrawRectLeftTopCenter(0.9, 0.9, 0.08, 0.05, 0, 0, 0, 100)
						SetTextScale(0.1500000, 0.4000000)
						SetTextDropshadow(0, 0, 0, 0, 0)
						SetTextEdge(1, 0, 0, 0, 255)
						DisplayTextWithLiteralString(0.905, 0.91, "STRING", "Checkpoint: ~y~" .. check .. "/" .. #checks[prid])
					end
					if(IsGameKeyboardKeyPressed(19)) then
						if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
							DrawRectLeftTopCenter(0.9, 0.9, 0.05, 0.02, 0, 0, 0, 100)
							DrawRectLeftTopCenter(0.9, 0.9, 0.05/100*restimer, 0.02, 0, 0, 100, 255)
							SetTextScale(0.1500000, 0.3000000)
							SetTextDropshadow(0, 0, 0, 0, 0)
							SetTextEdge(1, 0, 0, 0, 255)
							DisplayTextWithLiteralString(0.9, 0.87, "STRING", "Hold ~y~R ~w~to ~y~respawn")
						else
							SetTextScale(0.1500000, 0.3000000)
							SetTextDropshadow(0, 0, 0, 0, 0)
							SetTextEdge(1, 0, 0, 0, 255)
							DisplayTextWithLiteralString(0.9, 0.87, "STRING", "~y~You must be in a car")
						end
					else
						restimer = 0
					end
				end
			else
				RemoveBlip(prblip[1])
				gamemode = 0
				TriggerEvent('chatMessage', '[Pursuit Race]', {255, 0, 0}, 'You are dead. Race failed!')
				while IsPlayerDead(GetPlayerId()) do
					Wait(0)
				end
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if(gamemode == 4) then
			if(IsGameKeyboardKeyPressed(19)) then
				if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
					if(IsPlayerControlOn(GetPlayerId())) then
						restimer = restimer + 1
						if(restimer >= 100) then
							if(check > 1) then
								SetCarCoordinates(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), checks[prid][check-1][1], checks[prid][check-1][2], checks[prid][check-1][3])
								SetCarHeading(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), checks[prid][check-1][4])
								SetCarOnGroundProperly(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i))
								FixCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i))
							else
								SetCarCoordinates(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), prcoords[prid][2][1], prcoords[prid][2][2], prcoords[prid][2][3])
								SetCarHeading(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i), prcoords[prid][2][4])
								SetCarOnGroundProperly(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i))
								FixCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId()), _i))
							end
							restimer = 0
						end
						--Wait(3)
					end
				end
			end
		end
	end
end)

local racepos = 1
local count = 0
RegisterNetEvent('startPursuitRace')
AddEventHandler('startPursuitRace', function(rid, id)
	CreateThread(function()
		if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
			TriggerServerEvent('sendMessageToEveryone', '[Pursuit Race]', '' .. GetPlayerName(GetPlayerId(), _s) .. ' has joined Pursuit Race ' .. rid .. '.')
			check = 0
			gamemode = 4
			prid = rid
			racepos = 1
			RemoveAllCharWeapons(GetPlayerChar(GetPlayerId()))
			--[[SetPlayerControl(GetPlayerId(), false)
			count = 3
			Wait(1000)
			count = 2
			Wait(1000)
			count = 1
			Wait(1000)
			count = -1
			SetPlayerControl(GetPlayerId(), true)]]
			StartCountdown()
			check = 1
			--Wait(1000)
			--count = 0
		end
	end)
end)

CreateThread(function()
	while true do
		Wait(0)
		if(count > 0) then
			DrawRectLeftTopCenter(0.45, 0.3, 0.1, 0.15, 0, 0, 0, 100)
			SetTextScale(0.500000, 1.0000000)
			SetTextDropshadow(0, 0, 0, 0, 0)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextFont(4)
			SetTextCentre(1)
			DisplayTextWithLiteralString(0.5, 0.34, "STRING", "~r~" .. count)
		elseif(count == -1) then
			DrawRectLeftTopCenter(0.45, 0.3, 0.1, 0.15, 0, 0, 0, 100)
			SetTextScale(0.400000, 0.8000000)
			SetTextDropshadow(0, 0, 0, 0, 0)
			SetTextEdge(1, 0, 0, 0, 255)
			SetTextFont(4)
			SetTextCentre(1)
			DisplayTextWithLiteralString(0.5, 0.34, "STRING", "~r~GO")
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if(gamemode == 4) then
			if(check > 0) then
				if(not DoesBlipExist(prblip[1])) then
					prblip[1] = AddBlipForCoord(checks[prid][check][1], checks[prid][check][2], checks[prid][check][3], _i)
					if(check == #checks[prid]) then
						--ChangeBlipSprite(prblip[1], 65)
						--ChangeBlipScale(prblip[1], 0.5)
					end
				end
				DrawCheckpointWithAlpha(checks[prid][check][1], checks[prid][check][2], checks[prid][check][3]-1, 3.1, 0, 0, 255, 100)
				--[[if(checks[prid][check+1] ~= nil) then
					if(not DoesBlipExist(prblip[2])) then
						prblip[2] = AddBlipForCoord(checks[prid][check+1][1], checks[prid][check+1][2], checks[prid][check+1][3], _i)
						if(check+1 == #checks[prid]) then
							ChangeBlipSprite(prblip[2], 65)
							ChangeBlipScale(prblip[2], 0.5)
						end
					end
					DrawCheckpointWithAlpha(checks[prid][check+1][1], checks[prid][check+1][2], checks[prid][check+1][3]-1, 3.1, 0, 0, 255, 50)
				end]]
				if(IsPlayerNearCoords(checks[prid][check][1], checks[prid][check][2], checks[prid][check][3], 5)) then
					RemoveBlip(prblip[1])
					--RemoveBlip(prblip[2])
					if(check ~= #checks[prid]) then
						check = check + 1
						local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
						DrawSignalAttached("+100$ +50EXP")
						money = money + 100
						experience = experience + 50
						SaveStats()
						--TriggerEvent('chatMessage', '', {0, 255, 0}, '+100$/+50 EXP')
					else
						local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
						DrawSignalAttached("+" .. math.floor(4000/racepos) .. "$ +" .. math.floor(250/racepos) .. "EXP")
						money = money + math.floor(4500/racepos)
						experience = experience + math.floor(250/racepos)
						SaveStats()
						TriggerServerEvent('sendMessageForGamemode', gamemode, gmid, '', '^1' .. GetPlayerName(GetPlayerId(), _s) .. '^0 has finished ' .. racepos .. '! (+' .. math.floor(4500/racepos) .. '$/' .. math.floor(250/racepos) .. ' EXP)')
						TriggerServerEvent('finishRound', 4, prid)
						Wait(5000)
						gamemode = 0
						AlterWantedLevel(GetPlayerId(), 0)
						ApplyWantedLevelChangeNow(GetPlayerId())
						RemoveAllCharWeapons(GetPlayerChar(GetPlayerId()))
						for i=1,8,1 do
							GiveWeaponToChar(GetPlayerChar(GetPlayerId()), weps[i][1], weps[i][2], 1)
						end
					end
				end
			end
		else
			RemoveBlip(prblip[1])
		end
	end
end)

RegisterNetEvent('finishRound')
AddEventHandler('finishRound', function(id, modeid)
	if(gamemode == id) then
		if(id == 4) then
			if(prid == modeid) then
				racepos = racepos + 1
				--gamemode = 0
			end
		end
	end
end)