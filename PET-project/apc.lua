local apccoords = {
{-572.83936, -13.51472, 4.81739, 89.9516525268555},
{2218.43066, 367.85641, 17.21117, 272.216217041016}
}
local apczone = {
{{-728.543425, -13.496645, 4.81761}, 192.5009920921274, 39.80283771919912},
{{2248.58191, 367.945435, 17.37999}, 63.43384064544965, 81.78174000147344}
}
local resp = {
{
{-648.77661, -26.01713, 4.81384, 89.4519271850586},
{-648.76642, -2.40273, 4.81549, 88.5244979858398},
{-677.74365, 1.83937, 4.75786, 179.660614013672},
{-677.62616, -28.09333, 4.86839, 358.946716308594},
{-726.64929, 0.16463, 4.85855, 177.662170410156},
{-726.65259, -26.95034, 4.79584, 359.619232177734},
{-787.73511, -0.26881, 4.77454, 178.869735717773},
{-787.96661, -27.00619, 4.66811, 355.113403320313},
{-817.77075, -2.57154, 4.84345, 266.680969238281},
{-817.86548, -26.25548, 4.85472, 270.044250488281}
},
{
{2274.37207, 398.28439, 17.21102, 177.415802001953},
{2224.71899, 398.17654, 17.21102, 179.506942749023},
{2222.5127, 367.91238, 17.21117, 268.843170166016},
{2267.76978, 367.93332, 17.21107, 88.3387908935547},
{2272.198, 337.75305, 17.21106, 359.572540283203},
{2222.76611, 337.77258, 17.21118, 0.189259335398674}
}
}

local kills = 0
local killblocker = {}
for i=0,31,1 do
	killblocker[i] = 0
end

RegisterNetEvent('playerSpawned')
AddEventHandler('playerSpawned', function()
	CreateThread(function()
		if(gamemode == 7) then
			local rnd = GenerateRandomIntInRange(1, #resp[apcid]+1, _i)
			DeleteCar(apc)
			TriggerServerEvent('restartScript', "cleanup")
			Wait(1000)
			apc = SpawnCar(562680400, resp[apcid][rnd][1], resp[apcid][rnd][2], resp[apcid][rnd][3], resp[apcid][rnd][4])
			--SetEngineHealth(apc, 10000.1)
			--SetPetrolTankHealth(apc, 10000.1)
			--SetCarHealth(apc, 2000)
			LockCarDoors(apc, 4)
			--Wait(1000)
			WarpCharIntoCar(GetPlayerChar(GetPlayerId()), apc)
			--Wait(1000)
			--RemoveAllCharWeapons(GetPlayerChar(GetPlayerId()))
			--GiveWeaponToChar(GetPlayerChar(GetPlayerId()), GenerateRandomIntInRange(10, 19, _i), 1000, 1)
		end
	end)
end)

local apcmainblip = {}
local dbblip = {}
local apc = nil
CreateThread(function()
	while true do
		Wait(0)
		for i=1,#apccoords,1 do
			if(not DoesBlipExist(apcmainblip[i])) then
				apcmainblip[i] = AddBlipForCoord(apccoords[i][1], apccoords[i][2], apccoords[i][3], _i)
				ChangeBlipSprite(apcmainblip[i], 76)
				ChangeBlipColour(apcmainblip[i], 1)
				ChangeBlipScale(apcmainblip[i], 0.7)
				ChangeBlipNameFromAscii(apcmainblip[i], "APC Battle " .. i)
				SetBlipAsShortRange(apcmainblip[i], true)
			end
			if(gamemode == 0) then
				DrawTextAtCoord(apccoords[i][1], apccoords[i][2], apccoords[i][3], "APC_Battle_" .. i, 20)
				DrawCheckpointWithDist(apccoords[i][1], apccoords[i][2], apccoords[i][3]-1, 1.1, 255, 255, 0, 100)
				if(IsPlayerNearCoords(apccoords[i][1], apccoords[i][2], apccoords[i][3], 1)) then
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~enter APC battle", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						if(missionstarted == 0) then
							local rnd = GenerateRandomIntInRange(1, #resp[i]+1, _i)
							DeleteCar(apc)
							apc = SpawnCar(562680400, resp[i][rnd][1], resp[i][rnd][2], resp[i][rnd][3], resp[i][rnd][4])
							--SetEngineHealth(apc, 10000.1)
							--SetPetrolTankHealth(apc, 10000.1)
							--SetCarHealth(apc, 2000)
							LockCarDoors(apc, 4)
							WarpCharIntoCar(GetPlayerChar(GetPlayerId()), apc)
							gamemode = 7
							apcid = i
							kills = 0
							RemoveAllCharWeapons(GetPlayerChar(GetPlayerId()))
							--GiveWeaponToChar(GetPlayerChar(GetPlayerId()), GenerateRandomIntInRange(10, 19, _i), 1000, 1)
							TriggerServerEvent('sendMessageToEveryone', '[APC Battle]', '' .. GetPlayerName(GetPlayerId(), _s) .. ' has joined APC Battle ' .. i .. '.')
							TriggerEvent('chatMessage', '[APC Battle]', {255, 255, 0}, 'Be the first who will reach 20 kills to win.')
						else
							TriggerEvent('chatMessage', '[APC Battle]', {255, 0, 0}, 'Mission in progress!')
						end
					end
				end
			end
		end
		if(gamemode == 7) then
			if(not IsPlayerDead(GetPlayerId())) then
				DrawRectLeftTopCenter(0.9, 0.9, 0.08, 0.05, 0, 0, 0, 100)
				SetTextScale(0.200000, 0.4000000)
				SetTextDropshadow(0, 0, 0, 0, 0)
				SetTextEdge(1, 0, 0, 0, 255)
				DisplayTextWithLiteralString(0.91, 0.91, "STRING", "Kills: ~y~" .. kills .. "/10")
			end
			AlterWantedLevel(GetPlayerId(), 0)
			ApplyWantedLevelChangeNow(GetPlayerId())
			for i=1,40,1 do
				if(not DoesBlipExist(dbblip[i])) then
					if(i <= 10) then
						dbblip[i] = AddBlipForCoord(apczone[apcid][1][1]-apczone[apcid][2]/2, apczone[apcid][1][2]-apczone[apcid][3]/2+apczone[apcid][3]/10*i, apczone[apcid][1][3], _i)
					elseif(i>10 and i<=20) then
						dbblip[i] = AddBlipForCoord(apczone[apcid][1][1]+apczone[apcid][2]/2, apczone[apcid][1][2]-apczone[apcid][3]/2+apczone[apcid][3]/10*(i-10), apczone[apcid][1][3], _i)
					elseif(i>20 and i<=30) then
						dbblip[i] = AddBlipForCoord(apczone[apcid][1][1]-apczone[apcid][2]/2+apczone[apcid][2]/10*(i-20), apczone[apcid][1][2]-apczone[apcid][3]/2, apczone[apcid][1][3], _i)
					elseif(i > 30) then
						dbblip[i] = AddBlipForCoord(apczone[apcid][1][1]-apczone[apcid][2]/2+apczone[apcid][2]/10*(i-30), apczone[apcid][1][2]+apczone[apcid][3]/2, apczone[apcid][1][3], _i)
					end
					ChangeBlipScale(dbblip[i], 0.1)
					ChangeBlipSprite(dbblip[i], 3)
					ChangeBlipColour(dbblip[i], 1)
					ChangeBlipNameFromAscii(dbblip[i], "Match zone")
				end
			end
			if(not LocateCharAnyMeans3d(GetPlayerChar(GetPlayerId()), apczone[apcid][1][1], apczone[apcid][1][2], apczone[apcid][1][3]-10, apczone[apcid][2]/2, apczone[apcid][3]/2, 100.1, false)) then
				PrintStringWithLiteralStringNow("STRING", "~r~Go back into match zone!", 1000, 1)
				DamageChar(GetPlayerChar(GetPlayerId()), 10, 0)
				Wait(1000)
			end
		else
			for i=1,40,1 do
				if(DoesBlipExist(dbblip[i])) then
					RemoveBlip(dbblip[i])
				end
			end
			if(not IsCarDead(apc)) then
				DeleteCar(apc)
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if(gamemode == 7) then
			for i=0,31,1 do
				if(IsNetworkPlayerActive(i)) then
					if(IsPlayerDead(i)) then
						if(ConvertIntToPlayerindex(i) ~= ConvertIntToPlayerindex(GetPlayerId())) then
							if(killblocker[i] == 0) then
								if(FindNetworkKillerOfPlayer(i) == GetPlayerId()) then
									--if(not IsCarDead(apc)) then
									--	FixCar(apc)
									--end
									if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
										FixCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())))
									end
									kills = kills + 1
									TriggerServerEvent('sendMessageForGamemode', gamemode, gmid, '', '^1' .. GetPlayerName(i, _s) .. '^0 got killed by ^1' .. GetPlayerName(GetPlayerId(), _s))
									local px,py,pz = GetCharCoordinates(GetPlayerChar(i))
									DrawSignal(px, py, pz, "+200$ +75EXP")
									money = money + 100
									experience = experience + 50
									SaveStats()
									if(kills ~= 10) then
										if(kills%5 == 0) then
											TriggerServerEvent('sendMessageForGamemode', gamemode, gmid, '', '^1' .. GetPlayerName(GetPlayerId(), _s) .. '^0 has reached ^1' .. kills .. '^0 kills!')
										end
									else
										local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
										DrawSignalAttached("+8000$ +400EXP")
										money = money + 8000
										experience = experience + 400
										SaveStats()
										TriggerServerEvent('sendMessageForGamemode', gamemode, gmid, '', '^1' .. GetPlayerName(GetPlayerId(), _s) .. '^0 has won the round! (+8000$/+400 EXP)')
										TriggerServerEvent('finishRound', 7, apcid)
									end
								end
								killblocker[i] = 1
							end
						end
					else
						killblocker[i] = 0
					end
				end
			end
		end
	end
end)

RegisterNetEvent('finishRound')
AddEventHandler('finishRound', function(id, modeid)
	if(gamemode == id) then
		if(id == 7) then
			if(apcid == modeid) then
				kills = 0
				gamemode = 0
				--DeleteCar(apc)
				if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
					DeleteCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())))
				end
				SetCharCoordinates(GetPlayerChar(GetPlayerId()), apccoords[apcid][1], apccoords[apcid][2], apccoords[apcid][3])
				RemoveAllCharWeapons(GetPlayerChar(GetPlayerId()))
				for i=1,8,1 do
					GiveWeaponToChar(GetPlayerChar(GetPlayerId()), weps[i][1], weps[i][2], 1)
				end
			end
		end
	end
end)