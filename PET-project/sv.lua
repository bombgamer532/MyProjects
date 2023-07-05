local svcoords = {
{-441.33722, -956.42731, 3.62176, 88.5631408691406}
}
local svzone = {
{{-599.59131, -868.72525, -0.153735}, 240.15746308420105, 440.0401109637467}
}
local resp = {
{
{-710.89832, -749.79626, 4.84265, 179.490142822266},
{-715.28888, -816.64008, 4.84265, 187.824645996094},
{-695.80298, -873.02301, 4.84234, 201.543746948242},
{-668.4079, -931.89777, 4.84234, 207.157730102539},
{-608.47498, -990.69507, 4.84285, 356.450836181641},
{-574.19977, -957.09961, 4.84286, 268.904449462891},
{-542.85876, -973.19635, 4.84286, 357.72607421875},
{-507.31567, -910.02301, 4.84286, 86.6370315551758},
{-491.77692, -846.71497, 4.84286, 14.6514873504639},
{-515.36542, -788.33954, 4.84258, 21.9940357208252},
{-538.65259, -735.6817, 4.84258, 18.0640811920166},
{-567.77502, -686.92664, 4.84258, 42.5472259521484},
{-610.22498, -663.4671, 4.84255, 89.3657073974609},
{-650.19061, -669.57617, 4.84254, 135.670166015625},
{-685.4718, -707.1319, 4.84263, 142.378707885742},
{-680.12213, -795.44604, 4.84265, 220.412384033203},
{-608.40216, -824.11847, 4.84286, 178.220016479492},
{-557.52734, -814.2738, 4.84258, 314.667755126953},
{-608.40363, -887.34399, 4.84286, 180.508071899414}
}
}
local lootcoords = {
{
{-516.46063, -980.56873, 5.54312, 92.5702896118164},
{-500.242, -1006.9411, 5.34047, 92.7869033813477},
{-531.42963, -1026.14172, 5.00152, 89.642333984375},
{-545.03735, -1043.34155, 5.00739, 349.773529052734},
{-575.16577, -1018.76959, 5.00651, 353.340576171875},
{-654.00067, -924.32434, 5.54311, 166.188034057617},
{-646.65088, -881.92828, 5.54311, 269.341125488281},
{-657.42987, -852.28998, 5.54231, 219.350051879883},
{-695.49908, -791.46252, 5.54263, 19.8698959350586},
{-515.22308, -929.95886, 4.84286, 212.347015380859},
{-490.32504, -926.23889, 4.84286, 89.4870452880859},
{-573.7002, -928.05328, 5.54312, 192.647262573242},
{-574.01501, -871.64722, 5.54311, 18.9904499053955},
{-541.62616, -809.83191, 5.54268, 85.0890121459961},
{-564.66333, -758.01526, 5.20736, 67.685920715332},
{-557.80988, -728.89685, 5.5257, 175.9541015625},
{-587.87708, -712.73132, 5.07415, 146.060256958008},
{-601.61157, -679.93048, 5.91005, 351.664306640625},
{-636.04919, -676.02295, 5.9345, 101.166130065918},
{-652.64697, -727.53009, 5.29708, 71.3924179077148},
{-698.44769, -745.62793, 5.91014, 78.7142639160156},
{-637.15247, -803.3183, 5.72879, 218.1689453125},
{-605.46613, -795.75818, 4.84435, 262.326232910156},
{-618.41357, -805.20032, 13.07126, 176.799301147461},
{-573.83246, -792.40344, 13.07127, 252.942626953125},
{-572.50006, -719.0556, 13.07129, 349.042449951172},
{-655.05176, -744.66479, 13.071, 116.036834716797},
{-607.95361, -775.48718, 17.47839, 1.24979090690613},
{-605.11505, -735.97455, 17.47817, 77.8672790527344},
{-594.84381, -767.72931, 20.34493, 276.017120361328},
{-621.09149, -741.77356, 20.34182, 88.1784439086914},
{-603.83185, -893.73737, 11.17728, 181.893249511719},
{-612.6286, -893.66821, 11.14858, 149.711807250977},
{-610.81024, -958.29645, 4.84286, 359.681640625}
}
}
local lootstate = {}
for i=1,#svcoords,1 do
	lootstate[i] = {}
end
local lootblip = {}
for i=1,#svcoords,1 do
	lootblip[i] = {}
end

local kills = 0
local killblocker = {}
for i=0,31,1 do
	killblocker[i] = 0
end

RegisterNetEvent('playerSpawned')
AddEventHandler('playerSpawned', function()
	CreateThread(function()
		if(gamemode == 5) then
			local rnd = GenerateRandomIntInRange(1, #resp[svid]+1, _i)
			SetCharCoordinates(GetPlayerChar(GetPlayerId()), resp[svid][rnd][1], resp[svid][rnd][2], resp[svid][rnd][3])
			Wait(1000)
			--RemoveAllCharWeapons(GetPlayerChar(GetPlayerId()))
			GiveWeaponToChar(GetPlayerChar(GetPlayerId()), 7, 100, 1)
		end
	end)
end)

local guns = {7, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 21, 22, 26, 27, 29, 31, 32, 33, 34}
local svmainblip = {}
local svblip = {}
local bots = {}
local botamount = 10
local botblocker = {}
local bottarget = {}
CreateThread(function()
	while true do
		Wait(0)
		for i=1,#svcoords,1 do
			if(not DoesBlipExist(svmainblip[i])) then
				svmainblip[i] = AddBlipForCoord(svcoords[i][1], svcoords[i][2], svcoords[i][3], _i)
				ChangeBlipSprite(svmainblip[i], 77)
				ChangeBlipScale(svmainblip[i], 0.7)
				ChangeBlipNameFromAscii(svmainblip[i], "Survival " .. i)
				SetBlipAsShortRange(svmainblip[i], true)
			end
			if(gamemode == 0) then
				DrawTextAtCoord(svcoords[i][1], svcoords[i][2], svcoords[i][3], "Survival_" .. i, 20)
				DrawCheckpointWithDist(svcoords[i][1], svcoords[i][2], svcoords[i][3]-1, 1.1, 255, 255, 0, 100)
				if(IsPlayerNearCoords(svcoords[i][1], svcoords[i][2], svcoords[i][3], 1)) then
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~enter survival", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						if(missionstarted == 0) then
							local rnd = GenerateRandomIntInRange(1, #resp[i]+1, _i)
							SetCharCoordinates(GetPlayerChar(GetPlayerId()), resp[i][rnd][1], resp[i][rnd][2], resp[i][rnd][3])
							svid = i
							gamemode = 5
							playermode[ConvertIntToPlayerindex(GetPlayerId())] = {gamemode, svid}
							TriggerServerEvent('updModes', playermode)
							kills = 0
							RemoveAllCharWeapons(GetPlayerChar(GetPlayerId()))
							GiveWeaponToChar(GetPlayerChar(GetPlayerId()), 7, 100, 1)
							TriggerServerEvent('sendMessageToEveryone', '[Survival]', '' .. GetPlayerName(GetPlayerId(), _s) .. ' has joined Survival ' .. i .. '.')
							TriggerEvent('chatMessage', '[Survival]', {255, 255, 0}, 'Find loot and try to kill as many players as you can without dying.')
						else
							TriggerEvent('chatMessage', '[Survival]', {255, 0, 0}, 'Mission in progress!')
						end
					end
				end
			end
		end
		if(gamemode == 5) then
			for i=1,#lootcoords[svid],1 do
				RemoveBlip(lootblip[svid][i])
				if(lootstate[svid][i]==nil or lootstate[svid][i]==0) then
					if(IsPlayerNearCoords(lootcoords[svid][i][1], lootcoords[svid][i][2], lootcoords[svid][i][3], 50)) then
						if(not DoesBlipExist(lootblip[svid][i])) then
							lootblip[svid][i] = AddBlipForCoord(lootcoords[svid][i][1], lootcoords[svid][i][2], lootcoords[svid][i][3], _i)
							ChangeBlipColour(lootblip[svid][i], 4)
							ChangeBlipSprite(lootblip[svid][i], 0)
							ChangeBlipScale(lootblip[svid][i], 0.50)
							SetBlipAsShortRange(lootblip[svid][i], true)
							ChangeBlipNameFromAscii(lootblip[svid][i], "Loot")
						end
					end
					DrawCheckpointWithDist(lootcoords[svid][i][1], lootcoords[svid][i][2], lootcoords[svid][i][3]-1, 1.1, 0, 255, 0, 100)
					if(IsPlayerNearCoords(lootcoords[svid][i][1], lootcoords[svid][i][2], lootcoords[svid][i][3], 1)) then
						PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~collect loot", 1000, 1)
						if(IsGameKeyboardKeyJustPressed(18)) then
							local rnd = GenerateRandomIntInRange(1, 6+12+1)
							if(rnd == 8) then
								rnd = 7
							end
							if(rnd <= 3) then
								SetCharHealth(GetPlayerChar(-1), 200)
								TriggerEvent('chatMessage', '[Loot]', {0, 255, 0}, 'Medkit found!')
							elseif(rnd>=4 and rnd<=6) then
								AddArmourToChar(GetPlayerChar(-1), 100)
								TriggerEvent('chatMessage', '[Loot]', {0, 255, 0}, 'Armor vest found!')
							else
								GiveWeaponToChar(GetPlayerChar(-1), guns[GenerateRandomIntInRange(1, #guns+1)], 100, 1)
								TriggerEvent('chatMessage', '[Loot]', {0, 255, 0}, 'Weapon found!')
							end
							lootstate[svid][i] = 1
						end
					end
				end
			end
		else
			for i=1,#lootcoords,1 do
				for j=1,#lootcoords[i],1 do
					RemoveBlip(lootblip[i][j])
				end
			end
		end
		if(gamemode == 5) then
			if(not IsPlayerDead(GetPlayerId())) then
				DrawRectLeftTopCenter(0.9, 0.9, 0.08, 0.05, 0, 0, 0, 100)
				SetTextScale(0.200000, 0.4000000)
				SetTextDropshadow(0, 0, 0, 0, 0)
				SetTextEdge(1, 0, 0, 0, 255)
				DisplayTextWithLiteralString(0.91, 0.91, "STRING", "Kills: ~y~" .. kills)
			end
			AlterWantedLevel(GetPlayerId(), 0)
			ApplyWantedLevelChangeNow(GetPlayerId())
			for i=1,40,1 do
				if(not DoesBlipExist(svblip[i])) then
					if(i <= 10) then
						svblip[i] = AddBlipForCoord(svzone[svid][1][1]-svzone[svid][2]/2, svzone[svid][1][2]-svzone[svid][3]/2+svzone[svid][3]/10*i, svzone[svid][1][3], _i)
					elseif(i>10 and i<=20) then
						svblip[i] = AddBlipForCoord(svzone[svid][1][1]+svzone[svid][2]/2, svzone[svid][1][2]-svzone[svid][3]/2+svzone[svid][3]/10*(i-10), svzone[svid][1][3], _i)
					elseif(i>20 and i<=30) then
						svblip[i] = AddBlipForCoord(svzone[svid][1][1]-svzone[svid][2]/2+svzone[svid][2]/10*(i-20), svzone[svid][1][2]-svzone[svid][3]/2, svzone[svid][1][3], _i)
					elseif(i > 30) then
						svblip[i] = AddBlipForCoord(svzone[svid][1][1]-svzone[svid][2]/2+svzone[svid][2]/10*(i-30), svzone[svid][1][2]+svzone[svid][3]/2, svzone[svid][1][3], _i)
					end
					ChangeBlipScale(svblip[i], 0.1)
					ChangeBlipSprite(svblip[i], 3)
					ChangeBlipColour(svblip[i], 1)
					ChangeBlipNameFromAscii(svblip[i], "Match zone")
				end
			end
			if(not LocateCharAnyMeans3d(GetPlayerChar(GetPlayerId()), svzone[svid][1][1], svzone[svid][1][2], svzone[svid][1][3]-10, svzone[svid][2]/2, svzone[svid][3]/2, 100.1, false)) then
				PrintStringWithLiteralStringNow("STRING", "~r~Go back into match zone!", 1000, 1)
				DamageChar(GetPlayerChar(GetPlayerId()), 10, 0)
				Wait(1000)
			end
		else
			for i=1,40,1 do
				if(DoesBlipExist(svblip[i])) then
					RemoveBlip(svblip[i])
				end
			end
		end
	end
end)

local loottimer = {}
for i=1,#lootcoords,1 do
	loottimer[i] = {}
	for j=1,#lootcoords[i],1 do
		loottimer[i][j] = 30
	end
end
CreateThread(function()
	while true do
		Wait(0)
		if(gamemode == 5) then
			Wait(1000)
			for i=1,#lootcoords[svid],1 do
				if(lootstate[svid][i] ~= nil) then
					if(lootstate[svid][i] == 1) then
						loottimer[svid][i] = loottimer[svid][i] - 1
						if(loottimer[svid][i] <= 0) then
							lootstate[svid][i] = 0
						end
					else
						loottimer[svid][i] = 30
					end
				end
			end
		end
	end
end)

SvKill = function(id)
	kills = kills + 1
	TriggerServerEvent('sendMessageForGamemode', gamemode, gmid, '', '^1' .. GetPlayerName(id, _s) .. '^0 got killed by ^1' .. GetPlayerName(GetPlayerId(), _s))
	local px,py,pz = GetCharCoordinates(GetPlayerChar(id))
	DrawSignal(px, py, pz, "+" .. 100*kills .. "$ +" .. 25+25*kills .. "EXP")
	money = money + 100*kills
	experience = experience + 25+25*kills
	SaveStats()
	if(kills%5 == 0) then
		money = money + 100*kills
		experience = experience + 50*kills
		SaveStats()
		TriggerServerEvent('sendMessageForGamemode', gamemode, gmid, '', '^1' .. GetPlayerName(GetPlayerId(), _s) .. '^0 has reached ^1' .. kills .. '^0 kills! (+' .. 100*kills .. '$ and ' .. 50*kills .. ' EXP)')
	end
end
CreateThread(function()
	while true do
		Wait(0)
		if(gamemode == 5) then
			if(IsPlayerDead(GetPlayerId())) then
				kills = 0
			end
			--[[for i=0,31,1 do
				if(IsNetworkPlayerActive(i)) then
					if(IsPlayerDead(i)) then
						if(killblocker[i] == 0) then
							if(ConvertIntToPlayerindex(i) ~= ConvertIntToPlayerindex(GetPlayerId())) then
								if(FindNetworkKillerOfPlayer(i) == GetPlayerId()) then
									kills = kills + 1
									TriggerServerEvent('sendMessageForGamemode', gamemode, gmid, '', '^1' .. GetPlayerName(i, _s) .. '^0 got killed by ^1' .. GetPlayerName(GetPlayerId(), _s))
									local px,py,pz = GetCharCoordinates(GetPlayerChar(i))
									DrawSignal(px, py, pz, "+" .. 100*kills .. "$ +" .. 25+25*kills .. "EXP")
									money = money + 100*kills
									experience = experience + 25+25*kills
									SaveStats()
									if(kills%5 == 0) then
										money = money + 100*kills
										experience = experience + 50*kills
										SaveStats()
										TriggerServerEvent('sendMessageForGamemode', gamemode, gmid, '', '^1' .. GetPlayerName(GetPlayerId(), _s) .. '^0 has reached ^1' .. kills .. '^0 kills! (+' .. 100*kills .. '$ and ' .. 50*kills .. ' EXP)')
									end
								end
							end
							killblocker[i] = 1
						else
							kills = 0
						end
					else
						killblocker[i] = 0
					end
				end
			end]]
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		if(gamemode == 5) then
			local first = -1
			for i=0,31,1 do
				if(playermode[i][1] == gamemode) then
					if(playermode[i][2] == svid) then
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
										TriggerServerEvent('rewardSvKill', j, px, py, pz)
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
								local rnd = GenerateRandomIntInRange(1, #resp[svid]+1)
								local rnd2 = GenerateRandomIntInRange(1, #skins+1)
								bots[i] = SpawnPed(GetHashKey(skins[rnd2]), resp[svid][rnd][1], resp[svid][rnd][2], resp[svid][rnd][3], resp[svid][rnd][4])
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
										--TriggerServerEvent('decreaseKills', i)
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

RegisterNetEvent('rewardSvKill')
AddEventHandler('rewardSvKill', function(id, x, y, z)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		if(gamemode == 5) then
			kills = kills + 1
			DrawSignal(x, y, z, "+" .. 100*kills .. "$ +" .. 25+25*kills .. "EXP")
			money = money + 100*kills
			experience = experience + 25+25*kills
			SaveStats()
			if(kills%5 == 0) then
				money = money + 100*kills
				experience = experience + 50*kills
				SaveStats()
				TriggerServerEvent('sendMessageForGamemode', gamemode, gmid, '', '^1' .. GetPlayerName(GetPlayerId(), _s) .. '^0 has reached ^1' .. kills .. '^0 kills! (+' .. 100*kills .. '$ and ' .. 50*kills .. ' EXP)')
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
		if(id == 5) then
			if(svid == modeid) then
				kills = 0
				gamemode = 0
				playermode[ConvertIntToPlayerindex(GetPlayerId())] = {0, 0}
				TriggerServerEvent('updModes', playermode)
				SetCharCoordinates(GetPlayerChar(GetPlayerId()), svcoords[svid][1], svcoords[svid][2], svcoords[svid][3])
				RemoveAllCharWeapons(GetPlayerChar(GetPlayerId()))
				for i=1,8,1 do
					GiveWeaponToChar(GetPlayerChar(GetPlayerId()), weps[i][1], weps[i][2], 1)
				end
			end
		end
	end
end)