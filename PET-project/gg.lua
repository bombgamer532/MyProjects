local ggcoords = {
{-697.58844, 154.52199, 4.81718, 88.2034149169922},
{477.08151, 9.74464, 8.68352, 103.97420501709, 0}
}
local ggzone = {
{{-750.5289, 155.08203, 4.817765}, 82.73776804262005, 43.2029608845748},
{{494.565855, -66.68124, 9.255935}, 37.676523937012824, 54.28081648477389}
}
local resp = {
{
{-717.27368, 167.58569, 5.03349, 166.365661621094},
{-722.61481, 147.76192, 5.91785, 85.1254653930664},
{-757.06366, 145.49832, 5.03349, 89.1063079833984},
{-780.41815, 141.6461, 5.03455, 344.401458740234},
{-786.86761, 166.2998, 5.03456, 162.741439819336},
{-776.67145, 162.59184, 5.03455, 284.460815429688},
{-745.40118, 170.55646, 5.03348, 189.705520629883}
},
{
{482.79337, -44.45221, 9.2572, 181.940185546875, 0},
{504.25424, -48.05565, 9.2572, 97.8888778686523, 0},
{500.25754, -66.20586, 9.25559, 78.3352203369141, 0},
{506.75864, -85.53165, 9.2556, 78.2864227294922, 0},
{483.16284, -87.13381, 9.25559, 350.708282470703, 0},
{482.70117, -69.93836, 9.25559, 267.510101318359, 0},
{483.27307, -60.40804, 9.2556, 257.34375, 0}
}
}

local kills = 0
local killblocker = {}
for i=0,31,1 do
	killblocker[i] = 0
end

local level = 1
local levels = {
15,
14,
13,
12,
9,
7,
11,
10,
16,
17
}

RegisterNetEvent('playerSpawned')
AddEventHandler('playerSpawned', function()
	CreateThread(function()
		if(gamemode == 2) then
			local rnd = GenerateRandomIntInRange(1, #resp[ggid]+1, _i)
			SetCharCoordinates(GetPlayerChar(GetPlayerId()), resp[ggid][rnd][1], resp[ggid][rnd][2], resp[ggid][rnd][3])
			Wait(1000)
			--RemoveAllCharWeapons(GetPlayerChar(GetPlayerId()))
			GiveWeaponToChar(GetPlayerChar(GetPlayerId()), levels[level], 1000, 1)
		end
	end)
end)

local ggmainblip = {}
local ggblip = {}
local bots = {}
local botamount = 5
local botblocker = {}
local bottarget = {}
CreateThread(function()
	while true do
		Wait(0)
		for i=1,#ggcoords,1 do
			if(not DoesBlipExist(ggmainblip[i])) then
				ggmainblip[i] = AddBlipForCoord(ggcoords[i][1], ggcoords[i][2], ggcoords[i][3], _i)
				ChangeBlipSprite(ggmainblip[i], 76)
				ChangeBlipScale(ggmainblip[i], 0.7)
				ChangeBlipNameFromAscii(ggmainblip[i], "Gun game " .. i)
				SetBlipAsShortRange(ggmainblip[i], true)
			end
			if(gamemode == 0) then
				DrawTextAtCoord(ggcoords[i][1], ggcoords[i][2], ggcoords[i][3], "Gun_game_" .. i, 20)
				DrawCheckpointWithDist(ggcoords[i][1], ggcoords[i][2], ggcoords[i][3]-1, 1.1, 255, 255, 0, 100)
				if(IsPlayerNearCoords(ggcoords[i][1], ggcoords[i][2], ggcoords[i][3], 1)) then
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~enter gun game", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						if(missionstarted == 0) then
							local rnd = GenerateRandomIntInRange(1, #resp[i]+1, _i)
							SetCharCoordinates(GetPlayerChar(GetPlayerId()), resp[i][rnd][1], resp[i][rnd][2], resp[i][rnd][3])
							gamemode = 2
							ggid = i
							playermode[ConvertIntToPlayerindex(GetPlayerId())] = {gamemode, ggid}
							TriggerServerEvent('updModes', playermode)
							kills = 0
							level = 1
							RemoveAllCharWeapons(GetPlayerChar(GetPlayerId()))
							GiveWeaponToChar(GetPlayerChar(GetPlayerId()), levels[level], 1000, 0)
							TriggerServerEvent('sendMessageToEveryone', '[Gun Game]', '' .. GetPlayerName(GetPlayerId(), _s) .. ' has joined Gun Game ' .. i .. '.')
							TriggerEvent('chatMessage', '[Gun Game]', {255, 255, 0}, 'Reach the maximum level to win.')
						else
							TriggerEvent('chatMessage', '[Deathmatch]', {255, 0, 0}, 'Mission in progress!')
						end
					end
				end
			end
		end
		if(gamemode == 2) then
			if(not IsPlayerDead(GetPlayerId())) then
				DrawRectLeftTopCenter(0.9, 0.85, 0.08, 0.1, 0, 0, 0, 100)
				SetTextScale(0.200000, 0.4000000)
				SetTextDropshadow(0, 0, 0, 0, 0)
				SetTextEdge(1, 0, 0, 0, 255)
				DisplayTextWithLiteralString(0.91, 0.86, "STRING", "Kills: ~y~" .. kills .. "/3")
				SetTextScale(0.200000, 0.4000000)
				SetTextDropshadow(0, 0, 0, 0, 0)
				SetTextEdge(1, 0, 0, 0, 255)
				DisplayTextWithLiteralString(0.91, 0.91, "STRING", "Level: ~y~" .. level)
			end
			AlterWantedLevel(GetPlayerId(), 0)
			ApplyWantedLevelChangeNow(GetPlayerId())
			for i=1,40,1 do
				if(not DoesBlipExist(ggblip[i])) then
					if(i <= 10) then
						ggblip[i] = AddBlipForCoord(ggzone[ggid][1][1]-ggzone[ggid][2]/2, ggzone[ggid][1][2]-ggzone[ggid][3]/2+ggzone[ggid][3]/10*i, ggzone[ggid][1][3], _i)
					elseif(i>10 and i<=20) then
						ggblip[i] = AddBlipForCoord(ggzone[ggid][1][1]+ggzone[ggid][2]/2, ggzone[ggid][1][2]-ggzone[ggid][3]/2+ggzone[ggid][3]/10*(i-10), ggzone[ggid][1][3], _i)
					elseif(i>20 and i<=30) then
						ggblip[i] = AddBlipForCoord(ggzone[ggid][1][1]-ggzone[ggid][2]/2+ggzone[ggid][2]/10*(i-20), ggzone[ggid][1][2]-ggzone[ggid][3]/2, ggzone[ggid][1][3], _i)
					elseif(i > 30) then
						ggblip[i] = AddBlipForCoord(ggzone[ggid][1][1]-ggzone[ggid][2]/2+ggzone[ggid][2]/10*(i-30), ggzone[ggid][1][2]+ggzone[ggid][3]/2, ggzone[ggid][1][3], _i)
					end
					ChangeBlipScale(ggblip[i], 0.1)
					ChangeBlipSprite(ggblip[i], 3)
					ChangeBlipColour(ggblip[i], 1)
					ChangeBlipNameFromAscii(ggblip[i], "Match zone")
				end
			end
			if(not LocateCharAnyMeans3d(GetPlayerChar(GetPlayerId()), ggzone[ggid][1][1], ggzone[ggid][1][2], ggzone[ggid][1][3]-10, ggzone[ggid][2]/2, ggzone[ggid][3]/2, 100.1, false)) then
				PrintStringWithLiteralStringNow("STRING", "~r~Go back into match zone!", 1000, 1)
				DamageChar(GetPlayerChar(GetPlayerId()), 10, 0)
				Wait(1000)
			end
		else
			for i=1,40,1 do
				if(DoesBlipExist(ggblip[i])) then
					RemoveBlip(ggblip[i])
				end
			end
		end
	end
end)

GgKill = function(id)
	kills = kills + 1
	TriggerServerEvent('sendMessageForGamemode', gamemode, gmid, '', '^1' .. GetPlayerName(id, _s) .. '^0 got killed by ^1' .. GetPlayerName(GetPlayerId(), _s))
	local px,py,pz = GetCharCoordinates(GetPlayerChar(id))
	DrawSignal(px, py, pz, "+100$ +50EXP")
	money = money + 100
	experience = experience + 50
	SaveStats()
	if(kills == 3) then
		kills = 0
		level = level + 1
		TriggerServerEvent('sendMessageForGamemode', gamemode, gmid, '', '^1' .. GetPlayerName(GetPlayerId(), _s) .. '^0 has reached level ^1' .. level)
		if(level > 10) then
			local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
			DrawSignalAttached("+5000$ +300EXP")
			money = money + 5000
			experience = experience + 300
			SaveStats()
			TriggerServerEvent('sendMessageForGamemode', gamemode, gmid, '', '^1' .. GetPlayerName(GetPlayerId(), _s) .. '^0 has won the round! (+5000$/+300 EXP)')
			TriggerServerEvent('finishRound', 2, ggid)
		else
			RemoveAllCharWeapons(GetPlayerChar(GetPlayerId()))
			GiveWeaponToChar(GetPlayerChar(GetPlayerId()), levels[level], 1000, 1)
		end
	end
end
--[[CreateThread(function()
	while true do
		Wait(0)
		if(gamemode == 2) then
			for i=0,31,1 do
				if(IsNetworkPlayerActive(i)) then
					if(IsPlayerDead(i)) then
						if(killblocker[i] == 0) then
							if(ConvertIntToPlayerindex(i) ~= ConvertIntToPlayerindex(GetPlayerId())) then
								if(FindNetworkKillerOfPlayer(i) == GetPlayerId()) then
									kills = kills + 1
									TriggerServerEvent('sendMessageForGamemode', gamemode, gmid, '', '^1' .. GetPlayerName(i, _s) .. '^0 got killed by ^1' .. GetPlayerName(GetPlayerId(), _s))
									local px,py,pz = GetCharCoordinates(GetPlayerChar(i))
									DrawSignal(px, py, pz, "+100$ +50EXP")
									money = money + 100
									experience = experience + 50
									SaveStats()
									if(kills == 3) then
										kills = 0
										level = level + 1
										TriggerServerEvent('sendMessageForGamemode', gamemode, gmid, '', '^1' .. GetPlayerName(GetPlayerId(), _s) .. '^0 has reached level ^1' .. level)
										if(level > 10) then
											local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
											DrawSignalAttached("+5000$ +300EXP")
											money = money + 5000
											experience = experience + 300
											SaveStats()
											TriggerServerEvent('sendMessageForGamemode', gamemode, gmid, '', '^1' .. GetPlayerName(GetPlayerId(), _s) .. '^0 has won the round! (+5000$/+300 EXP)')
											TriggerServerEvent('finishRound', 2, ggid)
										else
											RemoveAllCharWeapons(GetPlayerChar(GetPlayerId()))
											GiveWeaponToChar(GetPlayerChar(GetPlayerId()), levels[level], 1000, 1)
										end
									end
								end
							end
							killblocker[i] = 1
						end
					else
						killblocker[i] = 0
					end
				end
			end
		end
	end
end)]]

CreateThread(function()
	while true do
		Wait(0)
		if(gamemode == 2) then
			local first = -1
			for i=0,31,1 do
				if(playermode[i][1] == gamemode) then
					if(playermode[i][2] == ggid) then
						first = i
						break
					end
				end
			end
			if(ConvertIntToPlayerindex(GetPlayerId()) == ConvertIntToPlayerindex(first)) then
				local FindClosest = function(bot)
					local ids = {}
					local coords = {}
					for j=0,31,1 do
						if(IsNetworkPlayerActive(j)) then
							if(not IsPlayerDead(j)) then
								ids[#ids+1] = GetPlayerChar(j)
								local px,py,pz = GetCharCoordinates(GetPlayerChar(j))
								coords[#coords+1] = {px, py, pz}
							end
						end
					end
					for j=1,botamount,1 do
						if(bots[j] ~= bot) then
							if(not IsCharDead(bots[j])) then
								ids[#ids+1] = bots[j]
								local px,py,pz = GetCharCoordinates(bots[j])
								coords[#coords+1] = {px, py, pz}
							end
						end
					end
					local px,py,pz = GetCharCoordinates(bot)
					return ids[GetClosestCoordFromCoordWithIndex({px, py, pz}, coords)]
				end
				for i=1,botamount,1 do
					if(not IsCharDead(bots[i])) then
						botblocker[i] = false
						UnlockRagdoll(bots[i], 0)
						if(not IsPedInCombat(bots[i])) then
							local closest = FindClosest(bots[i])
							TaskCombat(bots[i], closest)
							bottarget[i] = closest
						else
							if(not IsCharDead(bottarget[i])) then
								local closest = FindClosest(bots[i])
								if(closest ~= bottarget[i]) then
									TaskCombat(bots[i], closest)
									bottarget[i] = closest
								end
							else
								local closest = FindClosest(bots[i])
								TaskCombat(bots[i], closest)
								bottarget[i] = closest
							end
						end
					else
						if not botblocker[i] then
							UnlockRagdoll(bots[i], 1)
							for j=0,31,1 do
								if(IsNetworkPlayerActive(j)) then
									if(HasCharBeenDamagedByChar(bots[i], GetPlayerChar(j), false)) then
										local px,py,pz = GetCharCoordinates(bots[i])
										TriggerServerEvent('rewardGgKill', j, px, py, pz)
										TriggerServerEvent('sendMessageForGamemode', gamemode, gmid, '', '^1Bot' .. i .. '^0 got killed by ^1' .. GetPlayerName(j))
										ClearCharLastDamageEntity(bots[i])
									end
								end
							end
							for j=1,botamount,1 do
								if(HasCharBeenDamagedByChar(bots[i], bots[j], false)) then
									if(i ~= j) then
										TriggerServerEvent('sendMessageForGamemode', gamemode, gmid, '', '^1Bot' .. i .. '^0 got killed by ^1Bot' .. j)
										ClearCharLastDamageEntity(bots[i])
									end
								end
							end
							CreateThread(function()
								MarkCharAsNoLongerNeeded(bots[i])
								Wait(5000)
								DeleteChar(bots[i])
								local skins = {
								"M_Y_MULTIPLAYER",
								"F_Y_MULTIPLAYER",
								"m_y_runner",
								"f_y_shopper_05",
								"m_y_shopasst_01",
								"f_y_villbo_01"
								}
								local rnd = GenerateRandomIntInRange(1, #resp[ggid]+1)
								local rnd2 = GenerateRandomIntInRange(1, #skins+1)
								bots[i] = SpawnPed(GetHashKey(skins[rnd2]), resp[ggid][rnd][1], resp[ggid][rnd][2], resp[ggid][rnd][3], resp[ggid][rnd][4])
								SetCharHealth(bots[i], 300)
								SetCharAccuracy(bots[i], 100)
								if(rnd2%2 == 0) then
									RequestAnims("move_f@multiplyr")
									while not HaveAnimsLoaded("move_f@multiplyr") do
										Wait(0)
									end
									SetAnimGroupForChar(bots[i], "move_f@multiplyr")
								else
									RequestAnims("move_m@multiplyr")
									while not HaveAnimsLoaded("move_m@multiplyr") do
										Wait(0)
									end
									SetAnimGroupForChar(bots[i], "move_m@multiplyr")
								end
								GiveWeaponToChar(bots[i], levels[level], 1000, 1)
							end)
							botblocker[i] = true
						end
					end
				end
				--[[for i=0,31,1 do
					if(IsNetworkPlayerActive(i)) then
						if(IsPlayerDead(i)) then
							if(killblocker[i] == 0) then
								for j=1,botamount,1 do
									if(HasCharBeenDamagedByChar(GetPlayerChar(i), bots[j], false)) then
										TriggerServerEvent('decreaseKills', i)
										TriggerServerEvent('sendMessageForGamemode', gamemode, gmid, '', '^1' .. GetPlayerName(i) .. '^0 got killed by ^1Bot' .. j)
										ClearCharLastDamageEntity(GetPlayerChar(i))
										break
									end
								end
								killblocker[i] = 1
							end
						else
							killblocker[i] = 0
						end
					end
				end]]
			end
		else
			for i=1,botamount,1 do
				if(DoesCharExist(bots[i])) then
					DeleteChar(bots[i])
				end
			end
		end
	end
end)

RegisterNetEvent('rewardGgKill')
AddEventHandler('rewardGgKill', function(id, x, y, z)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		if(gamemode == 2) then
			kills = kills + 1
			DrawSignal(x, y, z, "+100$ +50EXP")
			money = money + 100
			experience = experience + 50
			SaveStats()
			if(kills == 3) then
				kills = 0
				level = level + 1
				TriggerServerEvent('sendMessageForGamemode', gamemode, gmid, '', '^1' .. GetPlayerName(GetPlayerId(), _s) .. '^0 has reached level ^1' .. level)
				if(level > 10) then
					local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
					DrawSignalAttached("+5000$ +300EXP")
					money = money + 5000
					experience = experience + 300
					SaveStats()
					TriggerServerEvent('sendMessageForGamemode', gamemode, gmid, '', '^1' .. GetPlayerName(GetPlayerId(), _s) .. '^0 has won the round! (+5000$/+300 EXP)')
					TriggerServerEvent('finishRound', 2, ggid)
				else
					RemoveAllCharWeapons(GetPlayerChar(GetPlayerId()))
					GiveWeaponToChar(GetPlayerChar(GetPlayerId()), levels[level], 1000, 1)
				end
			end
		end
	end
end)

RegisterNetEvent('decreaseKills')
AddEventHandler('decreaseKills', function(id)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		if(kills > 0) then
			kills = kills - 1
			local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
			DrawSignal(px, py, pz, "-1_kill")
		end
	end
end)

RegisterNetEvent('finishRound')
AddEventHandler('finishRound', function(id, modeid)
	if(gamemode == id) then
		if(id == 2) then
			if(ggid == modeid) then
				kills = 0
				level = 1
				gamemode = 0
				playermode[ConvertIntToPlayerindex(GetPlayerId())] = {0, 0}
				TriggerServerEvent('updModes', playermode)
				SetCharCoordinates(GetPlayerChar(GetPlayerId()), ggcoords[ggid][1], ggcoords[ggid][2], ggcoords[ggid][3])
				RemoveAllCharWeapons(GetPlayerChar(GetPlayerId()))
				for i=1,8,1 do
					GiveWeaponToChar(GetPlayerChar(GetPlayerId()), weps[i][1], weps[i][2], 1)
				end
			end
		end
	end
end)