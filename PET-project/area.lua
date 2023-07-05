areacoords = {
{-1235.12244, 1272.37598, 21.79766, 175.350875854492},
{-1386.68494, 703.06824, 19.57458, 156.384582519531},
{-1721.73279, 46.17962, 9.33532, 291.987579345703},
{-1296.20325, -430.03366, 2.9287, 4.57230091094971},
{-332.13174, 1644.03308, 20.33513, 22.4999580383301},
{-411.1489, 750.98499, 9.9672, 85.6441879272461},
{67.48234, -32.19309, 21.55785, 269.061614990234},
{-635.85461, -236.7724, 6.93389, 289.672637939453},
{894.78229, 1721.63354, 16.92905, 46.241283416748},
{1018.20959, 660.80719, 26.01966, 88.8494338989258},
{1772.62061, 665.73572, 28.03274, 196.434600830078},
{1326.052, -177.79796, 24.43023, 98.5390853881836},
{1017.91864, -618.65698, 14.2254, 88.840950012207},
{2334.6123, 153.845, 5.81285, 174.943862915039}
}
local areablips = {}
--for i=1,#areacoords,1 do
--	areablips[i] = {}
--end
areaowners = {}
for i=1,#areacoords,1 do
	areaowners[i] = "0"
end
RegisterNetEvent('updAreas')
AddEventHandler('updAreas', function(data)
	for i=1,#areaowners,1 do
		if(data[i] == nil) then
			data[i] = "0"
		end
		areaowners[i] = tostring(data[i])
	end
end)

SaveAreas = function()
	local data = {}
	for i=1,#areaowners,1 do
		data[#data+1] = areaowners[i]
	end
	TriggerServerEvent('saveAreas', data)
end

local capturecooldown = 0
CreateThread(function()
	while true do
		Wait(0)
		if(capturecooldown > 0) then
			Wait(1000)
			capturecooldown = capturecooldown - 1
		end
	end
end)

CreateThread(function()
	while true do
		Wait(0)
		for j=1,#areacoords,1 do
			if(clan ~= "0") then
				if(missionstarted == 0) then
					if(areaowners[j] ~= "0") then
						if(IsPlayerNearCoords(areacoords[j][1], areacoords[j][2], areacoords[j][3], 20)) then
							TriggerServerEvent('requestClanName', "" .. areaowners[j])
							Wait(60000)
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
		for j=1,#areacoords,1 do
			--for i=1,40,1 do
				RemoveBlip(areablips[j])
				if(clan ~= "0") then
					--[[if(i>=1 and i<=10) then
						if(not DoesBlipExist(areablips[j][i])) then
							areablips[j][i] = AddBlipForCoord((areacoords[j][1]-100)+20*(i-1), areacoords[j][2]+100, 0, _i)
						end
					elseif(i>=11 and i<=20) then
						if(not DoesBlipExist(areablips[j][i])) then
							areablips[j][i] = AddBlipForCoord(areacoords[j][1]+100, (areacoords[j][2]+100)-20*(i-11), 0, _i)
						end
					elseif(i>=21 and i<=30) then
						if(not DoesBlipExist(areablips[j][i])) then
							areablips[j][i] = AddBlipForCoord((areacoords[j][1]+100)-20*(i-21), areacoords[j][2]-100, 0, _i)
						end
					elseif(i>=31 and i<=40) then
						if(not DoesBlipExist(areablips[j][i])) then
							areablips[j][i] = AddBlipForCoord(areacoords[j][1]-100, (areacoords[j][2]-100)+20*(i-31), 0, _i)
						end
					end]]
					if(not DoesBlipExist(areablips[j])) then
						areablips[j] = AddBlipForCoord(areacoords[j][1], areacoords[j][2], areacoords[j][3], _i)
						ChangeBlipSprite(areablips[j], 3)
						ChangeBlipScale(areablips[j], 0.7)
					end
					if(areaowners[j] == clan) then
						ChangeBlipColour(areablips[j], 2)
						ChangeBlipNameFromAscii(areablips[j], "Your area")
					else
						ChangeBlipColour(areablips[j], 1)
						ChangeBlipNameFromAscii(areablips[j], "Rival area")
					end
					ChangeBlipScale(areablips[j], 0.50)
					SetBlipAsShortRange(areablips[j], true)
				end
			--end
			if(clan ~= "0") then
				if(missionstarted == 0) then
					if(areaowners[j] == "0") then
						DrawTextAtCoord(areacoords[j][1], areacoords[j][2], areacoords[j][3], "Not occupied area", 20)
					else
						if(clanname["" .. areaowners[j]]==nil or clanname["" .. areaowners[j]]=="0") then
							DrawTextAtCoord(areacoords[j][1], areacoords[j][2], areacoords[j][3], "" .. GetStringWithoutSpaces("" .. areaowners[j]) .. "'s_clan_area", 20)
						else
							DrawTextAtCoord(areacoords[j][1], areacoords[j][2], areacoords[j][3], "" .. GetStringWithoutSpaces("" .. clanname["" .. areaowners[j]]) .. "'s_area", 20)
						end
					end
					if(areaowners[j] == clan) then
						DrawCheckpointWithAlpha(areacoords[j][1], areacoords[j][2], areacoords[j][3]-1, 10.1, 0, 255, 0, 100)
					else
						DrawCheckpointWithAlpha(areacoords[j][1], areacoords[j][2], areacoords[j][3]-1, 10.1, 255, 0, 0, 100)
						if(IsPlayerNearCoords(areacoords[j][1], areacoords[j][2], areacoords[j][3], 5)) then
							PrintStringWithLiteralStringNow("STRING", "Press ~y~E ~w~to ~y~start capturing this area", 1000, 1)
							if(IsGameKeyboardKeyJustPressed(18)) then
								local tempamount = 0
								for i=1,#areaowners,1 do
									if(areaowners[i] == clan) then
										tempamount = tempamount + 1
									end
								end
								if(tempamount < 10) then
									if(capturecooldown == 0) then
										TriggerServerEvent('startCapture', j, areaowners[j])
										Settimera(0)
										while Timera() < 100000 do
											Wait(0)
											PrintStringWithLiteralStringNow("STRING", "Capture in progress (~y~" .. 100 - math.floor(Timera()/1000) .. " secs ~w~left)", 1000, 1)
											if(IsPlayerDead(GetPlayerId())) then
												TriggerServerEvent('finishCapture', j)
												TriggerEvent('chatMessage', '[Capture]', {255, 0, 0}, 'Capture has been failed!')
												break
											end
											if(not IsPlayerNearCoords(areacoords[j][1], areacoords[j][2], areacoords[j][3], 5)) then
												local temptimer = Timera()
												Settimerb(0)
												while Timerb() < 10000 do
													Wait(0)
													PrintStringWithLiteralStringNow("STRING", "~r~Return to the capture zone! (~y~" .. 10 - math.floor(Timerb()/1000) .. " secs ~r~left)", 1000, 1)
													if(IsPlayerNearCoords(areacoords[j][1], areacoords[j][2], areacoords[j][3], 5)) then
														Settimera(temptimer)
														break
													end
												end
												if(Timerb() >= 10000) then
													TriggerServerEvent('finishCapture', j)
													TriggerEvent('chatMessage', '[Capture]', {255, 0, 0}, 'Capture has been failed!')
													break
												end
											end
										end
										if(Timera() >= 100000) then
											TriggerServerEvent('finishCapture', j)
											capturecooldown = 600
											TriggerEvent('chatMessage', '[Capture]', {0, 255, 0}, 'Capture has been finished successfully!')
											if(areaowners[j] ~= "0") then
												if(clanname["" .. areaowners[j]]==nil or clanname["" .. areaowners[j]]=="0") then
													if(clanname["" .. clan]==nil or clanname["" .. clan]=="0") then
														TriggerServerEvent('sendMessageToClans', '[Capture]', "Area of " .. areaowners[j] .. "'s clan has been captured by " .. clan .. "'s clan!")
													else
														TriggerServerEvent('sendMessageToClans', '[Capture]', "Area of " .. areaowners[j] .. "'s clan has been captured by " .. clanname["" .. clan] .. "!")
													end
												else
													if(clanname["" .. clan]==nil or clanname["" .. clan]=="0") then
														TriggerServerEvent('sendMessageToClans', '[Capture]', "Area of " .. clanname["" .. areaowners[j]] .. "'s clan has been captured by " .. clan .. "'s clan!")
													else
														TriggerServerEvent('sendMessageToClans', '[Capture]', "Area of " .. clanname["" .. areaowners[j]] .. " has been captured by " .. clanname["" .. clan] .. "!")
													end
												end
											else
												TriggerServerEvent('sendMessageToClans', '[Capture]', "A not occupied area has been captured by " .. clan .. "'s clan!")
											end
											areaowners[j] = clan
											SaveAreas()
										end
									else
										TriggerEvent('chatMessage', '[Capture]', {255, 0, 0}, 'You must wait for ' .. capturecooldown .. ' seconds before starting a new capture!')
									end
								else
									TriggerEvent('chatMessage', '[Capture]', {255, 0, 0}, 'Your clan cannot control more than 10 territories!')
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
		local h,m = GetTimeOfDay(_i, _i)
		if(h==0 and m==0) then
			if(clan ~= "0") then
				local tempamount = 0
				for i=1,#areaowners,1 do
					if(areaowners[i] == clan) then
						tempamount = tempamount + 1
					end
				end
				if(tempamount > 0) then
					--if(clan == "" .. GetPlayerName(GetPlayerId())) then
					--	money = money + 10000*tempamount
					--	experience = experience + 1000*tempamount
					--	SaveStats()
					--	TriggerEvent('chatMessage', '[Clan]', {0, 255, 0}, 'You have received ' .. 10000*tempamount .. '$ and ' .. 1000*tempamount .. ' EXP from captured territories!')
					--else
						money = money + 1000*tempamount
						experience = experience + 250*tempamount
						SaveStats()
						TriggerEvent('chatMessage', '[Clan]', {0, 255, 0}, 'You have received ' .. 1000*tempamount .. '$ and ' .. 250*tempamount .. ' EXP from captured territories!')
					--end
				else
					TriggerEvent('chatMessage', '[Clan]', {255, 0, 0}, 'You have not received cash because your clan does not control any territories.')
				end
			end
			while m==0 do
				Wait(0)
				h,m = GetTimeOfDay(_i, _i)
			end
		end
	end
end)

local areamainblips = {}
local bliptimer = {}
for i=1,#areacoords,1 do
	bliptimer[i] = 0
end
RegisterNetEvent('startCapture')
AddEventHandler('startCapture', function(areaid, owner)
	if(clan ~= "0") then
		if(clan == owner) then
			RemoveBlip(areamainblips[areaid])
			if(not DoesBlipExist(areamainblips[areaid])) then
				areamainblips[areaid] = AddBlipForCoord(areacoords[areaid][1], areacoords[areaid][2], areacoords[areaid][3])
				ChangeBlipSprite(areamainblips[areaid], 85)
				ChangeBlipNameFromAscii(areamainblips[areaid], "Area is under attack!")
			end
			FlashBlip(areamainblips[areaid], true)
			bliptimer[areaid] = 100
			TriggerEvent('chatMessage', '[Capture]', {255, 255, 0}, 'Your area is currently being captured! (look for flashing blip on the map)')
		end
	end
end)

CreateThread(function()
	while true do
		Wait(1000)
		for i=1,#bliptimer,1 do
			if(bliptimer[i] > 0) then
				bliptimer[i] = bliptimer[i] - 1
				if(bliptimer[i] == 0) then
					RemoveBlip(areamainblips[i])
				end
			end
		end
	end
end)

RegisterNetEvent('finishCapture')
AddEventHandler('finishCapture', function(areaid)
	RemoveBlip(areamainblips[areaid])
end)

RegisterNetEvent('sendMessageToClans')
AddEventHandler('sendMessageToClans', function(m1, m2)
	if(clan ~= "0") then
		TriggerEvent('chatMessage', m1, {255, 255, 0}, m2)
	end
end)