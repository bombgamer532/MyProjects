local orgprice = 50000
local orgcoords = {
{126.44315, -668.15814, 14.77173, 176.78288269043}
}
local orgblip = {}

local currmission = 0
local currstage = 0
local EndMission = function()
	currmission = 0
	currstage = 0
	CleanMission()
end

CreateThread(function()
	while true do
		Wait(0)
		for i=1,#orgcoords,1 do
			if(not DoesBlipExist(orgblip[i])) then
				orgblip[i] = AddBlipForCoord(orgcoords[i][1], orgcoords[i][2], orgcoords[i][3], _i)
				ChangeBlipSprite(orgblip[i], 82)
				ChangeBlipScale(orgblip[i], 0.7)
				ChangeBlipNameFromAscii(orgblip[i], "Organization")
				SetBlipAsShortRange(orgblip[i], true)
			end
			if(org == 0) then
				DrawTextAtCoord(orgcoords[i][1], orgcoords[i][2], orgcoords[i][3], "Organization Price:_" .. orgprice .. "$ Level_needed:_20", 20)
				ChangeBlipColour(orgblip[i], 0)
			else
				DrawTextAtCoord(orgcoords[i][1], orgcoords[i][2], orgcoords[i][3], "Organization", 20)
				ChangeBlipColour(orgblip[i], 2)
			end
			DrawCheckpointWithDist(orgcoords[i][1], orgcoords[i][2], orgcoords[i][3]-1, 1.1, 255, 255, 0, 100)
			if(IsPlayerNearCoords(orgcoords[i][1], orgcoords[i][2], orgcoords[i][3], 1)) then
				DrawDescription("Organization", {
				-----------------------------------------------------------------------------------------------
				"Organization provides access to several missions, which are available only to owners of",
				"organization. Also there you can launch heists and preparation missions for them.",
				"Besides that, you get ability to create your own clan and invite other players there. Clan",
				"provides some bonuses like special gun shop with lowered prices, and increased payment for",
				"organization missions.",
				"Also clan lets you capture territories, which are marked with squares (these markers can be",
				"seen only by clan members). Every in-game day in 00:00 all clan members receive payment,",
				"which depends on number of captured territories. If someone starts capturing your area, you",
				"will be alarmed and there will be some time for you to react and protect it."
				})
				if(org == 0) then
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to purchase ~y~this organization ~w~for ~g~" .. orgprice .. "$", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						if(level >= 20) then
							local hashouse = 0
							for j=1,#houses,1 do
								if(houses[j] == 1) then
									hashouse = 1
								end
							end
							if(hashouse == 1) then
								if(money >= orgprice) then
									money = money - orgprice
									org = i
									SaveStats()
									TriggerEvent('chatMessage', '[Organization]', {0, 255, 0}, 'This organization has been successfully purchased!')
								else
									TriggerEvent('chatMessage', '[Organization]', {255, 0, 0}, 'You cannot afford it!')
								end
							else
								TriggerEvent('chatMessage', '[Organization]', {255, 0, 0}, 'You must own an apartment!')
							end
						else
							TriggerEvent('chatMessage', '[Organization]', {255, 0, 0}, 'You must reach level 20!')
						end
					end
				elseif(org == i) then
					PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~open organization menu", 1000, 1)
					if(IsGameKeyboardKeyJustPressed(18)) then
						local tempitems = {}
						tempitems[#tempitems+1] = "Collect income from all businesses"
						tempitems[#tempitems+1] = "Missions"
						tempitems[#tempitems+1] = "Heists"
						tempitems[#tempitems+1] = "Clan"
						DrawWindow("Organization", tempitems)
						while menuactive do
							Wait(0)
						end
						if(menuresult > 0) then
							if(tempitems[menuresult] == "Collect income from all businesses") then
								local tempmoney = 0
								for j=1,#biz,1 do
									tempmoney = tempmoney + bizmoney[j]
									bizmoney[j] = 0
								end
								SaveBizMoney()
								money = money + tempmoney
								SaveStats()
								TriggerEvent('chatMessage', '[Business]', {0, 255, 0}, 'Income collected (+' .. tempmoney .. '$)')
							elseif(tempitems[menuresult] == "Missions") then
								if(missionstarted == 0) then
									if(coop[ConvertIntToPlayerindex(GetPlayerId())] == -1) then
										local tempitems = {}
										tempitems[#tempitems+1] = "Asset Recovery"
										tempitems[#tempitems+1] = "Hostile Takeover"
										tempitems[#tempitems+1] = "Sightseer"
										tempitems[#tempitems+1] = "Headhunter"
										DrawWindow("Missions", tempitems)
										while menuactive do
											Wait(0)
											if(currbutton == 1) then
												DrawDescription("Asset Recovery", {
												-----------------------------------------------------------------------------------------------
												"Our contact is interested in getting specific vehs from his wishlist. Three of them are",
												"located and waiting for you to steal. We need all of them, destroyed car will make him angry."
												})
											elseif(currbutton == 2) then
												DrawDescription("Hostile Takeover", {
												-----------------------------------------------------------------------------------------------
												"FIB managed to get valuable information of our contact. Currently their currier is about to",
												"deliver this information to their headquarters. You must prevent them from doing it. He is",
												"being protected by FIB agents, so be careful."
												})
											elseif(currbutton == 3) then
												DrawDescription("Sightseer", {
												-----------------------------------------------------------------------------------------------
												"The briefcase with information has been lost during last rivals attack. This briefcase must",
												"be found faster than they will do so. We've received signals from 3 locations, but the case",
												"is only at one of them."
												})
											elseif(currbutton == 4) then
												DrawDescription("Headhunter", {
												-----------------------------------------------------------------------------------------------
												"We keep being attacked by several rival groups. It's time to get rid of them. Visit 3 marked",
												"locations and remove them."
												})
											end
										end
										if(menuresult > 0) then
											if(tempitems[menuresult] == "Asset Recovery") then
												local coords = {
												{-1248.49292, -261.01511, 2.92883, 179.295394897461},
												{92.93098, 1242.75818, 15.9078, 123.013854980469},
												{2111.80249, 414.31241, 6.08499, 269.186645507813}
												}
												local carlist = {
												"FELTZER",
												"INFERNUS",
												"PMP600",
												"ORACLE",
												"LANDSTALKER",
												"FEROCI",
												"HUNTLEY",
												"COMET",
												"COQUETTE",
												"COGNOSCENTI",
												"CAVALCADE",
												"BANSHEE",
												"PATRIOT",
												"RUINER",
												"SULTAN",
												"SULTANRS",
												"SUPERGT",
												"TURISMO"
												}
												for i=1,3,1 do
													vehs[i] = SpawnCar(GetHashKey(carlist[GenerateRandomIntInRange(1, #carlist+1)]), coords[i][1], coords[i][2], coords[i][3], coords[i][4])
													blips[i] = AddBlipForCar(vehs[i])
												end
												blips[4] = AddBlipForCoord(76.8194, 583.05579, 14.71782)
												SetObjective("Steal ~y~all vehs ~w~and deliver them to ~y~the drop-off")
												TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
												currmission = 1
												missionstarted = 1
											elseif(tempitems[menuresult] == "Hostile Takeover") then
												vehs[1] = SpawnCar(GetHashKey("FBI"), 2059.30054, 244.03511, 18.94094, 158.60530090332)
												peds[1] = SpawnPed(GetHashKey("M_O_SUITED"), 2059.30054, 244.03511, 18.94094, 158.60530090332)
												WarpCharIntoCarAsPassenger(peds[1], vehs[1], 2)
												peds[2] = SpawnPed(GetHashKey("M_M_FBI"), 2059.30054, 244.03511, 18.94094, 158.60530090332)
												GiveWeaponToChar(peds[2], 13, 1000, 1)
												WarpCharIntoCar(peds[2], vehs[1])
												peds[3] = SpawnPed(GetHashKey("M_M_FBI"), 2059.30054, 244.03511, 18.94094, 158.60530090332)
												GiveWeaponToChar(peds[3], 13, 1000, 1)
												WarpCharIntoCarAsPassenger(peds[3], vehs[1], 0)
												peds[4] = SpawnPed(GetHashKey("M_M_FBI"), 2059.30054, 244.03511, 18.94094, 158.60530090332)
												GiveWeaponToChar(peds[4], 13, 1000, 1)
												WarpCharIntoCarAsPassenger(peds[4], vehs[1], 1)
												TaskCarMission(peds[2], vehs[1], vehs[1], 1, 10.1, 0, 0, 10)
												blips[1] = AddBlipForChar(peds[1])
												SetObjective("Kill ~y~the courier")
												TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
												currmission = 2
												missionstarted = 1
											elseif(tempitems[menuresult] == "Sightseer") then
												local coords = {
												{1315.9209, 584.08252, 38.99526, 269.062194824219},
												{-227.77805, 690.90735, 3.4474, 359.297546386719},
												{-1078.68359, 692.31055, 8.50523, 358.232971191406}
												}
												local rnd = GenerateRandomIntInRange(1, #coords+1)
												objs[1] = SpawnObject(GetHashKey("cj_case_2"), coords[rnd][1], coords[rnd][2], coords[rnd][3]-1, coords[rnd][4])
												for i=1,#coords,1 do
													if(i == rnd) then
														blips[i] = AddBlipForObject(objs[1])
													else
														blips[i] = AddBlipForCoord(coords[i][1], coords[i][2], coords[i][3])
													end
													ChangeBlipColour(blips[i], 2)
													ChangeBlipNameFromAscii(blips[i], "Target")
												end
												SetObjective("Collect ~y~the briefcase ~w~which is located at one of ~y~three locations")
												TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
												currmission = 3
												missionstarted = 1
											elseif(tempitems[menuresult] == "Headhunter") then
												local coords = {
												{-405.39371, 1652.83875, 21.08428, 163.946182250977},
												{-421.97836, 1646.06799, 21.08428, 114.655799865723},
												{-430.35242, 1657.59338, 21.08428, 18.5025882720947},
												{-419.60413, 1664.86255, 21.08428, 206.74787902832},
												{-405.16174, 1672.25574, 21.08428, 198.265197753906},
												{-1409.2478, 905.87079, 22.58907, 75.4296722412109},
												{-1424.85767, 893.11871, 23.03681, 47.928150177002},
												{-1446.28357, 882.96954, 22.98962, 11.6795501708984},
												{-1467.70337, 898.53027, 25.05276, 263.752197265625},
												{-1435.78857, 913.54858, 23.61636, 174.734497070313},
												{1055.05688, 694.22162, 33.94951, 269.06591796875},
												{1047.00696, 699.59656, 33.94979, 103.224380493164},
												{1045.74915, 713.39221, 33.94979, 0.506504595279694},
												{1054.23083, 715.91272, 33.94979, 254.330993652344},
												{1055.89124, 707.55597, 33.9495, 177.435943603516}
												}
												for i=1,5,1 do
													peds[i] = SpawnPed(GetHashKey("M_M_EE_HEAVY_01"), coords[i][1], coords[i][2], coords[i][3], coords[i][4])
													GiveWeaponToChar(peds[i], 9, 1000, 1)
												end
												for i=6,10,1 do
													peds[i] = SpawnPed(GetHashKey("M_M_CHINATOWN_01"), coords[i][1], coords[i][2], coords[i][3], coords[i][4])
													GiveWeaponToChar(peds[i], 12, 1000, 1)
												end
												for i=11,15,1 do
													peds[i] = SpawnPed(GetHashKey("M_M_GUNNUT_01"), coords[i][1], coords[i][2], coords[i][3], coords[i][4])
													GiveWeaponToChar(peds[i], 10, 1000, 1)
												end
												for i=1,15,1 do
													blips[i] = AddBlipForChar(peds[i])
												end
												SetObjective("Kill all ~y~marked groups of mobsters")
												TriggerEvent('chatMessage', '[Mission]', {255, 255, 0}, 'Mission started!')
												currmission = 4
												missionstarted = 1
											end
										end
									else
										TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'Only a leader of your co-op team can start missions!')
									end
								else
									TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'Mission in progress!')
								end
							elseif(tempitems[menuresult] == "Heists") then
								if(missionstarted == 0) then
									if(coop[ConvertIntToPlayerindex(GetPlayerId())] == -1) then
										local tempitems = {}
										tempitems[#tempitems+1] = "Platypus"
										tempitems[#tempitems+1] = "Deconstruction"
										tempitems[#tempitems+1] = "LCPD Raid"
										tempitems[#tempitems+1] = "Bank of Liberty"
										tempitems[#tempitems+1] = "Libertonian"
										tempitems[#tempitems+1] = "Prison Break"
										tempitems[#tempitems+1] = "Special Cargo"
										DrawWindow("Heists", tempitems)
										while menuactive do
											Wait(0)
											if(currbutton == 1) then
												DrawDescription("Platypus", {
												-----------------------------------------------------------------------------------------------
												"Steal valuable stuff from russian mafia on Platypus cargo ship."
												})
											elseif(currbutton == 2) then
												DrawDescription("Deconstruction", {
												-----------------------------------------------------------------------------------------------
												"Help local mafia boss to get rid of russian mobsters in this area, who are based on the",
												"construction site."
												})
											elseif(currbutton == 3) then
												DrawDescription("LCPD Raid", {
												-----------------------------------------------------------------------------------------------
												"Hack LCPD database to steal valuable information."
												})
											elseif(currbutton == 4) then
												DrawDescription("Bank of Liberty", {
												-----------------------------------------------------------------------------------------------
												"Break into the Bank of Liberty, enter the vault and steal cash."
												})
											elseif(currbutton == 5) then
												DrawDescription("Libertonian", {
												-----------------------------------------------------------------------------------------------
												"Enter the Libertonian museum, find the safe and hack it to get cash."
												})
											elseif(currbutton == 6) then
												DrawDescription("Prison Break", {
												-----------------------------------------------------------------------------------------------
												"Help our contact to set free the needed prisoner out of Alderney State Correctional Facility."
												})
											elseif(currbutton == 7) then
												DrawDescription("Special Cargo", {
												-----------------------------------------------------------------------------------------------
												"Steal special cargo from highly secured area of the docks."
												})
											end
										end
										if(menuresult > 0) then
											if(tempitems[menuresult] == "Platypus") then
												if(biz[3]==1 or biz[4]==1) then
													ProceedToRobbery3()
												else
													TriggerEvent('chatMessage', '[Heist]', {255, 0, 0}, 'You must own at least one repair shop business!')
												end
											elseif(tempitems[menuresult] == "Deconstruction") then
												--if(biz[1]==1 or biz[2]==1) then
												if(biz[15]==1 or biz[16]==1 or biz[17]==1) then
													ProceedToRobbery6()
												else
													--TriggerEvent('chatMessage', '[Heist]', {255, 0, 0}, 'You must own at least one strip club business!')
													TriggerEvent('chatMessage', '[Heist]', {255, 0, 0}, 'You must own at least one gas station business!')
												end
											elseif(tempitems[menuresult] == "LCPD Raid") then
												--if(biz[5]==1 or biz[6]==1 or biz[7]==1) then
												if(biz[1]==1 or biz[2]==1) then
													ProceedToRobbery5()
												else
													--TriggerEvent('chatMessage', '[Heist]', {255, 0, 0}, 'You must own at least one car park business!')
													TriggerEvent('chatMessage', '[Heist]', {255, 0, 0}, 'You must own at least one strip club business!')
												end
											elseif(tempitems[menuresult] == "Bank of Liberty") then
												--if(biz[8]==1 or biz[9]==1) then --warehouses
												--if(biz[1]==1 or biz[2]==1) then
												--if(biz[5]==1 or biz[6]==1 or biz[7]==1) then
												--if(biz[8]==1 or biz[9]==1) then
												if(biz[5]==1 or biz[6]==1 or biz[7]==1) then
													ProceedToRobbery1()
												else
													--TriggerEvent('chatMessage', '[Heist]', {255, 0, 0}, 'You must own at least one strip club business!')
													--TriggerEvent('chatMessage', '[Heist]', {255, 0, 0}, 'You must own at least one warehouse business!')
													TriggerEvent('chatMessage', '[Heist]', {255, 0, 0}, 'You must own at least one car park business!')
												end
											elseif(tempitems[menuresult] == "Libertonian") then
												--if(biz[5]==1 or biz[6]==1 or biz[7]==1) then
												--if(biz[8]==1 or biz[9]==1) then
												--if(biz[10]==1 or biz[11]==1 or biz[12]==1) then
												if(biz[8]==1 or biz[9]==1) then
													ProceedToRobbery2()
												else
													--TriggerEvent('chatMessage', '[Heist]', {255, 0, 0}, 'You must own at least one car park business!')
													--TriggerEvent('chatMessage', '[Heist]', {255, 0, 0}, 'You must own at least one nightclub business!')
													TriggerEvent('chatMessage', '[Heist]', {255, 0, 0}, 'You must own at least one warehouse business!')
												end
											elseif(tempitems[menuresult] == "Prison Break") then
												--if(biz[1]==1 or biz[2]==1) then --strip clubs
												--if(biz[10]==1 or biz[11]==1 or biz[12]==1) then
												--if(biz[13]==1 or biz[14]==1) then
												if(biz[10]==1 or biz[11]==1 or biz[12]==1) then
													ProceedToRobbery4()
												else
													TriggerEvent('chatMessage', '[Heist]', {255, 0, 0}, 'You must own at least one nightclub business!')
												end
											elseif(tempitems[menuresult] == "Special Cargo") then
												if(biz[13]==1 or biz[14]==1) then
													ProceedToRobbery7()
												else
													TriggerEvent('chatMessage', '[Heist]', {255, 0, 0}, 'You must own at least one clubhouse business!')
												end
											end
										end
									else
										TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'Only a leader of your co-op team can start heists and preparation missions!')
									end
								else
									TriggerEvent('chatMessage', '[Mission]', {255, 0, 0}, 'Only a leader of your co-op team can start missions!')
								end
							elseif(tempitems[menuresult] == "Clan") then
								local tempitems = {}
								tempitems[#tempitems+1] = "Clan management"
								tempitems[#tempitems+1] = "Gun shop"
								if(clan ~= "0") then
									tempitems[#tempitems+1] = "Leave clan"
								end
								DrawWindow("Clan", tempitems)
								while menuactive do
									Wait(0)
								end
								if(menuresult > 0) then
									if(tempitems[menuresult] == "Clan management") then
										if((clanowned==0 and clan=="0") or (clanowned==1 and clan=="0") or (clanowned==1 and clan=="" .. GetPlayerName(GetPlayerId()))) then
											local tempitems = {}
											if(clanowned == 0) then
												tempitems[#tempitems+1] = "Create clan ~g~(100000$)"
											elseif(clanowned == 1) then
												if(clan == "0") then
													tempitems[#tempitems+1] = "Become boss"
												else
													if(clan == "" .. GetPlayerName(GetPlayerId())) then
														tempitems[#tempitems+1] = "Invite players"
														tempitems[#tempitems+1] = "Remove player"
														tempitems[#tempitems+1] = "Set clan name"
													end
												end
											end
											DrawWindow("Clan_management", tempitems)
											while menuactive do
												Wait(0)
											end
											if(menuresult > 0) then
												if(tempitems[menuresult] == "Create clan ~g~(100000$)") then
													if(money >= 100000) then
														money = money - 100000
														clanowned = 1
														clan = "" .. GetPlayerName(GetPlayerId(), _s)
														SaveStats()
														TriggerEvent('chatMessage', '[Clan]', {0, 255, 0}, 'Clan created! You can invite players now.')
													else
														TriggerEvent('chatMessage', '[Clan]', {255, 0, 0}, 'You cannot afford it!')
													end
												elseif(tempitems[menuresult] == "Become boss") then
													clan = "" .. GetPlayerName(GetPlayerId(), _s)
													SaveStats()
													TriggerEvent('chatMessage', '[Clan]', {0, 255, 0}, 'You are the boss of your clan now.')
												elseif(tempitems[menuresult] == "Invite players") then
													if(clan == "" .. GetPlayerName(GetPlayerId(), _s)) then
														local tempitems = {}
														local tempids = {}
														for j=0,31,1 do
															if(IsNetworkPlayerActive(j)) then
																if(ConvertIntToPlayerindex(j) ~= ConvertIntToPlayerindex(GetPlayerId())) then
																	tempitems[#tempitems+1] = "" .. GetPlayerName(j, _s)
																	tempids[#tempids+1] = j
																end
															end
														end
														DrawWindow("Select_player_to_invite", tempitems)
														while menuactive do
															Wait(0)
														end
														if(menuresult > 0) then
															TriggerServerEvent('invitePlayerToClan', tempids[menuresult], ConvertIntToPlayerindex(GetPlayerId()))
															TriggerEvent('chatMessage', '[Clan]', {255, 255, 0}, 'Invite has been sent.')
														end
													else
														TriggerEvent('chatMessage', '[Clan]', {255, 0, 0}, 'You must own a clan!')
													end
												elseif(tempitems[menuresult] == "Remove player") then
													if(clan == "" .. GetPlayerName(GetPlayerId(), _s)) then
														local tempitems = {}
														local tempids = {}
														for j=0,31,1 do
															if(IsNetworkPlayerActive(j)) then
																if(ConvertIntToPlayerindex(j) ~= ConvertIntToPlayerindex(GetPlayerId())) then
																	tempitems[#tempitems+1] = "" .. GetPlayerName(j, _s)
																	tempids[#tempids+1] = j
																end
															end
														end
														DrawWindow("Select_player_to_remove", tempitems)
														while menuactive do
															Wait(0)
														end
														if(menuresult > 0) then
															TriggerServerEvent('removePlayerFromClan', tempids[menuresult], ConvertIntToPlayerindex(GetPlayerId()))
														end
													else
														TriggerEvent('chatMessage', '[Clan]', {255, 0, 0}, 'You must own a clan!')
													end
												elseif(tempitems[menuresult] == "Set clan name") then
													local name = ActivateInput("Set")
													if(name ~= "") then
														TriggerServerEvent('setClanName', clan, name)
														TriggerEvent('chatMessage', '[Clan]', {0, 255, 0}, 'Clan name changed.')
													end
												end
											end
										else
											TriggerEvent('chatMessage', '[Clan]', {255, 0, 0}, 'Leave the clan you are currently in to enter this menu.')
										end
									elseif(tempitems[menuresult] == "Gun shop") then
										if(clan ~= "0") then
											::again::
											local tempitems = {}
											tempitems[#tempitems+1] = "Replenish armor ~g~(200$)"
											tempitems[#tempitems+1] = "Light armor vest ~g~(100$)"
											tempitems[#tempitems+1] = "Heavy armor vest ~g~(200$)"
											tempitems[#tempitems+1] = "Ammo box ~g~(300$)"
											for i=1,#guns,1 do
												if(i>=1 and i<=6) then
													tempitems[#tempitems+1] = "" .. guns[i][1] .. " ~g~(" .. guns[i][3]/2 .. "$)"
												else
													tempitems[#tempitems+1] = "" .. guns[i][1]
												end
											end
											DrawWindow("Gun_shop", tempitems)
											while menuactive do
												Wait(0)
											end
											if(menuresult > 0) then
												if(tempitems[menuresult] == "Replenish armor ~g~(200$)") then
													if(money >= 200) then
														money = money - 200
														SaveStats()
														AddArmourToChar(GetPlayerChar(GetPlayerId()), 100)
														TriggerEvent('chatMessage', '[Gun shop]', {0, 255, 0}, 'Armor replenished')
													else
														TriggerEvent('chatMessage', '[Gun shop]', {255, 0, 0}, 'You cannot afford it!')
													end
												elseif(tempitems[menuresult] == "Light armor vest ~g~(100$)") then
													if(inv[4] < 10) then
														if(money >= 100) then
															money = money - 100
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
												elseif(tempitems[menuresult] == "Heavy armor vest ~g~(200$)") then
													if(inv[5] < 10) then
														if(money >= 200) then
															money = money - 200
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
												elseif(tempitems[menuresult] == "Ammo box ~g~(300$)") then
													if(inv[6] < 10) then
														if(money >= 300) then
															money = money - 300
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
															if(tempitems[menuresult] == "" .. guns[i][1] .. " ~g~(" .. guns[i][3]/2 .. "$)") then
																if(money >= guns[i][3]/2) then
																	money = money - guns[i][3]/2
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
																tempitems[#tempitems+1] = "" .. guns[i][4] .. " bullets ~g~(" .. guns[i][3]/2 .. "$)"
																tempitems[#tempitems+1] = "" .. guns[i][4]*2 .. " bullets ~g~(" .. guns[i][3]*2/2 .. "$)"
																tempitems[#tempitems+1] = "" .. guns[i][4]*5 .. " bullets ~g~(" .. guns[i][3]*5/2 .. "$)"
																tempitems[#tempitems+1] = "" .. guns[i][4]*10 .. " bullets ~g~(" .. guns[i][3]*10/2 .. "$)"
																DrawWindow("" .. guns[i][1], tempitems)
																while menuactive do
																	Wait(0)
																end
																if(menuresult > 0) then
																	if(tempitems[menuresult] == "" .. guns[i][4] .. " bullets ~g~(" .. guns[i][3]/2 .. "$)") then
																		if(money >= guns[i][3]/2) then
																			money = money - guns[i][3]/2
																			SaveStats()
																			GiveWeaponToChar(GetPlayerChar(GetPlayerId()), guns[i][2], guns[i][4], 1)
																			TriggerEvent('chatMessage', '[Gun shop]', {0, 255, 0}, '' .. guns[i][1] .. ' purchased')
																		else
																			TriggerEvent('chatMessage', '[Gun shop]', {255, 0, 0}, 'You cannot afford it!')
																		end
																	elseif(tempitems[menuresult] == "" .. guns[i][4]*2 .. " bullets ~g~(" .. guns[i][3]*2/2 .. "$)") then
																		if(money >= guns[i][3]*2/2) then
																			money = money - guns[i][3]*2/2
																			SaveStats()
																			GiveWeaponToChar(GetPlayerChar(GetPlayerId()), guns[i][2], guns[i][4]*2, 1)
																			TriggerEvent('chatMessage', '[Gun shop]', {0, 255, 0}, '' .. guns[i][1] .. ' purchased')
																		else
																			TriggerEvent('chatMessage', '[Gun shop]', {255, 0, 0}, 'You cannot afford it!')
																		end
																	elseif(tempitems[menuresult] == "" .. guns[i][4]*5 .. " bullets ~g~(" .. guns[i][3]*5/2 .. "$)") then
																		if(money >= guns[i][3]*5/2) then
																			money = money - guns[i][3]*5/2
																			SaveStats()
																			GiveWeaponToChar(GetPlayerChar(GetPlayerId()), guns[i][2], guns[i][4]*5, 1)
																			TriggerEvent('chatMessage', '[Gun shop]', {0, 255, 0}, '' .. guns[i][1] .. ' purchased')
																		else
																			TriggerEvent('chatMessage', '[Gun shop]', {255, 0, 0}, 'You cannot afford it!')
																		end
																	elseif(tempitems[menuresult] == "" .. guns[i][4]*10 .. " bullets ~g~(" .. guns[i][3]*10/2 .. "$)") then
																		if(money >= guns[i][3]*10/2) then
																			money = money - guns[i][3]*10/2
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
										else
											TriggerEvent('chatMessage', '[Clan]', {0, 255, 0}, 'You must be a member of a clan!')
										end
									elseif(tempitems[menuresult] == "Leave clan") then
										clan = "0"
										SaveStats()
										TriggerEvent('chatMessage', '[Clan]', {255, 255, 0}, 'You have left the clan.')
									end
								end
							end
						end
					end
				else
					PrintStringWithLiteralStringNow("STRING", "~r~You already own an organization!", 1000, 1)
				end
			end
		end
	end
end)

RegisterNetEvent('invitePlayerToClan')
AddEventHandler('invitePlayerToClan', function(id, owner)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		if(org == 1) then
			if(clan == "0") then
				DrawWindow("You_have_been_invited_to_clan", {"Accept invite to " .. GetPlayerName(owner, _s) .. "'s clan"})
				while menuactive do
					Wait(0)
				end
				if(menuresult > 0) then
					clan = "" .. GetPlayerName(owner, _s)
					SaveStats()
					TriggerEvent('chatMessage', '[Clan]', {0, 255, 0}, "Welcome to " .. GetPlayerName(owner, _s) .. "'s clan!")
					TriggerServerEvent('sendMessageToPlayer', "" .. GetPlayerName(owner, _s), "[Clan]", "" .. GetPlayerName(id, _s) .. " has accepted your invitation!")
				else
					TriggerServerEvent('sendMessageToPlayer', "" .. GetPlayerName(owner, _s), "[Clan]", "" .. GetPlayerName(id, _s) .. " has declined your invitation.")
				end
			else
				TriggerServerEvent('sendMessageToPlayer', "" .. GetPlayerName(owner, _s), "[Clan]", "" .. GetPlayerName(id, _s) .. " is already a member of a clan!")
			end
		else
			TriggerServerEvent('sendMessageToPlayer', "" .. GetPlayerName(owner, _s), "[Clan]", "" .. GetPlayerName(id, _s) .. " does not own an organization!")
		end
	end
end)

RegisterNetEvent('removePlayerFromClan')
AddEventHandler('removePlayerFromClan', function(id, owner)
	if(ConvertIntToPlayerindex(id) == ConvertIntToPlayerindex(GetPlayerId())) then
		if(clan == "" .. GetPlayerName(owner)) then
			clan = "0"
			SaveStats()
			TriggerServerEvent('sendMessageToPlayer', "" .. GetPlayerName(owner, _s), "[Clan]", "Player has been removed from your clan.")
		else
			TriggerServerEvent('sendMessageToPlayer', "" .. GetPlayerName(owner, _s), "[Clan]", "You can remove only players from your clan!")
		end
	end
end)

clanname = {}
RegisterNetEvent('updClanName')
AddEventHandler('updClanName', function(c, name)
	clanname[c] = name
end)

CreateThread(function()
	while true do
		Wait(0)
		if(currmission > 0) then
			if(currmission == 1) then
				if(currstage == 0) then
					local carsdelivered = 0
					for i=1,3,1 do
						if(DoesVehicleExist(vehs[i])) then
							if(not IsCarDead(vehs[i])) then
								local bp = GetBlipCoords(blips[4])
								local cx,cy,cz = GetCarCoordinates(vehs[i])
								if(GetDistanceBetweenCoords3d(cx, cy, cz, bp.x, bp.y, bp.z) < 5) then
									RemoveBlip(blips[i])
									DeleteCar(vehs[i])
								end
							else
								DrawMessage("~r~Mission failed", "Car destroyed.")
								EndMission()
								break
							end
						else
							carsdelivered = carsdelivered + 1
						end
					end
					if(carsdelivered == 3) then
						if(clan == "0") then
							local finalreward = SeparateReward(10000, 900)
							money = money + finalreward[1]
							experience = experience + finalreward[2]
							SaveStats()
							DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
							orgMissionsCompleted = orgMissionsCompleted + 1
							SaveDailyStats()
						else
							local finalreward = SeparateReward(14000, 1200)
							money = money + finalreward[1]
							experience = experience + finalreward[2]
							SaveStats()
							DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
							orgMissionsCompleted = orgMissionsCompleted + 1
							SaveDailyStats()
						end
						EndMission()
					end
				end
			elseif(currmission == 2) then
				if(currstage == 0) then
					for i=1,4,1 do
						if(HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId())) or HasCarBeenDamagedByChar(vehs[1], GetPlayerChar(GetPlayerId()))) then
							if(i ~= 1) then
								AttackPlayer(peds[i])
							end
						end
					end
					if(IsCharDead(peds[1])) then
						RemoveBlip(blips[1])
						local px,py,pz = GetCharCoordinates(peds[1], _f, _f, _f)
						objs[1] = SpawnObject(GetHashKey("cj_case_2"), px, py, pz, 0.0)
						blips[1] = AddBlipForObject(objs[1])
						SetObjective("Collect ~y~the briefcase")
						currstage = 1
					end
				elseif(currstage == 1) then
					local ox,oy,oz = GetObjectCoordinates(objs[1])
					if(IsPlayerNearCoords(ox, oy, oz, 2)) then
						DeleteObject(objs[1])
						RemoveBlip(blips[1])
						AlterWantedLevel(GetPlayerId(), 4)
						ApplyWantedLevelChangeNow(GetPlayerId())
						SetObjective("Lose ~y~wanted level")
						currstage = 2
					end
				elseif(currstage == 2) then
					if(StoreWantedLevel(GetPlayerId(), _i) == 0) then
						blips[1] = AddBlipForCoord(1276.67163, 1561.52417, 17.73037)
						SetRoute(blips[1], true)
						SetObjective("Deliver ~y~this briefcase ~w~to ~y~the drop-off")
						currstage = 3
					end
				elseif(currstage == 3) then
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
						if(clan == "0") then
							local finalreward = SeparateReward(8000, 600)
							money = money + finalreward[1]
							experience = experience + finalreward[2]
							SaveStats()
							DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
							orgMissionsCompleted = orgMissionsCompleted + 1
							SaveDailyStats()
						else
							local finalreward = SeparateReward(10000, 700)
							money = money + finalreward[1]
							experience = experience + finalreward[2]
							SaveStats()
							DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
							orgMissionsCompleted = orgMissionsCompleted + 1
							SaveDailyStats()
						end
						EndMission()
					end
				end
			elseif(currmission == 3) then
				if(currstage == 0) then
					local ox,oy,oz = GetObjectCoordinates(objs[1])
					if(IsPlayerNearCoords(ox, oy, oz, 2)) then
						DeleteObject(objs[1])
						for i=1,3,1 do
							RemoveBlip(blips[i])
						end
						blips[1] = AddBlipForCoord(-1237.45129, 1775.67456, 31.29489)
						SetRoute(blips[1], true)
						SetObjective("Deliver ~y~this briefcase ~w~to ~y~the drop-off")
						currstage = 1
					end
				elseif(currstage == 1) then
					local bp = GetBlipCoords(blips[1])
					DrawCheckpointWithAlpha(bp.x, bp.y, bp.z-1, 1.1, 255, 255, 0, 100)
					if(IsPlayerNearCoords(bp.x, bp.y, bp.z, 1)) then
						if(clan == "0") then
							local finalreward = SeparateReward(6000, 500)
							money = money + finalreward[1]
							experience = experience + finalreward[2]
							SaveStats()
							DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
							orgMissionsCompleted = orgMissionsCompleted + 1
							SaveDailyStats()
						else
							local finalreward = SeparateReward(7000, 550)
							money = money + finalreward[1]
							experience = experience + finalreward[2]
							SaveStats()
							DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
							orgMissionsCompleted = orgMissionsCompleted + 1
							SaveDailyStats()
						end
						EndMission()
					end
				end
			elseif(currmission == 4) then
				if(currstage == 0) then
					local mobskilled = 0
					for i=1,15,1 do
						if(not IsCharDead(peds[i])) then
							if(i>=1 and i<=5) then
								if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
									for j=1,5,1 do
										AttackPlayer(peds[j])
									end
								end
							elseif(i>=6 and i<=10) then
								if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
									for j=6,10,1 do
										AttackPlayer(peds[j])
									end
								end
							elseif(i>=11 and i<=15) then
								if(IsPedNearPlayer(peds[i], GetPlayerChar(GetPlayerId()), 20) or HasCharBeenDamagedByChar(peds[i], GetPlayerChar(GetPlayerId()))) then
									for j=11,15,1 do
										AttackPlayer(peds[j])
									end
								end
							end
						else
							RemoveBlip(blips[i])
							mobskilled = mobskilled + 1
						end
					end
					if(mobskilled == 15) then
						SetObjective("Lose ~y~wanted level")
						currstage = 1
					end
				elseif(currstage == 1) then
					if(StoreWantedLevel(GetPlayerId(), _i) == 0) then
						if(clan == "0") then
							local finalreward = SeparateReward(15000, 1300)
							money = money + finalreward[1]
							experience = experience + finalreward[2]
							SaveStats()
							DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
							orgMissionsCompleted = orgMissionsCompleted + 1
							SaveDailyStats()
						else
							local finalreward = SeparateReward(18000, 1400)
							money = money + finalreward[1]
							experience = experience + finalreward[2]
							SaveStats()
							DrawMessage("~y~Mission completed", "You have got " .. finalreward[1] .. "$ and " .. finalreward[2] .. " EXP")
							orgMissionsCompleted = orgMissionsCompleted + 1
							SaveDailyStats()
						end
						EndMission()
					end
				end
			end
			if(IsPlayerDead(GetPlayerId())) then
				DrawMessage("~r~Mission failed", "You have died.")
				EndMission()
			end
		end
	end
end)