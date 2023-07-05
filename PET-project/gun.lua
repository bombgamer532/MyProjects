weps = {}
for i=1,8,1 do
	weps[i] = {0,0,0}
end

RegisterNetEvent('updWeps')
AddEventHandler('updWeps', function(data)
	for i=1,8,1 do
		if(data[i] == nil) then
			data[i] = {0,0,0}
		end
		weps[i][1] = tonumber(data[i][1])
		weps[i][2] = tonumber(data[i][2])
	end
end)

local guncoords = {
{1067.31335, 87.11202, 34.25125, 178.692932128906},
{82.20334, -342.00589, 11.18179, 178.316635131836},
{-1333.16357, 318.77249, 14.62244, 276.131530761719}
}
local gunblip = {}
guns = {
{"Baseball_bat", 1, 5, 1},
{"Pool_cue", 2, 5, 1},
{"Broken_pool_cue", 24, 5, 1}, --episodic 4
{"Knife", 3, 10, 1},
{"Grenade", 4, 300, 1},
{"Molotov", 5, 100, 1},
{"Glock_17", 7, 35, 10},
{"Deagle", 9, 100, 10},
{"Pump_shotgun", 10, 100, 10},
{"Baretta", 11, 200, 10},
{"Micro_Uzi", 12, 100, 10},
{"MP5", 13, 150, 10},
{"AK-47", 14, 80, 10},
{"M4", 15, 100, 10},
{"Sniper_Rifle", 16, 800, 10},
{"M40A1", 17, 500, 10},
{"RPG", 18, 2000, 1},
{"Grenade_Launcher", 21, 7000, 10},
{"Assault_Shotgun", 22, 350, 10},
--{"Episodic_3", 23, 1, 10},
--{"Episodic_5", 25, 1, 10},
{"Sawn-Off_Shotgun", 26, 200, 10},
{"Automatic_Pistol", 27, 150, 10},
{"Pipe_Bomb", 28, 700, 1},
{"Pistol_.44", 29, 100, 10},
--{"AA12_(Explosive_shells)", 30, 5000, 10},
{"AA12", 31, 500, 10},
{"P90", 32, 200, 10},
{"Golden_Uzi", 33, 200, 10},
{"M249", 34, 1000, 50},
--{"Advanced_Sniper", 35, 5000, 10},
{"Sticky_Bomb", 36, 800, 1}
}

RegisterNetEvent('playerSpawned')
AddEventHandler('playerSpawned', function()
	CreateThread(function()
		if(gamemode == 0) then
			Wait(1000)
		end
		for i=1,9,1 do
			if(i == 1) then
				local model = currparts[1]
				RequestModel(model)
				while not HasModelLoaded(model) do
					Wait(0)
					RequestModel(model)
				end
				ChangePlayerModel(GetPlayerId(), model)
				if(IsInteriorScene() and GetKeyForViewportInRoom(GetGameViewportId())~=0) then
					SetRoomForCharByKey(GetPlayerChar(GetPlayerId()), GetKeyForViewportInRoom(GetGameViewportId()))
				end
			elseif(i>=2 and i<=8) then
				SetCharComponentVariation(GetPlayerChar(GetPlayerId()), bodyparts2[i-1], currparts[i], currparts[i+7])
			else
				SetCharPropIndex(GetPlayerChar(GetPlayerId()), 0, currparts[16])
				SetCharPropIndex(GetPlayerChar(GetPlayerId()), 1, currparts[17])
			end
		end
		if(gamemode == 0) then
			for i=1,8,1 do
				GiveWeaponToChar(GetPlayerChar(GetPlayerId()), weps[i][1], weps[i][2], 1)
			end
		end
	end)
end)

CompareTables = function(t1, t2)
	if(#t1 == #t2) then
		for i=1,#t1,1 do
			if(type(t1[i])=="table" and type(t2[i])=="table") then
				if(not CompareTables(t1[i], t2[i])) then
					return false
				end
			else
				if(t1[i] ~= t2[i]) then
					return false
				end
			end
		end
		return true
	else
		return false
	end
end

local wepdata = {}
CreateThread(function()
	while true do
		Wait(0)
		if(loginform == 0) then
			if(IsPlayerControlOn(GetPlayerId())) then
				if(IsNetworkPlayerActive(GetPlayerId())) then
					if(not IsPlayerDead(GetPlayerId())) then
						if(IsCharModel(GetPlayerChar(GetPlayerId()), currparts[1])) then
							Wait(10000)
							if(IsNetworkPlayerActive(GetPlayerId())) then
								if(not IsPlayerDead(GetPlayerId())) then
									if(IsCharModel(GetPlayerChar(GetPlayerId()), currparts[1])) then
										if(IsScreenFadedIn()) then
											if(gamemode == 0) then
												local data = {}
												for i=1,8,1 do
													data[i] = table.pack(GetCharWeaponInSlot(GetPlayerChar(GetPlayerId()), i))
												end
												if(not CompareTables(data, wepdata)) then
													TriggerServerEvent('saveWeps', data)
													wepdata = data
												end
											end
										end
									end
								end
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
		for i=1,#guncoords,1 do
			if(not DoesBlipExist(gunblip[i])) then
				gunblip[i] = AddBlipForCoord(guncoords[i][1], guncoords[i][2], guncoords[i][3], _i)
				ChangeBlipSprite(gunblip[i], 59)
				ChangeBlipScale(gunblip[i], 0.7)
				ChangeBlipNameFromAscii(gunblip[i], "Gun shop")
				SetBlipAsShortRange(gunblip[i], true)
			end
			DrawCheckpointWithDist(guncoords[i][1], guncoords[i][2], guncoords[i][3]-1, 1.1, 255, 255, 0, 100)
			if(IsPlayerNearCoords(guncoords[i][1], guncoords[i][2], guncoords[i][3], 1)) then
				PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~open gun shop menu", 1000, 1)
				if(IsGameKeyboardKeyJustPressed(18)) then
					::again::
					local tempitems = {}
					tempitems[#tempitems+1] = "Replenish armor ~g~(300$)"
					tempitems[#tempitems+1] = "Light armor vest ~g~(150$)"
					tempitems[#tempitems+1] = "Heavy armor vest ~g~(300$)"
					tempitems[#tempitems+1] = "Ammo box ~g~(500$)"
					for i=1,#guns,1 do
						if(i>=1 and i<=6) then
							tempitems[#tempitems+1] = "" .. guns[i][1] .. " ~g~(" .. guns[i][3] .. "$)"
						else
							tempitems[#tempitems+1] = "" .. guns[i][1]
						end
					end
					DrawWindow("Gun_shop", tempitems)
					while menuactive do
						Wait(0)
					end
					if(menuresult > 0) then
						if(tempitems[menuresult] == "Replenish armor ~g~(300$)") then
							if(money >= 300) then
								money = money - 300
								SaveStats()
								AddArmourToChar(GetPlayerChar(GetPlayerId()), 100)
								TriggerEvent('chatMessage', '[Gun shop]', {0, 255, 0}, 'Armor replenished')
							else
								TriggerEvent('chatMessage', '[Gun shop]', {255, 0, 0}, 'You cannot afford it!')
							end
						elseif(tempitems[menuresult] == "Light armor vest ~g~(150$)") then
							if(inv[4] < 10) then
								if(money >= 150) then
									money = money - 150
									SaveStats()
									inv[4] = inv[4] + 1
									SaveInv()
									TriggerEvent('chatMessage', '[Gun shop]', {0, 255, 0}, 'Light armor vest purchased')
								else
									TriggerEvent('chatMessage', '[Gun shop]', {255, 0, 0}, 'You cannot afford it!')
								end
							else
								TriggerEvent('chatMessage', '[Gun shop]', {255, 0, 0}, 'Maximum amount reached!')
							end
						elseif(tempitems[menuresult] == "Heavy armor vest ~g~(300$)") then
							if(inv[5] < 10) then
								if(money >= 300) then
									money = money - 300
									SaveStats()
									inv[5] = inv[5] + 1
									SaveInv()
									TriggerEvent('chatMessage', '[Gun shop]', {0, 255, 0}, 'Heavy armor vest purchased')
								else
									TriggerEvent('chatMessage', '[Gun shop]', {255, 0, 0}, 'You cannot afford it!')
								end
							else
								TriggerEvent('chatMessage', '[Gun shop]', {255, 0, 0}, 'Maximum amount reached!')
							end
						elseif(tempitems[menuresult] == "Ammo box ~g~(500$)") then
							if(inv[6] < 10) then
								if(money >= 500) then
									money = money - 500
									SaveStats()
									inv[6] = inv[6] + 1
									SaveInv()
									TriggerEvent('chatMessage', '[Gun shop]', {0, 255, 0}, 'Ammo box purchased')
								else
									TriggerEvent('chatMessage', '[Gun shop]', {255, 0, 0}, 'You cannot afford it!')
								end
							else
								TriggerEvent('chatMessage', '[Gun shop]', {255, 0, 0}, 'Maximum amount reached!')
							end
						else
							for i=1,#guns,1 do
								if(i>=1 and i<=6) then
									if(tempitems[menuresult] == "" .. guns[i][1] .. " ~g~(" .. guns[i][3] .. "$)") then
										if(money >= guns[i][3]) then
											money = money - guns[i][3]
											SaveStats()
											GiveWeaponToChar(GetPlayerChar(GetPlayerId()), guns[i][2], guns[i][4], 1)
											TriggerEvent('chatMessage', '[Gun shop]', {0, 255, 0}, '' .. guns[i][1] .. ' purchased')
										else
											TriggerEvent('chatMessage', '[Gun shop]', {255, 0, 0}, 'You cannot afford it!')
										end
									end
								else
									if(tempitems[menuresult] == "" .. guns[i][1]) then
										::wep::
										local tempitems = {}
										tempitems[#tempitems+1] = "" .. guns[i][4] .. " bullets ~g~(" .. guns[i][3] .. "$)"
										tempitems[#tempitems+1] = "" .. guns[i][4]*2 .. " bullets ~g~(" .. guns[i][3]*2 .. "$)"
										tempitems[#tempitems+1] = "" .. guns[i][4]*5 .. " bullets ~g~(" .. guns[i][3]*5 .. "$)"
										tempitems[#tempitems+1] = "" .. guns[i][4]*10 .. " bullets ~g~(" .. guns[i][3]*10 .. "$)"
										DrawWindow("" .. guns[i][1], tempitems)
										while menuactive do
											Wait(0)
										end
										if(menuresult > 0) then
											if(tempitems[menuresult] == "" .. guns[i][4] .. " bullets ~g~(" .. guns[i][3] .. "$)") then
												if(money >= guns[i][3]) then
													money = money - guns[i][3]
													SaveStats()
													GiveWeaponToChar(GetPlayerChar(GetPlayerId()), guns[i][2], guns[i][4], 1)
													TriggerEvent('chatMessage', '[Gun shop]', {0, 255, 0}, '' .. guns[i][1] .. ' purchased')
												else
													TriggerEvent('chatMessage', '[Gun shop]', {255, 0, 0}, 'You cannot afford it!')
												end
											elseif(tempitems[menuresult] == "" .. guns[i][4]*2 .. " bullets ~g~(" .. guns[i][3]*2 .. "$)") then
												if(money >= guns[i][3]*2) then
													money = money - guns[i][3]*2
													SaveStats()
													GiveWeaponToChar(GetPlayerChar(GetPlayerId()), guns[i][2], guns[i][4]*2, 1)
													TriggerEvent('chatMessage', '[Gun shop]', {0, 255, 0}, '' .. guns[i][1] .. ' purchased')
												else
													TriggerEvent('chatMessage', '[Gun shop]', {255, 0, 0}, 'You cannot afford it!')
												end
											elseif(tempitems[menuresult] == "" .. guns[i][4]*5 .. " bullets ~g~(" .. guns[i][3]*5 .. "$)") then
												if(money >= guns[i][3]*5) then
													money = money - guns[i][3]*5
													SaveStats()
													GiveWeaponToChar(GetPlayerChar(GetPlayerId()), guns[i][2], guns[i][4]*5, 1)
													TriggerEvent('chatMessage', '[Gun shop]', {0, 255, 0}, '' .. guns[i][1] .. ' purchased')
												else
													TriggerEvent('chatMessage', '[Gun shop]', {255, 0, 0}, 'You cannot afford it!')
												end
											elseif(tempitems[menuresult] == "" .. guns[i][4]*10 .. " bullets ~g~(" .. guns[i][3]*10 .. "$)") then
												if(money >= guns[i][3]*10) then
													money = money - guns[i][3]*10
													SaveStats()
													GiveWeaponToChar(GetPlayerChar(GetPlayerId()), guns[i][2], guns[i][4]*10, 1)
													TriggerEvent('chatMessage', '[Gun shop]', {0, 255, 0}, '' .. guns[i][1] .. ' purchased')
												else
													TriggerEvent('chatMessage', '[Gun shop]', {255, 0, 0}, 'You cannot afford it!')
												end
											end
											goto wep
										end
									end
								end
							end
						end
						goto again
					end
				end
			end
		end
	end
end)