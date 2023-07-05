local dbcoords = {
{1593.30774, 901.17218, 16.15937, 234.308013916016}
}
local dbzone = {
{{1635.08392, 879.785, 16.103415}, 80.1, 80.1}
}
local resp = {
{
{1635.88611, 902.28546, 15.84847, 182.100479125977},
{1664.34058, 882.09863, 15.84812, 104.533935546875},
{1653.75342, 853.01337, 15.84812, 37.5528984069824},
{1616.46008, 858.24835, 15.84786, 307.227325439453},
{1611.41504, 885.2984, 15.84786, 252.313354492188}
}
}
local lootcoords = {
{
{1630.12537, 887.14435, 15.84847, 219.025421142578},
{1651.60742, 871.80695, 15.84811, 71.0041656494141},
{1632.64893, 860.67938, 15.84786, 335.584991455078},
{1611.02161, 853.8996, 15.84786, 308.036468505859},
{1607.73669, 891.77655, 15.84786, 239.388488769531},
{1628.99084, 848.29517, 15.84786, 65.4210815429688},
{1656.11768, 897.61975, 15.84847, 141.244842529297}
}
}
local lootstate = {}
for i=1,#dbcoords,1 do
	lootstate[i] = {}
end
local lootblip = {}
for i=1,#dbcoords,1 do
	lootblip[i] = {}
end

local kills = 0
local killblocker = {}
for i=0,31,1 do
	killblocker[i] = 0
end

local dbcar = nil
RegisterNetEvent('playerSpawned')
AddEventHandler('playerSpawned', function()
	CreateThread(function()
		if(gamemode == 6) then
			local rnd = GenerateRandomIntInRange(1, #resp[dbid]+1, _i)
			local models = {
			"sabre2",
			"vigero2",
			"emperor2"
			}
			DeleteCar(dbcar)
			TriggerServerEvent('restartScript', "cleanup")
			Wait(1000)
			dbcar = SpawnCar(GetHashKey(models[GenerateRandomIntInRange(1, #models+1)]), resp[dbid][rnd][1], resp[dbid][rnd][2], resp[dbid][rnd][3], resp[dbid][rnd][4])
			SetEngineHealth(dbcar, 10000.1)
			SetPetrolTankHealth(dbcar, 10000.1)
			SetCarHealth(dbcar, 2000)
			LockCarDoors(dbcar, 4)
			--Wait(1000)
			WarpCharIntoCar(GetPlayerChar(GetPlayerId()), dbcar)
			--Wait(1000)
			--RemoveAllCharWeapons(GetPlayerChar(GetPlayerId()))
			--GiveWeaponToChar(GetPlayerChar(GetPlayerId()), GenerateRandomIntInRange(10, 19, _i), 1000, 1)
		end
	end)
end)

local dbmainblip = {}
local dbblip = {}
CreateThread(function()
	while true do
		Wait(0)
		for i=1,#dbcoords,1 do
			if(not DoesBlipExist(dbmainblip[i])) then
				dbmainblip[i] = AddBlipForCoord(dbcoords[i][1], dbcoords[i][2], dbcoords[i][3], _i)
				ChangeBlipSprite(dbmainblip[i], 79)
				ChangeBlipColour(dbmainblip[i], 1)
				ChangeBlipScale(dbmainblip[i], 0.7)
				ChangeBlipNameFromAscii(dbmainblip[i], "Derby " .. i)
				SetBlipAsShortRange(dbmainblip[i], true)
			end
			if(gamemode == 0) then
				DrawTextAtCoord(dbcoords[i][1], dbcoords[i][2], dbcoords[i][3], "Derby_" .. i, 20)
				DrawCheckpointWithDist(dbcoords[i][1], dbcoords[i][2], dbcoords[i][3]-1, 1.1, 255, 255, 0, 100)
				if(IsPlayerNearCoords(dbcoords[i][1], dbcoords[i][2], dbcoords[i][3], 1)) then
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~enter derby", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						if(missionstarted == 0) then
							local rnd = GenerateRandomIntInRange(1, #resp[i]+1, _i)
							local models = {
							"sabre2",
							"vigero2",
							"emperor2"
							}
							DeleteCar(dbcar)
							dbcar = SpawnCar(GetHashKey(models[GenerateRandomIntInRange(1, #models+1)]), resp[i][rnd][1], resp[i][rnd][2], resp[i][rnd][3], resp[i][rnd][4])
							SetEngineHealth(dbcar, 10000.1)
							SetPetrolTankHealth(dbcar, 10000.1)
							SetCarHealth(dbcar, 2000)
							LockCarDoors(dbcar, 4)
							WarpCharIntoCar(GetPlayerChar(GetPlayerId()), dbcar)
							gamemode = 6
							dbid = i
							kills = 0
							RemoveAllCharWeapons(GetPlayerChar(GetPlayerId()))
							--GiveWeaponToChar(GetPlayerChar(GetPlayerId()), GenerateRandomIntInRange(10, 19, _i), 1000, 1)
							TriggerServerEvent('sendMessageToEveryone', '[Derby]', '' .. GetPlayerName(GetPlayerId(), _s) .. ' has joined Derby ' .. i .. '.')
							TriggerEvent('chatMessage', '[Derby]', {255, 255, 0}, 'Be the first who will reach 20 kills to win. Collect throwables around arena to use in fight.')
						else
							TriggerEvent('chatMessage', '[Derby]', {255, 0, 0}, 'Mission in progress!')
						end
					end
				end
			end
		end
		if(gamemode == 6) then
			for i=1,#lootcoords[dbid],1 do
				RemoveBlip(lootblip[dbid][i])
				if(lootstate[dbid][i]==nil or lootstate[dbid][i]==0) then
					if(IsPlayerNearCoords(lootcoords[dbid][i][1], lootcoords[dbid][i][2], lootcoords[dbid][i][3], 50)) then
						if(not DoesBlipExist(lootblip[dbid][i])) then
							lootblip[dbid][i] = AddBlipForCoord(lootcoords[dbid][i][1], lootcoords[dbid][i][2], lootcoords[dbid][i][3], _i)
							ChangeBlipColour(lootblip[dbid][i], 4)
							ChangeBlipSprite(lootblip[dbid][i], 0)
							ChangeBlipScale(lootblip[dbid][i], 0.50)
							SetBlipAsShortRange(lootblip[dbid][i], true)
							ChangeBlipNameFromAscii(lootblip[dbid][i], "Loot")
						end
					end
					DrawCheckpointWithDist(lootcoords[dbid][i][1], lootcoords[dbid][i][2], lootcoords[dbid][i][3]-1, 1.1, 0, 255, 0, 100)
					if(IsPlayerNearCoords(lootcoords[dbid][i][1], lootcoords[dbid][i][2], lootcoords[dbid][i][3], 1)) then
						local throws = {4,5,28,36}
						local rnd = GenerateRandomIntInRange(1, #throws+1)
						GiveWeaponToChar(GetPlayerChar(-1), throws[rnd], 1, 1)
						lootstate[dbid][i] = 1
					end
				end
			end
		else
			for i=1,#lootcoords,1 do
				for j=1,#lootcoords[i],1 do
					RemoveBlip(lootblip[i][j])
				end
			end
			if(not IsCarDead(dbcar)) then
				DeleteCar(dbcar)
			end
		end
		if(gamemode == 6) then
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
						dbblip[i] = AddBlipForCoord(dbzone[dbid][1][1]-dbzone[dbid][2]/2, dbzone[dbid][1][2]-dbzone[dbid][3]/2+dbzone[dbid][3]/10*i, dbzone[dbid][1][3], _i)
					elseif(i>10 and i<=20) then
						dbblip[i] = AddBlipForCoord(dbzone[dbid][1][1]+dbzone[dbid][2]/2, dbzone[dbid][1][2]-dbzone[dbid][3]/2+dbzone[dbid][3]/10*(i-10), dbzone[dbid][1][3], _i)
					elseif(i>20 and i<=30) then
						dbblip[i] = AddBlipForCoord(dbzone[dbid][1][1]-dbzone[dbid][2]/2+dbzone[dbid][2]/10*(i-20), dbzone[dbid][1][2]-dbzone[dbid][3]/2, dbzone[dbid][1][3], _i)
					elseif(i > 30) then
						dbblip[i] = AddBlipForCoord(dbzone[dbid][1][1]-dbzone[dbid][2]/2+dbzone[dbid][2]/10*(i-30), dbzone[dbid][1][2]+dbzone[dbid][3]/2, dbzone[dbid][1][3], _i)
					end
					ChangeBlipScale(dbblip[i], 0.1)
					ChangeBlipSprite(dbblip[i], 3)
					ChangeBlipColour(dbblip[i], 1)
					ChangeBlipNameFromAscii(dbblip[i], "Match zone")
				end
			end
			if(not LocateCharAnyMeans3d(GetPlayerChar(GetPlayerId()), dbzone[dbid][1][1], dbzone[dbid][1][2], dbzone[dbid][1][3]-10, dbzone[dbid][2]/2, dbzone[dbid][3]/2, 100.1, false)) then
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
		end
	end
end)

local loottimer = {}
for i=1,#lootcoords,1 do
	loottimer[i] = {}
	for j=1,#lootcoords[i],1 do
		loottimer[i][j] = 10
	end
end
CreateThread(function()
	while true do
		Wait(0)
		if(gamemode == 6) then
			Wait(1000)
			for i=1,#lootcoords[dbid],1 do
				if(lootstate[dbid][i] ~= nil) then
					if(lootstate[dbid][i] == 1) then
						loottimer[dbid][i] = loottimer[dbid][i] - 1
						if(loottimer[dbid][i] <= 0) then
							lootstate[dbid][i] = 0
						end
					else
						loottimer[dbid][i] = 10
					end
				end
			end
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if(gamemode == 6) then
			for i=0,31,1 do
				if(IsNetworkPlayerActive(i)) then
					if(IsPlayerDead(i)) then
						if(ConvertIntToPlayerindex(i) ~= ConvertIntToPlayerindex(GetPlayerId())) then
							if(FindNetworkKillerOfPlayer(i) == GetPlayerId()) then
								if(killblocker[i] == 0) then
									kills = kills + 1
									TriggerServerEvent('sendMessageForGamemode', gamemode, gmid, '', '^1' .. GetPlayerName(i, _s) .. '^0 got killed by ^1' .. GetPlayerName(GetPlayerId(), _s))
									local px,py,pz = GetCharCoordinates(GetPlayerChar(i))
									DrawSignal(px, py, pz, "+200$ +75EXP")
									money = money + 200
									experience = experience + 75
									SaveStats()
									if(kills ~= 10) then
										if(kills%5 == 0) then
											TriggerServerEvent('sendMessageForGamemode', gamemode, gmid, '', '^1' .. GetPlayerName(GetPlayerId(), _s) .. '^0 has reached ^1' .. kills .. '^0 kills!')
										end
									else
										local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
										DrawSignalAttached("+10000$ +500EXP")
										money = money + 10000
										experience = experience + 500
										SaveStats()
										TriggerServerEvent('sendMessageForGamemode', gamemode, gmid, '', '^1' .. GetPlayerName(GetPlayerId(), _s) .. '^0 has won the round! (+10000$/+500 EXP)')
										TriggerServerEvent('finishRound', 6, dbid)
									end
									killblocker[i] = 1
								end
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
		if(id == 6) then
			if(dbid == modeid) then
				kills = 0
				gamemode = 0
				--DeleteCar(dbcar)
				if(IsCharInAnyCar(GetPlayerChar(GetPlayerId()))) then
					DeleteCar(GetCarCharIsUsing(GetPlayerChar(GetPlayerId())))
				end
				SetCharCoordinates(GetPlayerChar(GetPlayerId()), dbcoords[dbid][1], dbcoords[dbid][2], dbcoords[dbid][3])
				RemoveAllCharWeapons(GetPlayerChar(GetPlayerId()))
				for i=1,8,1 do
					GiveWeaponToChar(GetPlayerChar(GetPlayerId()), weps[i][1], weps[i][2], 1)
				end
			end
		end
	end
end)