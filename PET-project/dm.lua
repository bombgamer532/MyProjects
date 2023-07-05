local dmcoords = {
{456.8407, 293.80322, 8.70864, 357.494476318359},
{-1831.24683, -659.117, 3.04918, 87.5795288085938},
{1920.90796, 425.0192, 18.20598, 270.077911376953}
}
local dmzone = {
{{464.44983, 204.28386, 8.753895}, 87.44010206492499, 115.88591751880209},
{{-1889.795045, -634.094845, 3.049295}, 60.446161112210426, 126.23960543056762},
{{1963.625735, 424.23175, 18.17295}, 99.74413094882625, 72.97152305536386}
}
local resp = {
{
{434.20078, 242.53513, 8.70357, 200.452926635742},
{456.82455, 193.66544, 8.69277, 355.707000732422},
{492.90326, 222.29669, 8.73118, 132.426879882813},
{500.37585, 252.2708, 8.81962, 186.140411376953},
{497.37308, 181.76959, 8.66657, 118.563850402832},
{431.7533, 165.51779, 8.68076, 269.205078125}
},
{
{-1869.40051, -679.04303, 3.04918, 165.643951416016},
{-1914.04224, -650.75116, 3.01995, 346.13916015625},
{-1901.56494, -594.90601, 2.88634, 153.718215942383},
{-1868.14722, -580.83588, 3.04941, 82.8934631347656},
{-1877.73352, -632.34839, 2.88553, 179.278518676758}
},
{
{1949.44714, 455.04681, 18.2966, 174.158798217773},
{1981.33911, 419.52863, 18.26935, 165.908813476563},
{2002.43005, 391.46457, 18.10752, 342.865447998047},
{1941.4408, 416.09708, 18.23199, 307.160705566406},
{1933.02307, 438.35364, 18.24462, 84.1333999633789}
}
}

local kills = 0
local killblocker = {}
for i=0,31,1 do
	killblocker[i] = 0
end

local guns = {7, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 21, 22, 26, 27, 29, 31, 32, 33, 34}
RegisterNetEvent('playerSpawned')
AddEventHandler('playerSpawned', function()
	CreateThread(function()
		if(gamemode == 1) then
			local rnd = GenerateRandomIntInRange(1, #resp[gmid]+1, _i)
			SetCharCoordinates(GetPlayerChar(GetPlayerId()), resp[gmid][rnd][1], resp[gmid][rnd][2], resp[gmid][rnd][3])
			Wait(1000)
			--RemoveAllCharWeapons(GetPlayerChar(GetPlayerId()))
			GiveWeaponToChar(GetPlayerChar(GetPlayerId()), guns[GenerateRandomIntInRange(1, #guns+1)], 1000, 1)
		end
	end)
end)

local dmmainblip = {}
local dmblip = {}
local bots = {}
local botamount = 5
local botblocker = {}
local bottarget = {}
CreateThread(function()
	while true do
		Wait(0)
		for i=1,#dmcoords,1 do
			if(not DoesBlipExist(dmmainblip[i])) then
				dmmainblip[i] = AddBlipForCoord(dmcoords[i][1], dmcoords[i][2], dmcoords[i][3], _i)
				ChangeBlipSprite(dmmainblip[i], 76)
				ChangeBlipScale(dmmainblip[i], 0.7)
				ChangeBlipNameFromAscii(dmmainblip[i], "Deathmatch " .. i)
				SetBlipAsShortRange(dmmainblip[i], true)
			end
			if(gamemode == 0) then
				DrawTextAtCoord(dmcoords[i][1], dmcoords[i][2], dmcoords[i][3], "Deathmatch_" .. i, 20)
				DrawCheckpointWithDist(dmcoords[i][1], dmcoords[i][2], dmcoords[i][3]-1, 1.1, 255, 255, 0, 100)
				if(IsPlayerNearCoords(dmcoords[i][1], dmcoords[i][2], dmcoords[i][3], 1)) then
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~enter deathmatch", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						if(missionstarted == 0) then
							local rnd = GenerateRandomIntInRange(1, #resp[i]+1, _i)
							SetCharCoordinates(GetPlayerChar(GetPlayerId()), resp[i][rnd][1], resp[i][rnd][2], resp[i][rnd][3])
							gamemode = 1
							gmid = i
							playermode[ConvertIntToPlayerindex(GetPlayerId())] = {gamemode, gmid}
							TriggerServerEvent('updModes', playermode)
							kills = 0
							RemoveAllCharWeapons(GetPlayerChar(GetPlayerId()))
							GiveWeaponToChar(GetPlayerChar(GetPlayerId()), guns[GenerateRandomIntInRange(1, #guns+1)], 1000, 1)
							TriggerServerEvent('sendMessageToEveryone', '[Deathmatch]', '' .. GetPlayerName(GetPlayerId(), _s) .. ' has joined Deathmatch ' .. i .. '.')
							TriggerEvent('chatMessage', '[Deathmatch]', {255, 255, 0}, 'Be the first who will reach 30 kills to win.')
						else
							TriggerEvent('chatMessage', '[Deathmatch]', {255, 0, 0}, 'Mission in progress!')
						end
					end
				end
			end
		end
		if(gamemode == 1) then
			if(not IsPlayerDead(GetPlayerId())) then
				DrawRectLeftTopCenter(0.9, 0.9, 0.08, 0.05, 0, 0, 0, 100)
				SetTextScale(0.200000, 0.4000000)
				SetTextDropshadow(0, 0, 0, 0, 0)
				SetTextEdge(1, 0, 0, 0, 255)
				DisplayTextWithLiteralString(0.91, 0.91, "STRING", "Kills: ~y~" .. kills .. "/30")
			end
			AlterWantedLevel(GetPlayerId(), 0)
			ApplyWantedLevelChangeNow(GetPlayerId())
			for i=1,40,1 do
				if(not DoesBlipExist(dmblip[i])) then
					if(i <= 10) then
						dmblip[i] = AddBlipForCoord(dmzone[gmid][1][1]-dmzone[gmid][2]/2, dmzone[gmid][1][2]-dmzone[gmid][3]/2+dmzone[gmid][3]/10*i, dmzone[gmid][1][3], _i)
					elseif(i>10 and i<=20) then
						dmblip[i] = AddBlipForCoord(dmzone[gmid][1][1]+dmzone[gmid][2]/2, dmzone[gmid][1][2]-dmzone[gmid][3]/2+dmzone[gmid][3]/10*(i-10), dmzone[gmid][1][3], _i)
					elseif(i>20 and i<=30) then
						dmblip[i] = AddBlipForCoord(dmzone[gmid][1][1]-dmzone[gmid][2]/2+dmzone[gmid][2]/10*(i-20), dmzone[gmid][1][2]-dmzone[gmid][3]/2, dmzone[gmid][1][3], _i)
					elseif(i > 30) then
						dmblip[i] = AddBlipForCoord(dmzone[gmid][1][1]-dmzone[gmid][2]/2+dmzone[gmid][2]/10*(i-30), dmzone[gmid][1][2]+dmzone[gmid][3]/2, dmzone[gmid][1][3], _i)
					end
					ChangeBlipScale(dmblip[i], 0.1)
					ChangeBlipSprite(dmblip[i], 3)
					ChangeBlipColour(dmblip[i], 1)
					ChangeBlipNameFromAscii(dmblip[i], "Match zone")
				end
			end
			if(not LocateCharAnyMeans3d(GetPlayerChar(GetPlayerId()), dmzone[gmid][1][1], dmzone[gmid][1][2], dmzone[gmid][1][3]-10, dmzone[gmid][2]/2, dmzone[gmid][3]/2, 100.1, false)) then
				PrintStringWithLiteralStringNow("STRING", "~r~Go back into match zone!", 1000, 1)
				DamageChar(GetPlayerChar(GetPlayerId()), 10, 0)
				Wait(1000)
			end
		else
			for i=1,40,1 do
				if(DoesBlipExist(dmblip[i])) then
					RemoveBlip(dmblip[i])
				end
			end
		end
	end
end)

DmKill = function(id)
	kills = kills + 1
	TriggerServerEvent('sendMessageForGamemode', gamemode, gmid, '', '^1' .. GetPlayerName(id, _s) .. '^0 got killed by ^1' .. GetPlayerName(GetPlayerId(), _s))
	local px,py,pz = GetCharCoordinates(GetPlayerChar(id))
	DrawSignal(px, py, pz, "+100$ +50EXP")
	money = money + 100
	experience = experience + 50
	SaveStats()
	if(kills ~= 30) then
		if(kills%10 == 0) then
			TriggerServerEvent('sendMessageForGamemode', gamemode, gmid, '', '^1' .. GetPlayerName(GetPlayerId(), _s) .. '^0 has reached ^1' .. kills .. '^0 kills!')
		end
	else
		local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
		DrawSignalAttached("+5000$ +250EXP")
		money = money + 5000
		experience = experience + 250
		SaveStats()
		TriggerServerEvent('sendMessageForGamemode', gamemode, gmid, '', '^1' .. GetPlayerName(GetPlayerId(), _s) .. '^0 has won the round! (+5000$/+250 EXP)')
		TriggerServerEvent('finishRound', 1, gmid)
	end
end
--[[CreateThread(function()
	while true do
		Wait(0)
		if(gamemode == 1) then
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
									if(kills ~= 30) then
										if(kills%10 == 0) then
											TriggerServerEvent('sendMessageForGamemode', gamemode, gmid, '', '^1' .. GetPlayerName(GetPlayerId(), _s) .. '^0 has reached ^1' .. kills .. '^0 kills!')
										end
									else
										local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
										DrawSignalAttached("+5000$ +250EXP")
										money = money + 5000
										experience = experience + 250
										SaveStats()
										TriggerServerEvent('sendMessageForGamemode', gamemode, gmid, '', '^1' .. GetPlayerName(GetPlayerId(), _s) .. '^0 has won the round! (+5000$/+250 EXP)')
										TriggerServerEvent('finishRound', 1, gmid)
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
		if(gamemode == 1) then
			local first = -1
			for i=0,31,1 do
				if(playermode[i][1] == gamemode) then
					if(playermode[i][2] == gmid) then
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
										TriggerServerEvent('rewardDmKill', j, px, py, pz)
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
								local rnd = GenerateRandomIntInRange(1, #resp[gmid]+1)
								local rnd2 = GenerateRandomIntInRange(1, #skins+1)
								bots[i] = SpawnPed(GetHashKey(skins[rnd2]), resp[gmid][rnd][1], resp[gmid][rnd][2], resp[gmid][rnd][3], resp[gmid][rnd][4])
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
								GiveWeaponToChar(bots[i], guns[GenerateRandomIntInRange(1, #guns+1)], 1000, 1)
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

RegisterNetEvent('rewardDmKill')
AddEventHandler('rewardDmKill', function(id, x, y, z)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		if(gamemode == 1) then
			kills = kills + 1
			DrawSignal(x, y, z, "+100$ +50EXP")
			money = money + 100
			experience = experience + 50
			SaveStats()
			if(kills ~= 30) then
				if(kills%10 == 0) then
					TriggerServerEvent('sendMessageForGamemode', gamemode, gmid, '', '^1' .. GetPlayerName(GetPlayerId(), _s) .. '^0 has reached ^1' .. kills .. '^0 kills!')
				end
			else
				local px,py,pz = GetCharCoordinates(GetPlayerChar(GetPlayerId()))
				DrawSignalAttached("+5000$ +250EXP")
				money = money + 5000
				experience = experience + 250
				SaveStats()
				TriggerServerEvent('sendMessageForGamemode', gamemode, gmid, '', '^1' .. GetPlayerName(GetPlayerId(), _s) .. '^0 has won the round! (+5000$/+250 EXP)')
				TriggerServerEvent('finishRound', 1, gmid)
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
		if(id == 1) then
			if(gmid == modeid) then
				kills = 0
				gamemode = 0
				playermode[ConvertIntToPlayerindex(GetPlayerId())] = {0, 0}
				TriggerServerEvent('updModes', playermode)
				SetCharCoordinates(GetPlayerChar(GetPlayerId()), dmcoords[gmid][1], dmcoords[gmid][2], dmcoords[gmid][3])
				RemoveAllCharWeapons(GetPlayerChar(GetPlayerId()))
				for i=1,8,1 do
					GiveWeaponToChar(GetPlayerChar(GetPlayerId()), weps[i][1], weps[i][2], 1)
				end
			end
		end
	end
end)